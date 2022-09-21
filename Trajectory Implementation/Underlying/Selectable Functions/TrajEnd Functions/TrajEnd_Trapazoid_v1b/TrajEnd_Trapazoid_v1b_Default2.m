%=========================================================
% 
%=========================================================

function [default] = TrajEnd_Trapazoid_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slope (mT/m/ms)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gmag (mT/m)';
default{m,1}.entrystr = '50';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SpoilFactor';
default{m,1}.entrystr = '1';

