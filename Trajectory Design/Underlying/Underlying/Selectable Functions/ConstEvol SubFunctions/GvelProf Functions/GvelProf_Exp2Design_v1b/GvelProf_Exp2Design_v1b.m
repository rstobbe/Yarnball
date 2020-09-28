%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,GVP,err] = GvelProf_Exp2Design_v1b(SCRPTipt,GVPipt)

Status2('done','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GVP.method = GVPipt.Func;  
GVP.tau = str2double(GVPipt.('tau'));

Status2('done','',3);