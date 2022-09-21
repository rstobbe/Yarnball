%==================================================================
% (v2c)
%       - Matching 'YarnBallMultiEchoOutOut_v2c'
%==================================================================

classdef DesType_YarnBallMultiEchoOutOut_v2c < handle

properties (SetAccess = private)                   
    Method = 'DesType_YarnBallMultiEchoOutOut_v2c'
    Name
    Panel
    DESTYPEipt
    TurnEvolutionFunc
    GenProjFunc
    ElipFunc
    SpinFunc
    RadAccFunc
    ProjSampFunc
    OrientFunc
    Fov
    Vox
    Tro
    NumEchos
    TrajTurnSlope
    TrajTurnEnd
    RphsTurnSlope
    RphsTurnEnd
    RphsTro
    SamplingTro
    TURNEVO
    GENPRJ
    CALCEVO
    GRAD
    KINFO
    SPIN
    ELIP
    RADACC
    PSMP
    ORNT
    SYS
    NUC
    GradTimeQuant
    SolutionTiming
    TestrkSpace
    TestkSpace
    TestYB
    TestRelRad
    MaxSphereFreq
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function DESTYPE = DesType_YarnBallMultiEchoOutOut_v2c(DESTYPEipt)

    %---------------------------------------------
    % Load Panel Input
    %---------------------------------------------
    DESTYPE.DESTYPEipt = DESTYPEipt;
    DESTYPE.Fov = str2double(DESTYPEipt.('FoV'));
    DESTYPE.Vox = str2double(DESTYPEipt.('Vox'));
    DESTYPE.Tro = str2double(DESTYPEipt.('Tro')); 
    DESTYPE.NumEchos = str2double(DESTYPEipt.('NumberOfEchos'));  
    DESTYPE.TrajTurnSlope = str2double(DESTYPEipt.('TurnSlope'));
    DESTYPE.TrajTurnEnd = str2double(DESTYPEipt.('TurnEnd'));
    DESTYPE.GenProjFunc = DESTYPEipt.('GenProjfunc').Func;
    DESTYPE.ElipFunc = DESTYPEipt.('Elipfunc').Func;
    DESTYPE.SpinFunc = DESTYPEipt.('Spinfunc').Func;
    DESTYPE.RadAccFunc = DESTYPEipt.('RadialAccfunc').Func;
    DESTYPE.TurnEvolutionFunc = DESTYPEipt.('TurnEvolutionfunc').Func;
    DESTYPE.ProjSampFunc = DESTYPEipt.('ProjSampfunc').Func;
    DESTYPE.OrientFunc = DESTYPEipt.('Orientfunc').Func;
    DESTYPE.RphsTurnSlope = str2double(DESTYPEipt.('RphsTurnSlope'));
    DESTYPE.RphsTurnEnd = str2double(DESTYPEipt.('RphsTurnEnd'));
    DESTYPE.RphsTro = str2double(DESTYPEipt.('RphsTro'));

    %---------------------------------------------
    % Get Working Structures from Sub Functions
    %---------------------------------------------
    TURNEVOipt = DESTYPEipt.('TurnEvolutionfunc');
    if isfield(DESTYPEipt,('TurnEvolutionfunc_Data'))
        TURNEVOipt.TurnEvolutionfunc_Data = DESTYPEipt.TurnEvolutionfunc_Data;
    end
    GENPRJipt = DESTYPEipt.('GenProjfunc');
    if isfield(DESTYPEipt,('GenProjfunc_Data'))
        GENPRJipt.GenProjfunc_Data = DESTYPEipt.GenProjfunc_Data;
    end
    ELIPipt = DESTYPEipt.('Elipfunc');
    if isfield(DESTYPEipt,('Elipfunc_Data'))
        ELIPipt.Elipfunc_Data = DESTYPEipt.Elipfunc_Data;
    end
    SPINipt = DESTYPEipt.('Spinfunc');
    if isfield(DESTYPEipt,('Spinfunc_Data'))
        SPINipt.Spinfunc_Data = DESTYPEipt.Spinfunc_Data;
    end
    RADACCipt = DESTYPEipt.('RadialAccfunc');
    if isfield(DESTYPEipt,('RadialAccfunc_Data'))
        RADACCipt.RadialAccfunc_Data = DESTYPEipt.RadialAccfunc_Data;
    end
    PSMPipt = DESTYPEipt.('ProjSampfunc');
    if isfield(DESTYPEipt,('ProjSampfunc_Data'))
        PSMPipt.ProjSampfunc_Data = DESTYPEipt.ProjSampfunc_Data;
    end
    ORNTipt = DESTYPEipt.('Orientfunc');
    if isfield(DESTYPEipt,('Orientfunc_Data'))
        ORNTipt.Orientfunc_Data = DESTYPEipt.Orientfunc_Data;
    end
    
    %------------------------------------------
    % Create Shell Objects
    %------------------------------------------
    func = str2func(DESTYPE.GenProjFunc);           
    DESTYPE.GENPRJ = func(GENPRJipt);
    func = str2func(DESTYPE.SpinFunc);           
    DESTYPE.SPIN = func(SPINipt);
    func = str2func(DESTYPE.ElipFunc);           
    DESTYPE.ELIP = func(ELIPipt);
    func = str2func(DESTYPE.RadAccFunc);                   
    DESTYPE.RADACC = func(RADACCipt);     
    func = str2func(DESTYPE.TurnEvolutionFunc);
    DESTYPE.TURNEVO = func(TURNEVOipt);
    func = str2func(DESTYPE.ProjSampFunc);
    DESTYPE.PSMP = func(PSMPipt);
    func = str2func(DESTYPE.OrientFunc);
    DESTYPE.ORNT = func(ORNTipt);
    func = str2func('CalcEvoDiffs_Simple_v2b');           
    DESTYPE.CALCEVO = func('');
    func = str2func('Gradient_Calculations_v2a');           
    DESTYPE.GRAD = func('');
    func = str2func('kSpaceInfo_BasicHolder_v2a');           
    DESTYPE.KINFO = func('');
end

%==================================================================
% Initialize
%==================================================================
function Initialize(DESTYPE,SYS,NUC)

    %---------------------------------------------
    % Basic
    %---------------------------------------------
    DESTYPE.SYS = SYS;
    DESTYPE.NUC = NUC;
    DESTYPE.GradTimeQuant = SYS.GradSampBase/1000;
    
    %---------------------------------------------
    % Subclasses
    %---------------------------------------------
    GENPRJfunc = str2func(DESTYPE.GENPRJ.Method);
    GENPRJipt = DESTYPE.GENPRJ.GENPRJipt;
    SPINfunc = str2func(DESTYPE.SPIN.Method);
    SPINipt = DESTYPE.SPIN.SPINipt;
    ELIPfunc = str2func(DESTYPE.ELIP.Method);
    ELIPipt = DESTYPE.ELIP.ELIPipt;
    RADACCfunc = str2func(DESTYPE.RADACC.Method);
    RADACCipt = DESTYPE.RADACC.RADACCipt;
    CALCEVOfunc = str2func(DESTYPE.CALCEVO.Method);
    CALCEVOipt = DESTYPE.CALCEVO.CALCEVOipt;
    TURNEVOfunc = str2func(DESTYPE.TURNEVO.Method);
    TURNEVOipt = DESTYPE.TURNEVO.TURNEVOipt;

    %---------------------------------------------
    % Define k-Space info 
    %   (Out/In the same)
    %---------------------------------------------
    func = str2func('kSpaceInfo_BasicHolder_v2a');  
    for n = 1:DESTYPE.NumEchos 
        DESTYPE.KINFO(n) = func('');
        DESTYPE.KINFO(n).SetFov(DESTYPE.Fov);
        DESTYPE.KINFO(n).SetVox(DESTYPE.Vox);
        DESTYPE.KINFO(n).SetElip(DESTYPE.ELIP.Elip);
        DESTYPE.KINFO(n).SetYbAxisElip(DESTYPE.ELIP.YbAxisElip);
    end

    %---------------------------------------------
    % Out Trajectory
    %---------------------------------------------
    DESTYPE.GENPRJ(1) = GENPRJfunc(GENPRJipt);
    DESTYPE.GENPRJ(1).SetDir(-1);
    DESTYPE.GENPRJ(1).SetkMax(DESTYPE.KINFO(1).kmax);
    DESTYPE.GENPRJ(1).SetGradTimeQuant(DESTYPE.GradTimeQuant);
    DESTYPE.GENPRJ(1).SetTro(DESTYPE.Tro);
    DESTYPE.GENPRJ(1).SetElip(ELIPfunc,ELIPipt);
    DESTYPE.GENPRJ(1).SetSpin(SPINfunc,SPINipt);
    DESTYPE.GENPRJ(1).SPIN.SetMatRad(DESTYPE.KINFO(1).rad);
    DESTYPE.GENPRJ(1).SPIN.DefineSpin;
    DESTYPE.GENPRJ(1).SetTurnEvo(TURNEVOfunc,TURNEVOipt);
    DESTYPE.GENPRJ(1).TURNEVO.SetSlope(DESTYPE.TrajTurnSlope);
    DESTYPE.GENPRJ(1).TURNEVO.SetEnd(DESTYPE.TrajTurnEnd);
    DESTYPE.GENPRJ(1).SetRadAcc(RADACCfunc,RADACCipt);
    DESTYPE.GENPRJ(1).SetCalcEvo(CALCEVOfunc,CALCEVOipt);
    DESTYPE.GENPRJ(1).Initialize;      
    
    %---------------------------------------------
    % Rephase Trajectory
    %---------------------------------------------
    DESTYPE.GENPRJ(2) = GENPRJfunc(GENPRJipt);
    DESTYPE.GENPRJ(2).SetDir(1);
    DESTYPE.GENPRJ(2).SetkMax(DESTYPE.KINFO(1).kmax);
    DESTYPE.GENPRJ(2).SetGradTimeQuant(DESTYPE.GradTimeQuant);
    DESTYPE.GENPRJ(2).SetTro(DESTYPE.RphsTro);
    DESTYPE.GENPRJ(2).SetElip(ELIPfunc,ELIPipt);
    DESTYPE.GENPRJ(2).SetSpin(SPINfunc,SPINipt);
    DESTYPE.GENPRJ(2).SPIN.SetMatRad(DESTYPE.KINFO(1).rad);
    DESTYPE.GENPRJ(2).SPIN.SetRelativeSpin(0);
    DESTYPE.GENPRJ(2).SPIN.DefineSpin;
    DESTYPE.GENPRJ(2).SetTurnEvo(TURNEVOfunc,TURNEVOipt);
    DESTYPE.GENPRJ(2).TURNEVO.SetSlope(DESTYPE.RphsTurnSlope);
    DESTYPE.GENPRJ(2).TURNEVO.SetEnd(DESTYPE.RphsTurnEnd);
    DESTYPE.GENPRJ(2).SetRadAcc(RADACCfunc,RADACCipt);
    DESTYPE.GENPRJ(2).SetCalcEvo(CALCEVOfunc,CALCEVOipt);
    DESTYPE.GENPRJ(2).Initialize;  

    %---------------------------------------------
    % Update k-Space info 
    %---------------------------------------------
    for n = 1:DESTYPE.NumEchos
        DESTYPE.KINFO(n).SetNproj(DESTYPE.GENPRJ(1).SPIN.NumProj);
        DESTYPE.KINFO(n).SetDesignSamplingTimeStart((n-1)*(DESTYPE.Tro + DESTYPE.RphsTro + 2*DESTYPE.GradTimeQuant));
        DESTYPE.KINFO(n).SetDesignSamplingTimeToCentre((n-1)*(DESTYPE.Tro + DESTYPE.RphsTro + 2*DESTYPE.GradTimeQuant));
        DESTYPE.KINFO(n).SetDesignTro(DESTYPE.Tro + DESTYPE.GradTimeQuant);
    end
    DESTYPE.SamplingTro = DESTYPE.NumEchos*(DESTYPE.Tro + DESTYPE.RphsTro + 2*DESTYPE.GradTimeQuant) - DESTYPE.GradTimeQuant;
    
    %---------------------------------------------
    % Timing
    %---------------------------------------------
    DESTYPE.SolutionTiming = (0:DESTYPE.GradTimeQuant:DESTYPE.SamplingTro);
end

%==================================================================
% Build
%==================================================================
function rkSpaceOut = Build(DESTYPE,InitYB)
    [rkSpace1,EndYB,~] = DESTYPE.GENPRJ(1).SolveTraj(InitYB);
    InitYB = EndYB - DESTYPE.GENPRJ(2).EvolveYB;
    [rkSpace2,EndYB,~] = DESTYPE.GENPRJ(2).SolveTraj(InitYB);
    rkSpaceOut0 = [];
    for n = 1:DESTYPE.NumEchos
        rkSpaceOut0 = cat(2,rkSpaceOut0,rkSpace1,flip(rkSpace2,2));
    end
    rkSpaceOut = DESTYPE.ORNT.Orient(rkSpaceOut0,DESTYPE.SYS,DESTYPE.GENPRJ(1).ELIP,DESTYPE.KINFO(1));
end    

%==================================================================
% Implement
%==================================================================
function kSpaceOut = Implement(DESTYPE)
    InitYB = DESTYPE.PSMP.CalcProjDist(DESTYPE.GENPRJ(1).SPIN);
    kSpaceOut = DESTYPE.Build(InitYB) * DESTYPE.KINFO(1).kmax;
end 

%==================================================================
% TestImplement
%==================================================================
function kSpaceOut = TestImplement(DESTYPE)
    InitYB = DESTYPE.PSMP.CalcProjDistTesting;
    kSpaceOut = DESTYPE.Build(InitYB) * DESTYPE.KINFO(1).kmax;
end 

%==================================================================
% Test
%==================================================================
function Test(DESTYPE)

    %---------------------------------------------
    % Create test waveform
    %---------------------------------------------    
    InitYB = [0 0];
    DESTYPE.TestrkSpace = DESTYPE.Build(InitYB);
    DESTYPE.TestkSpace = DESTYPE.KINFO(1).kmax * DESTYPE.TestrkSpace;
    DESTYPE.TestRelRad = (DESTYPE.TestrkSpace(1,:,1).^2 + DESTYPE.TestrkSpace(1,:,2).^2 + DESTYPE.TestrkSpace(1,:,3).^2).^0.5; 
    
    DESTYPE.GRAD.SetGamma(DESTYPE.NUC.gamma);
    DESTYPE.GRAD.SetTimeQuant(DESTYPE.GradTimeQuant);
    DESTYPE.GRAD.CalculateGradients(DESTYPE.TestkSpace);
    DESTYPE.GRAD.CalculateGradientChars;

    %---------------------------------------------
    % Define Max Frequency in FoV
    %---------------------------------------------     
    DESTYPE.MaxSphereFreq = DESTYPE.GRAD.GradMagMax*DESTYPE.Fov/2*DESTYPE.NUC.gamma;              
    
    %---------------------------------------------
    % Plot
    %---------------------------------------------     
    fh = figure(501); 
    fh.Name = 'Test Waveform';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1300 800];
    
    subplot(2,3,1); hold on;
    plot(DESTYPE.SolutionTiming,squeeze(DESTYPE.TestrkSpace(:,:,1)),'b');
    plot(DESTYPE.SolutionTiming,squeeze(DESTYPE.TestrkSpace(:,:,2)),'g');
    plot(DESTYPE.SolutionTiming,squeeze(DESTYPE.TestrkSpace(:,:,3)),'r');
    plot(DESTYPE.SolutionTiming,DESTYPE.TestRelRad,'k');
    plot([DESTYPE.GENPRJ(1).Tro DESTYPE.GENPRJ(1).Tro],[-1 1],'k:');  
    plot(DESTYPE.SolutionTiming,zeros(size(DESTYPE.SolutionTiming)),'k:');
    xlabel('ms')
    ylabel('rkSpace');

    subplot(2,3,2); hold on; axis equal; grid on; box off;
    plot3(squeeze(DESTYPE.TestrkSpace(1,:,1)),squeeze(DESTYPE.TestrkSpace(1,:,2)),squeeze(DESTYPE.TestrkSpace(1,:,3)),'k','linewidth',1);
    set(gca,'cameraposition',[-300 -400 120]);  
    
    [sT,sGrads,sGradMag] = DESTYPE.GRAD.GetSteppedGradWfm;
    subplot(2,3,4); hold on;
    plot(sT,sGrads(1,:,1),'b')
    plot(sT,sGrads(1,:,2),'g')
    plot(sT,sGrads(1,:,3),'r')    
    plot(sT,sGradMag,'k')
    plot(sT,zeros(size(sT)),'k:');
    xlabel('ms')
    ylabel('mT/m');
    
    [sT,sGradSlew,sGradSlewMag] = DESTYPE.GRAD.GetSteppedGradSlew;
    subplot(2,3,5); hold on;
    plot(sT,sGradSlew(:,:,1),'b')
    plot(sT,sGradSlew(:,:,2),'g')
    plot(sT,sGradSlew(:,:,3),'r')    
    plot(sT,sGradSlewMag,'k')
    plot(sT,zeros(size(sT)),'k:');
    xlim([0 DESTYPE.SolutionTiming(end)]);
    xlabel('ms')
    ylabel('mT/m/ms');

    [sT,sGradAcc,sGradAccMag] = DESTYPE.GRAD.GetSteppedGradAcc;
    subplot(2,3,6); hold on;
    plot(sT,sGradAcc(:,:,1),'b')
    plot(sT,sGradAcc(:,:,2),'g')
    plot(sT,sGradAcc(:,:,3),'r')    
    plot(sT,sGradAccMag,'k') 
    plot(sT,zeros(size(sT)),'k:');
    xlim([0 DESTYPE.SolutionTiming(end)]);
    xlabel('ms')
    ylabel('mT/m/ms/ms');
    
    %--------------------------------------------
    % Name
    %--------------------------------------------
    sfov = num2str(DESTYPE.KINFO(1).fov,'%03.0f');
    svox = num2str(10*(DESTYPE.KINFO(1).vox^3)/DESTYPE.KINFO(1).Elip,'%04.0f');
    selip = num2str(100*DESTYPE.KINFO(1).Elip,'%03.0f');
    stro = num2str(10*DESTYPE.KINFO(1).DesignTro,'%03.0f');
    snproj = num2str(DESTYPE.KINFO(1).nproj,'%4.0f');
    sechos = num2str(DESTYPE.NumEchos,'%4.0f');
    DESTYPE.Name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_S',DESTYPE.GENPRJ(1).SPIN.name,'_',sechos,'OO']; 
    
    %--------------------------------------------
    % Panel
    %--------------------------------------------    
    Panel0(1,:) = {'Method',DESTYPE.Method,'Output'};
    Panel0(3,:) = {'FovDim (mm)',DESTYPE.KINFO(1).fov,'Output'};
    Panel0(4,:) = {'VoxDim (mm)',DESTYPE.KINFO(1).vox,'Output'};
    Panel0(5,:) = {'Elip',DESTYPE.KINFO(1).Elip,'Output'};
    Panel0(6,:) = {'VoxNom (mm3)',((DESTYPE.KINFO(1).vox)^3)*(1/DESTYPE.KINFO(1).Elip),'Output'};
    Panel0(7,:) = {'VoxCeq (mm3)',((DESTYPE.KINFO(1).vox*1.24)^3)*(1/DESTYPE.KINFO(1).Elip),'Output'};
    Panel0(8,:) = {'Tro (ms)',DESTYPE.Tro,'Output'};
    Panel0(9,:) = {'Ntraj',DESTYPE.KINFO(1).nproj,'Output'};
    Panel0(10,:) = {'Echos',DESTYPE.NumEchos,'Output'};
    ind = 11;
    for n = 1:DESTYPE.NumEchos
        Panel0(ind,:) = {'DesignSampTimeToCentre (ms)',DESTYPE.KINFO(n).DesignSamplingTimeToCentre,'Output'};
        ind = ind+1;
    end   
    Panel0(ind,:) = {'','','Output'};
    %DESTYPE.Panel = [Panel0;DESTYPE.GENPRJ(1).SPIN.Panel];
    DESTYPE.Panel = Panel0;

end    
   
end
end
