%====================================================
% (v1d)
%   - remove 'start'
%   - include 'fiddle' as input
%====================================================

function [SCRPTipt,TURN,err] = TurnEvolution_Erf_v1d(SCRPTipt,TURNipt)

Status2('busy','Turn Evolution',3);

err.flag = 0;
err.msg = '';

TURN.method = TURNipt.Func;
TURN.slope = str2double(TURNipt.('Slope'));

Status2('done','',3);