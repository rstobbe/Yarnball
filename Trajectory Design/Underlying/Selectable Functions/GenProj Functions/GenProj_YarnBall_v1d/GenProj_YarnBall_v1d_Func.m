%==================================================
% 
%==================================================

function [GENPRJ,err] = GenProj_YarnBall_v1d_Func(GENPRJ,INPUT)

Status2('busy','Generate YarnBall Trajectories',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DESTYPE = INPUT.DESTYPE;
rad0 = INPUT.rad0;
phi0 = INPUT.phi0;
theta0 = INPUT.theta0;
clear INPUT;

%------------------------------------------
% Initialize
%------------------------------------------
options = odeset('RelTol',2.5e-14,'AbsTol',[1e-20,1e-20,1e-20]);
divs = 500;

%=====================================================================
% Solve Out from Centre
%=====================================================================
if DESTYPE.DESTRCT.dir == 1 
    defuncIn = DESTYPE.SLV.ybcolourin;
    defuncOut = DESTYPE.SLV.ybcolourout;
    tau1 = DESTYPE.SLV.tau1;
    tau2 = DESTYPE.SLV.tau2;
    len = DESTYPE.SLV.len;
    KSA = zeros(length(phi0),len,3);
    kArrX = zeros(length(phi0),len);
    kArrY = zeros(length(phi0),len);
    kArrZ = zeros(length(phi0),len);  
    EndVals = zeros(length(phi0),3);
    for m = 1:ceil(length(phi0)/divs)
        if m*divs < length(phi0)
            narray = (m-1)*divs+1:m*divs;
        else
            narray = (m-1)*divs+1:length(phi0);
        end
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
        try
            parfor n = narray 
                [x,Y] = ode113(defuncIn,tau1,[rad0,phi0(n),theta0(n)],options); 
                rad1 = Y(:,1).';  
                phi1 = Y(:,2).'; 
                theta1 = Y(:,3).';
                [x,Y] = ode113(defuncOut,tau2,[rad0,phi0(n),theta0(n)],options);
                EndVals(n,:) = Y(end,:);
                rad = [0 flip(rad1,2) Y(2:end,1).'];
                phi = [0 flip(phi1,2) Y(2:end,2).']; 
                theta = [0 flip(theta1,2) Y(2:end,3).'];
                kArrX(n,:) = rad.*sin(phi).*cos(theta);                              
                kArrY(n,:) = rad.*sin(phi).*sin(theta);
                kArrZ(n,:) = rad.*cos(phi); 
            end
        catch
            err.flag = 1;
            err.msg = 'Check ''DeSolTimfunc''';
            return
        end
    end
    
%=====================================================================
% Solve Return to Centre
%=====================================================================
elseif DESTYPE.DESTRCT.dir == -1
    defuncIn = DESTYPE.SLV.ybcolourin;
    defuncOut = DESTYPE.SLV.ybcolourout;
    tau1 = DESTYPE.SLV.tau1;
    tau2 = DESTYPE.SLV.tau2;
    len = DESTYPE.SLV.len;
    KSA = zeros(length(phi0),len,3);
    kArrX = zeros(length(phi0),len);
    kArrY = zeros(length(phi0),len);
    kArrZ = zeros(length(phi0),len);    
    EndVals = zeros(length(phi0),3);
    for m = 1:ceil(length(phi0)/divs)
        if m*divs < length(phi0)
            narray = (m-1)*divs+1:m*divs;
        else
            narray = (m-1)*divs+1:length(phi0);
        end
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
        for n = narray 
            [x,Y] = ode113(defuncOut,tau2,[rad0(n),phi0(n),theta0(n)],options);
            rad1 = Y(:,1).';  
            phi1 = Y(:,2).'; 
            theta1 = Y(:,3).';
            [x,Y] = ode113(defuncIn,tau1,[rad1(end),phi1(end),theta1(end)],options); 
            rad = [rad1 Y(2:end,1).' 0];
            phi = [phi1 Y(2:end,2).' 0]; 
            theta = [theta1 Y(2:end,3).' 0];
            kArrX(n,:) = rad.*sin(phi).*cos(theta);                              
            kArrY(n,:) = rad.*sin(phi).*sin(theta);
            kArrZ(n,:) = rad.*cos(phi); 
        end
    end
end

%------------------------------------------
% Consolidate
%------------------------------------------    
if strcmp(DESTYPE.DESTRCT.YbAxisElip,'z')
    KSA(:,:,1) = kArrX;
    KSA(:,:,2) = kArrY;
    KSA(:,:,3) = kArrZ*DESTYPE.DESTRCT.elip;
elseif strcmp(DESTYPE.DESTRCT.YbAxisElip,'y')
    KSA(:,:,1) = kArrX;
    KSA(:,:,2) = kArrY*DESTYPE.DESTRCT.elip;
    KSA(:,:,3) = kArrZ;
elseif strcmp(DESTYPE.DESTRCT.YbAxisElip,'x')
    KSA(:,:,1) = kArrX*DESTYPE.DESTRCT.elip;
    KSA(:,:,2) = kArrY;
    KSA(:,:,3) = kArrZ;
end
    
%------------------------------------------
% Return
%------------------------------------------    
GENPRJ.KSA = KSA;
GENPRJ.EndVals = EndVals;

Status2('done','',2);
Status2('done','',3);



