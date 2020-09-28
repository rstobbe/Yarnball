%=========================================================
% 
%=========================================================

function [default] = GvelProf_Exp2Decay_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tau (%)';
default{m,1}.entrystr = '0.004';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'StartFrac (%)';
default{m,1}.entrystr = '140';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayRate';
default{m,1}.entrystr = '17';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayShift (%)';
default{m,1}.entrystr = '13';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndDrop (%)';
default{m,1}.entrystr = '11';


