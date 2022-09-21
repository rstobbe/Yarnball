%==================================================================
% (v2a)
%   
%==================================================================

classdef H1_v2a < handle

properties (SetAccess = private)                   
    Method = 'H1_v2a'
    NUCipt
    nucleus = 'H1';
    gamma = 42.577;
    PanelOutput
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function NUC = H1_v2a(NUCipt)    
    NUC.NUCipt = NUCipt;
    Panel(1,:) = {'Nucleus',NUC.nucleus,'Output'};
    NUC.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
end 


end
end




