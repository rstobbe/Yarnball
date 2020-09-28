%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_Simple_v1a_Func(CACC,INPUT)

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
kArr0 = squeeze(INPUT.kArr);
kArr = kArr0 * PROJdgn.kmax;
TArr0 = INPUT.TArr;
RADEV = INPUT.RADEV;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if not(strcmp(RADEV.relprojlenmeas,'Yes'))
    err.flag = 1;
    err.msg = 'Use RadSolEv_DesignTest';
    return
end

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
Tend = TArr0(end);
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
    fh.Name = 'Trajectory Evolution';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1000 800];
    subplot(2,2,1); hold on;
    plot(Tvel0,magvel0,'k-'); 
    xlabel('tro (ms)'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
    xlim([0 Tend]);
    ylim([0 2000]);
    subplot(2,2,2); hold on;
    plot(Tacc0,magacc0,'k-');
    xlabel('tro (ms)'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
    xlim([0 Tend]);
    ylim([0 15000]); 
    subplot(2,2,3); hold on;
    plot(r,magvel0,'k-'); 
    xlabel('relative radius'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
    xlim([0 1]);
    ylim([0 2000]);
    subplot(2,2,4); hold on;
    plot(r,magacc0,'k-');
    xlabel('relative radius'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
    xlim([0 1]);
    ylim([0 15000]); 
end

%------------------------------------------
% Scale Acceleration
%------------------------------------------ 
slvno = length(magacc0);
ScaleAccProf = magacc0(slvno)*ones(1,slvno);

%---------------------------------------------
% Constrain
%---------------------------------------------
TArr = TArr0;
Tsegs = zeros(1,length(TArr));
for n = 2:length(TArr)
    Tsegs(n) = sqrt(magacc0(n)/ScaleAccProf(n-1))*(TArr(n)-TArr(n-1));
end

for n = 2:length(TArr)
    TArr(n) = TArr(n-1) + Tsegs(n);
end

%---------------------------------------------
% Relative Trajectory Increase
%---------------------------------------------
relprojleninc = TArr(length(TArr))/TArr0(length(TArr0));

%------------------------------------------
% Fix Time
%------------------------------------------
kmag0 = sqrt(kArr0(:,1).^2 + kArr0(:,2).^2 + kArr0(:,3).^2);
if kmag0(end) < 1
    err.flag = 1;
    err.msg = 'Trajectory not solved right to end';
    return
end
Tatkmax = interp1(kmag0,TArr,1,'spline'); 
TArr = PROJdgn.tro*TArr/Tatkmax;

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(kArr,TArr);
[acc,Tacc] = calcaccfunc(vel,Tvel);
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerk = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Plot
%------------------------------------------
if strcmp(CACC.Vis,'Yes')   
    subplot(2,2,1); hold on;
    plot(Tvel,magvel,'r-'); 
    subplot(2,2,2); hold on;
    plot(Tacc,magacc,'r-');    
    subplot(2,2,3); hold on;
    plot(r,magvel,'r-'); 
    subplot(2,2,4); hold on;
    plot(r,magacc,'r-');   
end

%---------------------------------------------
% Return
%--------------------------------------------- 
CACC.TArr = TArr;
CACC.r = r;
CACC.Tvel0 = Tvel0;
CACC.Tacc0 = Tacc0;
CACC.Tjerk0 = Tjerk0;
CACC.magvel0 = magvel0;
CACC.magacc0 = magacc0;
CACC.magjerk0 = magjerk0;
CACC.Tvel = Tvel;
CACC.Tacc = Tacc;
CACC.Tjerk = Tjerk;
CACC.magvel = magvel;
CACC.magacc = magacc;
CACC.magjerk = magjerk;
CACC.maxaveacc = mean(magacc(length(magacc)-100:length(magacc)));       % old way (file got modified without version change)
%ind = find(kmag0 >= 1,1,'first');
%CACC.maxaveacc = mean(magacc(ind-100:ind-10));                          % do this somewhere else - delete in new version
CACC.relprojleninc = relprojleninc;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
CACC.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);


