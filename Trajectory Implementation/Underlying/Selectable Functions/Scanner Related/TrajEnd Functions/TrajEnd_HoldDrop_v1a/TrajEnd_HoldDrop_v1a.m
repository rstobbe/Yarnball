%====================================================
% (v1a)
%     same as 'TrajEnd_HoldZero_v1a' (rename)
%====================================================


function [SCRPTipt,TEND,err] = TrajEnd_HoldDrop_v1a(SCRPTipt,TENDipt) 

Status('busy','TrajEnd Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEND.hold = str2double(TENDipt.('EndHold'));
TEND.slope = str2double(TENDipt.('EndSlp'));
TEND.method = TENDipt.Func;

Status2('done','',2);
Status2('done','',3);










