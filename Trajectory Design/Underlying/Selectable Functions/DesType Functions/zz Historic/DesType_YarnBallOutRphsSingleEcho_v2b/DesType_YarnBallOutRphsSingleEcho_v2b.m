%==================================================================
% (v2b)
%       - Clean up
%==================================================================

classdef DesType_YarnBallOutRphsSingleEcho_v2b < handle

properties (SetAccess = private)                   
    Method = 'DesType_YarnBallOutRphsSingleEcho_v2b'
    Name;
    DESTYPEipt;
    TurnEvolutionFunc;
    TurnSolutionFunc;
    TestFunc;
    RphsTro;
    RphsSlope;
    RphsSpinReduce;
    TURNEVO;
    TURNSOL;
    TST;
    GENPRJ;
    CALCEVO;
    PROJdgn;
    T;
    kSpace;
    rkSpace;
    rRad;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function DESTYPE = DesType_YarnBallOutRphsSingleEcho_v2b(DESTYPEipt)

    %---------------------------------------------
    % Load Panel Input
    %---------------------------------------------
    DESTYPE.DESTYPEipt = DESTYPEipt;
    DESTYPE.TurnEvolutionFunc = DESTYPEipt.('TurnEvolutionfunc').Func;
    DESTYPE.TurnSolutionFunc = DESTYPEipt.('TurnSolutionfunc').Func;
    DESTYPE.TestFunc = DESTYPEipt.('DesTestfunc').Func;
    DESTYPE.RphsTro = str2double(DESTYPEipt.('RphsTro'));
    DESTYPE.RphsSpinReduce = str2double(DESTYPEipt.('RphsSpinReduce'));
    DESTYPE.RphsSlope = str2double(DESTYPEipt.('RphsSlope'));

    %---------------------------------------------
    % Get Working Structures from Sub Functions
    %---------------------------------------------
    TURNEVOipt = DESTYPEipt.('TurnEvolutionfunc');
    if isfield(DESTYPEipt,('TurnEvolutionfunc_Data'))
        TURNEVOipt.TurnEvolutionfunc_Data = DESTYPEipt.TurnEvolutionfunc_Data;
    end
    TURNSOLipt = DESTYPEipt.('TurnSolutionfunc');
    if isfield(DESTYPEipt,('TurnSolutionfunc_Data'))
        TURNSOLipt.TurnSolutionfunc_Data = DESTYPEipt.TurnSolutionfunc_Data;
    end
    TSTipt = DESTYPEipt.('DesTestfunc');
    if isfield(DESTYPEipt,('DesTestfunc_Data'))
        TSTipt.DesTestfunc_Data = DESTYPEipt.DesTestfunc_Data;
    end

    %------------------------------------------
    % Create Shell Objects
    %------------------------------------------
    func = str2func(DESTYPE.TurnEvolutionFunc);           
    DESTYPE.TURNEVO = func(TURNEVOipt);
    func = str2func(DESTYPE.TurnSolutionFunc);           
    DESTYPE.TURNSOL = func(TURNSOLipt);
    func = str2func(DESTYPE.TestFunc);           
    DESTYPE.TST = func(TSTipt);
    func = str2func('CalcEvoDiffs_Simple_v2b');           
    DESTYPE.CALCEVO = func('');
    
    %------------------------------------------
    % Name
    %------------------------------------------
    DESTYPE.Name =  'SEOR';

end

%==================================================================
% InitialSetup
%==================================================================
function Build(DESTYPE,DESMETH)
    
    DESTYPE.PROJdgn = DESMETH.PROJdgn;

    %---------------------------------------------
    % Subclasses
    %---------------------------------------------
    GENPRJfunc = str2func(DESMETH.GENPRJ.Method);
    GENPRJipt = DESMETH.GENPRJ.GENPRJipt;
    SPINfunc = str2func(DESMETH.SPIN.Method);
    SPINipt = DESMETH.SPIN.SPINipt;
    ELIPfunc = str2func(DESMETH.ELIP.Method);
    ELIPipt = DESMETH.ELIP.ELIPipt;
    RADACCfunc = str2func(DESMETH.RADACC.Method);
    RADACCipt = DESMETH.RADACC.RADACCipt;
    CALCEVOfunc = str2func(DESTYPE.CALCEVO.Method);
    CALCEVOipt = DESTYPE.CALCEVO.CALCEVOipt;
    
    %---------------------------------------------
    % Out Trajectory
    %---------------------------------------------
    DESTYPE.GENPRJ = GENPRJfunc(GENPRJipt);
    DESTYPE.GENPRJ.SetkMax(DESTYPE.PROJdgn.kmax);
    DESTYPE.GENPRJ.SetTro(DESTYPE.PROJdgn.tro);
    DESTYPE.GENPRJ.SetElip(ELIPfunc,ELIPipt);
    DESTYPE.GENPRJ.SetSpin(SPINfunc,SPINipt);
    DESTYPE.GENPRJ.SPIN.SetMatRad(DESTYPE.PROJdgn.rad);
    DESTYPE.GENPRJ.SPIN.DefineSpin;
    DESTYPE.GENPRJ.SetRadAcc(RADACCfunc,RADACCipt);
    DESTYPE.GENPRJ.SetCalcEvo(CALCEVOfunc,CALCEVOipt);


    
    %---------------------------------------------
    % Rephase Trajectory
    %---------------------------------------------    
%     DESTYPE.GENPRJ(2) = GENPRJfunc(GENPRJipt);
%     DESTYPE.GENPRJ(2).SetColour(CLRfunc,CLRipt);
%     DESTYPE.GENPRJ(2).CLR.SetRadSol(RADSOLfunc,RADSOLipt);
%     DESTYPE.GENPRJ(2).CLR.RADSOL.SetDeRadSolFunc(DESTYPE.PROJdgn.p);
%     DESTYPE.GENPRJ(2).CLR.SetTurnEvo(TURNEVOfunc,TURNEVOipt);
%     DESTYPE.GENPRJ(2).CLR.SetTurnSol(TURNSOLfunc,TURNSOLipt);
%     DESTYPE.GENPRJ(2).CLR.SetSpin(SPINfunc,SPINipt);
%     DESTYPE.GENPRJ(2).CLR.SetRad(DESTYPE.PROJdgn.rad);
%     DESTYPE.GENPRJ(2).CLR.SetP(DESTYPE.PROJdgn.p);
%     DESTYPE.GENPRJ(2).CLR.SetDir(-1);
%     DESTYPE.GENPRJ(2).CLR.SPIN.SetRelativeSpin(DESTYPE.RphsSpinReduce);
%     DESTYPE.GENPRJ(2).CLR.SPIN.DefineSpin;
%     %DESTYPE.GENPRJ(2).CLR.TURNEVO.SetSlope(DESTYPE.RphsSlope);
%     DESTYPE.GENPRJ(2).SetElip(ELIPfunc,ELIPipt);
%     DESTYPE.GENPRJ(2).SetDeSol(DESOLfunc,DESOLipt);
%     DESTYPE.GENPRJ(2).SetkMax(DESTYPE.PROJdgn.kmax);
%     DESTYPE.GENPRJ(2).SetTro(DESTYPE.RphsTro);
%     DESTYPE.GENPRJ(2).SetTrajEvoDiffs(CALCEVOfunc,CALCEVOipt);
    
    %---------------------------------------------
    % Solve Turning for Each
%     %--------------------------------------------- 
%     DESTYPE.SolveTurning;   
%     
end


%==================================================================
% SolveDeSolTiming
%==================================================================
function Test(DESTYPE)
    InitYB = [0 0 0 0];
    DESTYPE.GENPRJ(1).Initialize(InitYB);    
    DESTYPE.GENPRJ(1).SolveTraj;
    
    figure(101); hold on;
    plot(DESTYPE.GENPRJ(1).Tau,squeeze(DESTYPE.GENPRJ(1).rkSpace));
    plot(DESTYPE.GENPRJ(1).Tau,DESTYPE.GENPRJ(1).GetTestRelRad);

    TrajNum = 1;
    DESTYPE.GENPRJ(1).CalcEvoDifs(TrajNum);
    
    figure(201); hold on;
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tvel,squeeze(DESTYPE.GENPRJ(1).CALCEVO.vel));
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tvel,squeeze(DESTYPE.GENPRJ(1).CALCEVO.magvel));    
 
    figure(202); hold on;
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tvel,squeeze(DESTYPE.GENPRJ(1).CALCEVO.sphvel(:,:,1)),'r');      % r
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tvel,squeeze(DESTYPE.GENPRJ(1).CALCEVO.sphvel(:,:,2)),'g');      % phi
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tvel,squeeze(DESTYPE.GENPRJ(1).CALCEVO.sphvel(:,:,3)),'b');      % theta
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tvel,squeeze(DESTYPE.GENPRJ(1).CALCEVO.magsphvel),'k');      
    
    figure(203); hold on;
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tacc,squeeze(DESTYPE.GENPRJ(1).CALCEVO.acc));
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tacc,squeeze(DESTYPE.GENPRJ(1).CALCEVO.magacc),'k');    
    
    figure(204); hold on;
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tacc,squeeze(DESTYPE.GENPRJ(1).CALCEVO.sphacc(:,:,1)),'r');      % r
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tacc,squeeze(DESTYPE.GENPRJ(1).CALCEVO.sphacc(:,:,2)),'g');      % phi
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tacc,squeeze(DESTYPE.GENPRJ(1).CALCEVO.sphacc(:,:,3)),'b');      % theta
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tacc,squeeze(DESTYPE.GENPRJ(1).CALCEVO.magsphacc),'k'); 
    
    plot(DESTYPE.GENPRJ(1).CALCEVO.Tacc,squeeze(DESTYPE.GENPRJ(1).CALCEVO.sphacc(:,:,4)),'m');    
    
    dr = DESTYPE.GENPRJ(1).drArr(1:2:end);
    dphi = DESTYPE.GENPRJ(1).dphiArr(1:2:end);
    dtheta = DESTYPE.GENPRJ(1).dthetaArr(1:2:end);
    r = DESTYPE.GENPRJ(1).rArr(1:2:end);
    phi = DESTYPE.GENPRJ(1).phiArr(1:2:end);
    theta = DESTYPE.GENPRJ(1).thetaArr(1:2:end);
    t = DESTYPE.GENPRJ(1).tArr(1:2:end);

    vtheta = r.*sin(phi).*dtheta; 
    vphi = r.*dphi;
    vx = dr.*cos(theta).*sin(phi) - r.*sin(theta).*sin(phi).*dtheta + r.*cos(theta).*cos(phi).*dphi;
    
    figure(23461); hold on;   
    S = sqrt(dr.^2 + (r.^2).*(sin(phi).^2).*(dtheta.^2) + (r.^2).*(dphi.^2));
    S2 = sqrt(dr.^2 + vtheta.^2 + vphi.^2);
    plot(t,S);
    plot(t,S2,'k');
    plot(t,dr,'r');
    plot(t,vtheta,'m');
    plot(t,vphi,'c');    
    
    d2r = (dr(2:end)-dr(1:end-1))./(t(2:end)-t(1:end-1));
    d2theta = (dtheta(2:end)-dtheta(1:end-1))./(t(2:end)-t(1:end-1));
    d2phi = (dphi(2:end)-dphi(1:end-1))./(t(2:end)-t(1:end-1));
    
    figure(23462);
    plot(t(2:end),d2phi);
    
    ar = d2r - r(1:end-1).*(dphi(1:end-1).^2) - r(1:end-1).*(sin(phi(1:end-1)).^2).*(dtheta(1:end-1).^2);
    modar = d2r + r(1:end-1).*(dphi(1:end-1).^2) + r(1:end-1).*(sin(phi(1:end-1)).^2).*(dtheta(1:end-1).^2);
    modar1 = r(1:end-1).*(dphi(1:end-1).^2); 
    atheta = 2*sin(phi(1:end-1)).*dtheta(1:end-1).*dr(1:end-1) + 2*r(1:end-1).*cos(phi(1:end-1)).*dtheta(1:end-1).*dphi(1:end-1) + r(1:end-1).*sin(phi(1:end-1)).*d2theta;
    aphi = 2*dr(1:end-1).*dphi(1:end-1) + r(1:end-1).*d2phi - r(1:end-1).*sin(phi(1:end-1)).*cos(phi(1:end-1)).*dtheta(1:end-1).^2;
    amean = sqrt(ar.^2 + atheta.^2 + aphi.^2);
    
    figure(2346); hold on;  
    plot(t(2:end),amean,'k');
    plot(t(2:end),ar,'r');
    plot(t(2:end),atheta,'m');
    plot(t(2:end),aphi,'c');     

    ar1 = d2r;
    ar2 = r(1:end-1).*(dphi(1:end-1).^2);
    ar3 = r(1:end-1).*(sin(phi(1:end-1)).^2).*(dtheta(1:end-1).^2);        
    figure(2347); hold on;     
    plot(t(2:end),ar1,'r'); 
    plot(t(2:end),ar2,'b'); 
    plot(t(2:end),ar3,'g'); 
    
    aphi1 = 2*dr(1:end-1).*dphi(1:end-1);
    aphi2 =  r(1:end-1).*d2phi;
    aphi3 = r(1:end-1).*sin(phi(1:end-1)).*cos(phi(1:end-1)).*dtheta(1:end-1).^2;        
    figure(2348); hold on;     
    plot(t(2:end),aphi1,'r'); 
    plot(t(2:end),aphi2,'b'); 
    plot(t(2:end),aphi3,'g'); 

    atheta1 = 2*sin(phi(1:end-1)).*dtheta(1:end-1).*dr(1:end-1);
    atheta2 =  2*r(1:end-1).*cos(phi(1:end-1)).*dtheta(1:end-1).*dphi(1:end-1);
    atheta3 = r(1:end-1).*sin(phi(1:end-1)).*d2theta;        
    figure(2349); hold on;     
    plot(t(2:end),atheta1,'r'); 
    plot(t(2:end),atheta2,'b'); 
    plot(t(2:end),atheta3,'g'); 

    

    
    
    
    
    
    
    
%     plot(t(2:end),d2theta,'g');
%     plot(t(2:end),d2phi,'b');    
%         
%     
%     figure(23464); hold on;
%     test =(dr(2:end)-dr(1:end-1))./(t(2:end)-t(1:end-1))
%     plot(t(1:end-1),(dr(2:end)-dr(1:end-1))./(t(2:end)-t(1:end-1)));
%     plot(r,dtheta);    
%     plot(r,dphi);       
%     
    DESTYPE.T = DESTYPE.GENPRJ.DESOL.tau;
    DESTYPE.rkSpace = DESTYPE.GENPRJ(1).rkSpace;    
    %DESTYPE.kSpace = DESTYPE.rkSpace * DESTYPE.PROJdgn.kmax;     
    DESTYPE.kSpace = DESTYPE.rkSpace;     
    
    DESTYPE.CALCEVO.CalcEvoDiffs(DESTYPE);
    figure(1235214); hold on;    
    plot(DESTYPE.CALCEVO.Tvel,squeeze(DESTYPE.CALCEVO.vel));
    plot(DESTYPE.CALCEVO.Tvel,squeeze(DESTYPE.CALCEVO.magvel)); 
    ylim([-5 5]);
    
    DESTYPE.CALCEVO.CalcEvoDiffs(DESTYPE);
    figure(1235215); hold on;    
    plot(DESTYPE.CALCEVO.Tacc,squeeze(DESTYPE.CALCEVO.acc));
    plot(DESTYPE.CALCEVO.Tacc,squeeze(DESTYPE.CALCEVO.magacc)); 
    ylim([-30 30]);
        
    
    
    
%     DESTYPE.GENPRJ(1).CALCEVO.CalcEvoDiffs(DESTYPE.GENPRJ(1));
%     DESTYPE.GENPRJ(2).CALCEVO.CalcEvoDiffs(DESTYPE.GENPRJ(2));
%     Tvel = [DESTYPE.GENPRJ(1).CALCEVO.Tvel DESTYPE.GENPRJ(1).CALCEVO.Tend+DESTYPE.GENPRJ(2).CALCEVO.Tvel];
%     vel = [DESTYPE.GENPRJ(1).CALCEVO.vel DESTYPE.GENPRJ(2).CALCEVO.vel];
%     plot(Tvel,squeeze(vel)); 
% 
%     
%     Tacc = [DESTYPE.GENPRJ(1).CALCEVO.Tacc DESTYPE.GENPRJ(1).CALCEVO.Tacc(end)+DESTYPE.GENPRJ(2).CALCEVO.Tacc];
%     acc = [DESTYPE.GENPRJ(1).CALCEVO.acc DESTYPE.GENPRJ(2).CALCEVO.acc];
%     figure(234523146); hold on;
%     plot(Tacc,squeeze(acc)); 
%     %ylim([-2000 2000]);
%     %xlim([1.99 2.01]);
%     %ylim([-15000 15000]); 
%     ylim([-300000 300000]); 
%     
%     DESOL = DESTYPE.GENPRJ(2).DESOL
%     
    error();
    
end


end
end
