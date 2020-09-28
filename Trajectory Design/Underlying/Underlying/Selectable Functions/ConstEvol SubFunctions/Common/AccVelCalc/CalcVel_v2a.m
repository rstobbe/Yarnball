%==================================================
% (v2a)
%       - Explort timing associated with velocities
%==================================================

function [vel,Tvel] = CalcVel_v2a(KSA,Tsamp)

T(:,1) = Tsamp; 
T(:,2) = Tsamp; 
T(:,3) = Tsamp;

KSA2 = circshift(KSA,[1 0]);
T2 = circshift(T,[1 0]);
KSA2(1,:) = 0;
T2(1,:) = 0;
vel = (KSA - KSA2)./(T - T2);
vel(1,:) = 0;

Tvel = T - (T - T2)/2;
Tvel = squeeze(Tvel(:,1));