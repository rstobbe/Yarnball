%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef TurnEvolution_Dummy_v2a < handle

properties (SetAccess = private)                   
    Method = 'TurnEvolution_Dummy_v2a'
    TURNEVOipt;
    TurnRadFunc = @(p,r) (p^2/r^2);
    TurnSpinFunc = @(p,r) (p^2/r^2);
    TurnLoc = 1;
end

methods 
    
%==================================================================
% Constructor
%==================================================================  
function TURNEVO = TurnEvolution_Dummy_v2a(TURNEVOipt)    
    TURNEVO.TURNEVOipt = TURNEVOipt;
end 

%==================================================================
% DefineTurnEvolution
%==================================================================  
function DefineTurnEvolution(TURNEVO,INPUT)    
    TURNEVO.TurnRadFunc = @(p,r) (p^2/r^2);
    TURNEVO.TurnSpinFunc = @(p,r) (p^2/r^2);
end

end
end