%=========================================================
% 
%=========================================================

function [default] = GvelProf_HoldDrop_v1a_Default2(SCRPTPATHS)


m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayStart (ms)';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayShape';
default{m,1}.entrystr = '25';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndDrop (%)';
default{m,1}.entrystr = '25';


