%==================================================================
% (v2a)
%   - Start
%==================================================================

classdef TurnEvolution_ExpRadStop_v2a < handle

properties (SetAccess = private)                   
    Method = 'TurnEvolution_ExpRadStop_v2a'
    TURNEVOipt;
    Slope;
    End;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TURNEVO = TurnEvolution_ExpRadStop_v2a(TURNEVOipt)    
    TURNEVO.TURNEVOipt = TURNEVOipt;
end 

%==================================================================
% Set
%==================================================================  
function SetSlope(TURNEVO,Slope)    
    TURNEVO.Slope = Slope;
end 
function SetEnd(TURNEVO,End)    
    TURNEVO.End = End;
end 

%================================================================== 
% RadialAcc
%================================================================== 
function Val = drWeight(TURNEVO,r)
    Val = (TURNEVO.End-exp(-TURNEVO.Slope*(1-r)));
end

end
end
