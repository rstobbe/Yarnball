%====================================================
%
%====================================================

function [TIMADJ,err] = TimingAdjust_DesignTest_v1a_Func(TIMADJ,INPUT)

Status2('busy','Adjust Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PSMP = INPUT.PSMP;
GENPRJ = INPUT.GENPRJ;
DESTYPE = INPUT.DESTYPE;
DESOL = INPUT.DESOL;
TST = INPUT.TST;
CACC = TIMADJ.CACC;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if isfield(TST,'IMPTYPE')
    err.flag = 1;
    err.msg = 'This ''TimingAdjust'' function is for design';
    return
end

%---------------------------------------------
% Generate one outward trajectory
%---------------------------------------------
func = str2func([GENPRJ.method,'_Func']);    
INPUT.rad0 = PROJdgn.p;
INPUT.phi0 = PSMP.phi;
INPUT.theta0 = PSMP.theta;
INPUT.dir = 1;
INPUT.DESTYPE = DESTYPE;
INPUT.PROJdgn.elip = 1;
[GENPRJ,err] = func(GENPRJ,INPUT);
if err.flag
    return
end
clear INPUT; 

%---------------------------------------------
% Constrain acceleration
%---------------------------------------------
func = str2func([CACC.method,'_Func']);  
CACC.Vis = TST.CACC.Vis;
INPUT.kArr = squeeze(GENPRJ.KSA);
INPUT.TArr = DESOL.T;
INPUT.PROJdgn = PROJdgn;
INPUT.RADEV = DESOL.RADEV;
INPUT.TST = TST;
INPUT.check = 0;
[CACC,err] = func(CACC,INPUT);
if err.flag == 1
    return
end
clear INPUT;   

%---------------------------------------------
% Return
%---------------------------------------------
TIMADJ.CACC = CACC;

Status2('done','',2);
Status2('done','',3);



    