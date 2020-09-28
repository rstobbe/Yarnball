%=========================================================
% 
%=========================================================

function [default] = TrajEnd_HoldDropConstMag_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SpoilFactor';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndSlp (mT/m/ms)';
default{m,1}.entrystr = '100';