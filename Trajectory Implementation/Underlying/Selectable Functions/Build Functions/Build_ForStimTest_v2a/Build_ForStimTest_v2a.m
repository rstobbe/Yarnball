%==================================================================
% (v2a)
%   
%==================================================================

classdef Build_ForStimTest_v2a < handle

properties (SetAccess = private)                   
    Method = 'Build_ForStimTest_v2a'
    TSTipt 
    Testing = 1;
    SysRespCompVis = 1;
    GradWfmVis = 1;
    TestKspaceVis = 1;
    FigShift = -1920;    
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TST = Build_ForStimTest_v2a(TSTipt)    
    TST.TSTipt = TSTipt;
end 


end
end



