%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef TurnSolution_Dummy_v2a < handle

properties (SetAccess = private)                   
    Method = 'TurnSolution_Dummy_v2a'
    TURNSOLipt;
end

methods 
    
%==================================================================
% Constructor
%==================================================================  
function TURNSOL = TurnSolution_Dummy_v2a(TURNSOLipt)    
    TURNSOL.TURNSOLipt = TURNSOLipt;
end 

%==================================================================
% SolveTurning
%================================================================== 
function SolveTurning(TURNSOL,CLR)  
    % Dummy
end


end
end