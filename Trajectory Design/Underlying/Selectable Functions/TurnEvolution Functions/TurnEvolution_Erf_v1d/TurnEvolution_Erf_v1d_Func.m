%====================================================
%
%====================================================

function [TURNEVO,err] = TurnEvolution_Erf_v1d_Func(TURNEVO,INPUT)

Status2('done','Turn Evolution',3);

err.flag = 0;
err.msg = '';

turnloc = INPUT.turnloc;
fiddle = INPUT.fiddle;
clear INPUT;

%---------------------------------------------
% Turn Function
%---------------------------------------------
Start = 1;
Slope = TURNEVO.slope;
TURNEVO.turnradfunc = @(p,r) (p^2/r^2)*(1 - erf(Start+Slope*(1-(turnloc+fiddle)^2)) + erf(Start+Slope*(1-(r+fiddle)^2)));
TURNEVO.turnspinfunc = @(p,r) (p^2/r^2);

Status2('done','',3);

