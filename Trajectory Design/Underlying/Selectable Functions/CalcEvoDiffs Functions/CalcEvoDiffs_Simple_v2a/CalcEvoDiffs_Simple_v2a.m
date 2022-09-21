%==================================================================
% (v2b)
%   - Convert to Object
%==================================================================

classdef CalcEvoDiffs_Simple_v2a < handle

properties (SetAccess = private)                   
    Method = 'CalcEvoDiffs_Simple_v2a'
    TDIFSipt
    T
    Tend
    kSpace
    Tvel
    Tacc
    Tjerk
    vel
    magvel
    acc
    magacc
    jerk
    magjerk    
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TDIFS = CalcEvoDiffs_Simple_v2a(TDIFSipt)    
    TDIFS.TDIFSipt = TDIFSipt;
end 

%==================================================================
% CalcEvoDiffs
%==================================================================  
function CalcEvoDiffs(TDIFS,GENPRJ)
    TDIFS.T = GENPRJ.T;
    TDIFS.Tend = TDIFS.T(end);
    TDIFS.kSpace = GENPRJ.kSpace;
    TDIFS.CalcVel;
    TDIFS.CalcAcc;
    TDIFS.CalcJerk;
end

%==================================================================
% CalcVel
%==================================================================  
function CalcVel(TDIFS)
    TDIFS.vel = (TDIFS.kSpace(:,2:end,:)-TDIFS.kSpace(:,1:end-1,:))./(TDIFS.T(2:end)-TDIFS.T(1:end-1));
    TDIFS.Tvel = (TDIFS.T(2:end)+TDIFS.T(1:end-1))/2;
    TDIFS.magvel = sqrt(TDIFS.vel(:,:,1).^2 + TDIFS.vel(:,:,2).^2 + TDIFS.vel(:,:,3).^2);
end

%==================================================================
% CalcAcc
%==================================================================  
function CalcAcc(TDIFS)
    TDIFS.acc = (TDIFS.vel(:,2:end,:)-TDIFS.vel(:,1:end-1,:))./(TDIFS.Tvel(2:end)-TDIFS.Tvel(1:end-1));
    TDIFS.Tacc = (TDIFS.Tvel(2:end)+TDIFS.Tvel(1:end-1))/2;
    TDIFS.magacc = sqrt(TDIFS.acc(:,:,1).^2 + TDIFS.acc(:,:,2).^2 + TDIFS.acc(:,:,3).^2);
end

%==================================================================
% CalcJerk
%==================================================================  
function CalcJerk(TDIFS)
    TDIFS.jerk = (TDIFS.acc(:,2:end,:)-TDIFS.acc(:,1:end-1,:))./(TDIFS.Tacc(2:end)-TDIFS.Tacc(1:end-1));
    TDIFS.Tjerk = (TDIFS.Tacc(2:end)+TDIFS.Tacc(1:end-1))/2;
    TDIFS.magjerk = sqrt(TDIFS.jerk(:,:,1).^2 + TDIFS.jerk(:,:,2).^2 + TDIFS.jerk(:,:,3).^2);
end

%==================================================================
% PlotEvoDiffs
%==================================================================  
function PlotEvoDiffs(TDIFS)
    fh = figure(15); 
    fh.Name = 'Trajectory Evolution';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1000 800];
    subplot(2,2,1); hold on;
    plot(TDIFS.Tvel,squeeze(TDIFS.vel)); 
    xlabel('tro (ms)'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
    xlim([0 TDIFS.Tvel(end)]);
    ylim([-2000 2000]);
    subplot(2,2,2); hold on;
    plot(TDIFS.Tacc,squeeze(TDIFS.acc));
    xlabel('tro (ms)'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
    xlim([0 TDIFS.Tacc(end)]);
    ylim([-15000 15000]); 
end


end
end
