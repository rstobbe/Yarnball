%====================================================
%
%====================================================

function [DESTYPE,err] = DesType_YarnBallOutSingleEcho_v1b_Func(DESTYPE,INPUT)

Status2('busy','YarnBall OutSingleEcho Design',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

Func = INPUT.func;
DESTYPE.name = 'SEO';

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
    clear INPUT;
    
    %---------------------------------------------
    % Get radial evolution function 
    %---------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    func = str2func([RADEV.method,'_Func']);           
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
    % Create Radial Evolution Functions
    %---------------------------------------------
    INPUT = DESTYPE.DESTRCT;
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsoloutfunc;
    INPUT.turnradfunc = @(p,r) 1;
    INPUT.turnloc = 1000;           % i.e. no turning
    DESTYPE.radevout = @(t,r) CLR.radevout(t,r,INPUT);
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsolinfunc;   
    DESTYPE.radevin = @(t,r) CLR.radevin(t,r,INPUT);    
    
    %---------------------------------------------
    % Determine Radius Solution
    %---------------------------------------------
    DESTYPE.MaxRadSolve = 1;

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
    INPUT.turnradfunc = @(p,r) 1;
    INPUT.turnspinfunc = @(p,r) 1;
    INPUT.turnloc = 1000;
    INPUT.dir = 1;
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsoloutfunc;
    DESTYPE.SLVOUT.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsolinfunc;     
    DESTYPE.SLVOUT.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    DESTYPE.SLVOUT.tau1 = DESOL.tau1;
    DESTYPE.SLVOUT.tau2 = DESOL.tau2;
    DESTYPE.SLVOUT.len = DESOL.len;   

%=================================================================
% GenerateOut
%=================================================================
elseif strcmp(Func,'GenerateOut') || strcmp(Func,'GenerateFull')

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
    clear INPUT;
    
    %------------------------------------------
    % Use Trajectory End (as previously calculated)
    %------------------------------------------
    DESTYPE.maxaveacc = CACC.maxaveacc;     
        
end

Status2('done','',2);
Status2('done','',3);


    