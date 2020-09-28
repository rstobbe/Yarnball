%====================================================
% (v1b)
%     - correction to trap calc
%====================================================


function [SCRPTipt,TEND,err] = TrajEnd_Trapazoid_v1b(SCRPTipt,TENDipt) 

Status('busy','TrajEnd Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEND.method = TENDipt.Func;
TEND.slope = str2double(TENDipt.('Slope'));
TEND.gmag = str2double(TENDipt.('Gmag'));
TEND.spoilfactor = str2double(TENDipt.('SpoilFactor'));

Status2('done','',2);
Status2('done','',3);










