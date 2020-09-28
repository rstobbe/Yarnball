%====================================================
% (v1e)
%   - just IMPTYPE -> DESTYPE (naming change)
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_YarnBallLookupKnee_v1e(SCRPTipt,DESOLipt)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESOL.method = DESOLipt.Func;
DESOL.radevfunc = DESOLipt.('RadSolEvfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = DESOLipt.Struct.labelstr;
RADEVipt = DESOLipt.('RadSolEvfunc');
if isfield(DESOLipt,([CallingFunction,'_Data']))
    if isfield(DESOLipt.([CallingFunction,'_Data']),('RadSolEvfunc_Data'))
        RADEVipt.RadSolEvfunc_Data = DESOLipt.([CallingFunction,'_Data']).RadSolEvfunc_Data;
    end
end
func = str2func(DESOL.radevfunc);           
[SCRPTipt,RADEV,err] = func(SCRPTipt,RADEVipt);
if err.flag
    return
end
DESOL.RADEV = RADEV;

Status2('done','',2);
Status2('done','',3);