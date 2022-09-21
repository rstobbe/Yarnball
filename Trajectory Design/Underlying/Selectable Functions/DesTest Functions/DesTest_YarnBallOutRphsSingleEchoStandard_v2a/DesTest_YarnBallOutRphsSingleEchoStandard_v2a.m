%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef DesTest_YarnBallOutRphsSingleEchoStandard_v2a < handle

properties (SetAccess = private)                   
    TESTipt;
    TestSpeed = 'Standard';
    SpinVis = 0;
    TimAdjVis = 0;
    DeSolVis = 0;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TEST = DesTest_YarnBallOutRphsSingleEchoStandard_v2a(TESTipt)    
    TEST.TESTipt = TESTipt;
end 

end
end