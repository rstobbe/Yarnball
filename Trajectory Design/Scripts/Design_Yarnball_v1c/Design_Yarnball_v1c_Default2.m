%====================================================
%
%====================================================

function [default] = Design_Yarnball_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    desmethpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\DesMeth Functions\DesMeth_YarnBall_v1c\'];      
elseif strcmp(filesep,'/')
end
desmethfunc = 'DesMeth_YarnBall_v1g';

FoV = 180;
Vox = 1;
Tro = 10;
Nproj = 2016;

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Design_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FoV (mm)';
default{m,1}.entrystr = FoV;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Vox (mm)';
default{m,1}.entrystr = Vox;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tro (ms)';
default{m,1}.entrystr = Tro;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Nproj';
default{m,1}.entrystr = Nproj;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DesMethfunc';
default{m,1}.entrystr = desmethfunc;
default{m,1}.searchpath = desmethpath;
default{m,1}.path = [desmethpath,desmethfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'LR1';
default{m,1}.labelstr = 'Design';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';



