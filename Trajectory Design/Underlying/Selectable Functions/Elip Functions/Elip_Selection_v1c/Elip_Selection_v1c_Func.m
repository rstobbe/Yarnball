%====================================================
% 
%====================================================

function [ELIP,err] = Elip_Selection_v1c_Func(ELIP,INPUT)

Status2('busy','Define Elip',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
clear INPUT

%---------------------------------------------
% Return Elip
%---------------------------------------------
OutDim = round(100*PROJdgn.vox*ELIP.voxelstretch)/100;
ELIP.elip = PROJdgn.vox/OutDim;                  % should be placed along 'z';
ELIP.voxelstretch = 1/ELIP.elip;

Status2('done','',2);
Status2('done','',3);