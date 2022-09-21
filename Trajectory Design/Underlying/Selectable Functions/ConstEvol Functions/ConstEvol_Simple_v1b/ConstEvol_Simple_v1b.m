%==================================================
% (v1b)
%       - replace PROJdgn.tro with just tro
%==================================================

function [SCRPTipt,CACC,err] = ConstEvol_Simple_v1b(SCRPTipt,CACCipt)

Status2('busy','Constrain Acceleration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CACC.method = CACCipt.Func; 

Status2('done','',2);
Status2('done','',3);

