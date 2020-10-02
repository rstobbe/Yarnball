%====================================================
% (v1d)
%      - as 'TrajEnd_LRrephase_v1d'  (name change only)
%====================================================


function [SCRPTipt,TEND,err] = TrajEnd_StandardRephase_v1d(SCRPTipt,TENDipt) 

Status('busy','TrajEnd Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEND.method = TENDipt.Func;
TEND.slope = str2double(TENDipt.('EndSlp'));

Status2('done','',2);
Status2('done','',3);










