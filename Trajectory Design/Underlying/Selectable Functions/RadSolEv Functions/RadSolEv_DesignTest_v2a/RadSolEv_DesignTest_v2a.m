%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef RadSolEv_DesignTest_v2a < handle

properties (SetAccess = private)                   
    Method = 'RadSolEv_DesignTest_v2a';
    RADSOLipt;
    DeRadSolFunc;
    SolType = 'Basic';
    InTol = 2e-5;   
    OutTol = 5e-14; 
    RelProjLenMeas = 'Yes';
    ConstEvol = 'No';
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function RADSOL = RadSolEv_DesignTest_v2a(RADSOLipt)    
    RADSOL.RADSOLipt = RADSOLipt;
end 

%==================================================================
% SetDeRadSolFunc
%==================================================================  
function SetDeRadSolFunc(RADSOL,p)    
    RADSOL.DeRadSolFunc = @(p,r) 1;
end 

end
end