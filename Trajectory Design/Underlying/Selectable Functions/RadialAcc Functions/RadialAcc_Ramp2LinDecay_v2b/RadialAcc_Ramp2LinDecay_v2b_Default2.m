%=========================================================
% 
%=========================================================

function [default] = RadialAcc_Ramp2LinDecay_v2b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RampRate';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayShift';
default{m,1}.entrystr = '0.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayRate';
default{m,1}.entrystr = '0.5';
