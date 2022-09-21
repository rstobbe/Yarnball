%==================================================================
% (v2a)
%   - 
%==================================================================

classdef DeSolTim_Standard_v2a < handle

properties (SetAccess = private)                   
    Method = 'DeSolTim_Standard_v2a'
    DESOLipt;
    Sol
    len = 1000;
    projlen;
    tau;
    rad;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function DESOL = DeSolTim_Standard_v2a(DESOLipt)    
    DESOL.DESOLipt = DESOLipt;
end 

%==================================================================
% GetDeSolutionTiming
%================================================================== 
function GetDeSolutionTiming(DESOL,GENPRJ,TST)
    
    tau0 = [0 1000];
    tol = 1e-20;
    eventfunc = @(t,YB) DESOL.EventFcn(t,YB);
    options = odeset('RelTol',tol,'AbsTol',tol,'Events',eventfunc);
    defunc = @(t,YB) GENPRJ.YarnballSolution(t,YB);
    
    rad0 = 0;
    phi0 = 0;                   % phi0 = 0 gives middle value for radius ending
    theta0 = 0;
    drad0 = 0;
    DESOL.Sol = ode113(defunc,tau0,[rad0,phi0,theta0,drad0],options);
     
    DESOL.projlen = DESOL.Sol.xe;
    DESOL.tau = linspace(0,DESOL.projlen,DESOL.len);
    YB = deval(DESOL.Sol,DESOL.tau);
    DESOL.rad = YB(1,:);
    
    if TST.DeSolVis
        figure(2346); hold on;
        plot(DESOL.tau,DESOL.rad,'*');
    end    
end

%===============================================================
% EventFcn
%===============================================================
function [position,isterminal,direction] = EventFcn(DESOL,t,YB)
    position = 1 - YB(1);
    isterminal = 1;
    direction = 0;
end

end
end









