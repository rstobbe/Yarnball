%====================================================
% 
%====================================================

function [DES,err] = Design_Yarnball_v1c_Func(INPUT,DES)

Status('busy','Create Yarnball Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DESMETH = INPUT.DESMETH;
clear INPUT

%----------------------------------------------------
% Basic Calcs
%----------------------------------------------------
PROJdgn.method = DES.desmethfunc;
PROJdgn.fov = DES.fov;
PROJdgn.vox = DES.vox;
PROJdgn.tro = DES.tro;
PROJdgn.nproj = DES.nproj;
PROJdgn.kstep = 1000/PROJdgn.fov;                                          
PROJdgn.kmax = 1000/(2*PROJdgn.vox);
PROJdgn.rad = PROJdgn.kmax/PROJdgn.kstep;

%------------------------------------------
% Design Trajectory
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([DES.desmethfunc,'_Func']);           
[DESMETH,err] = func(DESMETH,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Return
%------------------------------------------
desmethfunc = DES.desmethfunc;
DES = DESMETH;
DES.desmethfunc = desmethfunc;

Status('done','');
Status2('done','',2);
Status2('done','',3);


