%==================================================================
% (v2a)
%       - Turn Into Object
%==================================================================

classdef DesType_YarnBallOutRphsSingleEcho_v2a < handle

properties (SetAccess = private)                   
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
    TDIFS;
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
function DESTYPE = DesType_YarnBallOutRphsSingleEcho_v2a(DESTYPEipt)

    Status2('busy','Get DesType',3);

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
    func = str2func('CalcEvoDiffs_Simple_v2a');           
    DESTYPE.TDIFS = func('');
    
    %------------------------------------------
    % Name
    %------------------------------------------
    DESTYPE.Name =  'SEOR';

    Status2('done','',2);
    Status2('done','',3);

end

%==================================================================
% InitialSetup
%==================================================================
function InitialSetup(DESTYPE,INPUT)
    
    DESTYPE.PROJdgn = INPUT.PROJdgn;
    DESTYPE.PROJdgn.p = 0.7
    %---------------------------------------------
    % Subclasses
    %---------------------------------------------
    GENPRJfunc = str2func(INPUT.GENPRJ.Method);
    GENPRJipt = INPUT.GENPRJ.GENPRJipt;
    CLRfunc = str2func(INPUT.CLR.Method);
    CLRipt = INPUT.CLR.CLRipt;
    SPINfunc = str2func(INPUT.SPIN.Method);
    SPINipt = INPUT.SPIN.SPINipt;
    ELIPfunc = str2func(INPUT.ELIP.Method);
    ELIPipt = INPUT.ELIP.ELIPipt;
    TURNEVOfunc = str2func(DESTYPE.TURNEVO.Method);
    TURNEVOipt = DESTYPE.TURNEVO.TURNEVOipt;
    TURNSOLfunc = str2func(DESTYPE.TURNSOL.Method);
    TURNSOLipt = DESTYPE.TURNSOL.TURNSOLipt;
    RADSOLfunc = str2func(INPUT.RADSOL.Method);
    RADSOLipt = INPUT.RADSOL.RADSOLipt;
    DESOLfunc = str2func(INPUT.DESOL.Method);
    DESOLipt = INPUT.DESOL.DESOLipt;
    TDIFSfunc = str2func(DESTYPE.TDIFS.Method);
    TDIFSipt = DESTYPE.TDIFS.TDIFSipt;
    
    %---------------------------------------------
    % Out Trajectory
    %---------------------------------------------
    DESTYPE.GENPRJ = GENPRJfunc(GENPRJipt);
    DESTYPE.GENPRJ.SetColour(CLRfunc,CLRipt);
    DESTYPE.GENPRJ.CLR.SetRadSol(RADSOLfunc,RADSOLipt);
    DESTYPE.GENPRJ.CLR.RADSOL.SetDeRadSolFunc(DESTYPE.PROJdgn.p);
    DESTYPE.GENPRJ.CLR.SetTurnEvo(TURNEVOfunc,TURNEVOipt);
    DESTYPE.GENPRJ.CLR.SetTurnSol(TURNSOLfunc,TURNSOLipt);
    DESTYPE.GENPRJ.CLR.SetSpin(SPINfunc,SPINipt);
    DESTYPE.GENPRJ.CLR.SetRad(DESTYPE.PROJdgn.rad);
    DESTYPE.GENPRJ.CLR.SetP(DESTYPE.PROJdgn.p);
    DESTYPE.GENPRJ.CLR.SetDir(1);
    DESTYPE.GENPRJ.CLR.SPIN.DefineSpin;
    DESTYPE.GENPRJ.SetElip(ELIPfunc,ELIPipt);
    DESTYPE.GENPRJ.SetDeSol(DESOLfunc,DESOLipt);
    DESTYPE.GENPRJ.SetkMax(DESTYPE.PROJdgn.kmax);
    DESTYPE.GENPRJ.SetTro(DESTYPE.PROJdgn.tro);
    DESTYPE.GENPRJ.SetTrajEvoDiffs(TDIFSfunc,TDIFSipt);
    
    %---------------------------------------------
    % Rephase Trajectory
    %---------------------------------------------    
    DESTYPE.GENPRJ(2) = GENPRJfunc(GENPRJipt);
    DESTYPE.GENPRJ(2).SetColour(CLRfunc,CLRipt);
    DESTYPE.GENPRJ(2).CLR.SetRadSol(RADSOLfunc,RADSOLipt);
    DESTYPE.GENPRJ(2).CLR.RADSOL.SetDeRadSolFunc(DESTYPE.PROJdgn.p);
    DESTYPE.GENPRJ(2).CLR.SetTurnEvo(TURNEVOfunc,TURNEVOipt);
    DESTYPE.GENPRJ(2).CLR.SetTurnSol(TURNSOLfunc,TURNSOLipt);
    DESTYPE.GENPRJ(2).CLR.SetSpin(SPINfunc,SPINipt);
    DESTYPE.GENPRJ(2).CLR.SetRad(DESTYPE.PROJdgn.rad);
    DESTYPE.GENPRJ(2).CLR.SetP(DESTYPE.PROJdgn.p);
    DESTYPE.GENPRJ(2).CLR.SetDir(-1);
    DESTYPE.GENPRJ(2).CLR.SPIN.SetRelativeSpin(DESTYPE.RphsSpinReduce);
    DESTYPE.GENPRJ(2).CLR.SPIN.DefineSpin;
    %DESTYPE.GENPRJ(2).CLR.TURNEVO.SetSlope(DESTYPE.RphsSlope);
    DESTYPE.GENPRJ(2).SetElip(ELIPfunc,ELIPipt);
    DESTYPE.GENPRJ(2).SetDeSol(DESOLfunc,DESOLipt);
    DESTYPE.GENPRJ(2).SetkMax(DESTYPE.PROJdgn.kmax);
    DESTYPE.GENPRJ(2).SetTro(DESTYPE.RphsTro);
    DESTYPE.GENPRJ(2).SetTrajEvoDiffs(TDIFSfunc,TDIFSipt);
    
    %---------------------------------------------
    % Solve Turning for Each
    %--------------------------------------------- 
    DESTYPE.SolveTurning;   
    
end

%==================================================================
% SolveTurning
%==================================================================
function SolveTurning(DESTYPE)
%     DESTYPE.GENPRJ(1).CLR.TURNSOL.SolveTurning(DESTYPE.GENPRJ(1).CLR);
%     DESTYPE.GENPRJ(2).CLR.TURNSOL.SolveTurning(DESTYPE.GENPRJ(2).CLR);          
end

%==================================================================
% SolveDeSolTiming
%==================================================================
function SolveDeSolTiming(DESTYPE)
    for n = 1:2
        DESTYPE.GENPRJ(n).DESOL.SetCourseAdjust(0);
        DESTYPE.GENPRJ(n).DESOL.GetDeSolutionTiming(DESTYPE.GENPRJ(n).CLR,DESTYPE.TST);
    end
    
    DESOL = DESTYPE.GENPRJ(n).DESOL
    
    
end

%==================================================================
% SolveDeSolTiming
%==================================================================
function TimingAdjust(DESTYPE,TIMADJ)
    InitRad = DESTYPE.PROJdgn.p;
    InitPhi = pi/2;
    InitTheta = 0;
    DESTYPE.GENPRJ(1).Initialize(InitRad,InitPhi,InitTheta);    
    DESTYPE.GENPRJ(1).SolveTrajInternal;
    
    InitRad = DESTYPE.GENPRJ(1).EndRad;
    InitPhi = DESTYPE.GENPRJ(1).EndPhi;
    InitTheta = DESTYPE.GENPRJ(1).EndTheta;
    DESTYPE.GENPRJ(2).Initialize(InitRad,InitPhi,InitTheta);    
    DESTYPE.GENPRJ(2).SolveTrajInternal;
       
    DESTYPE.T = [DESTYPE.GENPRJ(1).T DESTYPE.GENPRJ(1).T(end)+DESTYPE.GENPRJ(2).T(2:end)];
    DESTYPE.rkSpace = [DESTYPE.GENPRJ(1).rkSpace DESTYPE.GENPRJ(2).rkSpace(1,2:end,:)];
    DESTYPE.rRad = [DESTYPE.GENPRJ(1).rRad DESTYPE.GENPRJ(2).rRad(2:end)];
    DESTYPE.kSpace = DESTYPE.rkSpace * DESTYPE.PROJdgn.kmax; 
    figure(1235213); hold on;
    plot(DESTYPE.T,squeeze(DESTYPE.rkSpace));
    plot(DESTYPE.T,squeeze(DESTYPE.rRad),'k');

    figure(2235213); hold on;
    plot(DESTYPE.GENPRJ(1).rRad(2:end),(DESTYPE.GENPRJ(1).rRad(2:end)-DESTYPE.GENPRJ(1).rRad(1:end-1))./(DESTYPE.GENPRJ(1).DESOL.tautot(2:end)-DESTYPE.GENPRJ(1).DESOL.tautot(1:end-1)));
      
    figure(3235213); hold on;
    plot(DESTYPE.GENPRJ(1).T(2:end),(DESTYPE.GENPRJ(1).rRad(2:end)-DESTYPE.GENPRJ(1).rRad(1:end-1))./(DESTYPE.GENPRJ(1).DESOL.tautot(2:end)-DESTYPE.GENPRJ(1).DESOL.tautot(1:end-1)));
    
    
    DESTYPE.TDIFS.CalcEvoDiffs(DESTYPE);
    figure(1235214); hold on;    
    plot(DESTYPE.TDIFS.Tvel,squeeze(DESTYPE.TDIFS.vel));
    plot(DESTYPE.TDIFS.Tvel,squeeze(DESTYPE.TDIFS.magvel)); 
    ylim([-20000 20000]);
    
    DESTYPE.TDIFS.CalcEvoDiffs(DESTYPE);
    figure(1235215); hold on;    
    plot(DESTYPE.TDIFS.Tacc,squeeze(DESTYPE.TDIFS.acc));
    plot(DESTYPE.TDIFS.Tacc,squeeze(DESTYPE.TDIFS.magacc)); 
    ylim([-300000 300000]);
        
    
    
    
%     DESTYPE.GENPRJ(1).TDIFS.CalcEvoDiffs(DESTYPE.GENPRJ(1));
%     DESTYPE.GENPRJ(2).TDIFS.CalcEvoDiffs(DESTYPE.GENPRJ(2));
%     Tvel = [DESTYPE.GENPRJ(1).TDIFS.Tvel DESTYPE.GENPRJ(1).TDIFS.Tend+DESTYPE.GENPRJ(2).TDIFS.Tvel];
%     vel = [DESTYPE.GENPRJ(1).TDIFS.vel DESTYPE.GENPRJ(2).TDIFS.vel];
%     plot(Tvel,squeeze(vel)); 
% 
%     
%     Tacc = [DESTYPE.GENPRJ(1).TDIFS.Tacc DESTYPE.GENPRJ(1).TDIFS.Tacc(end)+DESTYPE.GENPRJ(2).TDIFS.Tacc];
%     acc = [DESTYPE.GENPRJ(1).TDIFS.acc DESTYPE.GENPRJ(2).TDIFS.acc];
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
