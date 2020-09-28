%=====================================================
% (v1a)
%       - 
%=====================================================

function [SCRPTipt,GECC,err] = GECC_noECC_v1a(SCRPTipt,GECCipt)

Status2('busy','Get ECC Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GECC.method = GECCipt.Func;

Status2('done','',2);
Status2('done','',3);