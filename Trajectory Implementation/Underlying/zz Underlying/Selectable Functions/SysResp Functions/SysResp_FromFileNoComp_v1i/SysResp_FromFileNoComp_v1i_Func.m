%=====================================================
% 
%=====================================================

function [SYSRESP,err] = SysResp_FromFileNoComp_v1i_Func(SYSRESP,INPUT)

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
    
end
