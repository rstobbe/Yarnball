%====================================================
%
%====================================================

function [TURNSOL,err] = TurnSolution_Overshoot_v1c_Func(TURNSOL,INPUT)

Status2('busy','Turn Solution',3);

err.flag = 0;
err.msg = '';

DESTYPE = INPUT.DESTYPE;
CLR = INPUT.CLR;
clear INPUT;

TURNSOL.turnloc = 0;

%---------------------------------------------
% Solve Turning
%---------------------------------------------
regfunc = str2func('SolveTurning');
func = @(fiddle) regfunc(DESTYPE,TURNSOL,CLR,fiddle);
options = optimset('TolFun',0.00001,'DiffMinChange',1e-5);
lb = -0.1;
ub = 0.1;
fiddle0 = 0;
fiddle = lsqnonlin(func,fiddle0,lb,ub,options);
[rem,TURNSOL] = func(fiddle);

%---------------------------------------------
% Test
%---------------------------------------------
if rem > 0.001
    error
elseif rem < -0.001
    error
end

%---------------------------------------------
% Plot Info
%---------------------------------------------
n = 1;
for r = 0.75:0.00001:TURNSOL.MaxRadSolve+0.01
    dr(n) = TURNSOL.DESTYPE.radevout(0,r);
    if dr(n) < TURNSOL.maxradderivative
        break
    end
    n = n+1;
end
TURNSOL.rArr = (0.75:0.00001:r);
TURNSOL.drArr = dr;
% figure(9023847); hold on;
% plot(TURNSOL.rArr,TURNSOL.drArr);

Status2('done','',3);
end


%==============================================================
% Solve Turning
%==============================================================
function [Rem,TURNSOL] = SolveTurning(DESTYPE,TURNSOL,CLR,fiddle)

    %---------------------------------------------
    % Get TurnEvolution 
    %---------------------------------------------
    TURNEVO = DESTYPE.TURNEVO;
    func = str2func([TURNEVO.method,'_Func']);    
    INPUT.turnloc = TURNSOL.turnloc;
    INPUT.fiddle = fiddle;
    [TURNEVO,err] = func(TURNEVO,INPUT);
    if err.flag
        return
    end 
    DESTYPE.TURNEVO = TURNEVO;

    %---------------------------------------------
    % Create Radial Evolution Functions
    %---------------------------------------------
    INPUT = DESTYPE.DESTRCT;
    INPUT.turnradfunc = DESTYPE.TURNEVO.turnradfunc;
    INPUT.turnspinfunc = DESTYPE.TURNEVO.turnspinfunc;
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsoloutfunc;
    INPUT.turnloc = TURNSOL.turnloc;
    DESTYPE.radevout = @(t,r) CLR.radevout(t,r,INPUT);
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsolinfunc;   
    DESTYPE.radevin = @(t,r) CLR.radevin(t,r,INPUT);

    %---------------------------------------------
    % Determine Radius at MinDr
    %---------------------------------------------
    regfunc = str2func('SolveRadius');
    func = @(rad) regfunc(DESTYPE,TURNSOL,rad);
    options = optimset('TolFun',0.0000001);
    lb = 0.5;
    ub = 2;
    rad0 = 1;
    rad = lsqnonlin(func,rad0,lb,ub,options);  
    Rem = rad - TURNSOL.endrad;                    
    TURNSOL.DESTYPE = DESTYPE;
    TURNSOL.MaxRadSolve = rad;
end

%==============================================================
% Radius Solve
%==============================================================
function [Rem] = SolveRadius(DESTYPE,TURNSOL,rad)
    dr = DESTYPE.radevout(0,rad);
    Rem = dr - TURNSOL.maxradderivative;
end
