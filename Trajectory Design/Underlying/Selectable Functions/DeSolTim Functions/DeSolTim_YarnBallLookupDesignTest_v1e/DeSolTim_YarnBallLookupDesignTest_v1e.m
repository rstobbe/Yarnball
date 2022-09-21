%====================================================
% (v1e)
%   - PROJdgn.p replaced with value of p from DESTYPE
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_YarnBallLookupDesignTest_v1e(SCRPTipt,DESOLipt)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESOL.method = DESOLipt.Func;

RADEV.method = 'RadSolEv_DesignTest_v1d';
DESOL.RADEV = RADEV;

Status2('done','',2);
Status2('done','',3);