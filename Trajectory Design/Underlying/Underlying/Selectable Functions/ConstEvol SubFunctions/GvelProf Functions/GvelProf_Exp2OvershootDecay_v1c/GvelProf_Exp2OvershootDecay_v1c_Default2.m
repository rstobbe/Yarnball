%=========================================================
% 
%=========================================================

function [default] = GvelProf_Exp2OvershootDecay_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tau';
default{m,1}.entrystr = '0.02';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Overshoot';
default{m,1}.entrystr = '1.4';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'OvershootDecay';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayShift';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndDrop';
default{m,1}.entrystr = '0.10';


