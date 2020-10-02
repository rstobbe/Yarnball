%====================================================
% (v1c)
%       
%====================================================

function [SCRPTipt,GVEL,err] = GvelProf_Exp2Uniform_v1c(SCRPTipt,GVELipt)

Status2('done','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GVEL.method = GVELipt.Func;  
GVEL.gaccinit = 20000;
GVEL.tau = str2double(GVELipt.('Tau'));

Status2('done','',3);