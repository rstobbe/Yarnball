%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,TST,err] = DesTest_Basic_v1a(SCRPTipt,TSTipt)

Status2('busy','DesignTest',3);

err.flag = 0;
err.msg = '';

TST.method = TSTipt.Func;   

Status2('done','',3);