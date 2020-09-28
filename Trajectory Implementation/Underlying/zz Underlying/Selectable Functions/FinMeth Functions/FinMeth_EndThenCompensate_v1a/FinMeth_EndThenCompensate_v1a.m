%====================================================
% (v1a) 
%   
%====================================================

function [SCRPTipt,FINMETH,err] = FinMeth_EndThenCompensate_v1a(SCRPTipt,FINMETHipt) 

Status2('busy','Finish Trajectory',3);

err.flag = 0;
err.msg = '';

FINMETH.method = FINMETHipt.Func;

Status2('done','',3);










