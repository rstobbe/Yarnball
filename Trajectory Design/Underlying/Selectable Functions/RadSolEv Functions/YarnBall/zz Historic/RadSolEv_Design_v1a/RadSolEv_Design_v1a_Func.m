%====================================================
%
%====================================================

function [RADEV,err] = RadSolEv_Design_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solution',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsoloutfunc = '(1/p^2)';
RADEV.deradsolinfunc = '(1/p^2)';

%---------------------------------------------
% Solution Tolerences
%---------------------------------------------
RADEV.intol = 5e-7;        
RADEV.outtol = 5e-14;  

%---------------------------------------------
% Other
%---------------------------------------------
RADEV.relprojlenmeas = 'Yes';
RADEV.constevol = 'No';

Status2('done','',3);
