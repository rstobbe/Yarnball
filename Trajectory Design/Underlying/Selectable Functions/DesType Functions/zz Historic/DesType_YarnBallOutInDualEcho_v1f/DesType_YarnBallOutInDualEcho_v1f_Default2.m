%=========================================================
% 
%=========================================================

function [default] = DesType_YarnBallOutInDualEcho_v1f_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    turnevolutionpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\TurnEvolution Functions\']; 
    turnsolutionpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\TurnSolution Functions\']; 
    testpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\General\DesTest Functions\YarnBall\YarnBallOutInDualEcho\'];   
elseif strcmp(filesep,'/')
end
turnevolutionfunc = 'TurnEvolution_Erf_v1d';
turnsolutionfunc = 'TurnSolution_NoOvershoot_v1a';
testfunc = 'DesTest_YarnBallOutInDualEchoStandard_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TurnEvolutionfunc';
default{m,1}.entrystr = turnevolutionfunc;
default{m,1}.searchpath = turnevolutionpath;
default{m,1}.path = [turnevolutionpath,turnevolutionfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TurnSolutionfunc';
default{m,1}.entrystr = turnsolutionfunc;
default{m,1}.searchpath = turnsolutionpath;
default{m,1}.path = [turnsolutionpath,turnsolutionfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DesTestfunc';
default{m,1}.entrystr = testfunc;
default{m,1}.searchpath = testpath;
default{m,1}.path = [testpath,testfunc];