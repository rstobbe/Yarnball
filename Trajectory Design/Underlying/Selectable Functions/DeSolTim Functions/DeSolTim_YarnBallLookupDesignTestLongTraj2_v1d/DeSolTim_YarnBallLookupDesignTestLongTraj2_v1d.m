%====================================================
% (v1d)
%   - start DeSolTim_YarnBallLookupDesignTest_v1d
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_YarnBallLookupDesignTestLongTraj_v1d(SCRPTipt,DESOLipt)

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