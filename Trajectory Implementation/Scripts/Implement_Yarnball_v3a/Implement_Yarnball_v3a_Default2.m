%====================================================
%
%====================================================

function [default] = Implement_Yarnball_v3a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Testpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\Testing Functions\'];
    Nucpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\Nucleus Functions\'];
    Syspath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\Sys Functions\'];
    ImpMethpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\ImpMeth Functions\'];
elseif strcmp(filesep,'/')
end
Nucfunc = 'H1_v1a';
Testfunc = 'TrajTest_ImpFullVisuals_v1b';
Sysfunc = 'Sys_SiemensPrisma_v1a';
ImpMethfunc = 'ImpMeth_YarnBall_v1e';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Imp_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Des_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajDesCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadTrajDesDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajTestfunc';
default{m,1}.entrystr = Testfunc;
default{m,1}.searchpath = Testpath;
default{m,1}.path = [Testpath,Testfunc];

m = m+1;
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
default{m,1}.labelstr = 'ImpMethfunc';
default{m,1}.entrystr = ImpMethfunc;
default{m,1}.searchpath = ImpMethpath;
default{m,1}.path = [ImpMethpath,ImpMethfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'LRimp';
default{m,1}.labelstr = 'Implement';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
