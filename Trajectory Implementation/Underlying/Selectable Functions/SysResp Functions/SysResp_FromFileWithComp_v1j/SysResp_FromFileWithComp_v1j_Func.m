%=====================================================
% 
%=====================================================

function [SYSRESP,err] = SysResp_FromFileWithComp_v1j_Func(SYSRESP,INPUT)

Status2('busy','Include System Response',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJimp = INPUT.PROJimp;
qT0 = INPUT.qT0;
if isfield(INPUT,'GQKSA0')
    GQKSA0 = INPUT.GQKSA0;
end
if isfield(INPUT,'G0')
    G0 = INPUT.G0;
end
SYS = INPUT.SYS;
TST = INPUT.TST;
mode = INPUT.mode;
GSYSMOD = SYSRESP.GSYSMOD;
clear INPUT

%==================================================================
% Delay Gradient (potentially relevant for Siemens which starts the Gradients early)
%==================================================================
if strcmp(mode,'Delay')
    if rem(GSYSMOD.delaygradient,SYS.GradSampBase)
        err.flag = 1;
        err.msg = ['System response model not suitable for ',SYS.System];
        return
    end
    [nProj,~,~] = size(GQKSA0);
    initzeroadd = GSYSMOD.delaygradient/SYS.GradSampBase;
    initzeromat = zeros(nProj,initzeroadd,3);
    SYSRESP.GQKSA = cat(2,initzeromat,GQKSA0);
    SYSRESP.qT = [qT0 qT0(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*initzeroadd)/1000];
    SYSRESP.efftrajdel = GSYSMOD.delaygradient/1000;
    Status2('done','',3);
end   
        
%==================================================================
% Compensate 
%==================================================================
if strcmp(mode,'Compensate')

    %---------------------------------------------
    % Add regression delay 
    %---------------------------------------------
    [nProj,~,~] = size(SYSRESP.GQKSA);
    initzeroadd = GSYSMOD.regressiondelay/SYS.GradSampBase;
    initzeromat = zeros(nProj,initzeroadd,3);
    GQKSAtraj = cat(2,initzeromat,SYSRESP.GQKSA);
    qTtraj = [SYSRESP.qT SYSRESP.qT(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*initzeroadd)/1000]; 
    G0 = cat(2,initzeromat,G0);
    qT = [qT0 qT0(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*initzeroadd)/1000];    
    [GQKSA,~] = ReSampleKSpace_v7a(G0,qT,qT,PROJimp.gamma);
    
    %---------------------------------------------
    % Compensate
    %---------------------------------------------
    G00 = G0;
    Time = (0:GSYSMOD.dwell:qT(end)+1.0);
    GradImp0 = permute(interp1(qT(1:end-1)-0.0001,permute(G0,[2 1 3]),Time,'previous',0),[2 1 3]);
    GradImp = GradImp0;  
    Tfilt = [Time Time(end)+GSYSMOD.dwell]; 
    backup = round((GSYSMOD.regressiondelay/1000)/GSYSMOD.dwell);               % assuming design for integer
    Tfilt = Tfilt(1:end-backup); 
    TfiltDisp = Tfilt-GSYSMOD.regressiondelay/1000;
    TimeDisp = Time-GSYSMOD.regressiondelay/1000;
    qTDisp = qT-GSYSMOD.regressiondelay/1000;
    qTtrajDisp = qTtraj-GSYSMOD.regressiondelay/1000;
    
    for n = 1:SYSRESP.iterations 
        %---------------------------------------------
        % Filter
        %---------------------------------------------
        Gfilt = zeros(size(GradImp)); 
        for d = 1:3
            filt = dsp.FIRFilter;
            reset(filt);
            filt.Numerator = GSYSMOD.filtcoeff(:,d).';                 
            reset(filt);
            Gfilt(:,:,d) = (step(filt,squeeze(GradImp(:,:,d)).')).';                           
        end

        %---------------------------------------------
        % Compensate
        %---------------------------------------------   
        Gfilt = Gfilt(:,backup+1:end,:);
        [Kfilt,~] = ReSampleKSpace_v7a(Gfilt,Tfilt,qT,PROJimp.gamma);
        Kerr = Kfilt-GQKSA;
        
        if strcmp(TST.SYSRESP.Vis,'Yes')
            fh = figure(12345); clf;
            if strcmp(fh.NumberTitle,'on')
                fh.Name = 'System Response Compensation';
                fh.NumberTitle = 'off';
                fh.Position = [260+TST.figshift 150 1400 800];
            end
            subplot(2,3,1); hold on;
            plot(TimeDisp,GradImp0(1,:,1),'b:'); plot(TimeDisp,GradImp0(1,:,2),'g:'); plot(TimeDisp,GradImp0(1,:,3),'r:'); 
            plot(TimeDisp,GradImp(1,:,1),'b'); plot(TimeDisp,GradImp(1,:,2),'g'); plot(TimeDisp,GradImp(1,:,3),'r'); 
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Modification'); xlim([TimeDisp(1) TimeDisp(end)]);

            subplot(2,3,2); hold on;
            plot(qTtrajDisp,GQKSAtraj(1,:,1),'b*'); plot(qTtrajDisp,GQKSAtraj(1,:,2),'g*'); plot(qTtrajDisp,GQKSAtraj(1,:,3),'r*');     % stars should be overwritten if proper
            plot(qTDisp,GQKSA(1,:,1),'b*'); plot(qTDisp,GQKSA(1,:,2),'g*'); plot(qTDisp,GQKSA(1,:,3),'r*');
            plot(qTDisp,Kfilt(1,:,1),'b-'); plot(qTDisp,Kfilt(1,:,2),'g-'); plot(qTDisp,Kfilt(1,:,3),'r-');
            xlabel('(ms)'); ylabel('kSpace (1/m)'); title('Output Comparison'); xlim([qTDisp(1) SYSRESP.qT(end)]);

            subplot(2,3,3); hold on;
            plot(qTDisp,Kerr(1,:,1),'b'); plot(qTDisp,Kerr(1,:,2),'g'); plot(qTDisp,Kerr(1,:,3),'r');
            xlabel('(ms)'); ylabel('kSpace (1/m)'); title('k-Space Output Error'); ylim([-0.05 0.05]); xlim([qTDisp(1) SYSRESP.qT(end)]);
        end
        
        sz = size(Kerr);
        for i = 1:sz(1)
           for j = 1:sz(3)
               Kerr(i,:,j) = smooth(squeeze(Kerr(i,:,j)),SYSRESP.errsmthkern);
               Kerr(i,:,j) = Kerr(i,:,j) - median(Kerr(i,:,j));
           end
        end

        Gerr = SolveGradQuant_v1c(qT,Kerr,PROJimp.gamma);
        %--
        retreat = 10;
        decay = exp(-(1:retreat)/(retreat/4));
        decaymesh = repmat(decay,nProj,1,3);
        %--
        Gerr(:,length(SYSRESP.qT)+initzeroadd+(-retreat+1:0),:) = Gerr(:,length(SYSRESP.qT)+initzeroadd+(-retreat+1:0),:).*decaymesh;
        Gerr(:,length(SYSRESP.qT)+initzeroadd+1:end,:) = 0;
        
        if strcmp(TST.SYSRESP.Vis,'Yes')
            subplot(2,3,4); hold on;
            plot(qTDisp(1:end-1),Gerr(1,:,1),'b'); plot(qTDisp(1:end-1),Gerr(1,:,2),'g'); plot(qTDisp(1:end-1),Gerr(1,:,3),'r');
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Output Error'); ylim([-0.1 0.1]); xlim([qTDisp(1) SYSRESP.qT(end)]);
        end

        if n < SYSRESP.iterations 
            G0 = G0-Gerr;
            G0(:,1:initzeroadd,:) = 0;
            GradImp = permute(interp1(qT(1:end-1)-0.0001,permute(G0,[2 1 3]),Time,'previous',0),[2 1 3]);
        end
        
        if strcmp(TST.SYSRESP.Vis,'Yes')
            subplot(2,3,5); hold on;
            Galt = G00-G0;
            plot(qTDisp(1:end-1),Galt(1,:,1),'b'); plot(qTDisp(1:end-1),Galt(1,:,2),'g'); plot(qTDisp(1:end-1),Galt(1,:,3),'r');
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Alteration'); ylim([-1 1]); xlim([qTDisp(1) SYSRESP.qT(end)]); 

            subplot(2,3,6); hold on;
            plot(TfiltDisp(1:end-1),Gfilt(1,:,1),'k:');                         % lines should get covered below if proper...
            plot(TfiltDisp(1:end-1),Gfilt(1,:,2),'k:');
            plot(TfiltDisp(1:end-1),Gfilt(1,:,3),'k:');
            xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('System Input/Output'); xlim([TimeDisp(1) TimeDisp(end)]);
        end
    end
    SYSRESP.Gcomp = G0(:,initzeroadd+1:end,:);
    SYSRESP.Tcomp = qT0;
    SYSRESP.efftrajdel = GSYSMOD.delaygradient/1000;
    Status2('done','',3); 
end

%==================================================================
% Analyze
%==================================================================
if strcmp(mode,'Analyze')

    %---------------------------------------------
    % Add regression delay 
    %---------------------------------------------
    [nProj,~,~] = size(G0);
    initzeroadd = GSYSMOD.regressiondelay/SYS.GradSampBase;
    initzeromat = zeros(nProj,initzeroadd,3);
    G0 = cat(2,initzeromat,G0);
    qT = [qT0 qT0(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*initzeroadd)/1000];    
    
    Time = (0:GSYSMOD.dwell:qT(end)+1.0);
    GradImp = permute(interp1(qT(1:end-1)-0.0001,permute(G0,[2 1 3]),Time,'previous',0),[2 1 3]); 
    Gfilt = zeros(size(GradImp)); 
    Tfilt = [Time Time(end)+GSYSMOD.dwell]; 
    
    %---------------------------------------------
    % Filter
    %---------------------------------------------
    for d = 1:3
        filt = dsp.FIRFilter;
        reset(filt);
        filt.Numerator = GSYSMOD.filtcoeff(:,d).';                 
        reset(filt);
        Gfilt(:,:,d) = (step(filt,squeeze(GradImp(:,:,d)).')).';                           
    end

    backup = round((GSYSMOD.regressiondelay/1000)/GSYSMOD.dwell);               % assuming design for integer
    Gfilt = Gfilt(:,backup+1:end,:);    
    SYSRESP.Grecon = Gfilt;  
    SYSRESP.Trecon = Tfilt(1:end-backup) - GSYSMOD.regressiondelay/1000;
    SYSRESP.efftrajdel = GSYSMOD.delaygradient/1000;
    Status2('done','',3);
    
    %---
    if strcmp(TST.SYSRESP.Vis,'Yes')
        fh = figure(12345);
        if strcmp(fh.NumberTitle,'on')
            fh.Name = 'System Response Compensation';
            fh.NumberTitle = 'off';
            fh.Position = [260+TST.figshift 150 1400 800];
        end
        subplot(2,3,6); hold on;
        TimeDisp = Time-GSYSMOD.regressiondelay/1000;
        plot(TimeDisp,GradImp(1,:,1),'b:'); plot(TimeDisp,GradImp(1,:,2),'g:'); plot(TimeDisp,GradImp(1,:,3),'r:'); 
        plot(SYSRESP.Trecon(1:end-1),SYSRESP.Grecon(1,:,1),'b');
        plot(SYSRESP.Trecon(1:end-1),SYSRESP.Grecon(1,:,2),'g'); 
        plot(SYSRESP.Trecon(1:end-1),SYSRESP.Grecon(1,:,3),'r');
        xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('System Input/Output'); xlim([TimeDisp(1) TimeDisp(end)]);
    end
    %---

    %----------------------------------------------------
    % Save Figure
    %----------------------------------------------------
    if strcmp(TST.SYSRESP.Vis,'Yes')
        SYSRESP.Figure(1).Name = 'SysResp Characteristics';
        SYSRESP.Figure(1).Type = 'Graph';
        SYSRESP.Figure(1).hFig = fh;
        SYSRESP.Figure(1).hAx = gca;
    end      
end
