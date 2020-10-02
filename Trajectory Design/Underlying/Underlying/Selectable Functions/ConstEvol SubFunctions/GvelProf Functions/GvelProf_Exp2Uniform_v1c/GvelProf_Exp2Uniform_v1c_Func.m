%====================================================
% 
%====================================================

function [GVP,err] = GvelProf_Exp2Uniform_v1c_Func(GVP,INPUT)

Status2('busy','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------
GVP.Accprof = ['@(Acc0,AccMax,t) Acc0 + AccMax.*(1 - exp(-t/',num2str(GVP.tau),'))'];

Status2('done','',3);
