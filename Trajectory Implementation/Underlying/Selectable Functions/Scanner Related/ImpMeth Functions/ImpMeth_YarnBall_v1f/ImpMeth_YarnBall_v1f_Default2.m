%=========================================================
% 
%=========================================================

function [default] = ImpMeth_YarnBall_v1f_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    imptypepath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\ImpType Functions\'];
    DEsoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\DeSolTim Functions\']; 
    solfinepath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\SolFineTest Functions\']; 
    timadjpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\TimingAdjust Functions\']; 
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\ProjSamp Functions\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\TrajSamp Functions\'];
    TrajEndpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\TrajEnd Functions\']; 
    ORNTpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\Orient Functions\'];
    KSMPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\ImCon Related\kSamp Functions\'];     
    SYSRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\SysResp SubFunctions\']; 
elseif strcmp(filesep,'/')
end
ORNTfunc = 'Orient_Flexible_v1d'; 
imptypefunc = 'ImpType_YarnBallOutSingleEcho_v1e';
DEsoltimfunc = 'DeSolTim_YarnBallLookupImp_v1d';
solfinefunc = 'SolFineTest_YarnBall_v1b';
timadjfunc = 'TimingAdjust_ImpProfile_v1e';
TrajEndfunc = 'TrajEnd_StandardSpoil_v1f';
TrajSampfunc = 'TrajSamp_SiemensStandard_v3i';
KSMPfunc = 'kSamp_Standard_v1c';
ProjSampfunc = 'ProjSamp_Standard_v1a';
SYSRESPfunc = 'SysResp_FromFileWithComp_v1j'; 

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = ORNTfunc;
default{m,1}.searchpath = ORNTpath;
default{m,1}.path = [ORNTpath,ORNTfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = DEsoltimfunc;
default{m,1}.searchpath = DEsoltimpath;
default{m,1}.path = [DEsoltimpath,DEsoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SolFineTestfunc';
default{m,1}.entrystr = solfinefunc;
default{m,1}.searchpath = solfinepath;
default{m,1}.path = [solfinepath,solfinefunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TimingAdjustfunc';
default{m,1}.entrystr = timadjfunc;
default{m,1}.searchpath = timadjpath;
default{m,1}.path = [timadjpath,timadjfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImpTypefunc';
default{m,1}.entrystr = imptypefunc;
default{m,1}.searchpath = imptypepath;
default{m,1}.path = [imptypepath,imptypefunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajEndfunc';
default{m,1}.entrystr = TrajEndfunc;
default{m,1}.searchpath = TrajEndpath;
default{m,1}.path = [TrajEndpath,TrajEndfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysRespfunc';
default{m,1}.entrystr = SYSRESPfunc;
default{m,1}.searchpath = SYSRESPpath;
default{m,1}.path = [SYSRESPpath,SYSRESPfunc];

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

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjSampfunc';
default{m,1}.entrystr = ProjSampfunc;
default{m,1}.searchpath = ProjSamppath;
default{m,1}.path = [ProjSamppath,ProjSampfunc];

