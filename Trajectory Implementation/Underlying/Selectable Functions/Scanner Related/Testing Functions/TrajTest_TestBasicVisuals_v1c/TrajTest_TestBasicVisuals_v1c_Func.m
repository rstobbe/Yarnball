%====================================================
% 
%====================================================

function [TST,err] = TrajTest_TestBasicVisuals_v1c_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

TST.testing = 'Yes';
TST.savelots = 'Yes';
TST.traj = 'TestSet';
TST.redraw = 'No';
TST.testspeed = 'Standard';
TST.timecast = 'QuadCast';

TST.DESOL.Vis = 'No';
TST.CACC.Vis = 'ProfOnly';
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

