%====================================================
% (v1d)
%   - remove 'Solve T at Evolution Constraint'
%====================================================

function [SCRPTipt,IMPTYPE,err] = ImpType_YarnBallOutSingleEcho_v1d(SCRPTipt,IMPTYPEipt)

Status2('busy','Get ImpType',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMPTYPE.method = IMPTYPEipt.Func;  
IMPTYPE.finmethfunc = IMPTYPEipt.('FinMethfunc').Func;
IMPTYPE.sysrespfunc = IMPTYPEipt.('SysRespfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = IMPTYPEipt.Struct.labelstr;
FINMETHipt = IMPTYPEipt.('FinMethfunc');
if isfield(IMPTYPEipt,([CallingFunction,'_Data']))
    if isfield(IMPTYPEipt.([CallingFunction,'_Data']),('FinMethfunc_Data'))
        FINMETHipt.FinMethfunc_Data = IMPTYPEipt.([CallingFunction,'_Data']).FinMethfunc_Data;
    end
end
SYSRESPipt = IMPTYPEipt.('SysRespfunc');
if isfield(IMPTYPEipt,([CallingFunction,'_Data']))
    if isfield(IMPTYPEipt.([CallingFunction,'_Data']),('SysRespfunc_Data'))
        SYSRESPipt.SysRespfunc_Data = IMPTYPEipt.([CallingFunction,'_Data']).SysRespfunc_Data;
    end
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(IMPTYPE.sysrespfunc);           
[SCRPTipt,SYSRESP,err] = func(SCRPTipt,SYSRESPipt);
if err.flag
    return
end
func = str2func(IMPTYPE.finmethfunc);           
[SCRPTipt,FINMETH,err] = func(SCRPTipt,FINMETHipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
IMPTYPE.SYSRESP = SYSRESP;
IMPTYPE.FINMETH = FINMETH;

Status2('done','',3);