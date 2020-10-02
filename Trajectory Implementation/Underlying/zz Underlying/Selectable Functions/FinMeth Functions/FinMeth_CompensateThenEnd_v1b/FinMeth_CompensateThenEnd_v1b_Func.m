%====================================================
% 
%====================================================

function [FINMETH,err] = FinMeth_CompensateThenEnd_v1b_Func(FINMETH,INPUT)

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
% Trajectory End
%----------------------------------------------------
TrajEnd = qT(end) + qT(2);
FINMETH.start2est = TrajEnd-PROJdgn.tro;

%---------------------------------------------
% Add Zeros for Compensation Length
%---------------------------------------------    
%--
compdur = 500;          % us
%--
nproj = length(GQKSA(:,1,1));
step = qT0(2);
nzeros = (compdur/1000)/step;
zeroadd = zeros(nproj,nzeros,3);
zerotiming = (step:step:nzeros*step);
GQKSA = cat(2,GQKSA,zeroadd);
qT = [qT qT(end)+zerotiming];

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

%----------------------------------------------------
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
m = (2:length(G0(1,:,1)));
cartgsteps = [G0(:,1,:) G0(:,m,:)-G0(:,m-1,:)];
maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
if strcmp(TST.GVis,'Yes') 
    figure(1000); 
    subplot(2,2,2); hold on; 
    for p = 1:length(cartgsteps(1,:,1))
        maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
    end
    GWFM.G0wendmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
    plot(qT(2:end),maxcartgsteps/GQNT.gseg,'y-');
    plot(qT(2:end),maxmaggsteps/GQNT.gseg,'y:');
    title('Max Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    subplot(2,2,3); hold on; 
    for p = 1:length(cartg2drv(1,:,1))
        maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
    end
    GWFM.G0wendmaxcart2drv = max(maxcartg2drvT)/GQNT.gseg^2;
    plot(qT(2:end),maxcartg2drvT/GQNT.gseg^2,'y-');
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
INPUT.qT0 = qT;
INPUT.G0 = G0;
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
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
m = (2:length(Gcomp(1,:,1)));
cartgsteps = [Gcomp(:,1,:) Gcomp(:,m,:)-Gcomp(:,m-1,:)];
maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
for p = 1:length(cartgsteps(1,:,1))
    maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
end
GWFM.Gcompmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
for p = 1:length(cartg2drv(1,:,1))
    maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
end
GWFM.Gcompmaxcart2drv = max(maxcartg2drvT)/GQNT.gseg^2;
if strcmp(TST.GVis,'Yes') 
    figure(1000); 
    subplot(2,2,2); hold on; 
    sp3 = plot(qTcomp(2:end),maxcartgsteps/GQNT.gseg,'k-');
    sp4 = plot(qTcomp(2:end),maxmaggsteps/GQNT.gseg,'k:');
    title('Max Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    legend([sp3,sp4],'Max Channel Speed','Mean Total Speed','Location','southwest');
    subplot(2,2,3); hold on; 
    plot(qTcomp(2:end),maxcartg2drvT/GQNT.gseg^2,'k-');
    title('Max Gradient Channel Acceleration');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');    
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

%----------------------------------------------------
% Add Trajectory Ending
%----------------------------------------------------
%--
Delay2Spoil = 60;          %us
%--
LenGend = length(TEND.Gend(1,:,1));
SpoilDur = LenGend*GQNT.gseg;
WfmEnd = TrajEnd + Delay2Spoil/1000 + SpoilDur;
qTtot = (0:GQNT.gseg:WfmEnd+GQNT.gseg);

sz = size(Gcomp);
if sz(2) > length(qTtot)-1
    Gcomp = Gcomp(:,1:length(qTtot)-1,:);
    sz = size(Gcomp);
end
Gcomptot = zeros(nproj,length(qTtot)-1,3);
Gcomptot(:,1:sz(2),:) = Gcomp;
Gend = zeros(nproj,length(qTtot)-1,3);
Gend(:,end-LenGend+1:end,:) = TEND.Gend;
Gtot = Gcomptot+Gend;

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes') 
    [A,B,C] = size(Gtot);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTtot)-1
        L((n-1)*2+1) = qTtot(n);
        L(n*2) = qTtot(n+1);
        Gvis(:,(n-1)*2+1,:) = Gtot(:,n,:);
        Gvis(:,n*2,:) = Gtot(:,n,:);
    end
    figure(1000); 
    subplot(2,2,1); hold on; 
    plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
    title(['Traj',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end 

%----------------------------------------------------
% Other
%----------------------------------------------------            
GabsTraj = sqrt(G0(:,:,1).^2 + G0(:,:,2).^2 + G0(:,:,3).^2);   
GWFM.GmaxTraj = max(GabsTraj(:));
GWFM.sampend = PROJdgn.tro + SYSRESP.efftrajdel;   
GWFM.GmaxSncrChan = max(abs(Gtot(:)));
GWFM.tgwfm = qTtot(length(qTtot));
if isfield(TST,'traj')
    GWFM.TstTrj = TST.traj;
end

%----------------------------------------------------
% Return
%----------------------------------------------------
FINMETH.qT = qT;
FINMETH.GQKSA = GQKSA;
FINMETH.qTtot = qTtot;
FINMETH.Gtot = Gtot;
FINMETH.GWFM = GWFM;


Status2('done','',2);
Status2('done','',3);
