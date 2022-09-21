%====================================================
%
%====================================================

function [DESTYPE,err] = DesType_YarnBallOutRphsSingleEcho_v1f_Func(DESTYPE,INPUT)

Status2('busy','YarnBallOutIn Design',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

Func = INPUT.func;

%=================================================================
% PreDeSolTim
%=================================================================
if strcmp(Func,'PreDeSolTim')

    %---------------------------------------------
    % Name
    %---------------------------------------------
    DESTYPE.name = 'SEOR';
    
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
    % RadSolFuncs
    %------------------------------------------
    deradsolinfunc0 = str2func(['@(r,p)' RADEV.deradsolinfunc]);
    deradsoloutfunc0 = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
    
    %------------------------------------------
    % Define Spinning Speeds
    %------------------------------------------
    stheta0 = @(r) 1/SPIN.spincalcndiscsfunc(r);  
    sphi0 = @(r) 1/SPIN.spincalcnspokesfunc(r);         
       
    %------------------------------------------
    % Define Evolution Types
    %------------------------------------------
    DESTYPE0 = DESTYPE;
    clear DESTYPE
    for n = 1:2 
        p = PROJdgn.p;                          % has to stay constant for both
        if n == 1
            tro = PROJdgn.tro;
            %tro = DESTYPE0.RphsTro;
            elip = PROJdgn.elip;
            YbAxisElip = PROJdgn.YbAxisElip;
            dir = 1;
            stheta = stheta0;
            %stheta = @(r) stheta0(r)*DESTYPE0.SpinReduce;
            sphi = sphi0;
            slope = DESTYPE0.TURNEVO.slope;
        elseif n == 2
            tro = DESTYPE0.RphsTro;
            elip = 1;
            YbAxisElip = 'z';
            dir = -1;
            stheta = @(r) stheta0(r)*DESTYPE0.SpinReduce;
            sphi = @(r) sphi0(r);
            slope = DESTYPE0.TURNEVO.slope;
        end
        
        %---------------------------------------------
        % Create DESTRCT
        %---------------------------------------------
        tDESTYPE = DESTYPE0;
        tDESTYPE.DESTRCT.stheta = stheta;
        tDESTYPE.DESTRCT.sphi = sphi;
        tDESTYPE.DESTRCT.p = p;
        tDESTYPE.DESTRCT.dir = dir;
        tDESTYPE.DESTRCT.tro = tro;
        tDESTYPE.DESTRCT.rad = PROJdgn.rad;
        tDESTYPE.DESTRCT.elip = elip;
        tDESTYPE.DESTRCT.YbAxisElip = YbAxisElip;
        tDESTYPE.DESTRCT.deradsoloutfunc = @(r) deradsoloutfunc0(r,p); 
        tDESTYPE.DESTRCT.deradsolinfunc = @(r) deradsolinfunc0(r,p);   
        tDESTYPE.TURNEVO.slope = slope;
        
        %---------------------------------------------
        % Determine Radius Solution
        %---------------------------------------------
        func = str2func([TURNSOL.method,'_Func']);      
        INPUT.DESTYPE = tDESTYPE;
        INPUT.CLR = CLR;
        [TURNSOL,err] = func(TURNSOL,INPUT);
        if err.flag
            return
        end
        clear INPUT;
        tDESTYPE = TURNSOL.DESTYPE;
        TURNSOL = rmfield(TURNSOL,'DESTYPE');
        tDESTYPE.TURNSOL = TURNSOL;
        tDESTYPE.MaxRadSolve = TURNSOL.MaxRadSolve;
        DESTYPE(n) = tDESTYPE;
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
    clear INPUT;
    
    %---------------------------------------------
    % Create Structures
    %---------------------------------------------
    for n = 1:2
        if n == 1
            tau1 = DESOL.tau1;
            tau2 = DESOL.tau2;
            T = DESOL.T;
            len = DESOL.len;
        elseif n == 2
            tau1 = DESOL.tau1;
            tau2 = flip(DESOL.tau2(end)-DESOL.tau2);
            T = (DESOL.tautot/DESOL.projlen0)*DESTYPE(2).DESTRCT.tro;
            T = flip(T);
            len = DESOL.len;
        end
        INPUT = DESTYPE(n).DESTRCT;
        INPUT.turnradfunc = DESTYPE(n).TURNEVO.turnradfunc;
        INPUT.turnspinfunc = DESTYPE(n).TURNEVO.turnspinfunc;
        INPUT.dir = DESTYPE(n).DESTRCT.dir;
        INPUT.deradsolfunc = DESTYPE(n).DESTRCT.deradsoloutfunc;
        INPUT.turnloc = DESTYPE(n).TURNSOL.turnloc;
        DESTYPE(n).SLV.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
        INPUT.deradsolfunc = DESTYPE(n).DESTRCT.deradsolinfunc;     
        DESTYPE(n).SLV.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
        DESTYPE(n).SLV.tau1 = tau1;
        DESTYPE(n).SLV.tau2 = tau2;
        DESTYPE(n).SLV.len = len;
        DESTYPE(n).SLV.T = T;
        DESTYPE(n).SLV.RADEV = DESOL.RADEV;
    end

%=================================================================
% Timing Adjust
%=================================================================
elseif strcmp(Func,'TimingAdj')    

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    PROJdgn = INPUT.PROJdgn;
    TIMADJ = INPUT.TIMADJ;
    GENPRJ0 = INPUT.GENPRJ;
    PSMP = INPUT.PSMP;
    TST = INPUT.TST;
    clear INPUT;

    %---------------------------------------------
    % Constrain trajectory 1
    %---------------------------------------------
    rad0 = DESTYPE(1).DESTRCT.p;
    phi0 = PSMP.phi;
    theta0 = PSMP.theta;    
    
    %---------------------------------------------
    % Generate 
    %---------------------------------------------
    func = str2func([GENPRJ0.method,'_Func']);    
    INPUT.rad0 = rad0;
    INPUT.phi0 = phi0;
    INPUT.theta0 = theta0;
    INPUT.DESTYPE = DESTYPE(1);
    [GENPRJ(1),err] = func(GENPRJ0,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    
    %------------------------------------------
    % Timing Adjust
    %------------------------------------------
    func = str2func([TIMADJ.method,'_Func']);  
    INPUT.PROJdgn = PROJdgn;
    INPUT.DESTYPE = DESTYPE(1);
    INPUT.GENPRJ = GENPRJ(1);
    INPUT.TST = TST;
    [TIMADJ,err] = func(TIMADJ,INPUT);
    if err.flag == 1
        return
    end
    clear INPUT;   
    CACC(1) = TIMADJ.CACC;    
    
    %------------------------------------------
    % Plot Things
    %------------------------------------------
    figure(3623460); hold on;
    plot(CACC(1).Tvel,CACC(1).vel);
    figure(3623461); hold on;
    plot(CACC(1).Tacc,CACC(1).acc);     
    
    figure(2345234); hold on;
    Rad = sqrt(GENPRJ(1).KSA(1,:,1).^2 + GENPRJ(1).KSA(1,:,2).^2 + GENPRJ(1).KSA(1,:,3).^2);
    plot(CACC(1).TArr,squeeze(GENPRJ(1).KSA));
    plot(CACC(1).TArr,Rad)    
    
    %---------------------------------------------
    % Constrain trajectory 2
    %---------------------------------------------
    rad0 = GENPRJ(1).EndVals(:,1);
    phi0 = GENPRJ(1).EndVals(:,2);
    theta0 = GENPRJ(1).EndVals(:,3); 
     
    %---------------------------------------------
    % Generate 
    %---------------------------------------------
    func = str2func([GENPRJ0.method,'_Func']);    
    INPUT.rad0 = rad0;
    INPUT.phi0 = phi0;
    INPUT.theta0 = theta0;
    INPUT.DESTYPE = DESTYPE(2);
    [GENPRJ(2),err] = func(GENPRJ0,INPUT);
    if err.flag
        return
    end
    clear INPUT; 

    %------------------------------------------
    % Timing Adjust
    %------------------------------------------
    func = str2func([TIMADJ.method,'_Func']);  
    INPUT.PROJdgn = PROJdgn;
    INPUT.DESTYPE = DESTYPE(2);
    INPUT.GENPRJ = GENPRJ(2);
    INPUT.TST = TST;
    [TIMADJ,err] = func(TIMADJ,INPUT);
    if err.flag == 1
        return
    end
    clear INPUT;   
    CACC(2) = TIMADJ.CACC;

    %------------------------------------------
    % Plot Things
    %------------------------------------------
    figure(3623460); hold on;
    Tend = CACC(1).Tvel(end) + CACC(2).Tvel(end);
    T = Tend - flip(CACC(2).Tvel);
    plot(T,flip(-CACC(2).vel));
    figure(3623461); hold on;
    plot(T,flip(CACC(2).acc));  
      
    figure(2345234); hold on;
    Rad = sqrt(GENPRJ(2).KSA(1,:,1).^2 + GENPRJ(2).KSA(1,:,2).^2 + GENPRJ(2).KSA(1,:,3).^2);
    Tend = CACC(1).TArr(end) + CACC(2).TArr(end);
    T = Tend - flip(CACC(2).TArr);
    plot(T,squeeze(GENPRJ(2).KSA));
    plot(T,Rad)    

               
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








    