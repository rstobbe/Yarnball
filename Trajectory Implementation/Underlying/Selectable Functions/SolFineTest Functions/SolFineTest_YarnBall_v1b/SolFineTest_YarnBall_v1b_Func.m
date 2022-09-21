%====================================================
% 
%====================================================

function [SOLFINTEST,err] = SolFineTest_YarnBall_v1b_Func(SOLFINTEST,INPUT)

Status2('busy','Test Yarnball Solution Fineness',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
TST = INPUT.TST;
IMPTYPE = INPUT.IMPTYPE;
PSMP = INPUT.PSMP;
GENPRJ = INPUT.GENPRJ;
DESOL = INPUT.DESOL;
clear INPUT

%---------------------------------------------
% Generate Trajectory
%---------------------------------------------
func = str2func([IMPTYPE.method,'_Func']);    
INPUT.PSMP.phi = 0;
INPUT.PSMP.theta = 0;
INPUT.PROJdgn = PROJdgn;
INPUT.GENPRJ = GENPRJ;
INPUT.DESOL = DESOL;
INPUT.func = 'GenerateOut';  
INPUT.PROJdgn.elip = 1;
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;
T = IMPTYPE.T;
KSA = IMPTYPE.KSA;

%---------------------------------------------
% Test
%---------------------------------------------
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
testtro = interp1(Rad,T,1,'spline');         % ensure proper timing  
if round(testtro*1e5) ~= round(PROJdgn.tro*1e5)   
    figure(1234123);
    plot(T,Rad,'-*');
    error
end    

%---------------------------------------------
% Test
%---------------------------------------------
m = 2:length(KSA(1,:,1));
kStep = [KSA(:,1,:) KSA(:,m,:) - KSA(:,m-1,:)];
MagkStep = sqrt(kStep(:,:,1).^2 + kStep(:,:,2).^2 + kStep(:,:,3).^2);
MagkStep = mean(MagkStep,1);
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
if Rad(end) < 1                                 % make sure not solved to less than 1
    RadEnd = Rad(end)
    error
end    

%---------------------------------------------
% Measure TrajLength
%---------------------------------------------
ind = find(Rad >= 1,1);
SOLFINTEST.TrajLen = sum(MagkStep(1:ind));

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(TST.SOLFINTEST.Vis,'Yes')
    fh = figure(500);
    if strcmp(fh.NumberTitle,'on')
        fh.Name = 'Solution Fineness Testing for Waveform Generation';
        fh.NumberTitle = 'off';
        fh.Position = [400+TST.figshift 150 1000 800];
    else
        redraw = 1;
        if isfield(TST,'redraw')
            if strcmp(TST.redraw,'No')
                redraw = 0;
            end
        end
        if redraw == 1
            clf(fh);
        end
    end  
    subplot(2,2,1); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),1,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'bx');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),PROJdgn.p,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'rx');
    lim = max(Rad)*PROJdgn.rad;
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Full (Outward) Trajectory');
    set(gca,'cameraposition',[-310 -390 125]); 
    
    subplot(2,2,2); hold on; axis equal; grid on; box off;
    ind = find(Rad >= 1.25*PROJdgn.p,1);  
    if isempty(ind)
        ind = length(Rad);
    end
    plot3(PROJdgn.rad*KSA(1,1:ind,1),PROJdgn.rad*KSA(1,1:ind,2),PROJdgn.rad*KSA(1,1:ind,3),'k-');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),1,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'bx');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),PROJdgn.p,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'rx');
    lim = ceil(PROJdgn.rad*Rad(ind));
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Initial Portion');
    set(gca,'cameraposition',[-310 -390 125]); 

    subplot(2,2,3); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
    lim = 0.5;
    xlim([-lim,lim]); ylim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[0 0 5000]);
    set(gca,'CameraTargetMode','manual');
    set(gca,'CameraTarget',[0 0 0]);
    set(gca,'xtick',(-0.5:0.25:0.5)); set(gca,'ytick',(-0.5:0.25:0.5)); title('Solution Quantization Deflection @ Centre');

    subplot(2,2,4); hold on;
    plot(Rad,PROJdgn.rad*MagkStep,'k');
    plot([PROJdgn.p PROJdgn.p],PROJdgn.rad*[0 1.1],':');
    plot([0 2],[0.1 0.1],':');
    plot([0 2],[1 1],':');
    ylim([0 1.1]);
    xlabel('Relative Radius'); ylabel('kStep'); xlim([0 max(Rad)]); title('Solution Sampling Fineness');
    
    test = 1;
    if isfield(TST,'checks')
        if strcmp(TST.checks,'No')
            test = 0;
        end
    end
    if test == 1
        button = questdlg('Continue? (Check Solution Fineness for Waveform Generation)');
        if strcmp(button,'No') || strcmp(button,'Cancel')
            err.flag = 4;
            err.msg = '';
            return
        end
    end
    SOLFINTEST.Figure(1).Name = 'SolFinTest';
    SOLFINTEST.Figure(1).Type = 'Graph';
    SOLFINTEST.Figure(1).hFig = fh;
    SOLFINTEST.Figure(1).hAx = gca;   
end


Status2('done','',2);
Status2('done','',3);
