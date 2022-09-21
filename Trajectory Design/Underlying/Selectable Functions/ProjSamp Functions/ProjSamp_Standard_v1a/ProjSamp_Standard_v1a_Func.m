%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp_Standard_v1a_Func(PSMP,INPUT) 

Status2('busy','Calculate Projection Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SPIN = INPUT.SPIN;
testing = INPUT.testing;
clear INPUT;

%-----------------------------------------------
% No Oversampling
%-----------------------------------------------
azireconosampfact = 1;
polreconosampfact = 1;

ndiscs = SPIN.ndiscs*azireconosampfact;
nppd = SPIN.nspokes*polreconosampfact;
    
PSMP.ndiscs = ndiscs;
PSMP.nppd = nppd;
PSMP.nproj = ndiscs*nppd;
PSMP.projosamp = (PSMP.nproj/SPIN.nproj)*(SPIN.AziSampUsed*SPIN.PolSampUsed);                   % oversampling in the recon...                  
PSMP.azireconosampfact = azireconosampfact;
PSMP.polreconosampfact = polreconosampfact;

%-----------------------------------------------
% Define Sampling
%-----------------------------------------------
projsampscnr0 = (1:1:PSMP.nproj);
tempprojsampscnr = [];
for m = 1:PSMP.azireconosampfact:PSMP.ndiscs
    tempprojsampscnr = [tempprojsampscnr projsampscnr0((m-1)*PSMP.nppd+1:PSMP.polreconosampfact:m*PSMP.nppd)];
end
PSMP.projsampscnr = tempprojsampscnr;

%---------------------------------------------
% Create Vectors
%---------------------------------------------
if strcmp(testing,'Yes');
    PSMP.phi = pi/2;
    PSMP.theta = 0;
else    
    %-----------------------------------------------
    % Calculate Projection Distributions
    %-----------------------------------------------
    theta_step = pi/ndiscs;                                                              
    theta = (pi-theta_step/2:-theta_step:0);
    ndiscs = length(theta);
    n = 1;
    IV = 0;
    for i = 1:ndiscs
        phi_step = 2*pi/nppd;                                                              
        if rem(i,2)
            phi = (2*pi-phi_step/2:-phi_step:phi_step/2);
        else
            phi = (2*pi:-phi_step:phi_step);
        end
        IV(1,n:n+length(phi)-1) = phi;
        IV(2,n:n+length(phi)-1) = theta(i);
        n = n+length(phi);
    end
    PSMP.IV = IV;
    PSMP.phi = IV(1,:);
    PSMP.theta = IV(2,:);

    %---------------------------------------------
    % Visuals
    %--------------------------------------------- 
    visuals = 'off';
    if not(strcmp(visuals,'off'))
        figure(50); hold on; hold on; axis equal; grid on; axis([-1 1 -1 1 -1 1]);
        set(gca,'cameraposition',[-1000 -2000 300]); 
        phi0 = IV(1,:);
        theta0 = IV(2,:);
        for n = 1:PROJDIST.nproj
            x = cos(theta0(n)).*sin(phi0(n));                              % design location of each point in k-space
            y = sin(theta0(n)).*sin(phi0(n));
            z = cos(phi0(n));
            plot3([0 x],[0 y],[0 z]);
            pause(0.001);
        end
    end
end
    
%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Recon Ndiscs',PSMP.ndiscs,'Output'};
Panel(2,:) = {'Recon Nspokes',PSMP.nppd,'Output'};
Panel(3,:) = {'Recon Nproj',PSMP.nproj,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PSMP.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);








