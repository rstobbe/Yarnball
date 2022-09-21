%====================================================
%
%====================================================

function [TIMADJ,err] = TimingAdjust_DesignTest_v2a_Func(TIMADJ,INPUT)

Status2('busy','Adjust Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
GENPRJ = INPUT.GENPRJ;
DESTYPE = INPUT.DESTYPE;
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
% Constrain acceleration
%---------------------------------------------
func = str2func([CACC.method,'_Func']);  
CACC.Vis = TST.CACC.Vis;
if DESTYPE.DESTRCT.dir == 1
    INPUT.kArr = squeeze(GENPRJ.KSA);
    INPUT.TArr = DESTYPE.SLV.T;
else
    INPUT.kArr = flip(squeeze(GENPRJ.KSA));
    INPUT.TArr = flip(DESTYPE.SLV.T);
end
INPUT.TST = TST;
INPUT.check = 0;
INPUT.tro = DESTYPE.DESTRCT.tro;
INPUT.PROJdgn = PROJdgn;
INPUT.RADEV = DESTYPE.SLV.RADEV;
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



    