%==================================================
% (v1b)
%       - single array input
%==================================================

function [vel] = CalcVel_v1b(KSA,Tarr)

T(:,1) = Tarr; 
T(:,2) = Tarr; 
T(:,3) = Tarr;

KSA2 = circshift(KSA,[1 0]);
T2 = circshift(T,[1 0]);
KSA2(1,:) = 0;
T2(1,:) = 0;
vel = (KSA - KSA2)./(T - T2);
vel(1,:) = 0;

