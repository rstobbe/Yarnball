%====================================================
% (v1c)
%   - hard-code GaccInit 
%   - it gets calculated lower anyway
%====================================================

function [SCRPTipt,GVEL,err] = GvelProf_Exp2OvershootDecay_v1c(SCRPTipt,GVELipt)

Status2('done','Get Gradient Velocity Profile info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GVEL.method = GVELipt.Func;  
GVEL.gaccinit = 20000;
GVEL.tau = str2double(GVELipt.('Tau'));
GVEL.startfrac = str2double(GVELipt.('Overshoot'));
GVEL.decayrate = str2double(GVELipt.('OshootDecayRate'));
GVEL.decayshift = str2double(GVELipt.('OshootDecayShiftFrac'));
GVEL.enddrop = str2double(GVELipt.('EndDropRate'));

Status2('done','',3);