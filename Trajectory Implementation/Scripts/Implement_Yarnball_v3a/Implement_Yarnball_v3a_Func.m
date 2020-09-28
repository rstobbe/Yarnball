%=========================================================
% 
%=========================================================

function [IMP,err] = Implement_Proj3D_v3a_Func(INPUT,IMP)

Status('busy','Implement Trajectory Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
TST = INPUT.TST;
NUC = INPUT.NUC;
SYS = INPUT.SYS;
IMETH = INPUT.IMETH;
clear INPUT;

%----------------------------------------------------
% Get Testing Info
%----------------------------------------------------
Status('busy','Get Testing Info');
func = str2func([IMP.testfunc,'_Func']);
INPUT = [];
[TST,err] = func(TST,INPUT);
if err.flag
    return
end

%----------------------------------------------------
% Get System Info
%----------------------------------------------------
Status('busy','Get System Info');
func = str2func([IMP.sysfunc,'_Func']);
INPUT = [];
[SYS,err] = func(SYS,INPUT);
if err.flag
    return
end
PROJimp.system = SYS.System;

%----------------------------------------------------
% Get Nucleus Info
%----------------------------------------------------
Status('busy','Get Nucleus Info');
func = str2func([IMP.nucfunc,'_Func']);
INPUT = [];
[NUC,err] = func(NUC,INPUT);
if err.flag
    return
end
PROJimp.nucleus = NUC.nucleus;
PROJimp.gamma = NUC.gamma;

%----------------------------------------------------
% Implement
%----------------------------------------------------
Status('busy','Implement Trajectory Design');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.TST = TST;  
INPUT.SYS = SYS;
INPUT.PROJimp = PROJimp;
[IMETH,err] = func(IMETH,INPUT);
if err.flag
    return
end
clear INPUT

PROJimp = IMETH.PROJimp;
impPROJdgn = IMETH.impPROJdgn;
PSMP = IMETH.PSMP;
TSMP = IMETH.TSMP;
KSMP = IMETH.KSMP;
ORNT = IMETH.ORNT;
CACC = IMETH.CACC;
DESOL = IMETH.DESOL;
RADEV = IMETH.RADEV;
TEND = IMETH.TEND;
GWFM = IMETH.GWFM;
SYSRESP = IMETH.SYSRESP;

%----------------------------------------------------
% Save Figure
%----------------------------------------------------
if isfield(IMETH,'Figure')
    IMP.Figure = IMETH.Figure;
    IMETH = rmfield(IMETH,'Figure');
end

%----------------------------------------------------
% Add Design to Panel Output
%----------------------------------------------------
Panel = [DES.Panel2Imp;IMETH.Panel];
IMP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);   

%----------------------------------------------------
% Output Structure
%----------------------------------------------------
IMP.PROJimp = PROJimp;
IMP.PROJdgn = DES.PROJdgn;
IMP.impPROJdgn = impPROJdgn;
IMP.SYS = SYS;
IMP.NUC = NUC;
IMP.TST = TST;
IMP.PSMP = PSMP;
IMP.GWFM = GWFM;
IMP.TSMP = TSMP;
IMP.KSMP = KSMP;
IMP.ORNT = ORNT;
IMP.CACC = CACC;
IMP.DESOL = DESOL;
IMP.RADEV = RADEV;
IMP.TEND = TEND;
IMP.SYSRESP = SYSRESP;
IMP.samp = IMETH.samp;
IMP.Kmat = IMETH.Kmat;
IMP.Kend = IMETH.Kend;
IMP.G = IMETH.Gscnr;
IMP.qTscnr = IMETH.qTscnr;

Status('done','');
Status2('done','',2);
Status2('done','',3);


