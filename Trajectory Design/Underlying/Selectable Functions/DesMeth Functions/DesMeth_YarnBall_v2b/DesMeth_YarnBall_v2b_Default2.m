%=========================================================
% 
%=========================================================

function [default] = DesMeth_YarnBall_v2b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    destypepath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\DesType Functions\'];
    Nucpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\Nucleus Functions\'];
    Syspath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\Sys Functions\'];
elseif strcmp(filesep,'/')
end
destypefunc = 'DesType_YarnBallOutRphsSingleEcho_v2c';
Nucfunc = 'H1_v1a';
Sysfunc = 'Sys_SiemensPrisma_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Sysfunc';
default{m,1}.entrystr = Sysfunc;
default{m,1}.searchpath = Syspath;
default{m,1}.path = [Syspath,Sysfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Nucfunc';
default{m,1}.entrystr = Nucfunc;
default{m,1}.searchpath = Nucpath;
default{m,1}.path = [Nucpath,Nucfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DesTypefunc';
default{m,1}.entrystr = destypefunc;
default{m,1}.searchpath = destypepath;
default{m,1}.path = [destypepath,destypefunc];


