%==================================================
% (v2a)
%       - Convert to Objects
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_YarnBall_v2a(SCRPTipt,DESMETHipt)

Status('busy','Create YarnBall Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESMETH.method = DESMETHipt.Func;
DESMETH.genprojfunc = DESMETHipt.('GenProjfunc').Func;
DESMETH.elipfunc = DESMETHipt.('Elipfunc').Func;
DESMETH.spinfunc = DESMETHipt.('Spinfunc').Func;
DESMETH.desoltimfunc = DESMETHipt.('DeSolTimfunc').Func;
DESMETH.timadjfunc = DESMETHipt.('TimingAdjustfunc').Func;
DESMETH.colourfunc = DESMETHipt.('Colourfunc').Func;
DESMETH.destypefunc = DESMETHipt.('DesTypefunc').Func;
DESMETH.radsolfunc = DESMETHipt.('RadSolfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GENPRJipt = DESMETHipt.('GenProjfunc');
if isfield(DESMETHipt,('GenProjfunc_Data'))
    GENPRJipt.GenProjfunc_Data = DESMETHipt.GenProjfunc_Data;
end
ELIPipt = DESMETHipt.('Elipfunc');
if isfield(DESMETHipt,('Elipfunc_Data'))
    ELIPipt.Elipfunc_Data = DESMETHipt.Elipfunc_Data;
end
SPINipt = DESMETHipt.('Spinfunc');
if isfield(DESMETHipt,('Spinfunc_Data'))
    SPINipt.Spinfunc_Data = DESMETHipt.Spinfunc_Data;
end
DESOLipt = DESMETHipt.('DeSolTimfunc');
if isfield(DESMETHipt,('DeSolTimfunc_Data'))
    DESOLipt.DeSolTimfunc_Data = DESMETHipt.DeSolTimfunc_Data;
end
TIMADJipt = DESMETHipt.('TimingAdjustfunc');
if isfield(DESMETHipt,('TimingAdjustfunc_Data'))
    TIMADJipt.TimingAdjustfunc_Data = DESMETHipt.TimingAdjustfunc_Data;
end
CLRipt = DESMETHipt.('Colourfunc');
if isfield(DESMETHipt,('Colourfunc_Data'))
    CLRipt.Colourfunc_Data = DESMETHipt.Colourfunc_Data;
end
DESTYPEipt = DESMETHipt.('DesTypefunc');
if isfield(DESMETHipt,('DesTypefunc_Data'))
    DESTYPEipt.DesTypefunc_Data = DESMETHipt.DesTypefunc_Data;
end
RADSOLipt = DESMETHipt.('RadSolfunc');
if isfield(DESMETHipt,('RadSolfunc_Data'))
    RADSOLipt.RadSolfunc_Data = DESMETHipt.RadSolfunc_Data;
end

%------------------------------------------
% Build Object Shells
%------------------------------------------
func = str2func(DESMETH.colourfunc);           
CLR = func(CLRipt);
func = str2func(DESMETH.genprojfunc);           
GENPRJ = func(GENPRJipt);
func = str2func(DESMETH.spinfunc);           
SPIN = func(SPINipt);
func = str2func(DESMETH.elipfunc);           
ELIP = func(ELIPipt);
func = str2func(DESMETH.radsolfunc);           
RADSOL = func(RADSOLipt);
func = str2func(DESMETH.desoltimfunc);           
DESOL = func(DESOLipt);
func = str2func(DESMETH.destypefunc);           
DESTYPE = func(DESTYPEipt);
func = str2func(DESMETH.timadjfunc);           
TIMADJ = func(TIMADJipt);

%------------------------------------------
% Return
%------------------------------------------
DESMETH.ELIP = ELIP;
DESMETH.SPIN = SPIN;
DESMETH.DESOL = DESOL;
DESMETH.TIMADJ = TIMADJ;
DESMETH.GENPRJ = GENPRJ;
DESMETH.CLR = CLR;
DESMETH.DESTYPE = DESTYPE;
DESMETH.RADSOL = RADSOL;

Status2('done','',2);
Status2('done','',3);

