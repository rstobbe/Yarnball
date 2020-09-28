%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,GVP,err] = GvelProf_NegHoldExp2Design_v1b(SCRPTipt,GVPipt)

Status2('done','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GVP.method = GVPipt.Func;  
GVP.tau = str2double(GVPipt.('Tau'));
GVP.hold = str2double(GVPipt.('Hold'));

Status2('done','',3);