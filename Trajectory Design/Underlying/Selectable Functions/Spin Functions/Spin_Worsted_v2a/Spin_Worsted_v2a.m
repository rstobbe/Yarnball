%====================================================
% (v2a)
%    - v2: update to what 'RelativeSpin' means
%====================================================

function [SCRPTipt,SPIN,err] = Spin_Worsted_v2a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.nspokes = str2double(SPINipt.('NumSpokes'));
SPIN.ndiscs = str2double(SPINipt.('NumDiscs'));
SPIN.RelativeSpin = str2double(SPINipt.('RelativeSpin'));

Status2('done','',2);
Status2('done','',3);
