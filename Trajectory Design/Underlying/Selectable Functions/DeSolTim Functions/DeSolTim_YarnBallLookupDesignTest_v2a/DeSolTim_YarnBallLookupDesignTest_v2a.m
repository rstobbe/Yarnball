%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef DeSolTim_YarnBallLookupDesignTest_v2a < handle

properties (SetAccess = private)                   
    Method = 'DeSolTim_YarnBallLookupDesignTest_v2a'
    CourseAdjust
    DESOLipt;
    plout;
    plin;
    Nin0;
    OutShape;
    tau1;
    tau2;
    tautot;
    projlen0;
    len;
    Panel = cell(0);
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function DESOL = DeSolTim_YarnBallLookupDesignTest_v2a(DESOLipt)    
    DESOL.CourseAdjust = 0;
    DESOL.DESOLipt = DESOLipt;
end 

%==================================================================
% GetDeSolutionTiming
%================================================================== 
function SetCourseAdjust(DESOL,Val)
    DESOL.CourseAdjust = Val;
end

%==================================================================
% GetDeSolutionTiming
%================================================================== 
function err = GetDeSolutionTiming(DESOL,CLR,TST)

    Status2('busy','Determine Solution Timing',2);
    Status2('done','',3);
    err.flag = 0;
    err.msg = '';

    %------------------------------------------
    % Calculate Projection Lengths
    %------------------------------------------
    DESOL.SolveProjLenOut(CLR);  
    DESOL.SolveProjLenIn(CLR);  

    %------------------------------------------
    % Create Timing Arrays for Solving
    %------------------------------------------
    Status2('busy','Create Timing Vector',2);
    DESOL.Lookup;
    if DESOL.CourseAdjust
        Nin = DESOL.Nin0/5;
        T = DESOL.OutShape*5;
    else
        Nin = DESOL.Nin0;
        T = DESOL.OutShape;
    end

    %------------------------------------------
    % Inside Points
    %------------------------------------------
    tMax = 1e6;                                             % doesn't really matter just set sufficiently big
    t = (0:tMax); 
    tau = -DESOL.plin + DESOL.plin/Nin*t + exp(T*(t-Nin)) - exp(-T*Nin);
    while true
        ind = find(tau > 0,1,'first');
        if isempty(ind)
            error
        end
        if ind < DESOL.Nin0
            Nin = Nin*1.05;
        else
            break
        end
        tau = -DESOL.plin + DESOL.plin/Nin*t + exp(T*(t-Nin)) - exp(-T*Nin);
    end

    %------------------------------------------
    % Solve Middle
    %------------------------------------------                                   
    tau = -DESOL.plin + DESOL.plin/Nin*t + exp(T*(t-Nin)) - exp(-T*Nin);
    ind = find(tau > DESOL.plout,1);
    if isempty(ind)
        err.flag = 1;
        err.msg = 'Try alternative ''DeSolTim'' function';
        return
    end
    ind1 = find(tau <= 0,1,'last');  
    short1 = abs(tau(ind1));
    rateinc1 = (short1/(ind1-1));
    tau = -DESOL.plin + (DESOL.plin/Nin+rateinc1)*t + exp(T*(t-Nin)) - exp(-T*Nin);
    tautest = round(tau*1e15);
    ind2 = find(tautest <= 0,1,'last');  
    ind3 = find(tautest >= 0,1,'first'); 
    if ind2 ~= ind3
        error
    end
    SlvZero = ind2;
    DESOL.tau1 = flip(tau(2:SlvZero),2);
    SlvEnd = find(tau >= DESOL.plout,1,'first');
    DESOL.tau2 = tau(SlvZero:SlvEnd);                                 % will solve a tiny bit past
    if CLR.dir == -1
        DESOL.tau2 = DESOL.tau2(end) - flip(DESOL.tau2);
    end

    %------------------------------------------
    % Visualize
    %------------------------------------------
    if TST.DeSolVis
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
    if CLR.dir == 1
        DESOL.tautot = DESOL.plin+[-DESOL.plin flip(DESOL.tau1) DESOL.tau2(2:end)];      % (plin) for negative differential solution - from [1-40] thesis 
    elseif CLR.dir == -1
        DESOL.tautot = [DESOL.tau2 DESOL.tau2(end)-DESOL.tau1(2:end) DESOL.tau2(end)+DESOL.plin];
    end
    DESOL.projlen0 = DESOL.tautot(end);
    DESOL.len = length(DESOL.tau1)+length(DESOL.tau2);

    %--------------------------------------------- 
    % Panel Output
    %--------------------------------------------- 
    DESOL.Panel(1,:) = {'Method',DESOL.Method,'Output'};

    Status2('done','',2);
    Status2('done','',3);

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









