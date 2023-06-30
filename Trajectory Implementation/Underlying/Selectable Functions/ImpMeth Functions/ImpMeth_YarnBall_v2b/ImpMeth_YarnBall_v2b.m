%==================================================================
% (v2b)
%   - Convert to Object
%==================================================================

classdef ImpMeth_YarnBall_v2b < handle

properties (SetAccess = private)                   
    Method = 'ImpMeth_YarnBall_v2b'
    IMPMETHipt
    tsmpfunc
    tendfunc
    ksampfunc
    FinMethfunc
    Buildfunc
    BLD
    FINMETH
    TSMP
    TEND
    KSMP
    GRAD
    KINFO
    NUC
    SYS
    PSMP
    DES
    Panel = cell(0)
    PanelOutput
    ExpDisp
end
properties (SetAccess = public)    
    name
    path
    saveSCRPTcellarray
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function [IMPMETH,err] = ImpMeth_YarnBall_v2b(IMPMETHipt)    
    
    err.flag = 0;
    IMPMETH.IMPMETHipt = IMPMETHipt;
    %---------------------------------------------
    % Load Panel Input
    %---------------------------------------------
    IMPMETH.tsmpfunc = IMPMETHipt.('TrajSampfunc').Func;
    IMPMETH.tendfunc = IMPMETHipt.('TrajEndfunc').Func;
    IMPMETH.ksampfunc = IMPMETHipt.('kSampfunc').Func;
    IMPMETH.FinMethfunc = IMPMETHipt.('FinMethfunc').Func;    
    IMPMETH.Buildfunc = IMPMETHipt.('Buildfunc').Func;    
    
    %---------------------------------------------
    % Get Working Structures from Sub Functions
    %---------------------------------------------
    CallingFunction = IMPMETHipt.Struct.labelstr;
    BLDipt = IMPMETHipt.('Buildfunc');
    if isfield(IMPMETHipt,([CallingFunction,'_Data']))
        if isfield(IMPMETHipt.([CallingFunction,'_Data']),('Buildfunc_Data'))
            BLDipt.Buildfunc_Data = IMPMETHipt.([CallingFunction,'_Data']).Buildfunc_Data;
        end
    end
    TSMPipt = IMPMETHipt.('TrajSampfunc');
    if isfield(IMPMETHipt,([CallingFunction,'_Data']))
        if isfield(IMPMETHipt.([CallingFunction,'_Data']),('TrajSampfunc_Data'))
            TSMPipt.TrajSampfunc_Data = IMPMETHipt.([CallingFunction,'_Data']).TrajSampfunc_Data;
        end
    end
    TENDipt = IMPMETHipt.('TrajEndfunc');
    if isfield(IMPMETHipt,([CallingFunction,'_Data']))
        if isfield(IMPMETHipt.([CallingFunction,'_Data']),('TrajEndfunc_Data'))
            TENDipt.TrajEndfunc_Data = IMPMETHipt.([CallingFunction,'_Data']).TrajEndfunc_Data;
        end
    end
    KSMPipt = IMPMETHipt.('kSampfunc');
    if isfield(IMPMETHipt,([CallingFunction,'_Data']))
        if isfield(IMPMETHipt.([CallingFunction,'_Data']),('kSampfunc_Data'))
            KSMPipt.kSampfunc_Data = IMPMETHipt.([CallingFunction,'_Data']).kSampfunc_Data;
        end
    end
    FINMETHipt = IMPMETHipt.('FinMethfunc');
    if isfield(IMPMETHipt,([CallingFunction,'_Data']))
        if isfield(IMPMETHipt.([CallingFunction,'_Data']),('FinMethfunc_Data'))
            FINMETHipt.FinMethfunc_Data = IMPMETHipt.([CallingFunction,'_Data']).FinMethfunc_Data;
        end
    end
    %------------------------------------------
    % Build Object Shells
    %------------------------------------------
    func = str2func(IMPMETH.FinMethfunc);                   
    IMPMETH.FINMETH = func(FINMETHipt);
    func = str2func(IMPMETH.tsmpfunc);           
    IMPMETH.TSMP = func(TSMPipt);
    func = str2func(IMPMETH.tendfunc);           
    IMPMETH.TEND = func(TENDipt);
    func = str2func(IMPMETH.ksampfunc);                   
    IMPMETH.KSMP = func(KSMPipt); 
    func = str2func(IMPMETH.Buildfunc);                   
    IMPMETH.BLD = func(BLDipt); 
end 

%==================================================================
% ImplementYarnball
%==================================================================  
function err = Implement(IMPMETH,DES) 

    DESTYPE = DES.DESTYPE;
    IMPMETH.SYS = DESTYPE.SYS;
    IMPMETH.NUC = DESTYPE.NUC;
    IMPMETH.KINFO = DESTYPE.KINFO; 
    IMPMETH.PSMP = DESTYPE.PSMP;
    
    %---------------------------------------------
    % Create Gradient Waveforms
    %---------------------------------------------    
    if IMPMETH.BLD.Testing
        kSpace0 = DESTYPE.TestImplement;
    else
        kSpace0 = DESTYPE.Implement;
    end
    err = IMPMETH.FINMETH.Finish(kSpace0,DESTYPE,IMPMETH);
    if err.flag
        return
    end
    IMPMETH.GRAD = IMPMETH.TEND.GRAD;
    
    %---------------------------------------------
    % Test
    %---------------------------------------------     
    if IMPMETH.BLD.GradWfmVis
        fh = figure(5683); 
        fh.Name = 'Test Gradient Waveform';
        fh.NumberTitle = 'off';
        fh.Position = [260+IMPMETH.BLD.FigShift 150 900 800];

        [sT,sGrads,sGradMag,sGradMaxChan] = IMPMETH.GRAD.GetSteppedGradWfm;
        subplot(2,2,1); hold on;
        plot(sT,sGrads(1,:,1),'b')
        plot(sT,sGrads(1,:,2),'g')
        plot(sT,sGrads(1,:,3),'r')    
        plot(sT,sGradMaxChan,'k')
        plot(sT,zeros(size(sT)),'k:');
        xlabel('ms')
        ylabel('mT/m');
        title('Gradient Waveform (plus Channel Max)'); 

        [sT,sGradSlew,sGradSlewMag,sGradSlewMaxChan] = IMPMETH.GRAD.GetSteppedGradSlew;
        subplot(2,2,2); hold on;
        plot(sT,sGradSlew(1,:,1),'b')
        plot(sT,sGradSlew(1,:,2),'g')
        plot(sT,sGradSlew(1,:,3),'r')    
        plot(sT,sGradSlewMaxChan,'k')
        plot(sT,zeros(size(sT)),'k:');
        xlabel('ms')
        ylabel('mT/m/ms');
        title('Gradient Slew (plus Channel Max)'); 

        [sT,sGradAcc,sGradAccMag,sGradAccMaxChan] = IMPMETH.GRAD.GetSteppedGradAcc;
        subplot(2,2,3); hold on;
        plot(sT,sGradAcc(1,:,1),'b')
        plot(sT,sGradAcc(1,:,2),'g')
        plot(sT,sGradAcc(1,:,3),'r')    
        plot(sT,sGradAccMaxChan,'k') 
        plot(sT,zeros(size(sT)),'k:');
        xlabel('ms')
        ylabel('mT/m/ms/ms');
        title('Gradient Acceleration (plus Channel Max)'); 
    end

    %---------------------------------------------
    % Sample
    %---------------------------------------------     
    err = IMPMETH.TSMP.DefineTrajSamp(DESTYPE,IMPMETH);
    if err.flag
        return
    end    
    err = IMPMETH.KSMP.Sample(IMPMETH);
    if err.flag
        return
    end      

    %---------------------------------------------
    % Identify sampling point at k-space centre
    %---------------------------------------------  
    for n = 1:length(IMPMETH.KINFO)
        ind = find(round(IMPMETH.KINFO(n).SamplingTimeOnTrajectory*1e9) <= round(IMPMETH.KINFO(n).SamplingTimeToCentre*1e9),1,'last');
        IMPMETH.KINFO(n).SetSamplingPtAtCentre(ind);
    end

    %---------------------------------------------
    % Test
    %---------------------------------------------     
    if IMPMETH.BLD.TestKspaceVis
        fh = figure(5684); 
        fh.Name = 'Test k-Space';
        fh.NumberTitle = 'off';
        fh.Position = [260+IMPMETH.BLD.FigShift 150 900 800];   
        hold on;
        plot(DESTYPE.SolutionTiming+IMPMETH.FINMETH.SYSRESP.TrajectoryDelay,kSpace0(1,:,1),'b*')
        plot(DESTYPE.SolutionTiming+IMPMETH.FINMETH.SYSRESP.TrajectoryDelay,kSpace0(1,:,2),'g*')
        plot(DESTYPE.SolutionTiming+IMPMETH.FINMETH.SYSRESP.TrajectoryDelay,kSpace0(1,:,3),'r*')
        for n = 1:length(IMPMETH.KINFO)
            plot(IMPMETH.KINFO(n).SamplingTimeOnTrajectory,IMPMETH.KINFO(n).kSpace(1,:,1),'b')
            plot(IMPMETH.KINFO(n).SamplingTimeOnTrajectory,IMPMETH.KINFO(n).kSpace(1,:,2),'g')
            plot(IMPMETH.KINFO(n).SamplingTimeOnTrajectory,IMPMETH.KINFO(n).kSpace(1,:,3),'r')
            plot(IMPMETH.KINFO(n).SamplingTimeOnTrajectory,zeros(size(IMPMETH.KINFO(n).SamplingTimeOnTrajectory)),'k:');
            MagKspace = sqrt(IMPMETH.KINFO(n).kSpace(1,:,1).^2 + IMPMETH.KINFO(n).kSpace(1,:,2).^2 + IMPMETH(n).KINFO.kSpace(1,:,3).^2);
            plot(IMPMETH.KINFO(n).SamplingTimeOnTrajectory,MagKspace,'k');
        end
        xlabel('ms')
        ylabel('1/m');
        title('Sampled k-Space)');
    end
    
    %--------------------------------------------
    % Panel
    %--------------------------------------------    
    Panel0(1,:) = {'Method',IMPMETH.Method,'Output'};
    ind = 1;
    for n = 1:DESTYPE.NumEchos
        Panel1(ind,:) = {'SampTimeToCentre (ms)',DESTYPE.KINFO(n).SamplingTimeToCentre,'Output'};
        ind = ind+1;
    end
    %IMPMETH.Panel = [Panel0;IMPMETH.FINMETH.Panel;IMPMETH.TSMP.Panel;IMPMETH.KSMP.Panel]; 
    IMPMETH.Panel = [Panel0;DESTYPE.Panel;IMPMETH.TSMP.Panel;Panel1]; 
    %IMPMETH.Panel = [Panel0;DESTYPE.Panel;Panel1]; 
    IMPMETH.PanelOutput = cell2struct(IMPMETH.Panel,{'label','value','type'},2);
    IMPMETH.ExpDisp = PanelStruct2Text(IMPMETH.PanelOutput);
    IMPMETH.ExpDisp = [newline IMPMETH.ExpDisp];
    IMPMETH.DES = DESTYPE;
end


end
end









