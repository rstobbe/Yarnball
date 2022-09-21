
r = 0:0.001:1;

test = (1-0.5*exp(-20*(r)));

% TurnLoc = 0.95;
% Fiddle = 0.06;
% Slope = 3;
% 
% func = @(r,fiddle) erf(1+Slope*(1-(r+fiddle).^2));
% func0 = @(fiddle) 0.0001 - erf(1+Slope*(1-(1+fiddle).^2));
% options = optimset('TolFun',0.0000001);
% lb = 0;
% ub = 1;
% fiddle0 = 0;
% fiddle = lsqnonlin(func0,fiddle0,lb,ub,options) 


figure(3452345); hold on;
%plot(r,func(r,fiddle),'r');
plot(r,test,'b');
