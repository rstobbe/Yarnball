%=========================================================
% 
%=========================================================

function [default] = TrajEnd_ConstantSpoil3Chan_v1d_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndSlp (mT/m/ms)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gmax (mT/m)';
default{m,1}.entrystr = '60';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SpoilFactorMag';
default{m,1}.entrystr = '2';

