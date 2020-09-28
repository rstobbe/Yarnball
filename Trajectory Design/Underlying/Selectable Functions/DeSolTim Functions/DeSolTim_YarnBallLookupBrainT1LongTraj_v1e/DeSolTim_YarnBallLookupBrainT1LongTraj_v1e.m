%====================================================
% (v1e)
%   - start 'DeSolTim_YarnBallLookupBrainT1_v1e'
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_YarnBallLookupBrainT1LongTraj_v1e(SCRPTipt,DESOLipt)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESOL.method = DESOLipt.Func;

RADEV.method = 'RadSolEv_ForConstEvol_v1a';
DESOL.RADEV = RADEV;

Status2('done','',2);
Status2('done','',3);