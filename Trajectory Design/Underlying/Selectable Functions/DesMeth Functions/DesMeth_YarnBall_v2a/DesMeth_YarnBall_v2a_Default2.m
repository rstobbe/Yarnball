%=========================================================
% 
%=========================================================

function [default] = DesMeth_YarnBall_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    spinpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\Spin Functions\'];      
    desoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\DeSoltim Functions\']; 
    timadjpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\TimingAdjust Functions\']; 
    elippath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\Elip Functions\']; 
    colourpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\Colour Functions\'];     
    genprojpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\GenProj Functions\'];
    destypepath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\DesType Functions\'];
    radevpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\RadSolEv Functions\'];   
elseif strcmp(filesep,'/')
end
genprojfunc = 'GenProj_YarnBall_v1c';
colourfunc = 'Colour_Gold_v2a';
destypefunc = 'DesType_YarnBallOutRphsSingleEcho_v2a';
elipfunc = 'Elip_Isotropic_v1a';
spinfunc = 'Spin_Worsted_v2a';
desoltimfunc = 'DeSolTim_YarnBallLookupDesignTest_v2a';
timadjfunc = 'TimingAdjust_DesignTest_v1a';
radevfunc = 'RadSolEv_DesignTest_v2a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GenProjfunc';
default{m,1}.entrystr = genprojfunc;
default{m,1}.searchpath = genprojpath;
default{m,1}.path = [genprojpath,genprojfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Colourfunc';
default{m,1}.entrystr = colourfunc;
default{m,1}.searchpath = colourpath;
default{m,1}.path = [colourpath,colourfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Elipfunc';
default{m,1}.entrystr = elipfunc;
default{m,1}.searchpath = elippath;
default{m,1}.path = [elippath,elipfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Spinfunc';
default{m,1}.entrystr = spinfunc;
default{m,1}.searchpath = spinpath;
default{m,1}.path = [spinpath,spinfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RadSolfunc';
default{m,1}.entrystr = radevfunc;
default{m,1}.searchpath = radevpath;
default{m,1}.path = [radevpath,radevfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = desoltimfunc;
default{m,1}.searchpath = desoltimpath;
default{m,1}.path = [desoltimpath,desoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TimingAdjustfunc';
default{m,1}.entrystr = timadjfunc;
default{m,1}.searchpath = timadjpath;
default{m,1}.path = [timadjpath,timadjfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DesTypefunc';
default{m,1}.entrystr = destypefunc;
default{m,1}.searchpath = destypepath;
default{m,1}.path = [destypepath,destypefunc];


