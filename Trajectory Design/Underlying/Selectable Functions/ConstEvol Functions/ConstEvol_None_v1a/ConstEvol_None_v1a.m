%==================================================
% (v1a)
%    
%==================================================

function [SCRPTipt,CACC,err] = ConstEvol_None_v1a(SCRPTipt,CACCipt)

Status2('busy','Constrain Acceleration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CACC.method = CACCipt.Func; 

Status2('done','',2);
Status2('done','',3);

