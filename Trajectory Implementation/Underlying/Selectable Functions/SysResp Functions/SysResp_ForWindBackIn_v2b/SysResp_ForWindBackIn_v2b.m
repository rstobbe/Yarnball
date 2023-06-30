%==================================================================
% (v2b)
%       - clarity fix
%==================================================================

classdef SysResp_ForWindBackIn_v2b < handle

properties (SetAccess = private)                   
    Method = 'SysResp_ForWindBackIn_v2b'
    SYSRESPipt
    errsmthkern = 3
    iterations
    GSYSMOD
    GRAD
    NumProj
    TrajectoryDelay
    InitZeroAdd
    RegressZeroEndAdd
    TimeComp
    GradComp
    TimeResp
    GradResp
    CompDurPastGrad
    Panel = cell(0)
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function [SYSRESP,err] = SysResp_ForWindBackIn_v2b(SYSRESPipt)    
    err.flag = 0;
    SYSRESP.SYSRESPipt = SYSRESPipt;
    SYSRESP.iterations = str2double(SYSRESPipt.('Iterations'));
    CallingLabel = SYSRESPipt.Struct.labelstr;
    if not(isfield(SYSRESPipt,[CallingLabel,'_Data']))
        if isfield(SYSRESPipt.('SysRespFIR_File').Struct,'selectedfile')
            file = SYSRESPipt.('SysRespFIR_File').Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load SysRespFIR_File';
                ErrDisp(err);
                return
            else
                load(file);
                SYSRESPipt.([CallingLabel,'_Data']).('SysRespFIR_File_Data') = saveData;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load SysRespFIR_File';
            ErrDisp(err);
            return
        end
    end
    SYSRESP.GSYSMOD = SYSRESPipt.([CallingLabel,'_Data']).('SysRespFIR_File_Data').GSYSMOD;  
    %------------------------------------------
    % Create Shell Objects
    %------------------------------------------
    func = str2func('Gradient_Calculations_v2a');           
    SYSRESP.GRAD = func('');         
end 

%==================================================================
% Compensate
%==================================================================  
function err = Compensate(SYSRESP,qT0,qkSpace0,CompDurPastGrad,DESTYPE,IMPMETH)
    
    Status2('busy','Compensate Gradients',2); 
    err.flag = 0;
    SYSRESP.CompDurPastGrad = CompDurPastGrad;
    SYS = DESTYPE.SYS;
    NUC = DESTYPE.NUC;
    BLD = IMPMETH.BLD;
    %---------------------------------------------
    % Delay gradients (offset starting early)
    %---------------------------------------------    
    if rem(SYSRESP.GSYSMOD.delaygradient,SYS.GradSampBase)
        err.flag = 1;
        err.msg = ['System response model not suitable for ',SYS.System];
        return
    end
    if SYSRESP.CompDurPastGrad < 10
        err.flag = 1;
        err.msg = 'Minimum CompDurPastGrad = 10 us';
        return
    end

    [SYSRESP.NumProj,~,~] = size(qkSpace0);
    SYSRESP.InitZeroAdd = SYSRESP.GSYSMOD.delaygradient/SYS.GradSampBase;  
    InitZeroMat = zeros(SYSRESP.NumProj,SYSRESP.InitZeroAdd,3);
    qkSpaceDel = cat(2,InitZeroMat,qkSpace0);
    qTDel = [qT0 qT0(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*SYSRESP.InitZeroAdd)/1000];
    SYSRESP.TrajectoryDelay = SYSRESP.GSYSMOD.delaygradient/1000;
    
    %---------------------------------------------
    % Add Regression Zeros
    %---------------------------------------------
    SYSRESP.RegressZeroEndAdd = SYSRESP.CompDurPastGrad/SYS.GradSampBase; 
    RegressZeroEndMat = zeros(SYSRESP.NumProj,SYSRESP.RegressZeroEndAdd,3);
    qkSpaceReg0 = cat(2,qkSpaceDel,RegressZeroEndMat);
    qTReg = [qTDel qTDel(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*SYSRESP.RegressZeroEndAdd)/1000]; 
    
    %---------------------------------------------
    % Generate Initial Gradients
    %---------------------------------------------     
    SYSRESP.GRAD.SetGamma(NUC.gamma);
    SYSRESP.GRAD.SetTimeQuant(DESTYPE.GradTimeQuant);
    Grad0 = SYSRESP.GRAD.CalculateGradientsReturn(qkSpaceReg0);
    
    %---------------------------------------------
    % Timing
    %---------------------------------------------
    TrajStartTime = SYSRESP.GSYSMOD.delaygradient/1000;
    TrajStopTime = qT0(end) + TrajStartTime;
    TimeSubSamp = (0:SYSRESP.GSYSMOD.dwell:TrajStopTime+0.8);
    TimeFilt = [TimeSubSamp TimeSubSamp(end)+SYSRESP.GSYSMOD.dwell]; 
    backup = round((SYSRESP.GSYSMOD.regressiondelay/1000)/SYSRESP.GSYSMOD.dwell);               % assuming design for integer
    TimeFilt = TimeFilt(1:end-backup); 
    
    Grad = Grad0;
    GradErr = zeros(size(Grad));
    for n = 1:SYSRESP.iterations 
        
        %---------------------------------------------
        % Compensate
        %---------------------------------------------         
        Grad = Grad - GradErr;
        Grad(:,end,:) = 0;
        GradChangeTotal = Grad - Grad0;
        GradSubSamp = permute(interp1(qTReg(1:end-1)-0.0001,permute(Grad,[2 1 3]),TimeSubSamp,'previous',0),[2 1 3]);

        %---------------------------------------------
        % Filter
        %---------------------------------------------
        GradFilt = zeros(size(GradSubSamp)); 
        for dim = 1:3
            filt = dsp.FIRFilter;
            reset(filt);
            filt.Numerator = SYSRESP.GSYSMOD.filtcoeff(:,dim).';                 
            reset(filt);
            GradFilt(:,:,dim) = (step(filt,squeeze(GradSubSamp(:,:,dim)).')).';                           
        end

        %---------------------------------------------
        % Calculate Error
        %---------------------------------------------   
        GradFilt = GradFilt(:,backup+1:end,:);                                              % advance to undo regression delay...
        [qkSpaceFilt,~] = ReSampleKSpace_v7a(GradFilt,TimeFilt,qTReg,NUC.gamma);
        qkSpaceErr = qkSpaceFilt - qkSpaceReg0;

        sz = size(qkSpaceErr);
        qkSpaceErrSmooth = zeros(sz);
        for i = 1:sz(1)
           for j = 1:sz(3)
               qkSpaceErrSmooth(i,:,j) = smooth(squeeze(qkSpaceErr(i,:,j)),SYSRESP.errsmthkern);
               qkSpaceErrSmooth(i,:,j) = qkSpaceErrSmooth(i,:,j) - median(qkSpaceErrSmooth(i,:,j));
           end
        end        
        GradErr = SYSRESP.GRAD.CalculateGradientsReturn(qkSpaceErrSmooth);
        
        %---------------------------------------------
        % Visualize
        %---------------------------------------------  
        if BLD.SysRespCompVis
            fh = figure(12345); clf;
            if strcmp(fh.NumberTitle,'on')
                fh.Name = 'System Response Compensation';
                fh.NumberTitle = 'off';
                fh.Position = [100+BLD.FigShift 150 1400 800];
            end

            subplot(2,3,1); hold on;
            plot(qTReg,qkSpaceErr(1,:,1),'b'); plot(qTReg,qkSpaceErr(1,:,2),'g'); plot(qTReg,qkSpaceErr(1,:,3),'r');
            plot([TrajStartTime TrajStartTime],[-0.05 0.05],'k:');
            plot([TrajStopTime TrajStopTime],[-0.05 0.05],'k:');
            xlabel('(ms)'); ylabel('kSpace (1/m)'); title('k-Space Output Error'); ylim([-0.05 0.05]); xlim([qTReg(1) qTReg(end)]);
            
            subplot(2,3,2); hold on;
            [sqTRegDisp,sGradErr] = SYSRESP.GRAD.ReturnSteppedGrads(GradErr,qTReg);
            plot(sqTRegDisp,sGradErr(1,:,1),'b'); plot(sqTRegDisp,sGradErr(1,:,2),'g'); plot(sqTRegDisp,sGradErr(1,:,3),'r');
            plot([TrajStartTime TrajStartTime],[-0.05 0.05],'k:');
            plot([TrajStopTime TrajStopTime],[-0.05 0.05],'k:');
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Output Error'); ylim([-0.05 0.05]); xlim([qTReg(1) qTReg(end)]);

            subplot(2,3,3); hold on;
            [sqTRegDisp,sGradChangeTotal] = SYSRESP.GRAD.ReturnSteppedGrads(GradChangeTotal,qTReg);
            plot(sqTRegDisp,sGradChangeTotal(1,:,1),'b'); plot(sqTRegDisp,sGradChangeTotal(1,:,2),'g'); plot(sqTRegDisp,sGradChangeTotal(1,:,3),'r');
            plot([TrajStartTime TrajStartTime],[-1 1],'k:');
            plot([TrajStopTime TrajStopTime],[-1 1],'k:');
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Alteration'); xlim([qTReg(1) qTReg(end)]); ylim([-1 1]);  

            subplot(2,3,4); hold on;
            [sqTRegDisp,sGrad] = SYSRESP.GRAD.ReturnSteppedGrads(Grad,qTReg);
            plot(sqTRegDisp,sGrad(1,:,1),'b'); plot(sqTRegDisp,sGrad(1,:,2),'g'); plot(sqTRegDisp,sGrad(1,:,3),'r');
            plot(TimeFilt(1:end-1),GradFilt(1,:,1),'k:');                         
            plot(TimeFilt(1:end-1),GradFilt(1,:,2),'k:');
            plot(TimeFilt(1:end-1),GradFilt(1,:,3),'k:');
            plot([TrajStartTime TrajStartTime],[-10 10],'k:');
            plot([TrajStopTime TrajStopTime],[-10 10],'k:');
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Input/Output'); xlim([TimeSubSamp(1) TimeSubSamp(end)]);
        end
    end

    if BLD.SysRespCompVis
        [kSpaceFilt,~] = ReSampleKSpace_v7a(GradFilt,TimeFilt,TimeFilt,NUC.gamma);
        subplot(2,3,5); hold on;
        plot(TimeFilt,kSpaceFilt(1,:,1),'b'); plot(TimeFilt,kSpaceFilt(1,:,2),'g'); plot(TimeFilt,kSpaceFilt(1,:,3),'r');
        plot(qTReg,qkSpaceReg0(1,:,1),'b*'); plot(qTReg,qkSpaceReg0(1,:,2),'g*'); plot(qTReg,qkSpaceReg0(1,:,3),'r*');
        plot([TrajStartTime TrajStartTime],[-5 5],'k:');
        plot([TrajStopTime TrajStopTime],[-5 5],'k:');
        xlabel('(ms)'); ylabel('kSpace (1/m)'); title('kSpace Start Test'); xlim([TimeFilt(1) 0.15]); ylim([-5 5]); 
 
        subplot(2,3,6); hold on;
        plot(TimeFilt,kSpaceFilt(1,:,1),'b'); plot(TimeFilt,kSpaceFilt(1,:,2),'g'); plot(TimeFilt,kSpaceFilt(1,:,3),'r');
        plot(qTReg,qkSpaceReg0(1,:,1),'b*'); plot(qTReg,qkSpaceReg0(1,:,2),'g*'); plot(qTReg,qkSpaceReg0(1,:,3),'r*');
        plot([TrajStartTime TrajStartTime],[-5 5],'k:');
        plot([TrajStopTime TrajStopTime],[-5 5],'k:');
        xlabel('(ms)'); ylabel('kSpace (1/m)'); title('kSpace End Test'); xlim([TrajStopTime-0.1 TimeFilt(end)]); ylim([-1 1]);  
    end    

    SYSRESP.GradComp = Grad;
    SYSRESP.TimeComp = 0:(SYS.GradSampBase/1000):(SYS.GradSampBase/1000)*(length(SYSRESP.GradComp)-1);
    SYSRESP.GradResp = GradFilt;
    SYSRESP.TimeResp = 0:SYSRESP.GSYSMOD.dwell:SYSRESP.GSYSMOD.dwell*(length(SYSRESP.GradResp)-1);
    Status2('done','',2); 
    Status2('done','',3); 
end


end
end






