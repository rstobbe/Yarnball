%====================================================
% (v1f)
%       - start YarnBallOutInDualEcho_v1f
%====================================================

function [SCRPTipt,DESTYPE,err] = DesType_YarnBallOutRphsSingleEcho_v1f(SCRPTipt,DESTYPEipt)

Status2('busy','Get DesType',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESTYPE.method = DESTYPEipt.Func;
DESTYPE.turnevolutionfunc = DESTYPEipt.('TurnEvolutionfunc').Func;
DESTYPE.turnsolutionfunc = DESTYPEipt.('TurnSolutionfunc').Func;
DESTYPE.testfunc = DESTYPEipt.('DesTestfunc').Func;
DESTYPE.RphsTro = str2double(DESTYPEipt.('RphsTro'));
DESTYPE.SpinReduce = str2double(DESTYPEipt.('SpinReduce'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TURNEVOipt = DESTYPEipt.('TurnEvolutionfunc');
if isfield(DESTYPEipt,('TurnEvolutionfunc_Data'))
    TURNEVOipt.TurnEvolutionfunc_Data = DESTYPEipt.TurnEvolutionfunc_Data;
end
TURNSOLipt = DESTYPEipt.('TurnSolutionfunc');
if isfield(DESTYPEipt,('TurnSolutionfunc_Data'))
    TURNSOLipt.TurnSolutionfunc_Data = DESTYPEipt.TurnSolutionfunc_Data;
end
TSTipt = DESTYPEipt.('DesTestfunc');
if isfield(DESTYPEipt,('DesTestfunc_Data'))
    TSTipt.DesTestfunc_Data = DESTYPEipt.DesTestfunc_Data;
end

%------------------------------------------
% Get DesType Info
%------------------------------------------
func = str2func(DESTYPE.turnevolutionfunc);           
[SCRPTipt,TURNEVO,err] = func(SCRPTipt,TURNEVOipt);
if err.flag
    return
end

%------------------------------------------
% Get Testing Info
%------------------------------------------
func = str2func(DESTYPE.turnsolutionfunc);           
[SCRPTipt,TURNSOL,err] = func(SCRPTipt,TURNSOLipt);
if err.flag
    return
end

%------------------------------------------
% Get Testing Info
%------------------------------------------
func = str2func(DESTYPE.testfunc);           
[SCRPTipt,TST,err] = func(SCRPTipt,TSTipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
DESTYPE.TURNEVO = TURNEVO;
DESTYPE.TURNSOL = TURNSOL;
DESTYPE.TST = TST;

Status2('done','',2);
Status2('done','',3);
