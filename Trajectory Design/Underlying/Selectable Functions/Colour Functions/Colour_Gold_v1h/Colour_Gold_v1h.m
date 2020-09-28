%====================================================
% (v1h)
%   - in/out same
%====================================================

function [SCRPTipt,CLR,err] = Colour_Gold_v1h(SCRPTipt,CLRipt)

Status2('busy','Get Colour',3);

err.flag = 0;
err.msg = '';

CLR.method = CLRipt.Func;   

Status2('done','',3);