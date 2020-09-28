%====================================================
% 
%====================================================

function [TST,err] = TrajTest_ImpBasicVisuals_v1b_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

TST.testing = 'No';
TST.timecast = 'QuadCast';

TST.DESOL.Vis = 'No';
TST.CACC.Vis = 'No';
TST.SYSRESP.Vis = 'No';
TST.SOLFINTEST.Vis = 'No';
TST.IMPTYPE.Vis = 'No';
TST.GVis = 'Yes';
TST.KVis = 'No';
TST.IMETH.panel = 'full';

if strcmp(TST.figloc,'Centre')
    TST.figshift = 0;
elseif strcmp(TST.figloc,'Left')
    TST.figshift = -1920;    
elseif strcmp(TST.figloc,'Right')
    TST.figshift = 1920;
end

Status('done','');
Status2('done','',2);
Status2('done','',3);

