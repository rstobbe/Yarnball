%====================================================
% 
%====================================================

function [GVP,err] = GvelProf_Exp2Design_v1b_Func(GVP,INPUT)

Status2('busy','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
kArr = INPUT.kArr;
TArr = INPUT.TArr;
clear INPUT

%------------------------------------------
% Calculate Gvel Design Shape
%------------------------------------------    
[vel,Tvel] = CalcVel_v2a(kArr,TArr);
[acc,Tacc] = CalcAcc_v2a(vel,Tvel);
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);

GVP.Tacc = Tacc;
GVP.magacc = magacc;
GVP.Accprof = @(GVP,Acc0,AccMax,t) Accproffunc(GVP,Acc0,AccMax,t);
Status2('done','',3);

%==================================================
% Function
%==================================================
function [val,ind] = Accproffunc(GVP,Acc0,AccMax,t)

t0 = GVP.Tacc/max(GVP.Tacc);
magacc = GVP.magacc;
magacc2 = Acc0 + (AccMax-Acc0) .* (1 - exp(-t0/GVP.tau));
ind = find(magacc < magacc2,1,'first');
ind = ind+500;
magacc3 = [magacc2(1:ind-1);magacc(ind:end)];
val = interp1(t0,magacc3,t,'linear','extrap');



