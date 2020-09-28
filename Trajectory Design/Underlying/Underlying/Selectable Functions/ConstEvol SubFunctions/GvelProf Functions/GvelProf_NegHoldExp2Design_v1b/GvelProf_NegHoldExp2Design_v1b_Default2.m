%=========================================================
% 
%=========================================================

function [default] = GvelProf_NegHoldExp2Design_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Hold (ms)';
default{m,1}.entrystr = '0.2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tau (%)';
default{m,1}.entrystr = '0.2';


