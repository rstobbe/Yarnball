%====================================================
% (v1d)
%       - change from tolerance to 'speed'
%====================================================

function [SCRPTipt,RADEV,err] = RadSolEv_DesignTest_v1d(SCRPTipt,RADEVipt)

Status2('busy','Get Radial Evolution Function for DE Solution',3);

err.flag = 0;
err.msg = '';

RADEV.method = RADEVipt.Func;   

Status2('done','',3);