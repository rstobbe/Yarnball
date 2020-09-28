%====================================================
% 
%====================================================

function [DESOL,err] = DeSolTim_YarnBallLookupBrainT1LongTraj_v1e_Func(DESOL,INPUT)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
courseadjust = INPUT.courseadjust;
DESTYPE = INPUT.DESTYPE;
TST = INPUT.TST;
RADEV = DESOL.RADEV;
clear INPUT;

%---------------------------------------------
% Get radial evolution function 
%---------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([RADEV.method,'_Func']);           
[RADEV,err] = func(RADEV,INPUT);
if err.flag
    return
end
clear INPUT;
DESOL.RADEV = RADEV;

%------------------------------------------
% Calculate Projection Lengths
%------------------------------------------
Status2('busy','Calculate Trajectory Lengths',2);
[plout,err] = ProjLenOutside(PROJdgn.p,DESTYPE.MaxRadSolve,DESTYPE.radevout);    
if DESTYPE.MaxRadSolve > 1
    [plout0,err] = ProjLenOutside(PROJdgn.p,1,DESTYPE.radevout); 
else
    plout0 = plout;
end
if err.flag == 1
    return
end
if strcmp(RADEV.soltype,'basic')
    [plin,err] = ProjLenInsideRapid(PROJdgn.p,DESTYPE.radevin,RADEV.intol);     
else
    [plin,err] = ProjLenInside(PROJdgn.p,DESTYPE.radevin);
end
if err.flag == 1
    return
end

%------------------------------------------
% Create Timing Arrays for Solving
%------------------------------------------
Status2('busy','Create Timing Vector',2);
[Nin0,T] = Lookup(plin,plout);
if strcmp(courseadjust,'yes')
    Nin0 = Nin0/5;
    T = T*5;
end

%------------------------------------------
% Inside Points
%------------------------------------------
Nin = Nin0;
tMax = 1e6;                                             % doesn't really matter just set sufficiently big
t = (0:tMax); 
tau = -plin + plin/Nin*t + exp(T*(t-Nin)) - exp(-T*Nin);
while true
    ind = find(tau > 0,1,'first');
    if isempty(ind)
        error
    end
    if ind < Nin0
        Nin = Nin*1.05;
    else
        break
    end
    tau = -plin + plin/Nin*t + exp(T*(t-Nin)) - exp(-T*Nin);
end

%------------------------------------------
% Solve Middle
%------------------------------------------                                   
tau = -plin + plin/Nin*t + exp(T*(t-Nin)) - exp(-T*Nin);
ind = find(tau > plout,1);
if isempty(ind)
    error
end

ind1 = find(tau <= 0,1,'last');  
short1 = abs(tau(ind1));
rateinc1 = (short1/(ind1-1));

tau = -plin + (plin/Nin+rateinc1)*t + exp(T*(t-Nin)) - exp(-T*Nin);

tautest = round(tau*1e15);
ind2 = find(tautest <= 0,1,'last');  
ind3 = find(tautest >= 0,1,'first'); 
if ind2 ~= ind3
    error
end

SlvZero = ind2;
tau1 = flip(tau(2:SlvZero),2);
SlvEnd = find(tau >= plout,1,'first');
tau2 = tau(SlvZero:SlvEnd);                                 % will solve a tiny bit past

%------------------------------------------
% Visualize
%------------------------------------------
%TST.DESOL.Vis = 'Yes';
if strcmp(TST.DESOL.Vis,'Yes')
    figure(92); hold on; plot(tau(1:SlvEnd),'b-');
    plot(SlvZero,tau(SlvZero),'r*');
    xlabel('sample point'); ylabel('tau'); title('Timing Vector');    
end

%------------------------------------------
% Test
%------------------------------------------
if tau(2) < tau(1)
    err.flag = 1;
    err.msg = 'Timing Vector Problem (negative)';
    return
end

%------------------------------------------
% Calculate Real Timings
%------------------------------------------
tautot = plin+[-plin flip(tau1,2) tau2(2:length(tau2))];      % (plin) for negative differential solution - from [1-40] thesis 
projlen0 = plin+plout0;
T = (tautot/projlen0)*PROJdgn.tro;

%------------------------------------------
% Return
%------------------------------------------
DESOL.tau1 = tau1;
DESOL.tau2 = tau2;
DESOL.tautot = tautot;
DESOL.len = length(tau1)+length(tau2);
DESOL.plin = plin;
DESOL.plout = plout;
DESOL.T = T;
DESOL.PanelOutput = struct();

Status2('done','',2);
Status2('done','',3);


%===============================================================
% Rapid Inside
%===============================================================
function [projlen,err] = ProjLenInsideRapid(p,defunc,tol)

err.flag = 0;
err.msg = '';

tau = (0:-0.01:-2);
options = odeset('RelTol',tol,'AbsTol',tol);
[x,r] = ode113(defunc,tau,p,options); 
ind = find(r < 0,1,'first');

ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode113(defunc,tau,p,options);  
projlen = abs(interp1(r,tau,0,'spline'));

%===============================================================
% Inside
%===============================================================
function [projlen,err] = ProjLenInside(p,defunc)

err.flag = 0;
err.msg = '';

tau = (0:-1e-6:-2);
tol = 3e-6;
options = odeset('RelTol',tol,'AbsTol',tol);
[x,r] = ode113(defunc,tau,p,options); 
ind = find(r < 0,1,'first');

fh = figure(19283); 
fh.Name = 'Solve Projection Inside';
fh.NumberTitle = 'off';
fh.Position = [500 500 900 300];
subplot(1,2,1); hold on;
plot(tau,r,'b');
xlim([tau(ind+5) 0]);
title('Inside Solution');

n = 1;
while true
    tau = [(0:-1e-6:x(ind-1)) x(ind-1)-n*1e-7];
    tol = 2.5e-14;
    options = odeset('RelTol',tol,'AbsTol',tol);
    [x,r] = ode113(defunc,tau,p,options);  
    if length(r) ~= length(tau)
        break
    end
    rend(n) = r(end);
    subplot(1,2,2); hold on;
    plot(rend); drawnow;
    title('Error at Zero');
    rout = r;
    tauout = tau;
    n = n+1;
end
        
subplot(1,2,1); hold on;
plot(tauout,rout,'r');

projlen = abs(interp1(rout,tauout,0,'spline'));

%===============================================================
% Outside
%===============================================================
function [projlen,err] = ProjLenOutside(p,R,defunc)

err.flag = 0;
err.msg = '';

tau = (0:0.01:100);
tol = 5e-14;
options = odeset('RelTol',tol,'AbsTol',tol);
[x,r] = ode113(defunc,tau,p,options); 
ind = find(abs(r) > R,1,'first');
if isempty(ind)
    error;          
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode113(defunc,tau,p,options); 
projlen = interp1(abs(r),tau,R,'spline');

%===============================================================
% Lookup
%===============================================================
function [Nin,OutShape] = Lookup(plin,plout)

Nin = 4000 - 6000*plin;
if Nin < 2500
    Nin = 2500;
end
% OutShape = (0.23 - 0.005*plout);
% if OutShape > 0.08
%     OutShape = 0.08;
% end
OutShape = 0.1;
OutShape = OutShape*1e-3;
