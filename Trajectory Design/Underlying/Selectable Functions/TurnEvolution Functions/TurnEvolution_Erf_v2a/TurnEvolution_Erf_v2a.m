%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef TurnEvolution_Erf_v2a < handle

properties (SetAccess = private)                   
    Method = 'TurnEvolution_Erf_v2a'
    TURNEVOipt;
    Slope;
    TurnRadFunc;
    TurnSpinFunc;
    TurnLoc;
    Fiddle;
end

methods 
    
%==================================================================
% Constructor
%==================================================================  
function TURNEVO = TurnEvolution_Erf_v2a(TURNEVOipt)    
    TURNEVO.TURNEVOipt = TURNEVOipt;
    TURNEVO.Slope = str2double(TURNEVOipt.('Slope'));
end 

%==================================================================
% Setup
%==================================================================  
function SetSlope(TURNEVO,Slope)
    TURNEVO.Slope = Slope;
end

%==================================================================
% DefineTurnEvolution
%==================================================================  
function DefineTurnEvolution(TURNEVO,INPUT)    
    TURNEVO.TurnLoc = INPUT.TurnLoc;
    TURNEVO.Fiddle = INPUT.Fiddle;
    Start = 1;
    TURNEVO.TurnRadFunc = @(p,r) (p^2/r^2)*(1 - erf(Start+TURNEVO.Slope*(1-(TURNEVO.TurnLoc+TURNEVO.Fiddle)^2)) + erf(Start+TURNEVO.Slope*(1-(r+TURNEVO.Fiddle)^2)));
    TURNEVO.TurnSpinFunc = @(p,r) (p^2/r^2);
end

end
end