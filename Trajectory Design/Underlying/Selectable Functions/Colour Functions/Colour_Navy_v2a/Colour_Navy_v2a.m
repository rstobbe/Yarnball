%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef Colour_Navy_v2a < handle

properties (SetAccess = private)                   
    Method = 'Colour_Navy_v2a'
    CLRipt;
    TURNEVO;
    TURNSOL;
    RADSOL;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function CLR = Colour_Navy_v2a(CLRipt)    
    CLR.CLRipt = CLRipt;
end 

%==================================================================
% Setup
%==================================================================  
function SetTurnEvo(CLR,TURNEVOfunc,TURNEVOipt)
    CLR.TURNEVO = TURNEVOfunc(TURNEVOipt);
end
function SetTurnSol(CLR,TURNSOLfunc,TURNSOLipt)
    CLR.TURNSOL = TURNSOLfunc(TURNSOLipt);
end

%====================================================
% RadialSolution
%====================================================
function dr = RadialSolution(CLR,t,y,St,Sp)
    %dr = 1;
    
    r = y(1);
    phi = y(2);    
    %-------------------------------------------------------
    % Constant Speed
    %-------------------------------------------------------
    dr = (1 ./ (1 + (r^2)*(sin(phi)^2)*(St(r)^2) + r^4*Sp(r)^2*St(r)^2)) ^0.5;  
end

%====================================================
% RadialAcc
%====================================================
function d2r = RadialAcc(CLR,t,r,phi,theta,dr,dphi,dtheta)
    %d2r = 3*(2-r) - r*dphi^2 - r*(sin(phi)^2)*dtheta^2;
    %d2r = 3*(r+1) - r*dphi^2 - r*(sin(phi)^2)*dtheta^2;
    %d2r = 6 - r*dphi^2; 
    
    Val = 6;
    d2r = Val - r*dphi^2 - r*(sin(phi)^2)*dtheta^2 - 2*dr*dtheta;                   % smoother...
    %d2r = Val - r*dphi^2 - r*(sin(phi)^2)*dtheta^2; 
    %d2r = Val - r*dphi^2 - r*(sin(phi)^2)*dtheta^2 - 2*dr*dphi; 
    
end

end
end
