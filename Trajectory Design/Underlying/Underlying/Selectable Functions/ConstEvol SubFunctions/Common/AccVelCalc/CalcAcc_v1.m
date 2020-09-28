%==================================================
% Calculate Acceleration
%==================================================

function [acc] = CalcAcc_v1(vel,T)

vel2 = circshift(vel,[-1 0]);
T2 = circshift(T,[1 0]);
T3 = circshift(T,[-1 0]);
vel2(length(vel2),:) = vel2(length(vel2)-1,:);
T2(1,:) = 0;
T3(length(T3),:) = T3(length(T3)-1,:);
acc = (vel2 - vel)./(0.5*(T - T2)+0.5*(T3 - T));

acc(length(acc),:) = acc(length(acc)-1,:);

%T = T(1:10,1)
%T2 = T2(1:10,1)
%T3 = T3(1:10,1)
%vel = vel(1:10,1)
%vel2 = vel2(1:10,1)
%acc = acc(1:10,1)
%acc = acc(length(acc)-10:length(acc),1)
%test1 = (vel(2,1) - vel(1,1))/(0.5*(T(2,1)-T(1,1)))
%test2 = (vel(3,1) - vel(2,1))/(0.5*(T(2,1)-T(1,1))+0.5*(T(3,1)-T(2,1)))