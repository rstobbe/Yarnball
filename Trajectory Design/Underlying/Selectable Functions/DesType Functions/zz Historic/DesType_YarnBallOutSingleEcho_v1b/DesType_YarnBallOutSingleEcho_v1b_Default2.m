%=========================================================
% 
%=========================================================

function [default] = DesType_YarnBallOutSingleEcho_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    testpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\General\DesTest Functions\YarnBall\YarnBallOutSingleEcho\'];   
elseif strcmp(filesep,'/')
end
testfunc = 'DesTest_YarnBallOutSingleEchoStandard_v1c';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DesTestfunc';
default{m,1}.entrystr = testfunc;
default{m,1}.searchpath = testpath;
default{m,1}.path = [testpath,testfunc];
