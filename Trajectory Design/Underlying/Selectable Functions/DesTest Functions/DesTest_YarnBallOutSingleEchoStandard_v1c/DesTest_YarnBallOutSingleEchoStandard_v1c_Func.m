%====================================================
%
%====================================================

function [TST,err] = DesTest_YarnBallOutSingleEchoStandard_v1c_Func(TST,INPUT)

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
    TST.testspeed = 'rapid';
    TST.SPIN.Vis = 'No';
    TST.CACC.Vis = 'No';
    TST.DESOL.Vis = 'No';
    return
end

if strcmp(func,'TestPlot')

    PROJdgn = DESMETH.PROJdgn;
    KSA = squeeze(DESMETH.KSA);
    T0 = DESMETH.T0;

    Rad = sqrt(KSA(:,1).^2 + KSA(:,2).^2 + KSA(:,3).^2);
    ind2 = find(Rad >= PROJdgn.p,1);
    
    fh = figure(500); 
    fh.Name = 'Test Waveform';
    fh.NumberTitle = 'off';
    fh.Position = [400 550 1000 400];
    
    subplot(1,2,1); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(:,1),PROJdgn.rad*KSA(:,2),PROJdgn.rad*KSA(:,3),'k','linewidth',1);
    %plot3(PROJdgn.rad*KSA(ind2,1),PROJdgn.rad*KSA(ind2,2),PROJdgn.rad*KSA(ind2,3),'rx','linewidth',1);
    xlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); ylim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); zlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[-300 -400 120]);  
        
    subplot(1,2,2); hold on; 
    plot(T0,KSA(:,1),'b','linewidth',1);
    plot(T0,KSA(:,2),'g','linewidth',1);
    plot(T0,KSA(:,3),'r','linewidth',1);
    xlim([0 T0(end)]);
    ylim([-1 1]);
    xlabel('ms'); ylabel('Relative k-Space'); title('Trajectory Evolution (Pre AccConst)');

end

TST.Figure(1).Name = 'Test Waveform';
TST.Figure(1).Type = 'Graph';
TST.Figure(1).hFig = fh;
TST.Figure(1).hAx = gca;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel0(1,:) = {'Method',PROJdgn.method,'Output'};
Panel0(2,:) = {'Colour',DESMETH.CLR.method,'Output'};
Panel0(3,:) = {'FovWid (mm)',PROJdgn.fov,'Output'};
Panel0(4,:) = {'VoxWidNom (mm)',PROJdgn.vox,'Output'};
Panel0(5,:) = {'VoxWidCeq (mm)',PROJdgn.vox*1.24,'Output'};
Panel0(6,:) = {'Elip',PROJdgn.elip,'Output'};
Panel0(7,:) = {'VoxVolNom (mm3)',((PROJdgn.vox)^3)*(1/PROJdgn.elip),'Output'};
Panel0(8,:) = {'VoxVolCeq (mm3)',((PROJdgn.vox*1.24)^3)*(1/PROJdgn.elip),'Output'};
Panel0(9,:) = {'Tro (ms)',PROJdgn.tro,'Output'};
Panel0(10,:) = {'Ntraj',PROJdgn.nproj,'Output'};
Panel0(11,:) = {'','','Output'};

Panel1(1,:) = {'','','Output'};
Panel1(2,:) = {'p',PROJdgn.p,'Output'};
Panel1(3,:) = {'projlen0',DESMETH.DESOL.projlen0,'Output'};
Panel1(4,:) = {'BestCaseMaxSlew (mT/m)',PROJdgn.maxaveacc/42.577,'Output'};

Panel = [Panel0;DESMETH.SPIN.Panel;Panel1];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TST.PanelOutput = PanelOutput;
TST.Panel2Imp = [Panel0;DESMETH.SPIN.Panel];

