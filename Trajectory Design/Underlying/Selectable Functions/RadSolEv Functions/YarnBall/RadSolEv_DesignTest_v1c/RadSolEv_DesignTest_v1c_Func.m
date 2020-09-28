%====================================================
%
%====================================================

function [RADEV,err] = RadSolEv_DesignTest_v1c_Func(RADEV,INPUT)

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
RADEV.deradsoloutfunc = '1';
RADEV.deradsolinfunc = '1';

%---------------------------------------------
% Solution Tolerences
%---------------------------------------------
RADEV.intol = 2e-5;        
RADEV.outtol = 5e-14;  

%---------------------------------------------
% Other
%---------------------------------------------
RADEV.relprojlenmeas = 'Yes';
RADEV.constevol = 'No';

Status2('done','',3);
