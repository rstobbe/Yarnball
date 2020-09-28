%====================================================
% 
%====================================================

function [SPIN,err] = Spin_Worsted_v2a_Func(SPIN,INPUT)

Status2('busy','Define Spinning Functions',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
clear INPUT;

%---------------------------------------------
% Find Constraint
%---------------------------------------------
if 2*SPIN.ndiscs < SPIN.nspokes
    SPIN.p = SPIN.ndiscs/(pi*PROJdgn.rad);
else
    SPIN.p = SPIN.nspokes/(2*pi*PROJdgn.rad);
end

%---------------------------------------------
% Calculate Spin Functions
%---------------------------------------------
SPIN.spincalcndiscsfunc = @(r) SPIN.ndiscs/SPIN.RelativeSpin;
SPIN.spincalcnspokesfunc = @(r) SPIN.nspokes/SPIN.RelativeSpin;
SPIN.nproj = SPIN.ndiscs*SPIN.nspokes;

%------------------------------------------
% Name
%------------------------------------------
undersamptot = SPIN.RelativeSpin;
SPIN.AziSampUsed = SPIN.RelativeSpin;
SPIN.PolSampUsed = SPIN.RelativeSpin;

SPIN.type = 'Worsted';
SPIN.number = num2str(100*undersamptot,'%3.0f');
SPIN.name = ['W',SPIN.number];
SPIN.GblSamp = undersamptot;

%--------------------------------------------- 
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',SPIN.method,'Output'};
Panel(2,:) = {'RelativeSpin',SPIN.RelativeSpin,'Output'};
Panel(3,:) = {'Ndiscs',SPIN.ndiscs,'Output'};
Panel(4,:) = {'Nspokes',SPIN.nspokes,'Output'};

SPIN.Panel = Panel;
Status2('done','',2);
Status2('done','',3);

