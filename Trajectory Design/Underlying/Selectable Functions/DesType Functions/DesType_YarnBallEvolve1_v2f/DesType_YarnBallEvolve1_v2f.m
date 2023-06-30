%==================================================================
% (v2f)
%       - Match other
%==================================================================

classdef DesType_YarnBallEvolve1_v2f < handle

properties (SetAccess = private)                   
    Method = 'YarnBallEvolve1_v2f'
    Name
    Panel
    DESTYPEipt
    TurnEvolutionFunc
    GenProjFunc
    ElipFunc
    SpinFunc
    RadAccTFunc
    RadAccPFunc
    ProjSampFunc
    OrientFunc
    Fov
    Vox
    FullTro
    EvolveTro
    SegTro
    NumSegs
    NumProj
    TrajTurnSlope
    TrajTurnEnd
    RphsTurnSlope
    RphsTurnEnd
    RphsTro
    SamplingTro
    PtsPerSeg
    TURNEVO
    GENPRJ
    CALCEVO
    GRAD
    KINFO
    SPIN
    ELIP
    RADACCT
    RADACCP
    PSMP
    ORNT
    SYS
    NUC
    GradTimeQuant
    EvolveTiming
    SamplingTiming
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
function DESTYPE = DesType_YarnBallEvolve1_v2f(DESTYPEipt)

    %---------------------------------------------
    % Load Panel Input
    %---------------------------------------------
    DESTYPE.DESTYPEipt = DESTYPEipt;
    DESTYPE.Fov = str2double(DESTYPEipt.('FoV'));
    DESTYPE.Vox = str2double(DESTYPEipt.('Vox'));
    DESTYPE.FullTro = str2double(DESTYPEipt.('FullTro'));
    DESTYPE.SegTro = str2double(DESTYPEipt.('SegTro')); 
    DESTYPE.TrajTurnSlope = str2double(DESTYPEipt.('TrajTurnSlope'));
    DESTYPE.TrajTurnEnd = str2double(DESTYPEipt.('TrajTurnEnd'));
    DESTYPE.GenProjFunc = DESTYPEipt.('GenProjfunc').Func;
    DESTYPE.ElipFunc = DESTYPEipt.('Elipfunc').Func;
    DESTYPE.SpinFunc = DESTYPEipt.('Spinfunc').Func;
    DESTYPE.RadAccTFunc = DESTYPEipt.('RadialAccTfunc').Func;
    DESTYPE.RadAccPFunc = DESTYPEipt.('RadialAccPfunc').Func;
    DESTYPE.TurnEvolutionFunc = DESTYPEipt.('TurnEvolutionfunc').Func;
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
    RADACCTipt = DESTYPEipt.('RadialAccTfunc');
    if isfield(DESTYPEipt,('RadialAccTfunc_Data'))
        RADACCTipt.RadialAccTfunc_Data = DESTYPEipt.RadialAccTfunc_Data;
    end
    RADACCPipt = DESTYPEipt.('RadialAccPfunc');
    if isfield(DESTYPEipt,('RadialAccPfunc_Data'))
        RADACCPipt.RadialAccPfunc_Data = DESTYPEipt.RadialAccPfunc_Data;
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
    func = str2func(DESTYPE.RadAccTFunc);                   
    DESTYPE.RADACCT = func(); 
    DESTYPE.RADACCT.InitViaCompass(RADACCTipt);
    func = str2func(DESTYPE.RadAccPFunc);   
    DESTYPE.RADACCP = func(); 
    DESTYPE.RADACCP.InitViaCompass(RADACCPipt);
    func = str2func(DESTYPE.TurnEvolutionFunc);
    DESTYPE.TURNEVO = func(TURNEVOipt);
    func = str2func(DESTYPE.OrientFunc);
    DESTYPE.ORNT = func(ORNTipt);
    func = str2func('CalcEvoDiffs_Simple_v2b');           
    DESTYPE.CALCEVO = func('');
    func = str2func('Gradient_Calculations_v2a');           
    DESTYPE.GRAD = func('');
    func = str2func('kSpaceInfo_BasicHolder_v2b');           
    DESTYPE.KINFO = func('');
    func = str2func('ProjSamp_Standard_v2a');
    DESTYPE.PSMP = func('');
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
    RADACCTfunc = str2func(DESTYPE.RADACCT.Method);
    RADACCPfunc = str2func(DESTYPE.RADACCP.Method);
    RADACCTipt = DESTYPE.RADACCT.RADACCipt;
    RADACCPipt = DESTYPE.RADACCP.RADACCipt;
    CALCEVOfunc = str2func(DESTYPE.CALCEVO.Method);
    CALCEVOipt = DESTYPE.CALCEVO.CALCEVOipt;
    TURNEVOfunc = str2func(DESTYPE.TURNEVO.Method);
    TURNEVOipt = DESTYPE.TURNEVO.TURNEVOipt;

    %---------------------------------------------
    % Define k-Space info 
    %   (possibly arrayed)
    %---------------------------------------------
    DESTYPE.KINFO.SetFov(DESTYPE.Fov);
    DESTYPE.KINFO.SetVox(DESTYPE.Vox);
    DESTYPE.KINFO.SetTro(DESTYPE.SegTro);
    DESTYPE.KINFO.SetElip(DESTYPE.ELIP.Elip);
    DESTYPE.KINFO.SetYbAxisElip(DESTYPE.ELIP.YbAxisElip);
    
    %---------------------------------------------
    % Full Trajectory
    %---------------------------------------------
    DESTYPE.GENPRJ(1) = GENPRJfunc(GENPRJipt);
    DESTYPE.GENPRJ(1).SetDir(1);
    DESTYPE.GENPRJ(1).SetkMax(DESTYPE.KINFO(1).kmax);
    DESTYPE.GENPRJ(1).SetGradTimeQuant(DESTYPE.GradTimeQuant);
    DESTYPE.GENPRJ(1).SetTro(DESTYPE.FullTro);
    DESTYPE.GENPRJ(1).SetElip(ELIPfunc,ELIPipt);
    DESTYPE.GENPRJ(1).SetSpin(SPINfunc,SPINipt);
    DESTYPE.GENPRJ(1).SPIN.SetMatRad(DESTYPE.KINFO(1).rad);
    DESTYPE.GENPRJ(1).SPIN.DefineSpin;
    DESTYPE.GENPRJ(1).SetTurnEvo(TURNEVOfunc,TURNEVOipt);
    DESTYPE.GENPRJ(1).TURNEVO.SetSlope(DESTYPE.TrajTurnSlope);
    DESTYPE.GENPRJ(1).TURNEVO.SetEnd(DESTYPE.TrajTurnEnd);
    DESTYPE.GENPRJ(1).SetRadAcc(RADACCTfunc,RADACCTipt);
    DESTYPE.GENPRJ(1).SetCalcEvo(CALCEVOfunc,CALCEVOipt);
    DESTYPE.GENPRJ(1).Initialize;      
    
    %---------------------------------------------
    % Rephase Trajectory
    %---------------------------------------------
    DESTYPE.GENPRJ(2) = GENPRJfunc(GENPRJipt);
    DESTYPE.GENPRJ(2).SetDir(-1);
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
    DESTYPE.GENPRJ(2).SetRadAcc(RADACCPfunc,RADACCPipt);
    DESTYPE.GENPRJ(2).SetCalcEvo(CALCEVOfunc,CALCEVOipt);
    DESTYPE.GENPRJ(2).Initialize;     

    %---------------------------------------------
    % Evolve Info
    %---------------------------------------------
    DESTYPE.NumSegs = ceil(DESTYPE.FullTro/DESTYPE.SegTro);
    DESTYPE.NumProj = DESTYPE.GENPRJ(1).SPIN.NumProj * DESTYPE.NumSegs;
    
    %---------------------------------------------
    % Update k-Space info 
    %---------------------------------------------
    DESTYPE.KINFO.SetNproj(DESTYPE.NumProj);
    DESTYPE.KINFO.SetDesignSamplingTimeStart(0);
    DESTYPE.KINFO.SetDesignSamplingTimeToCentre(0);
    DESTYPE.KINFO.SetDesignTro(DESTYPE.SegTro);
    
    %---------------------------------------------
    % Timing
    %---------------------------------------------
    DESTYPE.EvolveTro = DESTYPE.FullTro;
    DESTYPE.EvolveTiming = (0:DESTYPE.GradTimeQuant:DESTYPE.EvolveTro);
    DESTYPE.SamplingTro = DESTYPE.SegTro + 2*DESTYPE.RphsTro + DESTYPE.GradTimeQuant;
    DESTYPE.SamplingTiming = (0:DESTYPE.GradTimeQuant:DESTYPE.SamplingTro);
    DESTYPE.PtsPerSeg = DESTYPE.SegTro/DESTYPE.GradTimeQuant;
end

%==================================================================
% Build
%==================================================================
function rkSpaceOut = Build(DESTYPE,InitYB)
    [rkSpaceEvolve,~,ArrYB] = DESTYPE.GENPRJ(1).SolveTraj(InitYB);
    sz = size(rkSpaceEvolve);
    rkSpaceOut = ones(sz(1)*DESTYPE.NumSegs,length(DESTYPE.SamplingTiming),3);
    p = 0;
    for m = 1:sz(1)
        for n = 1:DESTYPE.NumSegs
            rkSpaceTraj = rkSpaceEvolve(m,(n-1)*DESTYPE.PtsPerSeg+1:n*DESTYPE.PtsPerSeg,:);
            PreYB = squeeze(ArrYB(m,(n-1)*DESTYPE.PtsPerSeg+1,(2:3))).';
            %InitYB = PreYB - DESTYPE.GENPRJ(2).EvolveYB;
            [rkSpacePre,~,~] = DESTYPE.GENPRJ(2).SolveTraj(PreYB);
            PostYB = squeeze(ArrYB(m,n*DESTYPE.PtsPerSeg,(2:3))).';
            [rkSpacePost,~,~] = DESTYPE.GENPRJ(2).SolveTraj(PostYB);
            p = p+1;
            rkSpaceOut(p,:,:) = cat(2,flip(rkSpacePre,2),rkSpaceTraj,rkSpacePost);
        end
    end
    rkSpaceOut = DESTYPE.ORNT.Orient(rkSpaceOut,DESTYPE.SYS,DESTYPE.GENPRJ(1).ELIP,DESTYPE.KINFO);
end    

%==================================================================
% Implement
%==================================================================
function kSpaceOut = Implement(DESTYPE)
    InitYB = DESTYPE.PSMP.CalcProjDist(DESTYPE.GENPRJ(1).SPIN);
    kSpaceOut = DESTYPE.Build(InitYB) * DESTYPE.KINFO.kmax;
end 

%==================================================================
% TestImplement
%==================================================================
function kSpaceOut = TestImplement(DESTYPE)
    InitYB = DESTYPE.PSMP.CalcProjDistTesting;
    kSpaceOut = DESTYPE.Build(InitYB) * DESTYPE.KINFO.kmax;
end 

%==================================================================
% Test
%==================================================================
function Figure = Test(DESTYPE)

    %---------------------------------------------
    % Create test waveform
    %---------------------------------------------    
    InitYB = [0 0];
    [rkSpaceEvolve,~,~] = DESTYPE.GENPRJ(1).SolveTraj(InitYB);
    rkSpaceEvolve = DESTYPE.ORNT.Orient(rkSpaceEvolve,DESTYPE.SYS,DESTYPE.GENPRJ(1).ELIP,DESTYPE.KINFO);
    
    DESTYPE.TestrkSpace = rkSpaceEvolve;
    DESTYPE.TestkSpace = DESTYPE.KINFO.kmax * DESTYPE.TestrkSpace;
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
    % Plot Evolve
    %---------------------------------------------     
    fh = figure(501); 
    fh.Name = 'Evolve Waveform';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1300 800];
    
    subplot(2,3,1); hold on;
    plot(DESTYPE.EvolveTiming,squeeze(DESTYPE.TestrkSpace(:,:,1)),'b');
    plot(DESTYPE.EvolveTiming,squeeze(DESTYPE.TestrkSpace(:,:,2)),'g');
    plot(DESTYPE.EvolveTiming,squeeze(DESTYPE.TestrkSpace(:,:,3)),'r');
    plot(DESTYPE.EvolveTiming,DESTYPE.TestRelRad,'k');
    plot([DESTYPE.GENPRJ(1).Tro DESTYPE.GENPRJ(1).Tro],[-1 1],'k:');  
    plot(DESTYPE.EvolveTiming,zeros(size(DESTYPE.EvolveTiming)),'k:');
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
    xlim([0 DESTYPE.EvolveTiming(end)]);
    xlabel('ms')
    ylabel('mT/m/ms');

    [sT,sGradAcc,sGradAccMag] = DESTYPE.GRAD.GetSteppedGradAcc;
    subplot(2,3,6); hold on;
    plot(sT,sGradAcc(:,:,1),'b')
    plot(sT,sGradAcc(:,:,2),'g')
    plot(sT,sGradAcc(:,:,3),'r')    
    plot(sT,sGradAccMag,'k') 
    plot(sT,zeros(size(sT)),'k:');
    xlim([0 DESTYPE.EvolveTiming(end)]);
    xlabel('ms')
    ylabel('mT/m/ms/ms');
    
    Figure(1).Name = 'Test Waveform';
    Figure(1).Type = 'Graph';
    Figure(1).hFig = fh;
    Figure(1).hAx = gca; 
    
    %---------------------------------------------
    % Plot Test Segments
    %---------------------------------------------     
    TestrkSpaceSegs = DESTYPE.Build(InitYB);
    TestkSpaceSegs = DESTYPE.KINFO.kmax * TestrkSpaceSegs;
    TestRelRadSegs = (TestrkSpaceSegs(:,:,1).^2 + TestrkSpaceSegs(:,:,2).^2 + TestrkSpaceSegs(:,:,3).^2).^0.5; 
    
    DESTYPE.GRAD.SetGamma(DESTYPE.NUC.gamma);
    DESTYPE.GRAD.SetTimeQuant(DESTYPE.GradTimeQuant);
    DESTYPE.GRAD.CalculateGradients(TestkSpaceSegs);
    DESTYPE.GRAD.CalculateGradientChars;
    
    fh = figure(502); 
    fh.Name = 'Test Waveform';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1300 800];
    
    subplot(2,3,1); hold on;
    plot(DESTYPE.SamplingTiming,squeeze(TestrkSpaceSegs(1,:,1)),'b');
    plot(DESTYPE.SamplingTiming,squeeze(TestrkSpaceSegs(1,:,2)),'g');
    plot(DESTYPE.SamplingTiming,squeeze(TestrkSpaceSegs(1,:,3)),'r');
%     plot(DESTYPE.EvolveTiming,TestRelRadSegs,'k');
%     plot([DESTYPE.GENPRJ(1).Tro DESTYPE.GENPRJ(1).Tro],[-1 1],'k:');  
%     plot(DESTYPE.EvolveTiming,zeros(size(DESTYPE.EvolveTiming)),'k:');
    xlabel('ms')
    ylabel('rkSpace');

    subplot(2,3,2); hold on;
    plot(DESTYPE.SamplingTiming,squeeze(TestrkSpaceSegs(2,:,1)),'b');
    plot(DESTYPE.SamplingTiming,squeeze(TestrkSpaceSegs(2,:,2)),'g');
    plot(DESTYPE.SamplingTiming,squeeze(TestrkSpaceSegs(2,:,3)),'r');
%     plot(DESTYPE.EvolveTiming,TestRelRadSegs,'k');
%     plot([DESTYPE.GENPRJ(1).Tro DESTYPE.GENPRJ(1).Tro],[-1 1],'k:');  
%     plot(DESTYPE.EvolveTiming,zeros(size(DESTYPE.EvolveTiming)),'k:');
    xlabel('ms')
    ylabel('rkSpace');    
    
    subplot(2,3,2); hold on; axis equal; grid on; box off;
    plot3(squeeze(TestrkSpaceSegs(1,:,1)),squeeze(TestrkSpaceSegs(1,:,2)),squeeze(TestrkSpaceSegs(1,:,3)),'k','linewidth',1);
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
    xlim([0 DESTYPE.EvolveTiming(end)]);
    xlabel('ms')
    ylabel('mT/m/ms');

    [sT,sGradAcc,sGradAccMag] = DESTYPE.GRAD.GetSteppedGradAcc;
    subplot(2,3,6); hold on;
    plot(sT,sGradAcc(:,:,1),'b')
    plot(sT,sGradAcc(:,:,2),'g')
    plot(sT,sGradAcc(:,:,3),'r')    
    plot(sT,sGradAccMag,'k') 
    plot(sT,zeros(size(sT)),'k:');
    xlim([0 DESTYPE.EvolveTiming(end)]);
    xlabel('ms')
    ylabel('mT/m/ms/ms');
    
    Figure(1).Name = 'Test Waveform';
    Figure(1).Type = 'Graph';
    Figure(1).hFig = fh;
    Figure(1).hAx = gca; 
    
    
    %--------------------------------------------
    % Name
    %--------------------------------------------
    sfov = num2str(DESTYPE.KINFO.fov,'%03.0f');
    svox = num2str(10*(DESTYPE.KINFO.vox^3)/DESTYPE.KINFO.Elip,'%04.0f');
    selip = num2str(100*DESTYPE.KINFO.Elip,'%03.0f');
    stro = num2str(10*DESTYPE.KINFO.tro,'%03.0f');
    snproj = num2str(DESTYPE.KINFO.nproj,'%4.0f');
    DESTYPE.Name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_S',DESTYPE.GENPRJ(1).SPIN.name,'_1O']; 
    
    %--------------------------------------------
    % Panel
    %--------------------------------------------    
    Panel0(1,:) = {'Method',DESTYPE.Method,'Output'};
    Panel0(3,:) = {'FovDim (mm)',DESTYPE.KINFO.fov,'Output'};
    Panel0(4,:) = {'VoxDim (mm)',DESTYPE.KINFO.vox,'Output'};
    Panel0(5,:) = {'Elip',DESTYPE.KINFO.Elip,'Output'};
    Panel0(6,:) = {'VoxNom (mm3)',((DESTYPE.KINFO.vox)^3)*(1/DESTYPE.KINFO.Elip),'Output'};
    Panel0(7,:) = {'VoxCeq (mm3)',((DESTYPE.KINFO.vox*1.24)^3)*(1/DESTYPE.KINFO.Elip),'Output'};
    Panel0(8,:) = {'Tro (ms)',DESTYPE.KINFO.tro,'Output'};
    Panel0(9,:) = {'Ntraj',DESTYPE.KINFO.nproj,'Output'};
    Panel0(10,:) = {'Echos',DESTYPE.NumEchos,'Output'};
    Panel0(11,:) = {'DesignSampTimeToCentre (ms)',DESTYPE.KINFO.DesignSamplingTimeToCentre,'Output'};
    Panel0(12,:) = {'','','Output'};
    DESTYPE.Panel = Panel0;

end    
   
end
end
