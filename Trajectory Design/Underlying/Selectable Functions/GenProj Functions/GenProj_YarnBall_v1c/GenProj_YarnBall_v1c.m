%====================================================
% (v1c)
%    - allow YbAxis selection for Elip
%====================================================

function [SCRPTipt,GENPRJ,err] = GenProj_YarnBall_v1c(SCRPTipt,GENPRJipt)

Status2('busy','Get GenProj Function',3);

err.flag = 0;
err.msg = '';

GENPRJ.method = GENPRJipt.Func;   

Status2('done','',3);