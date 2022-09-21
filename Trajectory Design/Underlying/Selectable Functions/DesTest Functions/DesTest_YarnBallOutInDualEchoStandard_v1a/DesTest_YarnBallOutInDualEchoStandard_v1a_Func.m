%====================================================
%
%====================================================

function [TST,err] = DesTest_YarnBallOutInDualEchoStandard_v1a_Func(TST,INPUT)

Status2('busy','YarnBall Design Test',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
func = INPUT.func;
DESMETH = INPUT.DESMETH;
clear INPUT

if strcmp(func,'GetInfo')
    TST.testspeed = 'standard';
    TST.SPIN.Vis = 'No';
    TST.CACC.Vis = 'No';
    TST.DESOL.Vis = 'No';
    return
end

if strcmp(func,'TestPlot')

    DESTYPE = DESMETH.DESTYPE;
    TURNSOL = DESTYPE.TURNSOL;
    CACC = DESMETH.CACC;
    PROJdgn = DESMETH.PROJdgn;
    KSA = squeeze(DESMETH.KSA);

    Rad = sqrt(KSA(:,1).^2 + KSA(:,2).^2 + KSA(:,3).^2);
    ind1 = find(Rad >= 1,1,'first');
    ind2 = find(Rad >= 1,1,'last')+1;
    
    fh = figure(500); 
    fh.Name = 'Test Waveform';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1000 800];
    
    subplot(2,2,1); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(:,1),PROJdgn.rad*KSA(:,2),PROJdgn.rad*KSA(:,3),'k','linewidth',1);
    plot3(PROJdgn.rad*KSA(1:ind1,1),PROJdgn.rad*KSA(1:ind1,2),PROJdgn.rad*KSA(1:ind1,3),'r','linewidth',2);
    plot3(PROJdgn.rad*KSA(ind2:end,1),PROJdgn.rad*KSA(ind2:end,2),PROJdgn.rad*KSA(ind2:end,3),'b','linewidth',2);
    xlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); ylim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); zlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[-300 -400 120]);  
    title('OutInDualEcho');

    subplot(2,2,2); hold on;     
    Tcacc = [CACC.TArr 2*CACC.TArr(end)-flip(CACC.TArr(1:end-1),2)];
    plot(Tcacc,Rad);
    xlabel('ms');
    ylabel('Relative Radius');
    title('Timing Estimate');

    subplot(2,2,3); hold on;     
    plot(TURNSOL.rArr,TURNSOL.drArr);
    ylabel('dr');
    xlabel('Relative Radius');
    title('Radial Evolution Slow Down');    
end

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel0(1,:) = {'Method',PROJdgn.method,'Output'};
Panel0(2,:) = {'Colour',DESMETH.CLR.method,'Output'};
Panel0(3,:) = {'FovDim (mm)',PROJdgn.fov,'Output'};
Panel0(4,:) = {'VoxDim (mm)',PROJdgn.vox,'Output'};
Panel0(5,:) = {'Elip',PROJdgn.elip,'Output'};
Panel0(6,:) = {'VoxNom (mm3)',((PROJdgn.vox)^3)*(1/PROJdgn.elip),'Output'};
Panel0(7,:) = {'VoxCeq (mm3)',((PROJdgn.vox*1.24)^3)*(1/PROJdgn.elip),'Output'};
Panel0(8,:) = {'Tro (ms)',PROJdgn.tro,'Output'};
Panel0(9,:) = {'Ntraj',PROJdgn.nproj,'Output'};
Panel0(10,:) = {'','','Output'};

Panel1(1,:) = {'','','Output'};
Panel1(2,:) = {'p',PROJdgn.p,'Output'};
Panel1(3,:) = {'BestCaseMaxSlew (mT/m)',PROJdgn.maxaveacc/42.577,'Output'};

Panel = [Panel0;DESMETH.SPIN.Panel;Panel1];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TST.PanelOutput = PanelOutput;
TST.Panel2Imp = [Panel0;DESMETH.SPIN.Panel];

