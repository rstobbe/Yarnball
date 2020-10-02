%=========================================================
% 
%=========================================================

function [default] = GvelProf_Exp2LinearDecay_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tau';
default{m,1}.entrystr = '0.02';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayStart';
default{m,1}.entrystr = '0.35';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayRate';
default{m,1}.entrystr = '0.25';


