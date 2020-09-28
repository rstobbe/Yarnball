%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_YarnBall_v1g_Func(DESMETH,INPUT)

Status('busy','Create YarnBall Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
ELIP = DESMETH.ELIP;
SPIN = DESMETH.SPIN;
DESOL = DESMETH.DESOL;
TIMADJ = DESMETH.TIMADJ;
CLR = DESMETH.CLR;
DESTYPE = DESMETH.DESTYPE;
GENPRJ = DESMETH.GENPRJ;
TST = DESTYPE.TST;
clear INPUT

%---------------------------------------------
% Describe Trajectory
%---------------------------------------------
DESMETH.type = 'YB';

%------------------------------------------
% Spiral Accommodation
%------------------------------------------
SpiralOverShoot = 0;
PROJdgn.spiralaccom = (PROJdgn.rad+SpiralOverShoot)/PROJdgn.rad;

%-----------------------------------------------
% Determine value of p associated with nproj
%-----------------------------------------------
PROJdgn.p = sqrt(PROJdgn.nproj/(2*pi^2*PROJdgn.rad^2));                     

%------------------------------------------
% PSMP to solve 1 trajectory
%------------------------------------------
PSMP.phi = pi/2;
PSMP.theta = 0;

%------------------------------------------
% Get testing Info
%------------------------------------------
func = str2func([TST.method,'_Func']);  
INPUT.func = 'GetInfo';
INPUT.DESMETH = DESMETH;
[TST,err] = func(TST,INPUT);
if err.flag
    return
end
clear INPUT;
SPIN.Vis = TST.SPIN.Vis;
DESOL.Vis = TST.DESOL.Vis;

%------------------------------------------
% Get colour function
%------------------------------------------
func = str2func([CLR.method,'_Func']);    
INPUT = [];
[CLR,err] = func(CLR,INPUT);
if err.flag
    return
end

%------------------------------------------
% Get voxel shape function
%------------------------------------------
func = str2func([ELIP.method,'_Func']);  
INPUT.PROJdgn = PROJdgn;
[ELIP,err] = func(ELIP,INPUT);
if err.flag
    return
end
PROJdgn.elip = ELIP.elip;
if isfield(ELIP,'YbAxisElip')
    PROJdgn.YbAxisElip = ELIP.YbAxisElip;
else
    PROJdgn.YbAxisElip = 'z';
end
clear INPUT;

%------------------------------------------
% Get spinning functions
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([SPIN.method,'_Func']);           
[SPIN,err] = func(SPIN,INPUT);
if err.flag
    return
end
clear INPUT;
if isfield(SPIN,'p')
    PROJdgn.p = SPIN.p;
end
if isfield(SPIN,'nproj')
    PROJdgn.nproj = SPIN.nproj;
end

%------------------------------------------
% Develop differential equations
%------------------------------------------
func = str2func([DESTYPE.method,'_Func']);    
INPUT.DESOL = DESOL;
INPUT.CLR = CLR;
INPUT.SPIN = SPIN;
INPUT.PROJdgn = PROJdgn;
INPUT.func = 'PreDeSolTim';       
[DESTYPE,err] = func(DESTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Get DE solution timing
%------------------------------------------
func = str2func([DESOL.method,'_Func']);     
INPUT.PROJdgn = PROJdgn;
INPUT.DESTYPE = DESTYPE;
if strcmp(TST.testspeed,'rapid')
    INPUT.courseadjust = 'yes';    
else
    INPUT.courseadjust = 'no';
end      
[DESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Generation Setup
%------------------------------------------
func = str2func([DESTYPE.method,'_Func']);     
INPUT.DESOL = DESOL;
INPUT.CLR = CLR;
INPUT.func = 'PreGeneration';      
[DESTYPE,err] = func(DESTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Timing Adjust
%------------------------------------------
func = str2func([TIMADJ.method,'_Func']);  
INPUT.PROJdgn = PROJdgn;
INPUT.DESTYPE = DESTYPE;
INPUT.GENPRJ = GENPRJ;
INPUT.PSMP = PSMP;
INPUT.DESOL = DESOL;
INPUT.TST = TST;
[TIMADJ,err] = func(TIMADJ,INPUT);
if err.flag == 1
    return
end
clear INPUT;   
CACC = TIMADJ.CACC;

%------------------------------------------
% Generate Test Trajectory
%------------------------------------------
func = str2func([DESTYPE.method,'_Func']);     
INPUT.PROJdgn = PROJdgn;
INPUT.GENPRJ = GENPRJ;
INPUT.PSMP = PSMP;
INPUT.DESOL = DESOL;
INPUT.func = 'GenerateFull';      
[DESTYPE,err] = func(DESTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Acc Constrain Modify
%------------------------------------------
func = str2func([DESTYPE.method,'_Func']);     
INPUT.CACC = CACC;
INPUT.KSA = DESTYPE.KSA;
INPUT.func = 'AccConstrain';      
[DESTYPE,err] = func(DESTYPE,INPUT);
if err.flag
    return
end
clear INPUT;
PROJdgn.maxaveacc = DESTYPE.maxaveacc;       

%------------------------------------------
% Consolidate Design Info
%------------------------------------------
PROJdgn.maxsmpdwell = PROJdgn.kstep/max(CACC.magvel);
PROJdgn.projosamp = SPIN.GblSamp;

%--------------------------------------------
% Name
%--------------------------------------------
sfov = num2str(PROJdgn.fov,'%03.0f');
svox = num2str(10*(PROJdgn.vox^3)/PROJdgn.elip,'%04.0f');
selip = num2str(100*PROJdgn.elip,'%03.0f');
stro = num2str(10*PROJdgn.tro,'%03.0f');
snproj = num2str(PROJdgn.nproj,'%4.0f');
if strcmp(DESTYPE.name,'B')
    DESMETH.name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_S',SPIN.name];
else
    DESMETH.name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_S',SPIN.name,'_',DESTYPE.name];    
end
    
%------------------------------------------
% Return
%------------------------------------------
DESMETH.PROJdgn = PROJdgn;
DESMETH.ELIP = ELIP;
DESMETH.SPIN = SPIN;
DESMETH.CLR = CLR;
DESMETH.DESTYPE = DESTYPE;
DESMETH.RADEV = DESOL.RADEV;
DESMETH.DESOL = DESOL;
DESMETH.PSMP = PSMP;
DESMETH.CACC = CACC;
DESMETH.T0 = DESTYPE.T;
DESMETH.KSA = DESTYPE.KSA;

%------------------------------------------
% Create test plots etc..
%------------------------------------------
func = str2func([DESTYPE.method,'_Func']);     
INPUT.DESMETH = DESMETH;
INPUT.func = 'Test';      
[DESTYPE,err] = func(DESTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

if isfield(DESTYPE.TST,'Figure')
    DESMETH.Figure = DESTYPE.TST.Figure;
end
DESMETH.PanelOutput = DESTYPE.TST.PanelOutput;
DESMETH.Panel2Imp = DESTYPE.TST.Panel2Imp;

Status('done','');
Status2('done','',2);
Status2('done','',3);


