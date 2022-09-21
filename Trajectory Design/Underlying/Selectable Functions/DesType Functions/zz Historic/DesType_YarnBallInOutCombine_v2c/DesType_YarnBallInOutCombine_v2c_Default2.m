%=========================================================
% 
%=========================================================

function [default] = DesType_YarnBallInOutCombine_v2c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    turnevolutionpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\TurnEvolution Functions\'];
    spinpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\Spin Functions\'];      
    elippath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\Elip Functions\'];   
    genprojpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\GenProj Functions\'];
    radaccpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\RadialAcc Functions\'];
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\ProjSamp Functions\'];
    ORNTpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\Orient Functions\'];
elseif strcmp(filesep,'/')
end
ORNTfunc = 'Orient_YarnFlex_v2a'; 
genprojfunc = 'GenProj_Navy_v2e';
elipfunc = 'Elip_YarnBallIso_v2a';
spinfunc = 'Spin_Worsted_v2d';
radaccfunc = 'RadialAcc_Ramp2Uniform_v2a';
turnevolutionfunc = 'TurnEvolution_ExpRadStop_v2a';
ProjSampfunc = 'ProjSamp_Standard_v2a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FoV (mm)';
default{m,1}.entrystr = '230';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Vox (mm)';
default{m,1}.entrystr = '1.8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tro (ms)';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GenProjfunc';
default{m,1}.entrystr = genprojfunc;
default{m,1}.searchpath = genprojpath;
default{m,1}.path = [genprojpath,genprojfunc];

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
default{m,1}.labelstr = 'RadialAccfunc';
default{m,1}.entrystr = radaccfunc;
default{m,1}.searchpath = radaccpath;
default{m,1}.path = [radaccpath,radaccfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TurnEvolutionfunc';
default{m,1}.entrystr = turnevolutionfunc;
default{m,1}.searchpath = turnevolutionpath;
default{m,1}.path = [turnevolutionpath,turnevolutionfunc];

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TurnSlope';
default{m,1}.entrystr = '8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TurnEnd';
default{m,1}.entrystr = '1.0001';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RphsTurnSlope';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RphsTurnEnd';
default{m,1}.entrystr = '1.002';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RphsTro (ms)';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjSampfunc';
default{m,1}.entrystr = ProjSampfunc;
default{m,1}.searchpath = ProjSamppath;
default{m,1}.path = [ProjSamppath,ProjSampfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = ORNTfunc;
default{m,1}.searchpath = ORNTpath;
default{m,1}.path = [ORNTpath,ORNTfunc];
