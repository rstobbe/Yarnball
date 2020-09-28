%=========================================================
% 
%=========================================================

function [default] = DeSolTim_YarnBallLookup_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    radevpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\RadSolEv Functions\']; 
elseif strcmp(filesep,'/')
end
radevfunc = 'RadSolEv_ForConstEvol_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RadSolEvfunc';
default{m,1}.entrystr = radevfunc;
default{m,1}.searchpath = radevpath;
default{m,1}.path = [radevpath,radevfunc];
