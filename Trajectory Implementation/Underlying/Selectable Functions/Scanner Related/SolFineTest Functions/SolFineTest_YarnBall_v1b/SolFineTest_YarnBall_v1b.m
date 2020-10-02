%====================================================
% (v1b)  
%     - include the trajectory generation  
%====================================================

function [SCRPTipt,SOLFINTEST,err] = SolFineTest_YarnBall_v1b(SCRPTipt,SOLFINTESTipt) 

Status2('busy','Solution Fineness Testing',3);

err.flag = 0;
err.msg = '';

SOLFINTEST.method = SOLFINTESTipt.Func;

Status2('done','',3);










