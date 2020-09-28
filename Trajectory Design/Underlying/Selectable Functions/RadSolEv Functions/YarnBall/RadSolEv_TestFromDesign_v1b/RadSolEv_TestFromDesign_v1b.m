%====================================================
% (v1b)
%   -messing
%====================================================

function [SCRPTipt,RADEV,err] = RadSolEv_ForConstEvol_v1b(SCRPTipt,RADEVipt)

Status2('busy','Get Radial Evolution Function for DE Solution',3);

err.flag = 0;
err.msg = '';

RADEV.method = RADEVipt.Func;   

Status2('done','',3);