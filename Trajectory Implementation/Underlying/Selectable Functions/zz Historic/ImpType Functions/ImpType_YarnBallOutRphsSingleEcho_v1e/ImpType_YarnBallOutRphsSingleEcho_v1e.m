%====================================================
% (v1e)
%   -
%====================================================

function [SCRPTipt,IMPTYPE,err] = ImpType_YarnBallOutRphsSingleEcho_v1e(SCRPTipt,IMPTYPEipt)

Status2('busy','Get ImpType',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMPTYPE.method = IMPTYPEipt.Func;  
FINMETH.method = 'FinMeth_CompensateThenEnd_v1b';

%------------------------------------------
% Return
%------------------------------------------
IMPTYPE.FINMETH = FINMETH;

Status2('done','',3);
