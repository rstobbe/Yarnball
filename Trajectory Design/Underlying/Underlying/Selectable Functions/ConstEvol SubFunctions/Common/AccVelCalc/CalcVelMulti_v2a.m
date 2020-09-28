%==================================================
% (v2a)
%       - Explort timing associated with velocities
%==================================================

function [vel,Tvel] = CalcVelMulti_v2a(KSA,Tsamp)

sz = size(KSA);
T = repmat(Tsamp,[sz(1) 1 3]);

KSA2 = circshift(KSA,[0 1 0]);
T2 = circshift(T,[0 1 0]);
KSA2(:,1,:) = 0;
T2(:,1,:) = 0;
vel = (KSA - KSA2)./(T - T2);
vel(:,1,:) = 0;

Tvel = T - (T - T2)/2;
Tvel = squeeze(Tvel(1,:,1));