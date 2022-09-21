%==================================================================
% (v2a)
%   - Start
%==================================================================

classdef RadialAcc_Ramp2Uniform_v2a < handle

properties (SetAccess = private)                   
    Method = 'RadialAcc_Ramp2Uniform_v2a'
    RADACCipt;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function RADACC = RadialAcc_Ramp2Uniform_v2a(RADACCipt)    
    RADACC.RADACCipt = RADACCipt;
end 

%====================================================
% RadialAcc
%====================================================
function Val = RadialAcc(RADACC,t,r)
    Val = 1-0.9*exp(-200*(r)); 
    %Val = 1-0.9*exp(-5*(r));                   % for 'single' shot
end

end
end
