%=========================================================
% 
%=========================================================

function [default] = Elip_Selection_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'VoxelStretch';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'YbAxisElip';
default{m,1}.entrystr = 'z';
default{m,1}.options = {'x','y','z'};
