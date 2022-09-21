%====================================================
% (v2a)
%       -remove trajectory generation
%====================================================

function [SCRPTipt,TIMADJ,err] = TimingAdjust_DesignTest_v2a(SCRPTipt,TIMADJipt)

Status2('busy','Get Timing Adjust',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
TIMADJ.method = TIMADJipt.Func;   

%---------------------------------------------
% Describe Acceleration Constraint
%---------------------------------------------
CACC.method = 'ConstEvol_Simple_v1b';
TIMADJ.CACC = CACC;

Status2('done','',3);