%==================================================================
% (v2a)
%   
%==================================================================

classdef SysResp_FromFileWithComp_v2a < handle

properties (SetAccess = private)                   
    Method = 'SysResp_FromFileWithComp_v2a'
    SYSRESPipt
    errsmthkern
    iterations
    GSYSMOD
    GRAD
    NumProj
    InitZeroAdd
    EffTrajDel
    RegressZeroStartAdd
    RegressZeroEndAdd
    TimeReg
    GradReg
    CompDurPastGrad = 100
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function [SYSRESP,err] = SysResp_FromFileWithComp_v2a(SYSRESPipt)    
    err.flag = 0;
    SYSRESP.SYSRESPipt = SYSRESPipt;
    SYSRESP.errsmthkern = 3;
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
% Delay
%==================================================================  
function err = Compensate(SYSRESP,qT0,qkSpace0,DESTYPE)
    
    error('finish')
    
    err.flag = 0;
    SYS = DESTYPE.SYS;
    NUC = DESTYPE.NUC;
    %---------------------------------------------
    % Delay gradients (offset starting early)
    %---------------------------------------------    
    if rem(SYSRESP.GSYSMOD.delaygradient,SYS.GradSampBase)
        err.flag = 1;
        err.msg = ['System response model not suitable for ',SYS.System];
        return
    end
    [SYSRESP.NumProj,~,~] = size(qkSpace0);
    SYSRESP.InitZeroAdd = SYSRESP.GSYSMOD.delaygradient/SYS.GradSampBase;  
    InitZeroMat = zeros(SYSRESP.NumProj,SYSRESP.InitZeroAdd,3);
    qkSpaceDel = cat(2,InitZeroMat,qkSpace0);
    qTDel = [qT0 qT0(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*SYSRESP.InitZeroAdd)/1000];
    SYSRESP.EffTrajDel = SYSRESP.GSYSMOD.delaygradient/1000;
    
    %---------------------------------------------
    % Add Regression Zeros
    %---------------------------------------------
    SYSRESP.RegressZeroStartAdd = SYSRESP.GSYSMOD.regressiondelay/SYS.GradSampBase;
    RegressZeroStartMat = zeros(SYSRESP.NumProj,SYSRESP.RegressZeroStartAdd,3);
    SYSRESP.RegressZeroEndAdd = SYSRESP.CompDurPastGrad/SYS.GradSampBase; 
    RegressZeroEndMat = zeros(SYSRESP.NumProj,SYSRESP.RegressZeroEndAdd,3);
    
    qkSpaceReg0 = cat(2,RegressZeroStartMat,qkSpaceDel,RegressZeroEndMat);
    qTReg = [qTDel qTDel(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*(SYSRESP.RegressZeroStartAdd+SYSRESP.RegressZeroEndAdd))/1000]; 
    
    %---------------------------------------------
    % Generate Initial Gradients
    %---------------------------------------------     
    SYSRESP.GRAD.SetGamma(NUC.gamma);
    SYSRESP.GRAD.SetTimeQuant(DESTYPE.GradTimeQuant);
    Grad0 = SYSRESP.GRAD.CalculateGradientsReturn(qkSpaceReg0);
   
    %[Test,~] = ReSampleKSpace_v7a(Grad0,qTReg,qTReg,NUC.gamma);
    
    %---------------------------------------------
    % Timing
    %---------------------------------------------
    TimeSubSamp = (0:SYSRESP.GSYSMOD.dwell:qTReg(end)+1.0);
    TimeFilt = [TimeSubSamp TimeSubSamp(end)+SYSRESP.GSYSMOD.dwell]; 
    backup = round((SYSRESP.GSYSMOD.regressiondelay/1000)/SYSRESP.GSYSMOD.dwell);               % assuming design for integer
    TimeFilt = TimeFilt(1:end-backup); 
    TimeFiltDisp = TimeFilt-SYSRESP.GSYSMOD.regressiondelay/1000;
    TimeSubSampDisp = TimeSubSamp-SYSRESP.GSYSMOD.regressiondelay/1000;
    qTRegDisp = qTReg-SYSRESP.GSYSMOD.regressiondelay/1000;
    
    Grad = Grad0;
    GradErr = zeros(size(Grad));
    for n = 1:SYSRESP.iterations 
        
        %---------------------------------------------
        % Compensate
        %---------------------------------------------         
        GradNew = Grad - GradErr;
        GradNew(:,1:SYSRESP.RegressZeroStartAdd,:) = 0;
        GradChangeTotal = GradNew - Grad0;
        GradNewSubSamp = permute(interp1(qTReg(1:end-1)-0.0001,permute(GradNew,[2 1 3]),TimeSubSamp,'previous',0),[2 1 3]);
        
        %---------------------------------------------
        % Filter
        %---------------------------------------------
        GradFilt = zeros(size(GradNewSubSamp)); 
        for dim = 1:3
            filt = dsp.FIRFilter;
            reset(filt);
            filt.Numerator = SYSRESP.GSYSMOD.filtcoeff(:,dim).';                 
            reset(filt);
            GradFilt(:,:,dim) = (step(filt,squeeze(GradNewSubSamp(:,:,dim)).')).';                           
        end

        %---------------------------------------------
        % Calculate Error
        %---------------------------------------------   
        GradFilt = GradFilt(:,backup+1:end,:);
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
        Grad = GradNew;
        
        %---------------------------------------------
        % Visualize
        %---------------------------------------------  
        Vis = 'Yes';
        TST.figshift = -1800;
        if strcmp(Vis,'Yes')
            fh = figure(12345); clf;
            if strcmp(fh.NumberTitle,'on')
                fh.Name = 'System Response Compensation';
                fh.NumberTitle = 'off';
                fh.Position = [260+TST.figshift 150 900 800];
            end

            subplot(2,2,1); hold on;
            plot(qTRegDisp,qkSpaceErr(1,:,1),'b'); plot(qTRegDisp,qkSpaceErr(1,:,2),'g'); plot(qTRegDisp,qkSpaceErr(1,:,3),'r');
            xlabel('(ms)'); ylabel('kSpace (1/m)'); title('k-Space Output Error'); xlim([qTRegDisp(1) qTRegDisp(end)]); ylim([-0.05 0.05]);
            
            subplot(2,2,2); hold on;
            plot(qTRegDisp(1:end-1),GradErr(1,:,1),'b'); plot(qTRegDisp(1:end-1),GradErr(1,:,2),'g'); plot(qTRegDisp(1:end-1),GradErr(1,:,3),'r');
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Output Error'); xlim([qTRegDisp(1) qTRegDisp(end)]); ylim([-0.1 0.1]);

            subplot(2,2,3); hold on;
            plot(qTRegDisp(1:end-1),GradChangeTotal(1,:,1),'b'); plot(qTRegDisp(1:end-1),GradChangeTotal(1,:,2),'g'); plot(qTRegDisp(1:end-1),GradChangeTotal(1,:,3),'r');
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Alteration'); xlim([qTRegDisp(1) qTRegDisp(end)]); ylim([-1 1]);  

            subplot(2,2,4); hold on;
            plot(qTRegDisp(1:end-1),Grad(1,:,1),'b'); plot(qTRegDisp(1:end-1),Grad(1,:,2),'g'); plot(qTRegDisp(1:end-1),Grad(1,:,3),'r');
            plot(TimeFiltDisp(1:end-1),GradFilt(1,:,1),'k:');                         % lines should get covered below if proper...
            plot(TimeFiltDisp(1:end-1),GradFilt(1,:,2),'k:');
            plot(TimeFiltDisp(1:end-1),GradFilt(1,:,3),'k:');
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('System Input/Output'); xlim([TimeSubSampDisp(1) TimeSubSampDisp(end)]);
        end
    end
    SYSRESP.GradReg = Grad(:,SYSRESP.RegressZeroStartAdd+1:end,:);
    SYSRESP.TimeReg = 0:(SYS.GradSampBase/1000):(SYS.GradSampBase/1000)*(length(SYSRESP.GradReg)-1);
    Status2('done','',3); 
end


end
end






