%=========================================================
% 
%=========================================================

function [default] = TrajEnd_Spoil1ChanZeroOthers_v1e_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndSlp (mT/m/ms)';
default{m,1}.entrystr = '150';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gmax (mT/m)';
default{m,1}.entrystr = '50';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SpoilFactor';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Dir';
default{m,1}.entrystr = 'y';
default{m,1}.options = {'x','y','z'};


