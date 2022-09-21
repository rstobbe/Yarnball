%=========================================================
% 
%=========================================================

function [default] = ImpMeth_YarnBall_v2b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Buildpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\Testing Functions\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\TrajSamp Functions\'];
    TrajEndpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\TrajEnd Functions\']; 
    KSMPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\ImCon Related\kSamp Functions\'];     
    FinMethpath = [];
elseif strcmp(filesep,'/')
end
TrajEndfunc = 'TrajEnd_Dummy_v2a';
TrajSampfunc = 'TrajSamp_SiemensStandard_v2a';
KSMPfunc = 'kSamp_Standard_v2a';
FinMethfunc = 'FinMeth_CompensateThenEnd_v2a';
Buildfunc = 'Build_ForStimTest_v2a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Buildfunc';
default{m,1}.entrystr = Buildfunc;
default{m,1}.searchpath = Buildpath;
default{m,1}.path = [Buildpath,Buildfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FinMethfunc';
default{m,1}.entrystr = FinMethfunc;
default{m,1}.searchpath = FinMethpath;
default{m,1}.path = [FinMethpath,FinMethfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajEndfunc';
default{m,1}.entrystr = TrajEndfunc;
default{m,1}.searchpath = TrajEndpath;
default{m,1}.path = [TrajEndpath,TrajEndfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajSampfunc';
default{m,1}.entrystr = TrajSampfunc;
default{m,1}.searchpath = TrajSamppath;
default{m,1}.path = [TrajSamppath,TrajSampfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = KSMPfunc;
default{m,1}.searchpath = KSMPpath;
default{m,1}.path = [KSMPpath,KSMPfunc];



