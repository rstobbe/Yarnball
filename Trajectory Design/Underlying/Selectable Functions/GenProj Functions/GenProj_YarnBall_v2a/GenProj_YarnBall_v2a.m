%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef GenProj_YarnBall_v2a < handle

properties (SetAccess = private)                   
    Method = 'GenProj_YarnBall_v2a'
    GENPRJipt
    CLR
    ELIP
    DESOL
    TDIFS
    InitRad
    InitPhi
    InitTheta
    EndRad
    EndPhi
    EndTheta
    rkSpace
    rRad
    kSpace
    T
    kMax
    Tro
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function GENPRJ = GenProj_YarnBall_v2a(GENPRJipt)    
    GENPRJ.GENPRJipt = GENPRJipt;
end 

%==================================================================
% Setup
%==================================================================  
function SetColour(GENPRJ,CLRfunc,CLRipt)
    GENPRJ.CLR = CLRfunc(CLRipt);
end
function SetElip(GENPRJ,ELIPfunc,ELIPipt)
    GENPRJ.ELIP = ELIPfunc(ELIPipt);
end
function SetDeSol(GENPRJ,DESOLfunc,DESOLipt)
    GENPRJ.DESOL = DESOLfunc(DESOLipt);
end
function SetTrajEvoDiffs(GENPRJ,TDIFSfunc,TDIFSipt)
    GENPRJ.TDIFS = TDIFSfunc(TDIFSipt);
end
function SetkMax(GENPRJ,kMax)
    GENPRJ.kMax = kMax;
end
function SetTro(GENPRJ,Tro)
    GENPRJ.Tro = Tro;
end

%==================================================================
% Initialize
%==================================================================  
function Initialize(GENPRJ,rad0,phi0,theta0)   
    GENPRJ.InitRad = rad0;
    GENPRJ.InitPhi = phi0;
    GENPRJ.InitTheta = theta0;
end

%==================================================================
% Setup
%==================================================================  
function SolveTrajInternal(GENPRJ)
    GENPRJ.rkSpace = GENPRJ.SolveTraj;
    GENPRJ.rRad = (GENPRJ.rkSpace(1,:,1).^2 + GENPRJ.rkSpace(1,:,2).^2 + GENPRJ.rkSpace(1,:,3).^2).^0.5; 
    GENPRJ.kSpace = GENPRJ.kMax * GENPRJ.rkSpace;
    GENPRJ.T = GENPRJ.Tro * GENPRJ.DESOL.tautot/GENPRJ.DESOL.projlen0;
end

%==================================================================
% Setup
%==================================================================  
function KSA = SolveTraj(GENPRJ)
    options = odeset('RelTol',2.5e-14,'AbsTol',[1e-20,1e-20,1e-20]);
    divs = 500;
    defuncIn = @(t,y) GENPRJ.CLR.FullSolutionIn(t,y);
    defuncOut = @(t,y) GENPRJ.CLR.FullSolutionOut(t,y);    
    rad0 = GENPRJ.InitRad;
    phi0 = GENPRJ.InitPhi;
    theta0 = GENPRJ.InitTheta;
    tau1 = GENPRJ.DESOL.tau1;
    tau2 = GENPRJ.DESOL.tau2;
    len = GENPRJ.DESOL.len;
    dir = GENPRJ.CLR.dir;
    KSA = zeros(length(phi0),len,3);
    kArrX = zeros(length(phi0),len);
    kArrY = zeros(length(phi0),len);
    kArrZ = zeros(length(phi0),len);  
    RadEnd = zeros(length(phi0),1);
    PhiEnd = zeros(length(phi0),1); 
    ThetaEnd = zeros(length(phi0),1);
    for m = 1:ceil(length(phi0)/divs)
        if m*divs < length(phi0)
            narray = (m-1)*divs+1:m*divs;
        else
            narray = (m-1)*divs+1:length(phi0);
        end
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
        try
            for n = narray 
                [x,Y] = ode113(defuncOut,tau2,[rad0,phi0(n),theta0(n)],options); 
                radout = Y(:,1).';  
                phiout = Y(:,2).'; 
                thetaout = Y(:,3).';
                if dir == 1
                    [x,Y] = ode113(defuncIn,tau1,[rad0,phi0(n),theta0(n)],options);
                    radin = Y(:,1).';  
                    phiin = Y(:,2).'; 
                    thetain = Y(:,3).';
                    rad = [0 flip(radin) radout(2:end)];
                    phi = [0 flip(phiin) phiout(2:end)]; 
                    theta = [0 flip(thetain) thetaout(2:end)];
                elseif dir == -1
                    [x,Y] = ode113(defuncIn,tau1,[radout(end),phiout(end),thetaout(end)],options);
                    radin = Y(:,1).';  
                    phiin = Y(:,2).'; 
                    thetain = Y(:,3).';
                    rad = [radout radin(2:end) 0];
                    phi = [phiout phiin(2:end) 0]; 
                    theta = [thetaout thetain(2:end) 0];
                end               
                RadEnd(n) = rad(end);
                PhiEnd(n) = phi(end);                
                ThetaEnd(n) = theta(end);                
                kArrX(n,:) = rad.*sin(phi).*cos(theta);                              
                kArrY(n,:) = rad.*sin(phi).*sin(theta);
                kArrZ(n,:) = rad.*cos(phi); 
            end
        catch
            error('Check ''DeSolTimfunc''');
        end
    end   
    if strcmp(GENPRJ.ELIP.YbAxisElip,'z')
        KSA(:,:,1) = kArrX;
        KSA(:,:,2) = kArrY;
        KSA(:,:,3) = kArrZ*GENPRJ.ELIP.Elip;
    elseif strcmp(GENPRJ.ELIP.YbAxisElip,'y')
        KSA(:,:,1) = kArrX;
        KSA(:,:,2) = kArrY*GENPRJ.ELIP.Elip;
        KSA(:,:,3) = kArrZ;
    elseif strcmp(GENPRJ.ELIP.YbAxisElip,'x')
        KSA(:,:,1) = kArrX*GENPRJ.ELIP.Elip;
        KSA(:,:,2) = kArrY;
        KSA(:,:,3) = kArrZ;
    end
    GENPRJ.EndRad = RadEnd;
    GENPRJ.EndPhi = PhiEnd;
    GENPRJ.EndTheta = ThetaEnd;    
    Status2('done','',2);
    Status2('done','',3);
end








end
end

