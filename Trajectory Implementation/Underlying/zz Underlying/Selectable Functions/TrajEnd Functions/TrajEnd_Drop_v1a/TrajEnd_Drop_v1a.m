%====================================================
% (v1a)
%     
%====================================================


function [SCRPTipt,TEND,err] = TrajEnd_Zero_v1a(SCRPTipt,TENDipt) 

Status('busy','TrajEnd Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEND.slope = str2double(TENDipt.('EndSlp'));
TEND.method = TENDipt.Func;

Status2('done','',2);
Status2('done','',3);










