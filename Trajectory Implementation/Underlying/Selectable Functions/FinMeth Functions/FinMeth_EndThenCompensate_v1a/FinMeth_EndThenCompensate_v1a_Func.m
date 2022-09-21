%====================================================
% 
%====================================================

function [FINMETH,err] = FinMeth_EndThenCompensate_v1a_Func(FINMETH,INPUT)

Status2('busy','Finish Trajectory',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
GQKSA0 = INPUT.GQKSA0;
qT0 = INPUT.qT0; 
SYS = INPUT.SYS;
SYSRESP = INPUT.SYSRESP;
TEND = INPUT.TEND;
TST = INPUT.TST;
GQNT = INPUT.GQNT;
clear INPUT;

%----------------------------------------------------
% Delay Start (if necessary)
%----------------------------------------------------
Status2('busy','Delay Gradient Start',2);
func = str2func([SYSRESP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qT0 = qT0;
INPUT.GQKSA0 = GQKSA0;
INPUT.SYS = SYS;
INPUT.TST = TST;
INPUT.mode = 'Delay';
[SYSRESP,err] = func(SYSRESP,INPUT);
if err.flag
    return
end
qT = SYSRESP.qT;
GQKSA = SYSRESP.GQKSA;

%----------------------------------------------------
% Solve Gradient Quantization
%----------------------------------------------------
Status2('busy','Solve Gradient Quantization',2);
G0 = SolveGradQuant_v1c(qT,GQKSA,PROJimp.gamma);

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes')
    [A,B,C] = size(G0);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qT)-1
        L((n-1)*2+1) = qT(n);
        L(n*2) = qT(n+1);
        Gvis(:,(n-1)*2+1,:) = G0(:,n,:);
        Gvis(:,n*2,:) = G0(:,n,:);
    end
    fhwfm = figure(1000); 
    if strcmp(fhwfm.NumberTitle,'on')
        fhwfm.Name = 'Gradient Waveforms';
        fhwfm.NumberTitle = 'off';
        fhwfm.Position = [400+TST.figshift 150 1000 800];
    else
        redraw = 1;
        if isfield(TST,'redraw')
            if strcmp(TST.redraw,'No')
                redraw = 0;
            end
        end
        if redraw == 1
            clf(fhwfm);
        end
    end  
    subplot(2,2,1); hold on; 
    plot(L,zeros(size(L)),'k:');
    plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:');
    title(['Traj ',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');   
end

%---------------------------------------------
% Calculate Gradient Momoments
%---------------------------------------------
Gmom = sum(G0,2)*(SYS.GradSampBase/1000);
Gend = G0(:,end,:);   

%----------------------------------------------------
% Calculation Trajectory Ending
%----------------------------------------------------
Status2('busy','End Trajectory',2);
func = str2func([TEND.method,'_Func']);
INPUT.SYS = SYS;
INPUT.Gmom = Gmom;  
INPUT.Gend = Gend;
INPUT.PROJimp = PROJimp;
INPUT.PROJdgn = PROJdgn;
[TEND,err] = func(TEND,INPUT);
if err.flag
    return
end   
Gend = TEND.Gend;
G0wend = cat(2,G0,Gend);
qTend = (GQNT.gseg:GQNT.gseg:length(Gend(1,:,1))*GQNT.gseg);
qTwend = [qT qT(end)+qTend];

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes')
    [A,B,C] = size(G0wend);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTwend)-1
        L((n-1)*2+1) = qTwend(n);
        L(n*2) = qTwend(n+1);
        Gvis(:,(n-1)*2+1,:) = G0wend(:,n,:);
        Gvis(:,n*2,:) = G0wend(:,n,:);
    end
    figure(1000); 
    subplot(2,2,1); hold on; 
    plot(L,zeros(size(L)),'k:');
    plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:');
    title(['Traj ',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');   
end

%----------------------------------------------------
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
m = (2:length(G0wend(1,:,1))-2);
cartgsteps = [G0wend(:,1,:) G0wend(:,m,:)-G0wend(:,m-1,:)];
maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
if strcmp(TST.GVis,'Yes') 
    figure(1000); 
    subplot(2,2,2); hold on; 
    for p = 1:length(cartgsteps(1,:,1))
        maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
    end
    %---
    maxcartgsteps = smooth(maxcartgsteps,7);
    %---
    GWFM.G0wendmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
    plot(qTwend(2:length(qTwend)-2),maxcartgsteps/GQNT.gseg,'y-');
    plot(qTwend(2:length(qTwend)-2),maxmaggsteps/GQNT.gseg,'y:');
    title('Max Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    figure(1000); 
    subplot(2,2,3); hold on; 
    for p = 1:length(cartg2drv(1,:,1))
        maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
    end
    %---
    maxcartg2drvT = smooth(maxcartg2drvT,7);
    %---
    GWFM.G0wendmaxcart2drv = max(maxcartg2drvT(2:length(qT)-1))/GQNT.gseg^2;
    plot(qTwend(2:length(qT)-1),maxcartg2drvT(2:length(qT)-1)/GQNT.gseg^2,'y-');
    title('Max Gradient Channel Acceleration');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');    
end

%----------------------------------------------------
% Compensate for System Response
%----------------------------------------------------
Status2('busy','Compensate for System Response',2);
func = str2func([SYSRESP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qT0 = qTwend;
INPUT.G0 = G0wend;
INPUT.SYS = SYS;
INPUT.TST = TST;
INPUT.mode = 'Compensate';
[SYSRESP,err] = func(SYSRESP,INPUT);
if err.flag
    return
end
Gcomp = SYSRESP.Gcomp;    
qTcomp = SYSRESP.Tcomp; 

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes') 
    [A,B,C] = size(Gcomp);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTcomp)-1
        L((n-1)*2+1) = qTcomp(n);
        L(n*2) = qTcomp(n+1);
        Gvis(:,(n-1)*2+1,:) = Gcomp(:,n,:);
        Gvis(:,n*2,:) = Gcomp(:,n,:);
    end
    figure(1000); 
    subplot(2,2,1); hold on; 
    plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
    title(['Traj',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end  

%----------------------------------------------------
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
m = (2:length(Gcomp(1,:,1))-2);
cartgsteps = [Gcomp(:,1,:) Gcomp(:,m,:)-Gcomp(:,m-1,:)];
maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
for p = 1:length(cartgsteps(1,:,1))
    maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
end
%---
maxcartgsteps = smooth(maxcartgsteps,7);
%---
GWFM.Gcompmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
for p = 1:length(cartg2drv(1,:,1))
    maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
end
%---
maxcartg2drvT = smooth(maxcartg2drvT,7);
%---
GWFM.Gcompmaxcart2drv = max(maxcartg2drvT(2:length(qT)-1))/GQNT.gseg^2;

if strcmp(TST.GVis,'Yes') 
    figure(1000); 
    subplot(2,2,2); hold on; 
    sp3 = plot(qTcomp(2:length(qTcomp)-2),maxcartgsteps/GQNT.gseg,'k-');
    sp4 = plot(qTcomp(2:length(qTcomp)-2),maxmaggsteps/GQNT.gseg,'k:');
    title('Max Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    legend([sp3,sp4],'Max Channel Speed','Mean Total Speed','Location','southwest');    
    subplot(2,2,3); hold on; 
    plot(qTcomp(2:length(qT)-1),maxcartg2drvT(2:length(qT)-1)/GQNT.gseg^2,'k-');
    title('Max Gradient Channel Acceleration');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');    
end 

%----------------------------------------------------
% Other
%----------------------------------------------------            
GWFM.GmaxSncrChan = max(abs(Gcomp(:)));
GWFM.GmaxScnrChan = max(abs(Gcomp(:)));
GabsTraj = sqrt(G0(:,:,1).^2 + G0(:,:,2).^2 + G0(:,:,3).^2);   
GWFM.GmaxTraj = max(GabsTraj(:));
GWFM.tgwfm = qTcomp(end);
GWFM.sampend = PROJdgn.tro + SYSRESP.efftrajdel;   
if isfield(TST,'traj')
    GWFM.TstTrj = TST.traj;
end

%----------------------------------------------------
% Return
%----------------------------------------------------
FINMETH.qT = qT;
FINMETH.GQKSA = GQKSA;
FINMETH.qTtot = qTcomp;
FINMETH.Gtot = Gcomp;
FINMETH.GWFM = GWFM;


Status2('done','',2);
Status2('done','',3);
