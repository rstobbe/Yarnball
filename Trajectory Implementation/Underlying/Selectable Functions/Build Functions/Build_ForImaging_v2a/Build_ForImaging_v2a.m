%==================================================================
% (v2a)
%   
%==================================================================

classdef Build_ForImaging_v2a < handle

properties (SetAccess = private)                   
    Method = 'Build_ForImaging_v2a'
    TSTipt 
    Testing = 0;
    SysRespCompVis = 1;
    GradWfmVis = 1;
    TestKspaceVis = 1;
    FigShift = -1920;    
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TST = Build_ForImaging_v2a(TSTipt)    
    TST.TSTipt = TSTipt;
end 


end
end



