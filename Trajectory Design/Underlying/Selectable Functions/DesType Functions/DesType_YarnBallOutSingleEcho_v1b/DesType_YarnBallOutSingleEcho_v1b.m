%====================================================
% (v1b)
%       - add AccConstrain section 
%====================================================

function [SCRPTipt,DESTYPE,err] = DesType_YarnBallOutSingleEcho_v1b(SCRPTipt,DESTYPEipt)

Status2('busy','Get DesType',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESTYPE.method = DESTYPEipt.Func;   
DESTYPE.testfunc = DESTYPEipt.('DesTestfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TSTipt = DESTYPEipt.('DesTestfunc');
if isfield(DESTYPEipt,('DesTestfunc_Data'))
    TSTipt.DesTestfunc_Data = DESTYPEipt.DesTestfunc_Data;
end

%------------------------------------------
% Get Testing Info
%------------------------------------------
func = str2func(DESTYPE.testfunc);           
[SCRPTipt,TST,err] = func(SCRPTipt,TSTipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
DESTYPE.TST = TST;

Status2('done','',2);
Status2('done','',3);
