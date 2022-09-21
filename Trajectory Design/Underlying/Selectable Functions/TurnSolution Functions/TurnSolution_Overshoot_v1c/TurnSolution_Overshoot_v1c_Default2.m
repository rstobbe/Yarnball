%=========================================================
% 
%=========================================================

function [default] = TurnSolution_Overshoot_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelativeOvershoot';
default{m,1}.entrystr = '1.00025';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxRadDerivative';
default{m,1}.entrystr = '0.01';