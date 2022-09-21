%==================================================================
% (v2a)
%   - Start
%==================================================================

classdef TurnEvolution_NoStop_v2a < handle

properties (SetAccess = private)                   
    Method = 'TurnEvolution_NoStop_v2a'
    TURNEVOipt;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TURNEVO = TurnEvolution_NoStop_v2a(TURNEVOipt)    
    TURNEVO.TURNEVOipt = TURNEVOipt;
end 

%==================================================================
% Set
%==================================================================  
function SetSlope(TURNEVO,Slope)    
end 
function SetEnd(TURNEVO,End)    
end 

%====================================================
% RadialAcc
%====================================================
function Val = drWeight(TURNEVO,r)
    Val = 1;
end

end
end
