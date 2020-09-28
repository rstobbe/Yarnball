%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,GVP,err] = GvelProf_RampNegExp2Design_v1b(SCRPTipt,GVPipt)

Status2('done','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GVP.method = GVPipt.Func;  
GVP.ramp = str2double(GVPipt.('Ramp'));
GVP.tau = str2double(GVPipt.('Tau'));
GVP.dropstart = str2double(GVPipt.('DropStart'));

Status2('done','',3);