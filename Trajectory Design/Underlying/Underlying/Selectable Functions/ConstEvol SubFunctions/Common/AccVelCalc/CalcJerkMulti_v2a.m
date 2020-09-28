%==================================================
% Calculate Acceleration
%==================================================

function [acc,Tjerk,Tjerkseg] = CalcJerkMulti_v2a(acc,Tacc)

sz = size(acc);
T = repmat(Tacc,[sz(1) 1 3]);

acc2 = circshift(acc,[0 -1 0]);
T2 = circshift(T,[0 -1 0]);
acc = (acc2 - acc)./(T2 - T);            

Tjerk = T - (T - T2)/2;
Tjerk = squeeze(Tjerk(1,:,1));

Tjerk(length(Tjerk)) = Tacc(length(Tacc)) + (Tacc(length(Tacc)) - Tacc(length(Tacc)-1))/2;
acc(:,length(acc),:) = acc(:,length(acc)-1,:);

Tjerkseg = T2 - T;
Tjerkseg = squeeze(Tjerkseg(1,:,1));

%Test = 0;