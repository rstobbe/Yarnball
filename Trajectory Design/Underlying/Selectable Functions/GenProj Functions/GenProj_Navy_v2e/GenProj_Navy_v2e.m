%==================================================================
% (v2e)
%   - More cleaning up
%==================================================================

classdef GenProj_Navy_v2e < handle

properties (SetAccess = private)                   
    Method = 'GenProj_Navy_v2e'
    GENPRJipt
    RADACC
    ELIP
    SPIN
    CALCEVO
    TURNEVO
    EvolveYB
    Dir
    YB
    rkSpace
    kMax
    GradTimeQuant
    Tro
    T
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function GENPRJ = GenProj_Navy_v2e(GENPRJipt)    
    GENPRJ.GENPRJipt = GENPRJipt;
end 

%==================================================================
% Setup
%==================================================================  
function SetRadAcc(GENPRJ,RADACCfunc,RADACCipt)
    GENPRJ.RADACC = RADACCfunc(RADACCipt);
end
function SetSpin(GENPRJ,SPINfunc,SPINipt)
    GENPRJ.SPIN = SPINfunc(SPINipt);
end
function SetElip(GENPRJ,ELIPfunc,ELIPipt)
    GENPRJ.ELIP = ELIPfunc(ELIPipt);
end
function SetCalcEvo(GENPRJ,CALCEVOfunc,CALCEVOipt)
    GENPRJ.CALCEVO = CALCEVOfunc(CALCEVOipt);
end
function SetTurnEvo(GENPRJ,TURNEVOfunc,TURNEVOipt)
    GENPRJ.TURNEVO = TURNEVOfunc(TURNEVOipt);
end
function SetkMax(GENPRJ,kMax)
    GENPRJ.kMax = kMax;
end
function SetGradTimeQuant(GENPRJ,GradTimeQuant)
    GENPRJ.GradTimeQuant = GradTimeQuant;
end
function SetTro(GENPRJ,Tro)
    if rem(Tro,GENPRJ.GradTimeQuant)
        error;
    end
    GENPRJ.Tro = Tro;
end
function SetDir(GENPRJ,Dir)
    GENPRJ.Dir = Dir;
end

%==================================================================
% Return
%==================================================================  
function kSpace = GetkSpace(GENPRJ)
   kSpace = GENPRJ.kMax * GENPRJ.rkSpace;
end
function T = GetT(GENPRJ)
   T = GENPRJ.T;
end
function rRad = GetTestRelRad(GENPRJ)
   rRad = (GENPRJ.rkSpace(1,:,1).^2 + GENPRJ.rkSpace(1,:,2).^2 + GENPRJ.rkSpace(1,:,3).^2).^0.5; 
end

%==================================================================
% Calculate
%==================================================================  
function CalcEvoDifs(GENPRJ,TrajNum)
   kSpace = GENPRJ.kMax * GENPRJ.rkSpace(TrajNum,:,:);
   GENPRJ.CALCEVO.CalcEvoDiffs(GENPRJ.T,kSpace,GENPRJ.YB(TrajNum,:,:),GENPRJ.kMax);
end

%==================================================================
% Initialize
%==================================================================  
function Initialize(GENPRJ)
    InitYB = [0 0];
    [arkSpace,EndYB,aYB] = GENPRJ.SolveTraj(InitYB);
    GENPRJ.rkSpace = arkSpace;
    GENPRJ.YB = aYB;
    GENPRJ.EvolveYB = EndYB - InitYB;
end

%==================================================================
% SolveTraj
%==================================================================  
function [arkSpace,EndYB,aYB] = SolveTraj(GENPRJ,InitYB)
    tol = 2.5e-14;
    eventfunc = @(t,YB) GENPRJ.EventFcn(t,YB);
    options = odeset('RelTol',tol,'AbsTol',tol,'Events',eventfunc);
    defunc = @(t,YB) GENPRJ.YarnballSolution(t,YB);
    NumTraj = length(InitYB(:,1));
    aInitYB = [zeros(NumTraj,1) InitYB zeros(NumTraj,1)];
    SolLen = round(GENPRJ.Tro/GENPRJ.GradTimeQuant + 1);          
    GENPRJ.T = (0:GENPRJ.GradTimeQuant:GENPRJ.Tro);
    kArrX = zeros(NumTraj,SolLen);
    kArrY = zeros(NumTraj,SolLen);
    kArrZ = zeros(NumTraj,SolLen);  
    aYB = zeros(NumTraj,SolLen,4);  
    divs = 200;    
    for m = 1:ceil(NumTraj/divs)
        if m*divs < NumTraj
            narray = (m-1)*divs+1:m*divs;
        else
            narray = (m-1)*divs+1:NumTraj;
        end
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
        parfor n = narray 
            Sol = ode113(defunc,[0 1000],aInitYB(n,:),options);
            ProjLen = Sol.xe;
            Tau = linspace(0,ProjLen,SolLen);
            tYB = deval(Tau,Sol).';        
            kArrX(n,:) = tYB(:,1).*sin(tYB(:,2)).*cos(tYB(:,3));                              
            kArrY(n,:) = tYB(:,1).*sin(tYB(:,2)).*sin(tYB(:,3));
            kArrZ(n,:) = tYB(:,1).*cos(tYB(:,2)); 
            aYB(n,:,:) = tYB;
        end
    end 
    arkSpace = zeros(NumTraj,SolLen,3);
    if strcmp(GENPRJ.ELIP.YbAxisElip,'z')
        arkSpace(:,:,1) = kArrX;
        arkSpace(:,:,2) = kArrY;
        arkSpace(:,:,3) = kArrZ*GENPRJ.ELIP.Elip;
    elseif strcmp(GENPRJ.ELIP.YbAxisElip,'y')
        arkSpace(:,:,1) = kArrX;
        arkSpace(:,:,2) = kArrY*GENPRJ.ELIP.Elip;
        arkSpace(:,:,3) = kArrZ;
    elseif strcmp(GENPRJ.ELIP.YbAxisElip,'x')
        arkSpace(:,:,1) = kArrX*GENPRJ.ELIP.Elip;
        arkSpace(:,:,2) = kArrY;
        arkSpace(:,:,3) = kArrZ;
    end
    EndYB = aYB(:,end,(2:3));
    EndYB = reshape(EndYB,NumTraj,2);
    Status2('done','',2);
    Status2('done','',3);
end

%==================================================================
% YarnballSolution
%==================================================================  
function dYB = YarnballSolution(GENPRJ,t,YB)  
    St = @(r) GENPRJ.SPIN.SpinTheta(r);
    Sp = @(r) GENPRJ.SPIN.SpinPhi(r);
    r = YB(1);
    phi = YB(2);
    theta = YB(3);
    dr = YB(4);
    %-----
    dr = dr * GENPRJ.TURNEVO.drWeight(r); 
    dtheta = St(r)*dr;
    dphi = Sp(r)*r*dtheta; 
    %-----
    RadAcc = GENPRJ.RADACC.RadialAcc(t,r);
    d2r = RadAcc - r*dphi^2 - r*((sin(phi))^2)*dtheta^2 - 2*dr*dtheta - 2*(r.*cos(phi).*dtheta.*dphi).^2;                   % Smooth Acc
    %-----
    dphi = GENPRJ.Dir * dphi;
    dtheta = GENPRJ.Dir * dtheta;
    dYB = [dr;dphi;dtheta;d2r];
end

%===============================================================
% EventFcn
%===============================================================
function [position,isterminal,direction] = EventFcn(GENPRJ,t,YB)
    position = 1 - YB(1);
    isterminal = 1;
    direction = 0;
end


end
end

