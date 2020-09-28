%=========================================================
% 
%=========================================================

function [default] = TrajEnd_Spoil1ChanDropOther_v1d_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndSlpSpoil (mT/m/ms)';
default{m,1}.entrystr = '80';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndSlpDrop (mT/m/ms)';
default{m,1}.entrystr = '50';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gmax (mT/m)';
default{m,1}.entrystr = '60';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SpoilFactor';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Dir';
default{m,1}.entrystr = 'y';
default{m,1}.options = {'x','y','z'};


