%====================================================
%
%====================================================

function [default] = Implement_Yarnball_v4a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    ImpMethpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\ImpMeth Functions\'];
elseif strcmp(filesep,'/')
end
ImpMethfunc = 'ImpMeth_YarnBall_v2b';

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
