%==================================================
% (v1g)
%       - CACC back into DesType for mod
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_YarnBall_v1g(SCRPTipt,DESMETHipt)

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

%------------------------------------------
% Get Elip Function Info
%------------------------------------------
func = str2func(DESMETH.elipfunc);           
[SCRPTipt,ELIP,err] = func(SCRPTipt,ELIPipt);
if err.flag
    return
end

%------------------------------------------
% Get Spinning Function Info
%------------------------------------------
func = str2func(DESMETH.spinfunc);           
[SCRPTipt,SPIN,err] = func(SCRPTipt,SPINipt);
if err.flag
    return
end

%------------------------------------------
% Get DE Solution Timing Function Info
%------------------------------------------
func = str2func(DESMETH.desoltimfunc);           
[SCRPTipt,DESOL,err] = func(SCRPTipt,DESOLipt);
if err.flag
    return
end

%------------------------------------------
% Get Timing Adjust Info
%------------------------------------------
func = str2func(DESMETH.timadjfunc);           
[SCRPTipt,TIMADJ,err] = func(SCRPTipt,TIMADJipt);
if err.flag
    return
end

%------------------------------------------
% Get Colour Info
%------------------------------------------
func = str2func(DESMETH.colourfunc);           
[SCRPTipt,CLR,err] = func(SCRPTipt,CLRipt);
if err.flag
    return
end

%------------------------------------------
% Get GenProj Info
%------------------------------------------
func = str2func(DESMETH.colourfunc);           
[SCRPTipt,GENPRJ,err] = func(SCRPTipt,GENPRJipt);
if err.flag
    return
end

%------------------------------------------
% Get DesType Info
%------------------------------------------
func = str2func(DESMETH.destypefunc);           
[SCRPTipt,DESTYPE,err] = func(SCRPTipt,DESTYPEipt);
if err.flag
    return
end

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

Status2('done','',2);
Status2('done','',3);

