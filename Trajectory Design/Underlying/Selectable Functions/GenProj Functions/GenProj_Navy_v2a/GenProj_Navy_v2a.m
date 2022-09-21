%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef GenProj_Navy_v2a < handle

properties (SetAccess = private)                   
    Method = 'GenProj_Navy_v2a'
    GENPRJipt
    CLR
    ELIP
    DESOL
    TDIFS
    SPIN
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
    drArr
    dthetaArr
    dphiArr
    rArr
    thetaArr
    phiArr
    tArr
    idx
    drSol
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function GENPRJ = GenProj_Navy_v2a(GENPRJipt)    
    GENPRJ.GENPRJipt = GENPRJipt;
end 

%==================================================================
% Setup
%==================================================================  
function SetColour(GENPRJ,CLRfunc,CLRipt)
    GENPRJ.CLR = CLRfunc(CLRipt);
end
function SetSpin(GENPRJ,SPINfunc,SPINipt)
    GENPRJ.SPIN = SPINfunc(SPINipt);
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
    GENPRJ.T = GENPRJ.Tro * GENPRJ.DESOL.tau/GENPRJ.DESOL.projlen;
end

%==================================================================
% Setup
%==================================================================  
function KSA = SolveTraj(GENPRJ)
    options = odeset('RelTol',2.5e-14,'AbsTol',[1e-20,1e-20,1e-20,1e-20]);
    %options = odeset('RelTol',2.5e-14,'AbsTol',[1e-20,1e-20,1e-20]);
    divs = 500;
    defunc = @(t,y) GENPRJ.YarnballSolution(t,y);
    rad0 = 0;
    dr0 = 0;
    phi0 = GENPRJ.InitPhi;
    theta0 = GENPRJ.InitTheta;
    tau = GENPRJ.DESOL.tau;
    len = GENPRJ.DESOL.len;
%     dir = GENPRJ.CLR.dir;
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
%         try
            for n = narray 
                GENPRJ.idx = 1;
                [tau,Y] = ode113(defunc,tau,[rad0,phi0(n),theta0(n),dr0],options);
                %[tau,Y] = ode113(defunc,tau,[rad0,phi0(n),theta0(n)],options); 
                rad = Y(:,1).';  
                phi = Y(:,2).'; 
                theta = Y(:,3).';
                GENPRJ.drSol = Y(:,4).';
                RadEnd(n) = rad(end);
                PhiEnd(n) = phi(end);                
                ThetaEnd(n) = theta(end);                
                kArrX(n,:) = rad.*sin(phi).*cos(theta);                              
                kArrY(n,:) = rad.*sin(phi).*sin(theta);
                kArrZ(n,:) = rad.*cos(phi); 
            end
%         catch
%             error('Check ''DeSolTimfunc''');
%         end
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

%==================================================================
% YarnballSolution
%==================================================================  
% function dy = YarnballSolution(GENPRJ,t,y)  
%     r = y(1);
%     St = @(r) GENPRJ.SPIN.SpinTheta(r);
%     Sp = @(r) GENPRJ.SPIN.SpinPhi(r);
%     dr = GENPRJ.CLR.RadialSolution(t,y,St,Sp);
%     dtheta = St(r)*dr;                                  % drop to zero on inside...
%     dphi = Sp(r)*r*dtheta;
%     dy = [dr;dphi;dtheta];
%     GENPRJ.drArr(GENPRJ.idx) = dr;
%     GENPRJ.dphiArr(GENPRJ.idx) = dphi;
%     GENPRJ.dthetaArr(GENPRJ.idx) = dtheta;
%     GENPRJ.rArr(GENPRJ.idx) = y(1);
%     GENPRJ.phiArr(GENPRJ.idx) = y(2);
%     GENPRJ.thetaArr(GENPRJ.idx) = y(3);
%     GENPRJ.tArr(GENPRJ.idx) = t;
%     GENPRJ.idx = GENPRJ.idx + 1;
% end

%==================================================================
% YarnballSolution
%==================================================================  
function dy = YarnballSolution(GENPRJ,t,y)  
    St = @(r) GENPRJ.SPIN.SpinTheta(r);
    Sp = @(r) GENPRJ.SPIN.SpinPhi(r);
    r = y(1);
    phi = y(2);
    theta = y(3);
    dr = y(4);
    dtheta = St(r)*dr;
    dphi = Sp(r)*r*dtheta;
    d2r = GENPRJ.CLR.RadialAcc(t,r,phi,theta,dr,dphi,dtheta);
    dy = [dr;dphi;dtheta;d2r];

    GENPRJ.drArr(GENPRJ.idx) = dr;
    GENPRJ.dphiArr(GENPRJ.idx) = dphi;
    GENPRJ.dthetaArr(GENPRJ.idx) = dtheta;
    GENPRJ.rArr(GENPRJ.idx) = y(1);
    GENPRJ.phiArr(GENPRJ.idx) = y(2);
    GENPRJ.thetaArr(GENPRJ.idx) = y(3);
    GENPRJ.tArr(GENPRJ.idx) = t;
    GENPRJ.idx = GENPRJ.idx + 1;
end







end
end

