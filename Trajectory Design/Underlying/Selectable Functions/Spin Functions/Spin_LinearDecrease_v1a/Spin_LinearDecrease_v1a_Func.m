%====================================================
% 
%====================================================

function [SPIN,err] = Spin_LinearDecrease_v1a_Func(SPIN,INPUT)

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
% Linear Relative Spin Decrease
%---------------------------------------------
RelSpin = @(r) (1 - r)*(SPIN.RelSpinCentre - SPIN.RelSpinEdge) + SPIN.RelSpinEdge;
% figure(1234123);
% r = (0:0.1:1);
% plot(r,RelSpin(r));
% ylim([0 1]);

%---------------------------------------------
% Calculate Spin Functions
%---------------------------------------------
SPIN.spincalcndiscsfunc = @(r) SPIN.ndiscs/RelSpin(r);
SPIN.spincalcnspokesfunc = @(r) SPIN.nspokes/RelSpin(r);
SPIN.nproj = SPIN.ndiscs*SPIN.nspokes;

%------------------------------------------
% Name
%------------------------------------------
SPIN.AziSampUsed = SPIN.RelSpinCentre;
SPIN.PolSampUsed = SPIN.RelSpinCentre;

SPIN.type = 'LinearDecrease';
SPIN.number1 = num2str(100*SPIN.RelSpinCentre,'%3.0f');
SPIN.number2 = num2str(100*SPIN.RelSpinEdge,'%3.0f');
SPIN.number = [SPIN.number1,SPIN.number2];
SPIN.name = ['LD',SPIN.number1,SPIN.number2];
SPIN.GblSamp = SPIN.RelSpinEdge;

%--------------------------------------------- 
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',SPIN.method,'Output'};
Panel(2,:) = {'RelativeSpinCentre',SPIN.RelSpinCentre,'Output'};
Panel(3,:) = {'RelativeSpinEdge',SPIN.RelSpinEdge,'Output'};
Panel(4,:) = {'Ndiscs',SPIN.ndiscs,'Output'};
Panel(5,:) = {'Nspokes',SPIN.nspokes,'Output'};

SPIN.Panel = Panel;
Status2('done','',2);
Status2('done','',3);

