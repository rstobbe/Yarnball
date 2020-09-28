%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_TestOnly_v1a_Func(CACC,INPUT)

Status2('busy','Constrain Trajectory Evolution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
CACC.doconstraint = 'Yes';
if INPUT.check == 1
    return
end

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
kArr = INPUT.kArr * PROJdgn.kmax;
TArr0 = INPUT.TArr;
clear INPUT

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
CACC.calcvelfunc = 'CalcVel_v2a';
CACC.calcaccfunc = 'CalcAcc_v2a';
CACC.calcjerkfunc = 'CalcJerk_v2a';
if not(exist(CACC.calcaccfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
calcvelfunc = str2func(CACC.calcvelfunc);
calcaccfunc = str2func(CACC.calcaccfunc);
calcjerkfunc = str2func(CACC.calcjerkfunc);

%---------------------------------------------
% Common Variables
%---------------------------------------------
tro = PROJdgn.tro;
r = (sqrt(kArr(:,1).^2 + kArr(:,2).^2 + kArr(:,3).^2))/PROJdgn.kmax; 

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel0] = calcvelfunc(kArr,TArr0);
[acc,Tacc0] = calcaccfunc(vel,Tvel0);
[jerk,Tjerk0] = calcjerkfunc(acc,Tacc0);
magvel0 = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc0 = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerk0 = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Initial Visualization
%------------------------------------------  
if strcmp(CACC.Vis,'Yes')
    fh = figure(15); 
    fh.Name = 'Test Trajectory Evolution';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1000 800];
    subplot(2,2,1); hold on;
    plot(Tvel0,magvel0/PROJimp.gamma,'k-'); 
    xlabel('tro (ms)'); ylabel('Gradient Magnitude (mT/m)'); title('Gradient Magnitude');
    xlim([0 tro]);
    ylim([0 50]);
    subplot(2,2,2); hold on;
    plot(Tacc0,magacc0/PROJimp.gamma,'k-');
    xlabel('tro (ms)'); ylabel('Gradient Speed (mT/m/ms)'); title('Gradient Speed');
    xlim([0 tro]);
    ylim([0 1000]); 
    subplot(2,2,3); hold on;
    plot(Tjerk0,magjerk0/PROJimp.gamma,'k-');
    xlabel('tro (ms)'); ylabel('Gradient Acceleration (mT/m/ms2)'); title('Gradient Acceleration');
    xlim([0 tro]);     
    ylim([0 1e4]);
    subplot(2,2,4); hold on;
    plot(TArr0,r,'k-');
    xlabel('tro (ms)'); ylabel('Radial Evolution'); title('Radial Evolution');
    xlim([0 tro]);     
    %ylim([0 1e4]);  
end

%---------------------------------------------
% Return
%--------------------------------------------- 
CACC.TArr = TArr0;
CACC.r = r;
CACC.Tvel0 = Tvel0;
CACC.Tacc0 = Tacc0;
CACC.Tjerk0 = Tjerk0;
CACC.magvel0 = magvel0;
CACC.magacc0 = magacc0;
CACC.magjerk0 = magjerk0;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
CACC.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);


