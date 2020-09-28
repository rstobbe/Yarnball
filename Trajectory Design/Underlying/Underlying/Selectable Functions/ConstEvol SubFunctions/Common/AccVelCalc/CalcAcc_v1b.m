%==================================================
% Calculate Acceleration
%==================================================

function [acc] = CalcAcc_v1b(vel,Tarr)

T(:,1) = Tarr; 
T(:,2) = Tarr; 
T(:,3) = Tarr;

vel2 = circshift(vel,[-1 0]);
T2 = circshift(T,[1 0]);
T3 = circshift(T,[-1 0]);
vel2(length(vel2),:) = vel2(length(vel2)-1,:);
T2(1,:) = 0;
T3(length(T3),:) = T3(length(T3)-1,:);
acc = (vel2 - vel)./(0.5*(T - T2)+0.5*(T3 - T));            

acc(length(acc),:) = acc(length(acc)-1,:);

