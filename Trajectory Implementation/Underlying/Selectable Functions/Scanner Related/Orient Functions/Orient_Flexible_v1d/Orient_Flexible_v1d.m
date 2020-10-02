%====================================================
% (v1d)
%    - Update elip for different YbAxis 
%====================================================

function [SCRPTipt,ORNT,err] = Orient_Flexible_v1d(SCRPTipt,ORNTipt)

Status2('busy','Orient Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ORNT.method = ORNTipt.Func;
ORNT.kxyz = ORNTipt.('YarnBall_xyz');

Status2('done','',2);
Status2('done','',3);
