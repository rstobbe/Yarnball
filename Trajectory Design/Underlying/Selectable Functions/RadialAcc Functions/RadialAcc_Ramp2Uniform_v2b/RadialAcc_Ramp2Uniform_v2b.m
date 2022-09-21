%==================================================================
% (v2b)
%   - Add RampRate
%==================================================================

classdef RadialAcc_Ramp2Uniform_v2b < handle

properties (SetAccess = private)                   
    Method = 'RadialAcc_Ramp2Uniform_v2b'
    RADACCipt;
    RampRate;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function RADACC = RadialAcc_Ramp2Uniform_v2b(RADACCipt)    
    RADACC.RADACCipt = RADACCipt;
    RADACC.RampRate = str2double(RADACCipt.('RampRate')); 
end 

%====================================================
% RadialAcc
%====================================================
function Val = RadialAcc(RADACC,t,r)
    Val = 1-0.9*exp(-RADACC.RampRate*(r)); 
end

end
end
