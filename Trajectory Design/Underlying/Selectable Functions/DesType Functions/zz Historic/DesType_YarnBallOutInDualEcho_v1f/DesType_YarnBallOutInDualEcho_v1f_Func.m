%====================================================
%
%====================================================

function [DESTYPE,err] = DesType_YarnBallOutInDualEcho_v1f_Func(DESTYPE,INPUT)

Status2('busy','YarnBallOutIn Design',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

Func = INPUT.func;
DESTYPE.name = 'DEOI';

%=================================================================
% PreDeSolTim
%=================================================================
if strcmp(Func,'PreDeSolTim')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    CLR = INPUT.CLR;
    SPIN = INPUT.SPIN;
    RADEV = INPUT.DESOL.RADEV;
    PROJdgn = INPUT.PROJdgn;   
    TURNSOL = DESTYPE.TURNSOL;
    clear INPUT;
   
    %---------------------------------------------
    % Get radial evolution function 
    %---------------------------------------------
    func = str2func([RADEV.method,'_Func']);     
    INPUT.PROJdgn = PROJdgn;      
    [RADEV,err] = func(RADEV,INPUT);
    if err.flag
        return
    end
    clear INPUT;    
    
    %------------------------------------------
    % Define Spinning Speeds
    %------------------------------------------
    stheta = @(r) 1/SPIN.spincalcndiscsfunc(r);  
    sphi = @(r) 1/SPIN.spincalcnspokesfunc(r);     

    %------------------------------------------
    % RadSolFuncs
    %------------------------------------------
    deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
    deradsolinfunc = @(r) deradsolinfunc(r,PROJdgn.p);
    deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
    deradsoloutfunc = @(r) deradsoloutfunc(r,PROJdgn.p);
    
    %---------------------------------------------
    % Create DESTRCT
    %---------------------------------------------
    DESTYPE.DESTRCT.stheta = stheta;
    DESTYPE.DESTRCT.sphi = sphi;
    DESTYPE.DESTRCT.p = PROJdgn.p;
    DESTYPE.DESTRCT.rad = PROJdgn.rad;
    DESTYPE.DESTRCT.deradsoloutfunc = deradsoloutfunc;
    DESTYPE.DESTRCT.deradsolinfunc = deradsolinfunc;
        
    %---------------------------------------------
    % Determine Radius Solution
    %---------------------------------------------
    func = str2func([TURNSOL.method,'_Func']);      
    INPUT.DESTYPE = DESTYPE;
    INPUT.CLR = CLR;
    [TURNSOL,err] = func(TURNSOL,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    DESTYPE = TURNSOL.DESTYPE;
    TURNSOL = rmfield(TURNSOL,'DESTYPE');
    DESTYPE.TURNSOL = TURNSOL;
    DESTYPE.MaxRadSolve = TURNSOL.MaxRadSolve;
    
%=================================================================
% PreGeneration
%=================================================================
elseif strcmp(Func,'PreGeneration')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    DESOL = INPUT.DESOL;
    CLR = INPUT.CLR;
    clear INPUT;
    
    %---------------------------------------------
    % Create 'Out from Centre' Structure
    %---------------------------------------------
    INPUT = DESTYPE.DESTRCT;
    INPUT.turnradfunc = DESTYPE.TURNEVO.turnradfunc;
    INPUT.turnspinfunc = DESTYPE.TURNEVO.turnspinfunc;
    INPUT.dir = 1;
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsoloutfunc;
    INPUT.turnloc = DESTYPE.TURNSOL.turnloc;
    DESTYPE.SLVOUT.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsolinfunc;     
    DESTYPE.SLVOUT.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    DESTYPE.SLVOUT.tau1 = DESOL.tau1;
    DESTYPE.SLVOUT.tau2 = DESOL.tau2;
    DESTYPE.SLVOUT.len = DESOL.len;   

    %---------------------------------------------
    % Create 'Return to Centre' Structure
    %---------------------------------------------    
    INPUT.dir = -1;
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsoloutfunc;
    DESTYPE.SLVRET.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsolinfunc;     
    DESTYPE.SLVRET.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    DESTYPE.SLVRET.tau1 = DESOL.tau1;
    DESTYPE.SLVRET.tau2 = flip(DESOL.tau2(end)-DESOL.tau2);
    DESTYPE.SLVRET.len = DESOL.len;   

%=================================================================
% GenerateOut
%=================================================================
elseif strcmp(Func,'GenerateOut')

    PROJdgn = INPUT.PROJdgn;
    PSMP = INPUT.PSMP;
    GENPRJ = INPUT.GENPRJ;
    DESOL = INPUT.DESOL;
    clear INPUT;

    %---------------------------------------------
    % Generate outward portion
    %---------------------------------------------
    func = str2func([GENPRJ.method,'_Func']);    
    INPUT.rad0 = PROJdgn.p;
    INPUT.phi0 = PSMP.phi;
    INPUT.theta0 = PSMP.theta;
    INPUT.dir = 1;
    INPUT.DESTYPE = DESTYPE;
    INPUT.PROJdgn = PROJdgn;
    [GENPRJ,err] = func(GENPRJ,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    DESTYPE.T = DESOL.T;
    DESTYPE.KSA = GENPRJ.KSA;       
    
%=================================================================
% GenerateFull
%=================================================================
elseif strcmp(Func,'GenerateFull')

    PROJdgn = INPUT.PROJdgn;
    PSMP = INPUT.PSMP;
    GENPRJ = INPUT.GENPRJ;
    DESOL = INPUT.DESOL;
    clear INPUT;

    %---------------------------------------------
    % Generate outward portion
    %---------------------------------------------
    func = str2func([GENPRJ.method,'_Func']);    
    INPUT.rad0 = PROJdgn.p;
    INPUT.phi0 = PSMP.phi;
    INPUT.theta0 = PSMP.theta;
    INPUT.dir = 1;
    INPUT.DESTYPE = DESTYPE;
    INPUT.PROJdgn = PROJdgn;
    [GENPRJ,err] = func(GENPRJ,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    KSA = GENPRJ.KSA;

    %---------------------------------------------
    % Generate return portion
    %---------------------------------------------    
    func = str2func([GENPRJ.method,'_Func']);    
    INPUT.rad0 = GENPRJ.EndVals(:,1);
    INPUT.phi0 = GENPRJ.EndVals(:,2);
    INPUT.theta0 = GENPRJ.EndVals(:,3);
    INPUT.dir = -1;
    INPUT.DESTYPE = DESTYPE;
    INPUT.PROJdgn = PROJdgn;
    [GENPRJ,err] = func(GENPRJ,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    KSA2 = GENPRJ.KSA;
    
    %---------------------------------------------
    % Combine
    %---------------------------------------------
    T = [DESOL.T 2*DESOL.T(end)-flip(DESOL.T(1:end-1),2)];
    KSA = cat(2,KSA,KSA2);
    DESTYPE.T = T;
    DESTYPE.KSA = KSA;    

%=================================================================
% Test
%=================================================================
elseif strcmp(Func,'Test')
    
    DESMETH = INPUT.DESMETH;
    TST = DESTYPE.TST;
    clear INPUT;
    
    %------------------------------------------
    % Run Test Plots
    %------------------------------------------
    func = str2func([TST.method,'_Func']);    
    INPUT.DESMETH = DESMETH;  
    INPUT.func = 'TestPlot';
    [TST,err] = func(TST,INPUT);
    if err.flag
        return
    end
    DESTYPE.TST = TST;

%=================================================================
% AccConstrain
%=================================================================
elseif strcmp(Func,'AccConstrain')
    
    CACC = INPUT.CACC;
    KSA = INPUT.KSA;
    clear INPUT;
    
    %------------------------------------------
    % Use Trajectory End (as previously calculated)
    %------------------------------------------
    KSA = squeeze(DESTYPE.KSA);
    Rad = sqrt(KSA(:,1).^2 + KSA(:,2).^2 + KSA(:,3).^2);
    ind = find(Rad >= 0.7,1,'first');
    DESTYPE.maxaveacc = mean(CACC.magacc(ind-100:ind-10));       
       
end

Status2('done','',2);
Status2('done','',3);








    