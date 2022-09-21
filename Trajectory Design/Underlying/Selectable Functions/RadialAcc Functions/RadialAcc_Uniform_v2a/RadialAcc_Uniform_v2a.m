%==================================================================
% (v2a)
%   - Start
%==================================================================

classdef RadialAcc_Uniform_v2a < handle

properties (SetAccess = private)                   
    Method = 'RadialAcc_Uniform_v2a'
    RADACCipt;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function RADACC = RadialAcc_Uniform_v2a(RADACCipt)    
    RADACC.RADACCipt = RADACCipt;
end 

%====================================================
% RadialAcc
%====================================================
function RadAcc = RadialAcc(RADACC,t,r)
    RadAcc = 1;   
end

end
end
