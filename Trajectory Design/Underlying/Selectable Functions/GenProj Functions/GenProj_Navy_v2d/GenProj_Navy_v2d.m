%==================================================================
% (v2d)
%   - More cleaning up
%==================================================================

classdef GenProj_Navy_v2d < handle

properties (SetAccess = private)                   
    Method = 'GenProj_Navy_v2d'
    GENPRJipt
    RADACC
    ELIP
    SPIN
    CALCEVO
    TURNEVO
    InitYB
    EndYB
    EvolveYB
    SolLen
    NumTraj
    Dir
    YB
    rkSpace
    kMax
    Tro
    T
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function GENPRJ = GenProj_Navy_v2d(GENPRJipt)    
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
function SetTro(GENPRJ,Tro)
    if rem(Tro,0.01)
        error;
    end
    GENPRJ.Tro = Tro;
    GENPRJ.SolLen = Tro/0.01 + 1;           % Siemens quantization
    GENPRJ.T = (0:0.01:Tro);
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
function Initialize(GENPRJ,InitYB)   
    GENPRJ.InitYB = InitYB;
    GENPRJ.NumTraj = length(InitYB(:,1));
end

%==================================================================
% SolveTraj
%==================================================================  
function SolveTraj(GENPRJ)
    tol = 1e-20;
    eventfunc = @(t,YB) GENPRJ.EventFcn(t,YB);
    options = odeset('RelTol',tol,'AbsTol',tol,'Events',eventfunc);
    defunc = @(t,YB) GENPRJ.YarnballSolution(t,YB);
    
    aInitYB = [0 GENPRJ.InitYB 0];
    aSolLen = GENPRJ.SolLen;

    kArrX = zeros(GENPRJ.NumTraj,GENPRJ.SolLen);
    kArrY = zeros(GENPRJ.NumTraj,GENPRJ.SolLen);
    kArrZ = zeros(GENPRJ.NumTraj,GENPRJ.SolLen);  
    aYB = zeros(GENPRJ.NumTraj,GENPRJ.SolLen,4);  
    
    divs = 500;    
    for m = 1:ceil(GENPRJ.NumTraj/divs)
        if m*divs < GENPRJ.NumTraj
            narray = (m-1)*divs+1:m*divs;
        else
            narray = (m-1)*divs+1:GENPRJ.NumTraj;
        end
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
        for n = narray 
            Sol = ode113(defunc,[0 1000],aInitYB,options);
            ProjLen = Sol.xe;
            Tau = linspace(0,ProjLen,aSolLen);
            aYB(n,:,:) = deval(Tau,Sol).';        
            kArrX(n,:) = aYB(n,:,1).*sin(aYB(n,:,2)).*cos(aYB(n,:,3));                              
            kArrY(n,:) = aYB(n,:,1).*sin(aYB(n,:,2)).*sin(aYB(n,:,3));
            kArrZ(n,:) = aYB(n,:,1).*cos(aYB(n,:,2)); 
        end
    end 
    GENPRJ.rkSpace = zeros(GENPRJ.NumTraj,GENPRJ.SolLen,3);
    if strcmp(GENPRJ.ELIP.YbAxisElip,'z')
        GENPRJ.rkSpace(:,:,1) = kArrX;
        GENPRJ.rkSpace(:,:,2) = kArrY;
        GENPRJ.rkSpace(:,:,3) = kArrZ*GENPRJ.ELIP.Elip;
    elseif strcmp(GENPRJ.ELIP.YbAxisElip,'y')
        GENPRJ.rkSpace(:,:,1) = kArrX;
        GENPRJ.rkSpace(:,:,2) = kArrY*GENPRJ.ELIP.Elip;
        GENPRJ.rkSpace(:,:,3) = kArrZ;
    elseif strcmp(GENPRJ.ELIP.YbAxisElip,'x')
        GENPRJ.rkSpace(:,:,1) = kArrX*GENPRJ.ELIP.Elip;
        GENPRJ.rkSpace(:,:,2) = kArrY;
        GENPRJ.rkSpace(:,:,3) = kArrZ;
    end
    GENPRJ.YB = aYB;
    GENPRJ.EndYB = squeeze(aYB(:,end,(2:3))).';
    GENPRJ.EvolveYB = GENPRJ.EndYB - GENPRJ.InitYB;
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

