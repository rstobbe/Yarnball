%==================================================
% Calculate Acceleration
%==================================================

function [acc,Tjerk,Tjerkseg] = CalcJerk_v2a(acc,Tacc)

T(:,1) = Tacc; 
T(:,2) = Tacc; 
T(:,3) = Tacc;

acc2 = circshift(acc,[-1 0]);
T2 = circshift(T,[-1 0]);
acc = (acc2 - acc)./(T2 - T);            

Tjerk = T - (T - T2)/2;
Tjerk = squeeze(Tjerk(:,1));

Tjerk(length(Tjerk)) = Tacc(length(Tacc)) + (Tacc(length(Tacc)) - Tacc(length(Tacc)-1))/2;
acc(length(acc),:) = acc(length(acc)-1,:);

Tjerkseg = T2 - T;
Tjerkseg = squeeze(Tjerkseg(:,1));

%Test = 0;