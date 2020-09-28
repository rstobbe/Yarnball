%====================================================
% 
%====================================================

function [ELIP,err] = Elip_Isotropic_v1a_Func(ELIP,INPUT)

Status2('busy','Define Elip',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ELIP.elip = 1;                  

Status2('done','',2);
Status2('done','',3);