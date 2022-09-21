%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_YarnBall_v2a_Func(DESMETH,INPUT)

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
RADSOL = DESMETH.RADSOL;
TST = DESTYPE.TST;
clear INPUT

%---------------------------------------------
% Describe Trajectory
%---------------------------------------------
DESMETH.type = 'YB';

%------------------------------------------
% PROJdgn
%------------------------------------------
SpiralOverShoot = 0;
PROJdgn.spiralaccom = (PROJdgn.rad+SpiralOverShoot)/PROJdgn.rad;
PROJdgn.p = sqrt(PROJdgn.nproj/(2*pi^2*PROJdgn.rad^2));                     
PROJdgn.YbAxisElip = ELIP.YbAxisElip;
PROJdgn.elip = ELIP.Elip;

%------------------------------------------
% InitialSetup
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.GENPRJ = GENPRJ;
INPUT.CLR = CLR;
INPUT.SPIN = SPIN;
INPUT.ELIP = ELIP;
INPUT.RADSOL = RADSOL;
INPUT.DESOL = DESOL;
DESTYPE.InitialSetup(INPUT);
clear INPUT

%------------------------------------------
% SolveDeSolTiming
%------------------------------------------
DESTYPE.SolveDeSolTiming;

%------------------------------------------
% TimingAdjust
%------------------------------------------
DESTYPE.TimingAdjust(TIMADJ);


% %--------------------------------------------
% % Name
% %--------------------------------------------
% sfov = num2str(PROJdgn.fov,'%03.0f');
% svox = num2str(10*(PROJdgn.vox^3)/PROJdgn.elip,'%04.0f');
% selip = num2str(100*PROJdgn.elip,'%03.0f');
% stro = num2str(10*PROJdgn.tro,'%03.0f');
% snproj = num2str(PROJdgn.nproj,'%4.0f');
% if strcmp(DESTYPE.name,'B')
%     DESMETH.name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_S',SPIN.name];
% else
%     DESMETH.name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_S',SPIN.name,'_',DESTYPE.name];    
% end
    
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
% DESMETH.CACC = CACC;
% DESMETH.T0 = DESTYPE.T;
% DESMETH.KSA = DESTYPE.KSA;

%------------------------------------------
% Create test plots etc..
%------------------------------------------
% func = str2func([DESTYPE.method,'_Func']);     
% INPUT.DESMETH = DESMETH;
% INPUT.func = 'Test';      
% [DESTYPE,err] = func(DESTYPE,INPUT);
% if err.flag
%     return
% end
% clear INPUT;
% 
% if isfield(DESTYPE.TST,'Figure')
%     DESMETH.Figure = DESTYPE.TST.Figure;
% end
% DESMETH.PanelOutput = DESTYPE.TST.PanelOutput;
% DESMETH.Panel2Imp = DESTYPE.TST.Panel2Imp;

Panel(1,:) = {'Method',PROJdgn.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DESMETH.PanelOutput = PanelOutput;
DESMETH.name = 'test'

Status('done','');
Status2('done','',2);
Status2('done','',3);


