%=========================================================
% 
%=========================================================

function [default] = ImpType_YarnBallOutSingleEcho_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    SYSRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\SysResp SubFunctions\']; 
    FINMETHpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\FinMeth SubFunctions\']; 
elseif strcmp(filesep,'/')
end
FINMETHfunc = 'FinMeth_EndThenCompensate_v1a'; 
SYSRESPfunc = 'SysResp_FromFileWithComp_v1i'; 

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FinMethfunc';
default{m,1}.entrystr = FINMETHfunc;
default{m,1}.searchpath = FINMETHpath;
default{m,1}.path = [FINMETHpath,FINMETHfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysRespfunc';
default{m,1}.entrystr = SYSRESPfunc;
default{m,1}.searchpath = SYSRESPpath;
default{m,1}.path = [SYSRESPpath,SYSRESPfunc];
