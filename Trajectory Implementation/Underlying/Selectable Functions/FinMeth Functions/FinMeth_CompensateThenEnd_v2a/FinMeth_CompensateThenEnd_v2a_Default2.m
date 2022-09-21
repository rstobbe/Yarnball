%=========================================================
% 
%=========================================================

function [default] = FinMeth_CompensateThenEnd_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    SYSRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\Scanner Related\SysResp SubFunctions\']; 
elseif strcmp(filesep,'/')
end
SYSRESPfunc = 'SysResp_ForWindBackIn_v2a'; 

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysRespfunc';
default{m,1}.entrystr = SYSRESPfunc;
default{m,1}.searchpath = SYSRESPpath;
default{m,1}.path = [SYSRESPpath,SYSRESPfunc];
