%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,GVEL,err] = GvelProf_HoldDrop_v1a(SCRPTipt,GVELipt)

Status2('done','Get Gradient Velocity Profile info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GVEL.method = GVELipt.Func;  
GVEL.decayshape = str2double(GVELipt.('DecayShape'));
GVEL.decaystart = str2double(GVELipt.('DecayStart'));
GVEL.enddrop = str2double(GVELipt.('EndDrop'));

Status2('done','',3);