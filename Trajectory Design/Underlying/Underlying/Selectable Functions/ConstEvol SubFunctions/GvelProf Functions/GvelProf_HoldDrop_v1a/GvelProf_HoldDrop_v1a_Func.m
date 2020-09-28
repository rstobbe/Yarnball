%====================================================
% 
%====================================================

function [GVP,err] = GvelProf_HoldDrop_v1a_Func(GVP,INPUT)

Status2('busy','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------

GVP.profile = ['@(GvelMax,DecayDrop,t) GvelMax-((1./(1+exp(',num2str(GVP.decayshape),'*(-t+',num2str(GVP.decaystart),'))))*GvelMax*DecayDrop)-heaviside(t-',num2str(GVP.decaystart),').*GvelMax.*',num2str(GVP.enddrop/100),'.*(t-',num2str(GVP.decaystart),')'];

Status2('done','',3);
