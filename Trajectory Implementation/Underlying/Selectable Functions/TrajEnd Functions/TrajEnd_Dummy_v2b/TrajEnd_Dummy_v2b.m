%==================================================================
% (v2a)
%   
%==================================================================

classdef TrajEnd_Dummy_v2b < handle

properties (SetAccess = private)                   
    Method = 'TrajEnd_Dummy_v2b'
    TENDipt
    GRAD
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TEND = TrajEnd_Dummy_v2b(TENDipt)    
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
function err = EndTrajectories(TEND,FINMETH,DESTYPE)    
    err.flag = 0;
    TEND.GRAD.SetGamma(DESTYPE.NUC.gamma);
    TEND.GRAD.SetTimeQuant(DESTYPE.GradTimeQuant);
    Grad = FINMETH.SYSRESP.GradComp;
    TEND.GRAD.DefineGradients(Grad);
    TEND.GRAD.CalculateGradientChars;
end 


end
end



