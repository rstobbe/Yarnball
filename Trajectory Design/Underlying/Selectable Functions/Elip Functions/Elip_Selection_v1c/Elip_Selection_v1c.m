%====================================================
% (v1c)
%    - Add YbAxisElip
%====================================================

function [SCRPTipt,ELIP,err] = Elip_Selection_v1c(SCRPTipt,ELIPipt)

Status2('busy','Elip Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ELIP.method = ELIPipt.Func;
ELIP.voxelstretch = str2double(ELIPipt.('VoxelStretch'));
ELIP.YbAxisElip = (ELIPipt.('YbAxisElip'));

Status2('done','',2);
Status2('done','',3);
