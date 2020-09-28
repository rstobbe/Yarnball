%====================================================
%
%====================================================

function [IMPTYPE,err] = ImpType_YarnBallOutSingleEcho_v1d_Func(IMPTYPE,INPUT)

Status2('busy','YarnBall OutSingleEcho Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

Func = INPUT.func;
IMPTYPE.name = 'SEO';
FINMETH = IMPTYPE.FINMETH;

%=================================================================
% PreDeSolTim
%=================================================================
if strcmp(Func,'PreDeSolTim')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    DESTYPE = INPUT.DESTYPE;
    CLR = INPUT.CLR;
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
    % RadSolFuncs
    %------------------------------------------
    deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
    deradsolinfunc = @(r) deradsolinfunc(r,PROJdgn.p);
    deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
    deradsoloutfunc = @(r) deradsoloutfunc(r,PROJdgn.p);
    
    %---------------------------------------------
    % Update DESTRCT for implementation
    %---------------------------------------------
    IMPTYPE.DESTRCT = DESTYPE.DESTRCT;
    IMPTYPE.DESTRCT.deradsoloutfunc = deradsoloutfunc;
    IMPTYPE.DESTRCT.deradsolinfunc = deradsolinfunc;

    %---------------------------------------------
    % Create Radial Evolution Functions
    %---------------------------------------------
    INPUT = IMPTYPE.DESTRCT;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    INPUT.turnradfunc = @(p,r) 1;
    INPUT.turnloc = 1000;           % i.e. no turning
    IMPTYPE.radevout = @(t,r) CLR.radevout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;   
    IMPTYPE.radevin = @(t,r) CLR.radevin(t,r,INPUT);    
    
    %---------------------------------------------
    % Determine Radius Solution
    %---------------------------------------------
    IMPTYPE.MaxRadSolve = 1;

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
    INPUT = IMPTYPE.DESTRCT;
    INPUT.turnradfunc = @(p,r) 1;
    INPUT.turnspinfunc = @(p,r) 1;
    INPUT.turnloc = 1000;
    INPUT.dir = 1;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    IMPTYPE.SLVOUT.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;     
    IMPTYPE.SLVOUT.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    IMPTYPE.SLVOUT.tau1 = DESOL.tau1;
    IMPTYPE.SLVOUT.tau2 = DESOL.tau2;
    IMPTYPE.SLVOUT.len = DESOL.len;   

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
    INPUT.DESTYPE = IMPTYPE;
    INPUT.PROJdgn = PROJdgn;
    [GENPRJ,err] = func(GENPRJ,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    IMPTYPE.T = DESOL.T;
    IMPTYPE.KSA = GENPRJ.KSA;     

%=================================================================
% GenerateFull
%=================================================================
elseif strcmp(Func,'GenerateFull')

    PROJdgn = INPUT.PROJdgn;
    PSMP = INPUT.PSMP;
    GENPRJ = INPUT.GENPRJ;
    TIMADJ = INPUT.TIMADJ;
    clear INPUT;

    %---------------------------------------------
    % Generate outward portion
    %---------------------------------------------
    func = str2func([GENPRJ.method,'_Func']);    
    INPUT.rad0 = PROJdgn.p;
    INPUT.phi0 = PSMP.phi;
    INPUT.theta0 = PSMP.theta;
    INPUT.dir = 1;
    INPUT.DESTYPE = IMPTYPE;
    INPUT.PROJdgn = PROJdgn;
    [GENPRJ,err] = func(GENPRJ,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    KSA = GENPRJ.KSA;

    %---------------------------------------------
    % Return
    %---------------------------------------------
    IMPTYPE.T = TIMADJ.T;
    IMPTYPE.KSA = KSA;

%=================================================================
% Finish
%=================================================================
elseif strcmp(Func,'Finish')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    PROJdgn = INPUT.PROJdgn;
    PROJimp = INPUT.PROJimp;
    GQKSA0 = INPUT.GQKSA0;
    qT0 = INPUT.qT0; 
    SYS = INPUT.SYS;
    SYSRESP = INPUT.SYSRESP;
    TEND = INPUT.TEND;
    TST = INPUT.TST;
    GQNT = INPUT.GQNT;
    clear INPUT;
    
    %---------------------------------------------
    % Finish
    %---------------------------------------------               
    func = str2func([FINMETH.method,'_Func']);      
    INPUT.PROJdgn = PROJdgn;
    INPUT.PROJimp = PROJimp;
    INPUT.GQKSA0 = GQKSA0;
    INPUT.qT0 = qT0;
    INPUT.SYS = SYS;
    INPUT.SYSRESP = SYSRESP;
    INPUT.TEND = TEND;
    INPUT.TST = TST;
    INPUT.GQNT = GQNT;
    [FINMETH,err] = func(FINMETH,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    IMPTYPE.qT = FINMETH.qT;
    IMPTYPE.GQKSA = FINMETH.GQKSA;
    IMPTYPE.qTtot = FINMETH.qTtot;
    IMPTYPE.Gtot = FINMETH.Gtot;
    IMPTYPE.GWFM = FINMETH.GWFM;

    if isfield(FINMETH,'Figure')
        IMPTYPE.Figure(1) = FINMETH.Figure;
    end    
    
%=================================================================
% PostResample
%=================================================================
elseif strcmp(Func,'PostResample')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    Samp0 = INPUT.Samp0;
    Kmat0 = INPUT.Kmat0;
    SampRecon0 = INPUT.SampRecon;
    KmatRecon0 = INPUT.KmatRecon;
    npro = length(SampRecon0);
    nptot = length(Samp0);
    KSMP = INPUT.KSMP;
    TSMP = INPUT.TSMP;
    TST = INPUT.TST;
    clear INPUT

    if strcmp(TST.IMPTYPE.Vis,'Yes')
        fh = figure(5963455); hold on;
        fh.Name = 'Radial Evolution';
        fh.NumberTitle = 'off';
        fh.Position = [650+TST.figshift 550 500 400];
        Rad0 = sqrt(Kmat0(1,:,1).^2 + Kmat0(1,:,2).^2 + Kmat0(1,:,3).^2);
        plot(Rad0,'k');
        ylabel('Radius (1/m)');
        xlabel('Sample');
    end
         
    KmatDisplay = NaN*ones([nptot 3 1]);
    ind = find(round(Samp0*1e6) == round(SampRecon0(1)*1e6));
    KmatDisplay(ind:ind+npro-1,:,1) = squeeze(KmatRecon0(1,:,:));
    
    %---------------------------------------------
    % Fit 1st Image
    %---------------------------------------------
    tKmatRecon = squeeze(KmatRecon0(1,:,:));
    Rad0 = sqrt(tKmatRecon(:,1).^2 + tKmatRecon(:,2).^2 + tKmatRecon(:,3).^2);
    ind = 1:1:50;
    for n = 1:length(ind)
        tKmat0 = squeeze(Kmat0(1,ind(n):ind(n)+npro-1,:));
        Rad1 = sqrt(tKmat0(:,1).^2 + tKmat0(:,2).^2 + tKmat0(:,3).^2);
        resid = Rad0 - Rad1;
        residsum(n) = sum(abs(resid(:)));
    end
    SampStart1 = ind(residsum == min(residsum));
    if residsum(SampStart1) ~= 0
        error
    end
    if strcmp(TST.IMPTYPE.Vis,'Yes')
        plot([NaN*ones(SampStart1-1,1);Rad0],'r','linewidth',2);
    end
        
    IMPTYPE.SampStart = SampStart1;
    IMPTYPE.KmatRecon = KmatRecon0;
    IMPTYPE.KmatDisplay = KmatDisplay;
    IMPTYPE.numberofimages = 1;
   
    %---------------------------------------------
    % Return Relavent to KSMP Structure
    %---------------------------------------------    
    KSMP.SampStart = IMPTYPE.SampStart;
    CenSamp = KSMP.SampStart;
    KSMP.Delay2Centre = Samp0(CenSamp);
    KSMP.flip = 0;
    IMPTYPE.KSMP = KSMP;
    IMPTYPE.TSMP = TSMP;
    
end

    