%=========================================================
% (v3i)
%       - Same as 'SiemensLR_v3i' (just name change)
%       - panael parameter name change
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_SiemensStandard_v3i(SCRPTipt,TSMPipt)

Status2('busy','Get Trajectory Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.minbaseoversamp = str2double(TSMPipt.('OverSamp'));
TSMP.sysoversamp = 1.25;

Status2('done','',2);
Status2('done','',3);