%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,TURNSOL,err] = TurnSolution_NoOvershoot_v1a(SCRPTipt,TURNSOLipt)

Status2('busy','Turn Solution Function',3);

err.flag = 0;
err.msg = '';

TURNSOL.method = TURNSOLipt.Func;   

Status2('done','',3);