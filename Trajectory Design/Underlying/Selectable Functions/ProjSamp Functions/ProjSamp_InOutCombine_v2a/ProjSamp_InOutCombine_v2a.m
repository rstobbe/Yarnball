%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef ProjSamp_InOutCombine_v2a < handle

properties (SetAccess = private)                   
    Method = 'ProjSamp_InOutCombine_v2a'
    PSMPipt
    ReconNumDiscs
    ReconNumSpokes
    ReconNumProj
    ReconSampFact
    ReconAziIntFactExtra = 1
    ReconPolIntFactExtra = 1
    ReconTotIntFactExtra = 1
    ReconAziSampFact
    ReconPolSampFact
    ScnrNumProj
    ScnrImpProjArr
    ScnrNotImpProjArr = []
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function PSMP = ProjSamp_InOutCombine_v2a(PSMPipt)    
    PSMP.PSMPipt = PSMPipt;
end 


%==================================================================
% CalcProjDist
%==================================================================  
function InitYB = CalcProjDist(PSMP,SPIN)

    %-----------------------------------------------
    % Don't create exra trajectories for recon
    %-----------------------------------------------
    PSMP.ReconAziSampFact = SPIN.AziSampFact;
    PSMP.ReconPolSampFact = SPIN.PolSampFact;
    PSMP.ReconNumDiscs = SPIN.NumDiscs;
    PSMP.ReconNumSpokes = SPIN.NumSpokes;
    PSMP.ReconNumProj = SPIN.NumProj/2;
    PSMP.ReconSampFact = SPIN.GblSampFact;                         
    PSMP.ScnrNumProj = PSMP.ReconNumProj;
    PSMP.ScnrImpProjArr = (1:PSMP.ReconNumProj);
    
    %-----------------------------------------------
    % Calculate Projection Distributions
    %-----------------------------------------------
    theta_step = pi/PSMP.ReconNumDiscs;                                                              
    theta = (pi-theta_step/2:-theta_step:0);
    n = 1;
    InitYB = 0;
    for i = 1:PSMP.ReconNumDiscs
        phi_step = 2*pi/PSMP.ReconNumSpokes;                                                              
        if rem(i,2)
            phi = (pi-phi_step/2:-phi_step:phi_step/2);
        else
            phi = (pi:-phi_step:phi_step);
        end
        InitYB(n:n+length(phi)-1,1) = phi;
        InitYB(n:n+length(phi)-1,2) = theta(i);
        n = n+length(phi);
    end

    %---------------------------------------------
    % Visuals
    %--------------------------------------------- 
    visuals = 'off';
    if not(strcmp(visuals,'off'))
        figure(50); hold on; hold on; axis equal; grid on; axis([-1 1 -1 1 -1 1]);
        set(gca,'cameraposition',[-1000 -2000 300]); 
        phi0 = InitYB(:,1);
        theta0 = InitYB(:,2);
        for n = 1:PSMP.ReconNumProj
            x = cos(theta0(n)).*sin(phi0(n));                              % design location of each point in k-space
            y = sin(theta0(n)).*sin(phi0(n));
            z = cos(phi0(n));
            plot3([0 x],[0 y],[0 z]);
            pause(0.001);
        end
    end
end

%==================================================================
% CalcProjDistTesting
%==================================================================  
function InitYB = CalcProjDistTesting(PSMP)    
    InitYB(:,1) = [pi*(0:6)/7 pi*(0:6)/7 pi*(0:6)/7 pi*(0:6)/7 pi*(0:6)/7 pi*(0:6)/7 pi*(0:6)/7];
    InitYB(:,2) = [zeros(1,7) (pi/7)*ones(1,7) (2*pi/7)*ones(1,7) (3*pi/7)*ones(1,7) (4*pi/7)*ones(1,7) (5*pi/7)*ones(1,7) (6*pi/7)*ones(1,7)];   
end


end
end






