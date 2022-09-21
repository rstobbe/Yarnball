%=========================================================
% 
%=========================================================

function [default] = DesType_YarnBallOutRphsSingleEcho_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    turnevolutionpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\TurnEvolution Functions\']; 
    turnsolutionpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\TurnSolution Functions\']; 
    testpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\General\DesTest Functions\YarnBall\YarnBallOutInDualEcho\'];   
elseif strcmp(filesep,'/')
end
turnevolutionfunc = 'TurnEvolution_Erf_v2a';
turnsolutionfunc = 'TurnSolution_NoOvershoot_v2a';
testfunc = 'DesTest_YarnBallOutRphsSingleEchoStandard_v2a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RphsTro (ms)';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RphsSlope';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RphsSpinReduce';
default{m,1}.entrystr = '0.5';

m = m+1;
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