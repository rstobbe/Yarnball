%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef Colour_Gold_v2a < handle

properties (SetAccess = private)                   
    Method = 'Colour_Gold_v2a'
    CLRipt;
    SPIN;
    TURNEVO;
    TURNSOL;
    RADSOL;
    p;
    rad;
    dir;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function CLR = Colour_Gold_v2a(CLRipt)    
    CLR.CLRipt = CLRipt;
end 

%==================================================================
% Setup
%==================================================================  
function SetTurnEvo(CLR,TURNEVOfunc,TURNEVOipt)
    CLR.TURNEVO = TURNEVOfunc(TURNEVOipt);
end
function SetTurnSol(CLR,TURNSOLfunc,TURNSOLipt)
    CLR.TURNSOL = TURNSOLfunc(TURNSOLipt);
end
function SetSpin(CLR,SPINfunc,SPINipt)
    CLR.SPIN = SPINfunc(SPINipt);
end
function SetRad(CLR,rad)
    CLR.rad = rad;
    CLR.SPIN.SetRad(rad);
end
function SetRadSol(CLR,RADSOLfunc,RADSOLipt)
    CLR.RADSOL = RADSOLfunc(RADSOLipt);
end
function SetP(CLR,p)
    CLR.p = p;
end
function SetDir(CLR,dir)
    CLR.dir = dir;
end

%==================================================================
% FullSolutionIn
%==================================================================  
function dy = FullSolutionIn(CLR,t,y)  
    r = y(1);
    if r > CLR.TURNEVO.TurnLoc  
        dr = CLR.TURNEVO.TurnRadFunc(CLR.p,r)*(1/CLR.RADSOL.DeRadSolFunc(CLR.p,r));    
        dr0 = CLR.TURNEVO.TurnSpinFunc(CLR.p,r)*(1/CLR.RADSOL.DeRadSolFunc(CLR.p,r));   
    else
        dr = (CLR.p^2/r^2)*(1/CLR.RADSOL.DeRadSolFunc(CLR.p,r));
        dr0 = dr;
    end
    dtheta = CLR.dir*CLR.SPIN.stheta(r)*pi*CLR.rad*abs(dr0);
    dphi = 2*(CLR.SPIN.sphi(r)*pi*CLR.rad*r)*dtheta;
    dy = [dr;dphi;dtheta];
end

%==================================================================
% FullSolutionOut
%==================================================================  
function dy = FullSolutionOut(CLR,t,y)  
    r = y(1);
    if r > CLR.TURNEVO.TurnLoc  
        dr = CLR.dir*CLR.TURNEVO.TurnRadFunc(CLR.p,r)*(1/CLR.RADSOL.DeRadSolFunc(CLR.p,r));    
        dr0 = CLR.dir*CLR.TURNEVO.TurnSpinFunc(CLR.p,r)*(1/CLR.RADSOL.DeRadSolFunc(CLR.p,r));   
    else
        dr = CLR.dir*(CLR.p^2/r^2)*(1/CLR.RADSOL.DeRadSolFunc(CLR.p,r));
        dr0 = CLR.dir*dr;
    end
    dtheta = CLR.SPIN.stheta(r)*pi*CLR.rad*abs(dr0);
    dphi = 2*(CLR.SPIN.sphi(r)*pi*CLR.rad*r)*dtheta;
    dy = [dr;dphi;dtheta];
end

%====================================================
% RadialSolution
%====================================================
function dr = RadialSolution(CLR,t,r) 
    if r > CLR.TURNEVO.TurnLoc 
        dr = CLR.TURNEVO.TurnRadFunc(CLR.p,r)*(1/CLR.RADSOL.DeRadSolFunc(CLR.p,r));     
    else
        dr = (CLR.p^2/r^2)*(1/CLR.RADSOL.DeRadSolFunc(CLR.p,r));
    end
end
    
end
end
