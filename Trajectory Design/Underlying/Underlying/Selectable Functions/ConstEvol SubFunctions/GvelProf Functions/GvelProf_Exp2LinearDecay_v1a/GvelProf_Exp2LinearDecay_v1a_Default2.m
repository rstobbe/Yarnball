%=========================================================
% 
%=========================================================

function [default] = GvelProf_Exp2LinerDecay_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'tau (%)';
default{m,1}.entrystr = '0.012';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'decaystart (%)';
default{m,1}.entrystr = '35';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'decayrate (%)';
default{m,1}.entrystr = '25';


