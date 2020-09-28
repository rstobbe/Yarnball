%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,GVEL,err] = GvelProf_Exp2LinearDecay_v1a(SCRPTipt,GVELipt)

Status2('done','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GVEL.method = GVELipt.Func;  
GVEL.gaccinit = 20000;
GVEL.tau = str2double(GVELipt.('tau'));
GVEL.decaystart = str2double(GVELipt.('decaystart'));
GVEL.decayrate = str2double(GVELipt.('decayrate'));

Status2('done','',3);