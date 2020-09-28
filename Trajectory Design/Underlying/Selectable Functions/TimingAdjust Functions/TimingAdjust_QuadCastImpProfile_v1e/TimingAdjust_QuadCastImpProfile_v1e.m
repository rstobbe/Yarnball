%====================================================
% (v1e)
%   - interpolate timing for full solution fineness here
%   - purpose to facilitate 'elip'
%====================================================

function [SCRPTipt,TIMADJ,err] = TimingAdjust_QuadCastImpProfile_v1e(SCRPTipt,TIMADJipt)

Status2('busy','Get Timing Adjust',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
TIMADJ.method = TIMADJipt.Func;   
TIMADJ.gvelprof = TIMADJipt.('GvelProf').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GVPipt = TIMADJipt.('GvelProf');
if isfield(TIMADJipt,('GvelProf_Data'))
    GVPipt.GvelProf_Data = TIMADJipt.GvelProf_Data;
end

%------------------------------------------
% Get RadEvfunc Info
%------------------------------------------
func = str2func(TIMADJ.gvelprof);           
[SCRPTipt,GVP,err] = func(SCRPTipt,GVPipt);
if err.flag
    return
end

%---------------------------------------------
% Describe Acceleration Constraint
%---------------------------------------------
CACC.method = 'ConstEvol_ShapeAlongTraj_v1c';

TIMADJ.CACC = CACC;
TIMADJ.GVP = GVP;

Status2('done','',3);