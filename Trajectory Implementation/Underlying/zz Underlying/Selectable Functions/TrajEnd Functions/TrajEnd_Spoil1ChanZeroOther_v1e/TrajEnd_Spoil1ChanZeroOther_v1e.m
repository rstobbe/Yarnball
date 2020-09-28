%====================================================
% (v1e)
%   - Turn into trapazoid if need be
%====================================================


function [SCRPTipt,TEND,err] = TrajEnd_Spoil1ChanZeroOther_v1e(SCRPTipt,TENDipt) 

Status('busy','TrajEnd');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEND.method = TENDipt.Func;
TEND.slope = str2double(TENDipt.('EndSlp'));
TEND.gmax = str2double(TENDipt.('Gmax'));
TEND.spoilfactor = str2double(TENDipt.('SpoilFactor'));
TEND.dir = TENDipt.('Dir');

Status2('done','',2);
Status2('done','',3);










