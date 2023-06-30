%==================================================================
% (v2a)
%   
%==================================================================

classdef Na23_v2a < handle

properties (SetAccess = private)                   
    Method = 'Na23_v2a'
    NUCipt
    nucleus = 'Na23';
    gamma = 11.26;
    PanelOutput
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function NUC = Na23_v2a(NUCipt)    
    NUC.NUCipt = NUCipt;
    Panel(1,:) = {'Nucleus',NUC.nucleus,'Output'};
    NUC.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
end 


end
end




