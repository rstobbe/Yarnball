%====================================================
%
%====================================================

function [IMPTYPE,err] = ImpType_YarnBallOutInDualEcho_v1e_Func(IMPTYPE,INPUT)

Status2('busy','Create OutInOut Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

Func = INPUT.func;
IMPTYPE.name = 'DEOI';
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
    TURNSOL = DESTYPE.TURNSOL;
    TURNEVO = DESTYPE.TURNEVO;
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
    IMPTYPE.TURNEVO = TURNEVO;
    
    %---------------------------------------------
    % Determine Radius Solution
    %---------------------------------------------
    func = str2func([TURNSOL.method,'_Func']);      
    INPUT.DESTYPE = IMPTYPE;  
    INPUT.CLR = CLR;
    [TURNSOL,err] = func(TURNSOL,INPUT);
    if err.flag
        return
    end
    clear INPUT;    
    IMPTYPE = TURNSOL.DESTYPE;
    TURNSOL = rmfield(TURNSOL,'DESTYPE');
    IMPTYPE.TURNSOL = TURNSOL;
    IMPTYPE.MaxRadSolve = TURNSOL.MaxRadSolve; 
    if IMPTYPE.MaxRadSolve ~= DESTYPE.MaxRadSolve
        error               % out evolution change?
    end          
    
%=================================================================
% PreGeneration
%=================================================================
elseif strcmp(Func,'PreGeneration')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    DESOL = INPUT.DESOL;
    CLR = INPUT.CLR;
    DESTYPE = INPUT.DESTYPE;
    clear INPUT;
    
    %---------------------------------------------
    % Create 'Out from Centre' Structure
    %---------------------------------------------
    INPUT = IMPTYPE.DESTRCT;
    INPUT.turnradfunc = DESTYPE.TURNEVO.turnradfunc;
    INPUT.turnspinfunc = DESTYPE.TURNEVO.turnspinfunc;
    INPUT.dir = 1;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    INPUT.turnloc = DESTYPE.TURNSOL.turnloc;
    IMPTYPE.SLVOUT.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;     
    IMPTYPE.SLVOUT.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    IMPTYPE.SLVOUT.tau1 = DESOL.tau1;
    IMPTYPE.SLVOUT.tau2 = DESOL.tau2;
    IMPTYPE.SLVOUT.len = DESOL.len;   

    %---------------------------------------------
    % Create 'Return to Centre' Structure
    %---------------------------------------------    
    INPUT.dir = -1;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    IMPTYPE.SLVRET.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;     
    IMPTYPE.SLVRET.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    IMPTYPE.SLVRET.tau1 = DESOL.tau1;
    IMPTYPE.SLVRET.tau2 = flip(DESOL.tau2(end)-DESOL.tau2);
    IMPTYPE.SLVRET.len = DESOL.len;    
    
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
    
    %------------------------------------------
    % Solve T at Evolution Constraint
    %------------------------------------------
    Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
    Rad = mean(Rad,1);
    if strcmp(TIMADJ.CACC.doconstraint,'Yes')
        T = interp1(TIMADJ.ConstEvolRad,TIMADJ.ConstEvolT,Rad,'spline');
    end
    testtro = interp1(Rad,T,1,'spline'); 
    if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
        error
    end
    IMPTYPE.TrajOutTimEnd = T(end);
    
    %---------------------------------------------
    % Generate return portion
    %---------------------------------------------    
    func = str2func([GENPRJ.method,'_Func']);    
    INPUT.rad0 = GENPRJ.EndVals(:,1);
    INPUT.phi0 = GENPRJ.EndVals(:,2);
    INPUT.theta0 = GENPRJ.EndVals(:,3);
    INPUT.dir = -1;
    INPUT.DESTYPE = IMPTYPE;
    INPUT.PROJdgn = PROJdgn;
    [GENPRJ,err] = func(GENPRJ,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    KSA2 = GENPRJ.KSA;

    %------------------------------------------
    % Solve T at Evolution Constraint
    %------------------------------------------
    Rad2 = sqrt(KSA2(:,:,1).^2 + KSA2(:,:,2).^2 + KSA2(:,:,3).^2);
    Rad2 = mean(Rad2,1);
    if strcmp(TIMADJ.CACC.doconstraint,'Yes')
        T2 = interp1(TIMADJ.ConstEvolRad,TIMADJ.ConstEvolT,Rad2,'spline');
    end
    T2 = 2*T(end)-T2;

    %---------------------------------------------
    % Combine
    %---------------------------------------------
    IMPTYPE.T = [T T2];
    IMPTYPE.KSA = cat(2,KSA,KSA2);
    
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
    IMPTYPE.start2est = FINMETH.start2est;
    
%=================================================================
% PreDeSolTim
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
    end
       
    KmatRecon = zeros([size(KmatRecon0) 2]);
    KmatRecon(:,:,:,1) = KmatRecon0;    
    KmatDisplay = NaN*ones([nptot 3 3]);
    ind = find(round(Samp0*1e6) == round(SampRecon0(1)*1e6));
    KmatDisplay(ind:ind+npro-1,:,1) = squeeze(KmatRecon(1,:,:,1));
    
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
    
    %---------------------------------------------
    % Fit 2nd Image
    %---------------------------------------------
%     %----
%     shift = 0.001;
%     %----
%     Samp0 = (shift:PROJimp.dwell:qTrecon(end)+shift); 
%     %Samp0 = (0:PROJimp.dwell:qTrecon(end));  
%     [Kmat0,Kend] = ReSampleKSpace_v7a(Grecon,qTrecon-qTrecon(1),Samp0-qTrecon(1),PROJimp.gamma);                % negative time fixup    
        
    tKmatRecon = squeeze(flip(KmatRecon0(1,:,:),2));
    Rad0 = sqrt(tKmatRecon(:,1).^2 + tKmatRecon(:,2).^2 + tKmatRecon(:,3).^2);
    ind = find(Samp0 >= IMPTYPE.start2est);
    ind = ind-10:1:ind+20;
    residsum = [];
    for n = 1:length(ind)
        tKmat0 = squeeze(Kmat0(1,ind(n):ind(n)+npro-1,:));
        Rad1 = sqrt(tKmat0(:,1).^2 + tKmat0(:,2).^2 + tKmat0(:,3).^2);
        resid = Rad0 - Rad1;
        residsum(n) = sum(abs(resid(:)));
    end
    SampStart2 = ind(residsum == min(residsum));
    if SampStart2 == ind(1) || SampStart2 == ind(end)
        error                                   % something wrong with initial estimate
    end
    if strcmp(TST.IMPTYPE.Vis,'Yes')
        plot([NaN*ones(SampStart2-1,1);Rad0],'r','linewidth',2);
    end
    
    KmatRecon(:,:,:,2) = flip(Kmat0(:,SampStart2:SampStart2+npro-1,:),2);
    KmatDisplay(SampStart2:SampStart2+npro-1,:,2) = Kmat0(1,SampStart2:SampStart2+npro-1,:);
    KmatDisplay(1:SampStart2+npro-1,:,3) = Kmat0(1,1:SampStart2+npro-1,:);
    
    IMPTYPE.SampStart = [SampStart1 SampStart2];
    IMPTYPE.KmatRecon = KmatRecon;
    IMPTYPE.KmatDisplay = KmatDisplay;
    IMPTYPE.numberofimages = 2;
   
    %---------------------------------------------
    % Return Relavent to KSMP Structure
    %---------------------------------------------    
    KSMP.SampStart = IMPTYPE.SampStart;
    CenSamp = KSMP.SampStart;
    CenSamp(2) = CenSamp(2) + npro-1;
    KSMP.Delay2Centre = Samp0(CenSamp);
    KSMP.flip = [0 1];
    IMPTYPE.KSMP = KSMP;

    %---------------------------------------------
    % Increase Tro to accomodate any gradient delay (Siemens)
    %---------------------------------------------
    troProt = TSMP.dwellProt*ceil(KSMP.Delay2Centre(2)/TSMP.dwellProt);
    nproProt = troProt/TSMP.dwellProt;
    extraptsProt = TSMP.minextraptsProt;
    while true
        totpts = (nproProt+extraptsProt)*TSMP.sysoversamp;
        if rem(totpts,2) == 0                         % make sure number of data points is a multiple of 2                            
            break
        else
            extraptsProt = extraptsProt+1;
        end
    end    
    
    %---------------------------------------------
    % Return Relavent to TSMP Structure
    %---------------------------------------------       
    TSMP.troProt = TSMP.dwellProt*(nproProt+extraptsProt);
    TSMP.troMag = TSMP.dwell*(totpts);
    TSMP.nproProt = nproProt+extraptsProt;  
    TSMP.nproMag = totpts;
    IMPTYPE.TSMP = TSMP;
       
end
    









    