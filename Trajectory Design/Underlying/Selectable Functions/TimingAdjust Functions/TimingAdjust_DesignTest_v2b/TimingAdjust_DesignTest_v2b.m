%==================================================================
% (v2b)
%   - Convert to Object
%==================================================================

classdef TimingAdjust_DesignTest_v2b < handle

properties (SetAccess = private)                   
    Method = 'TimingAdjust_DesignTest_v2b'
    TIMADJipt;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TIMADJ = TimingAdjust_DesignTest_v2b(TIMADJipt)    
    TIMADJ.TIMADJipt = TIMADJipt;
end 

%==================================================================
% CalcEvoDiffs
%==================================================================  
function CalcEvoDiffs(TIMADJ,GENPRJ)
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

%     %------------------------------------------
%     % Initial Visualization
%     %------------------------------------------  
%     if strcmp(CACC.Vis,'Yes')
%         fh = figure(15); 
%         fh.Name = 'Trajectory Evolution';
%         fh.NumberTitle = 'off';
%         fh.Position = [400 150 1000 800];
%         subplot(2,2,1); hold on;
%         plot(Tvel0,magvel0,'k-'); 
%         xlabel('tro (ms)'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
%         xlim([0 Tend]);
%         ylim([0 2000]);
%         subplot(2,2,2); hold on;
%         plot(Tacc0,magacc0,'k-');
%         xlabel('tro (ms)'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
%         xlim([0 Tend]);
%         ylim([0 15000]); 
%         subplot(2,2,3); hold on;
%         plot(r,magvel0,'k-'); 
%         xlabel('relative radius'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
%         xlim([0 1]);
%         ylim([0 2000]);
%         subplot(2,2,4); hold on;
%         plot(r,magacc0,'k-');
%         xlabel('relative radius'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
%         xlim([0 1]);
%         ylim([0 15000]); 
%     end
end




end
end
