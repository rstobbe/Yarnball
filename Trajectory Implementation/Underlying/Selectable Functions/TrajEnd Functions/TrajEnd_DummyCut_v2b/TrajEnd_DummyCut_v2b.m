%==================================================================
% (v2a)
%   
%==================================================================

classdef TrajEnd_DummyCut_v2b < handle

properties (SetAccess = private)                   
    Method = 'TrajEnd_DummyCut_v2b'
    TENDipt
    GRAD
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TEND = TrajEnd_DummyCut_v2b(TENDipt)    
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

    DeletePoints = ((FINMETH.CompDurPastGrad/DESTYPE.GradTimeQuant)/1000 - 1);
    Grad = FINMETH.SYSRESP.GradComp(:,1:end-DeletePoints,:);
    sz = size(Grad);
    ZeroEnd = zeros(sz(1),1,3);
    Grad = cat(2,Grad,ZeroEnd);
    
    TEND.GRAD.DefineGradients(Grad);
    TEND.GRAD.CalculateGradientChars;
end 


end
end



