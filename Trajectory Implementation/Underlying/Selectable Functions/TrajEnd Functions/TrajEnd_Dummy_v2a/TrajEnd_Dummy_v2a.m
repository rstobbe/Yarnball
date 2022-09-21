%==================================================================
% (v2a)
%   
%==================================================================

classdef TrajEnd_Dummy_v2a < handle

properties (SetAccess = private)                   
    Method = 'TrajEnd_Dummy_v2a'
    TENDipt
    GRAD
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TEND = TrajEnd_Dummy_v2a(TENDipt)    
    TEND.TENDipt = TENDipt;
    %------------------------------------------
    % Create Shell Objects
    %------------------------------------------
    func = str2func('Gradient_Calculations_v2a');           
    TEND.GRAD = func('');     
end 

%==================================================================
% Constructor
%==================================================================  
function err = EndTrajectories(TEND,GradComp,DESTYPE)    
    err.flag = 0;
    TEND.GRAD.SetGamma(DESTYPE.NUC.gamma);
    TEND.GRAD.SetTimeQuant(DESTYPE.GradTimeQuant);
    TEND.GRAD.DefineGradients(GradComp);
    TEND.GRAD.CalculateGradientChars;
end 


end
end



