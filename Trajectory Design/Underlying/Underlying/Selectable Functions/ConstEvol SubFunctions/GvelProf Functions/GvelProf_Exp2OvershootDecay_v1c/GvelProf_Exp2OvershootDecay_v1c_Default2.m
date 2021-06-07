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
default{m,1}.labelstr = 'OshootDecayRate';
default{m,1}.entrystr = '0.17';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'OshootDecayShiftFrac';
default{m,1}.entrystr = '0.2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndDropRate';
default{m,1}.entrystr = '0.10';


