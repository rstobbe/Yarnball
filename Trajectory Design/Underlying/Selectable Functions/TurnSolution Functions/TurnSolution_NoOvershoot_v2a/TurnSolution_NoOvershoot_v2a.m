%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef TurnSolution_NoOvershoot_v2a < handle

properties (SetAccess = private)                   
    Method = 'TurnSolution_NoOvershoot_v2a'
    TURNSOLipt;
    TurnLoc = 0.95;
    %MaxRadDerivative = 0.002;
    MaxRadDerivative = 0.00001;
    EndRad = 1.00005;               % keep a tiny bit longer than 1.   
	MaxRadSolve;
    rArr;
    drArr;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TURNSOL = TurnSolution_NoOvershoot_v2a(TURNSOLipt)    
    TURNSOL.TURNSOLipt = TURNSOLipt;
end 

%==================================================================
% SolveTurning
%================================================================== 
function SolveTurning(TURNSOL,CLR)  
    func = @(fiddle) TURNSOL.TurningFunction(CLR,fiddle);
    options = optimset('TolFun',0.00001,'DiffMinChange',1e-5);
    lb = -0.1;
    ub = 0.1;
    fiddle0 = 0;
    fiddle = lsqnonlin(func,fiddle0,lb,ub,options);
    func(fiddle);
    TURNSOL.PlotInfo(CLR);
end

%==============================================================
% TurningFunction
%==============================================================
function Rem = TurningFunction(TURNSOL,CLR,fiddle)

    %---------------------------------------------
    % Get TurnEvolution 
    %--------------------------------------------- 
    INPUT.TurnLoc = TURNSOL.TurnLoc;
    INPUT.Fiddle = fiddle;
    CLR.TURNEVO.DefineTurnEvolution(INPUT);

    %---------------------------------------------
    % Determine Radius at MinDr
    %---------------------------------------------
    func = @(rad) TURNSOL.RadiusFunction(CLR,rad);
    options = optimset('TolFun',0.0000001);
    lb = 0.5;
    ub = 2;
    rad0 = 1;
    rad = lsqnonlin(func,rad0,lb,ub,options);  
    Rem = rad - TURNSOL.EndRad;                    
    TURNSOL.MaxRadSolve = rad;
end

%==============================================================
% Radius Solve
%==============================================================
function Rem = RadiusFunction(TURNSOL,CLR,rad)
    dr = CLR.RadialSolution(0,rad);
    Rem = dr - TURNSOL.MaxRadDerivative;
end

%==============================================================
% PlotInfo
%==============================================================
function PlotInfo(TURNSOL,CLR)
    n = 1;
    for rad = 0.90:0.00001:TURNSOL.MaxRadSolve+0.01
        dr(n) = CLR.RadialSolution(0,rad);
        if dr(n) < TURNSOL.MaxRadDerivative
            break
        end
        n = n+1;
    end
    TURNSOL.rArr = (0.90:0.00001:rad);
    TURNSOL.drArr = dr;
end

end
end




