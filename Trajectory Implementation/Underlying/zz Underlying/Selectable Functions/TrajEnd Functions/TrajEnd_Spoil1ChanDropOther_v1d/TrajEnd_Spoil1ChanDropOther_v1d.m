%====================================================
% (v1d)
%   - start 'TrajEnd_StandardSpoil_v1d'
%====================================================


function [SCRPTipt,TEND,err] = TrajEnd_ConstantSpoil1Chan_v1d(SCRPTipt,TENDipt) 

Status('busy','TrajEnd');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEND.method = TENDipt.Func;
TEND.slopespoil = str2double(TENDipt.('EndSlpSpoil'));
TEND.slopedrop = str2double(TENDipt.('EndSlpDrop'));
TEND.gmax = str2double(TENDipt.('Gmax'));
TEND.spoilfactor = str2double(TENDipt.('SpoilFactor'));
TEND.dir = TENDipt.('Dir');

Status2('done','',2);
Status2('done','',3);










