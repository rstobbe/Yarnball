%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_None_v1a_Func(CACC,INPUT)

Status2('busy','Constrain Trajectory Evolution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return
%--------------------------------------------- 
CACC.PanelOutput = struct();
CACC.doconstraint = 'No';

Status2('done','',2);
Status2('done','',3);


