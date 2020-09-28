%==================================================
% Calculate Jerk
%==================================================

function [jerk] = CalcJerk_v1b(acc,Tarr)

T(:,1) = Tarr; 
T(:,2) = Tarr; 
T(:,3) = Tarr;

acc2 = circshift(acc,[-1 0]);
T2 = circshift(T,[1 0]);
T3 = circshift(T,[-1 0]);
acc2(length(acc2),:) = acc2(length(acc2)-1,:);
T2(1,:) = 0;
T3(length(T3),:) = T3(length(T3)-1,:);
jerk = (acc2 - acc)./(0.5*(T - T2)+0.5*(T3 - T));

jerk(length(jerk),:) = jerk(length(jerk)-1,:);

