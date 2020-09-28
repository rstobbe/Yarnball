%====================================================
% 
%====================================================

function [CACCP,err] = GvelProf_Exp2LinearDecay_v1a_Func(CACCP,INPUT)

Status2('busy','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------

CACCP.Accprof = ['@(Acc0,AccMax,t) Acc0+(AccMax-heaviside(t-',num2str(CACCP.decaystart/100),').*AccMax.*',num2str(CACCP.decayrate/100),'.*(t-',num2str(CACCP.decaystart/100),')-Acc0).*(1 - exp(-t/',num2str(CACCP.tau),'))'];

Status2('done','',3);
