%====================================================
% 
%====================================================

function [CACCP,err] = CAccProf_Exp2Decay2_v1a_Func(CACCP,INPUT)

Status2('busy','Get Desired Acceleration Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------

%CACCP.Accprof = ['@(Acc0,AccMax,t,tro) Acc0+(AccMax-((1./(1+exp(',num2str(CACCP.decayrate),'*(-t+',num2str(CACCP.decayshift),'))))*AccMax*',num2str(CACCP.startfrac/100-1),')-AccMax*',num2str(CACCP.enddrop/100),'*(t/tro)-Acc0).*(1 - exp(-t/',num2str(CACCP.tau),'))'];

CACCP.Accprof = ['@(Acc0,AccMax,t) Acc0+(AccMax-((1./(1+exp(',num2str(CACCP.decayrate),'*(-t+',num2str(CACCP.decayshift/100),'))))*AccMax*',num2str(CACCP.startfrac/100-1),')-heaviside(t-',num2str(CACCP.decayshift/100),').*AccMax.*',num2str(CACCP.enddrop/100),'.*(t-',num2str(CACCP.decayshift/100),')-Acc0).*(1 - exp(-t/',num2str(CACCP.tau),'))'];

Status2('done','',3);
