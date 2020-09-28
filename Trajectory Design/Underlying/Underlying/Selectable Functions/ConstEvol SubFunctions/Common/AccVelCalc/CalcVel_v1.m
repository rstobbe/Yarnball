%==================================================
% Calculate Velocity
%==================================================

function [vel] = CalcVel_v1(KSA,T)

KSA2 = circshift(KSA,[1 0]);
T2 = circshift(T,[1 0]);
KSA2(1,:) = 0;
T2(1,:) = 0;
vel = (KSA - KSA2)./(T - T2);
vel(1,:) = 0;

%vel2 = zeros(slvno,3);
%for m = 2:slvno
%    vel2(m,1) = (KSA(m,1)-KSA(m-1,1))/(T(m)-T(m-1));
%    vel2(m,2) = (KSA(m,2)-KSA(m-1,2))/(T(m)-T(m-1));
%    vel2(m,3) = (KSA(m,3)-KSA(m-1,3))/(T(m)-T(m-1));
%end
%test = (vel-vel2);
%difference = sum(test(:))