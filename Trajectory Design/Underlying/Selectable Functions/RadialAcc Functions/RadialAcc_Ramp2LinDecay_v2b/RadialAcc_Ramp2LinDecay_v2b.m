%==================================================================
% (v2b)
%   - Start RadialAcc_Ramp2Uniform_v2b
%==================================================================

classdef RadialAcc_Ramp2LinDecay_v2b < handle

properties (SetAccess = private)                   
    Method = 'RadialAcc_Ramp2LinDecay_v2b'
    RADACCipt;
    RampRate;
    DecayShift;
    DecayRate
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function RADACC = RadialAcc_Ramp2LinDecay_v2b(RADACCipt)    
    RADACC.RADACCipt = RADACCipt;
    RADACC.RampRate = str2double(RADACCipt.('RampRate')); 
    RADACC.DecayShift = str2double(RADACCipt.('DecayShift')); 
    RADACC.DecayRate = str2double(RADACCipt.('DecayRate'));     
end 

%====================================================
% RadialAcc
%====================================================
function Val = RadialAcc(RADACC,t,r)
    Val = (1-0.9*exp(-RADACC.RampRate*(r))) - heaviside(r-RADACC.DecayShift)*(r-RADACC.DecayShift)*RADACC.DecayRate; 
end

end
end
