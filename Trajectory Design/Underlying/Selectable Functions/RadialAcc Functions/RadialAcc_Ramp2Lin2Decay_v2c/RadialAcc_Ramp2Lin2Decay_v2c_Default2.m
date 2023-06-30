%=========================================================
% 
%=========================================================

function [default] = RadialAcc_Ramp2Uniform_v2c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RampRate';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Beginning';
default{m,1}.entrystr = '0.9';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayShift1 (r)';
default{m,1}.entrystr = '0.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayRate1';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayShift2 (r)';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayRate2';
default{m,1}.entrystr = '0.5';
