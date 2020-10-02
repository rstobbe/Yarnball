%====================================================
% 
%====================================================

function [GVP,err] = GvelProf_Exp2LinearDecay_v1a_Func(GVP,INPUT)

Status2('busy','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------
GVP.Accprof = ['@(Acc0,AccMax,t) Acc0+(AccMax-heaviside(t-',num2str(GVP.decaystart),').*AccMax.*',num2str(GVP.decayrate),'.*(t-',num2str(GVP.decaystart),')-Acc0).*(1 - exp(-t/',num2str(GVP.tau),'))'];

Status2('done','',3);
