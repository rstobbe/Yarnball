%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef DeSolTim_Testing_v2a < handle

properties (SetAccess = private)                   
    Method = 'DeSolTim_Testing_v2a'
    CourseAdjust
    DESOLipt;
    tau;
    projlen;
    rad;
    len;
    Panel = cell(0);
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function DESOL = DeSolTim_Testing_v2a(DESOLipt)    
    DESOL.CourseAdjust = 0;
    DESOL.DESOLipt = DESOLipt;
end 

%==================================================================
% GetDeSolutionTiming
%================================================================== 
function err = GetDeSolutionTiming(DESOL,CLR,TST)

    err = 0;
%     tau0 = (0:0.01:100);
%     tol = 5e-14;
%     options = odeset('RelTol',tol,'AbsTol',tol);
%     defunc = @(t,rad) CLR.RadialSolution(t,rad);
%     [tau0,rad0] = ode113(defunc,tau0,0,options); 
%     ind = find(abs(rad0) > 1,1,'first');
%     if isempty(ind)
%         error;          
%     end
%     ind = ind+1;
%     tau0 = (0:1e-5:tau0(ind));
%     [tau0,rad0] = ode113(defunc,tau0,0,options); 
%     ind = find(abs(rad0) >= 1,1,'first');
%     if isempty(ind)
%         error;          
%     end
%     tau0 = tau0(1:ind);
%     rad0 = rad0(1:ind);
%     
%     figure(2346);
%     plot(tau0,rad0,'*');

    tau0 = (0:0.001:8);
    rad0 = (0:0.001:8);
    DESOL.tau = tau0;
    DESOL.rad = rad0;
    DESOL.len = length(tau0);
    DESOL.projlen = tau0(end);
    
end

%===============================================================
% SolveProjLenOut
%===============================================================
function SolveProjLenOut(DESOL,CLR)
    tau = (0:0.01:100);
    tol = 5e-14;
    options = odeset('RelTol',tol,'AbsTol',tol);
    defunc = @(t,r) CLR.RadialSolution(t,r);
    p = CLR.p;
    [x,r] = ode113(defunc,tau,p,options); 
    ind = find(abs(r) > 1,1,'first');
    if isempty(ind)
        error;          
    end
    ind = ind+1;
    tau = (0:x(ind)/1e5:x(ind));
    [x,r] = ode113(defunc,tau,p,options); 
    DESOL.plout = interp1(abs(r),tau,1,'spline');
end

%===============================================================
% SolveProjLenIn
%===============================================================
function SolveProjLenIn(DESOL,CLR)
    tau = (0:-0.01:-2);
    tol = CLR.RADSOL.InTol;
    options = odeset('RelTol',tol,'AbsTol',tol);
    defunc = @(t,r) CLR.RadialSolution(t,r);
    p = CLR.p;
    [x,r] = ode113(defunc,tau,p,options); 
    ind = find(r < 0,1,'first');
    ind = ind+1;
    tau = (0:x(ind)/1e5:x(ind));
    [x,r] = ode113(defunc,tau,p,options);  
    DESOL.plin = abs(interp1(r,tau,0,'spline'));
end

%===============================================================
% Lookup
%===============================================================
function Lookup(DESOL)
    DESOL.Nin0 = 4000 - 6000*DESOL.plin;
    if DESOL.Nin0 < 1500
        DESOL.Nin0 = 2000;
    end
    DESOL.OutShape = (0.23 - 0.005*DESOL.plout)*1e-3;
end


end
end









