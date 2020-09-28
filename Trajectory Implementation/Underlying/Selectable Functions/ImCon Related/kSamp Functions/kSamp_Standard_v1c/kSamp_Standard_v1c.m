%=====================================================
% (v1c) 
%      - negative time fixup
%=====================================================

function [SCRPTipt,KSMP,err] = kSamp_Standard_v1c(SCRPTipt,KSMPipt)

Status2('done','Get k-Space Sampling Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;

Status2('done','',2);
Status2('done','',3);

