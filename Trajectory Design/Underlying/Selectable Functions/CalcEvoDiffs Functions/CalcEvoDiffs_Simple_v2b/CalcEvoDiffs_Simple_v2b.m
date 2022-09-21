%==================================================================
% (v2b)
%   - Clean up
%==================================================================

classdef CalcEvoDiffs_Simple_v2b < handle

properties (SetAccess = private)                   
    Method = 'CalcEvoDiffs_Simple_v2b'
    CALCEVOipt
    T
    kSpace
    YB
    dYB
    mYB
    d2YB
    mdYB
    m2YB
    kMax
    Tvel
    Tacc
    Tjerk
    vel
    sphvel
    magvel
    magsphvel
    acc
    sphacc
    magacc
    magsphacc
    jerk
    magjerk    
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function CALCEVO = CalcEvoDiffs_Simple_v2b(CALCEVOipt)    
    CALCEVO.CALCEVOipt = CALCEVOipt;
end 

%==================================================================
% CalcEvoDiffs
%==================================================================  
function CalcEvoDiffs(CALCEVO,T,kSpace,YB,kMax)
    CALCEVO.T = T;
    CALCEVO.kSpace = kSpace;
    CALCEVO.YB = YB;
    CALCEVO.kMax = kMax;
    CALCEVO.CalcVel;
    CALCEVO.CalcAcc;
    CALCEVO.CalcJerk;
    CALCEVO.CalcSphVel;
    CALCEVO.CalcSphAcc;
end

%==================================================================
% CalcVel
%==================================================================  
function CalcVel(CALCEVO)
    CALCEVO.vel = (CALCEVO.kSpace(:,2:end,:)-CALCEVO.kSpace(:,1:end-1,:))./(CALCEVO.T(2:end)-CALCEVO.T(1:end-1));
    CALCEVO.Tvel = (CALCEVO.T(2:end)+CALCEVO.T(1:end-1))/2;
    CALCEVO.magvel = sqrt(CALCEVO.vel(:,:,1).^2 + CALCEVO.vel(:,:,2).^2 + CALCEVO.vel(:,:,3).^2);
end

%==================================================================
% CalcAcc
%==================================================================  
function CalcAcc(CALCEVO)
    CALCEVO.acc = (CALCEVO.vel(:,2:end,:)-CALCEVO.vel(:,1:end-1,:))./(CALCEVO.Tvel(2:end)-CALCEVO.Tvel(1:end-1));
    CALCEVO.Tacc = (CALCEVO.Tvel(2:end)+CALCEVO.Tvel(1:end-1))/2;
    CALCEVO.magacc = sqrt(CALCEVO.acc(:,:,1).^2 + CALCEVO.acc(:,:,2).^2 + CALCEVO.acc(:,:,3).^2);
end

%==================================================================
% CalcJerk
%==================================================================  
function CalcJerk(CALCEVO)
    CALCEVO.jerk = (CALCEVO.acc(:,2:end,:)-CALCEVO.acc(:,1:end-1,:))./(CALCEVO.Tacc(2:end)-CALCEVO.Tacc(1:end-1));
    CALCEVO.Tjerk = (CALCEVO.Tacc(2:end)+CALCEVO.Tacc(1:end-1))/2;
    CALCEVO.magjerk = sqrt(CALCEVO.jerk(:,:,1).^2 + CALCEVO.jerk(:,:,2).^2 + CALCEVO.jerk(:,:,3).^2);
end

%==================================================================
% CalcSphVel
%==================================================================  
function CalcSphVel(CALCEVO)
    CALCEVO.dYB = (CALCEVO.YB(:,2:end,:)-CALCEVO.YB(:,1:end-1,:))./(CALCEVO.T(2:end)-CALCEVO.T(1:end-1));
    CALCEVO.mYB = (CALCEVO.YB(:,2:end,:)+CALCEVO.YB(:,1:end-1,:))/2;
    CALCEVO.sphvel(:,:,1) = CALCEVO.dYB(:,:,1);                                                 % r
    CALCEVO.sphvel(:,:,2) = CALCEVO.mYB(:,:,1).*CALCEVO.dYB(:,:,2);                             % phi
    CALCEVO.sphvel(:,:,3) = CALCEVO.mYB(:,:,1).*sin(CALCEVO.mYB(:,:,2)).*CALCEVO.dYB(:,:,3);    % theta
    CALCEVO.magsphvel = sqrt(CALCEVO.sphvel(:,:,1).^2 + CALCEVO.sphvel(:,:,2).^2 + CALCEVO.sphvel(:,:,3).^2);
    CALCEVO.sphvel = CALCEVO.sphvel * CALCEVO.kMax;
    CALCEVO.magsphvel = CALCEVO.magsphvel * CALCEVO.kMax;
end

%==================================================================
% CalcSphAcc
%==================================================================  
function CalcSphAcc(CALCEVO)
    CALCEVO.d2YB = (CALCEVO.dYB(:,2:end,:)-CALCEVO.dYB(:,1:end-1,:))./(CALCEVO.Tvel(2:end)-CALCEVO.Tvel(1:end-1));
    CALCEVO.mdYB = (CALCEVO.dYB(:,2:end,:)+CALCEVO.dYB(:,1:end-1,:))/2;
    CALCEVO.m2YB = (CALCEVO.mYB(:,2:end,:)+CALCEVO.mYB(:,1:end-1,:))/2;
    d2r = CALCEVO.d2YB(:,:,1);
    d2phi = CALCEVO.d2YB(:,:,2);
    d2theta = CALCEVO.d2YB(:,:,3);
    dr = CALCEVO.mdYB(:,:,1);
    dphi = CALCEVO.mdYB(:,:,2);
    dtheta = CALCEVO.mdYB(:,:,3);
    r = CALCEVO.m2YB(:,:,1);
    phi = CALCEVO.m2YB(:,:,2);
    theta = CALCEVO.m2YB(:,:,3);
    CALCEVO.sphacc(:,:,1) = d2r - r.*(dphi.^2) - r.*((sin(phi)).^2).*(dtheta.^2);                                   % r
    CALCEVO.sphacc(:,:,2) = 2*dr.*dphi + r.*d2phi - r.*sin(phi).*cos(phi).*(dtheta.^2);                             % phi
    CALCEVO.sphacc(:,:,3) = 2*sin(phi).*dtheta.*dr + 2*r.*cos(phi).*dtheta.*dphi + r.*sin(phi).*d2theta;            % theta   
    CALCEVO.sphacc(:,:,4) = d2r;
    CALCEVO.magsphacc = sqrt(CALCEVO.sphacc(:,:,1).^2 + CALCEVO.sphacc(:,:,2).^2 + CALCEVO.sphacc(:,:,3).^2);
    CALCEVO.sphacc = CALCEVO.sphacc * CALCEVO.kMax;
    CALCEVO.magsphacc = CALCEVO.magsphacc * CALCEVO.kMax;
end

%==================================================================
% PlotEvoDiffs
%==================================================================  
function PlotEvoDiffs(CALCEVO)
    fh = figure(15); 
    fh.Name = 'Trajectory Evolution';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1000 800];
    subplot(2,2,1); hold on;
    plot(CALCEVO.Tvel,squeeze(CALCEVO.vel)); 
    xlabel('tro (ms)'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
    xlim([0 CALCEVO.Tvel(end)]);
    ylim([-2000 2000]);
    subplot(2,2,2); hold on;
    plot(CALCEVO.Tacc,squeeze(CALCEVO.acc));
    xlabel('tro (ms)'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
    xlim([0 CALCEVO.Tacc(end)]);
    ylim([-15000 15000]); 
end


end
end
