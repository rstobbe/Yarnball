%==================================================
% Calculate Acceleration
%==================================================

function [acc,Tacc,Taccseg] = CalcAcc2D_v2a(vel,Tvel)

T(:,1) = Tvel; 
T(:,2) = Tvel; 

vel2 = circshift(vel,[-1 0]);
T2 = circshift(T,[-1 0]);
acc = (vel2 - vel)./(T2 - T);            

Tacc = T - (T - T2)/2;
Tacc = squeeze(Tacc(:,1));

Tacc(length(Tacc)) = Tvel(length(Tvel)) + (Tvel(length(Tvel)) - Tvel(length(Tvel)-1))/2;
acc(length(acc),:) = acc(length(acc)-1,:);

Taccseg = T2 - T;
Taccseg = squeeze(Taccseg(:,1));

%Test = 0;