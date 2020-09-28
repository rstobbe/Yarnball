%=========================================================
% 
%=========================================================

function [default] = GvelProf_RampNegExp2Design_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Ramp (mT/m/ms2)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DropStart (ms)';
default{m,1}.entrystr = '0.125';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tau (%)';
default{m,1}.entrystr = '0.002';


