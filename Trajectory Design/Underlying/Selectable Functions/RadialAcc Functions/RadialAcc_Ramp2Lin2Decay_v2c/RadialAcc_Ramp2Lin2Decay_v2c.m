%==================================================================
% (v2c)
%   - Add 'Beginning'
%   - Change Constructor.
%==================================================================

classdef RadialAcc_Ramp2Lin2Decay_v2c < handle

properties (SetAccess = private)                   
    Method = 'RadialAcc_Ramp2Lin2Decay_v2c'
    RADACCipt;
    RampRate;
    Beginning;
    DecayShift1
    DecayRate1
    DecayShift2
    DecayRate2
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function RADACC = RadialAcc_Ramp2Lin2Decay_v2c(varargin)    
    if length(varargin) == 1
        RADACC.RADACCipt = varargin{1};
        RADACC.RampRate = str2double(RADACC.RADACCipt.('RampRate')); 
        RADACC.Beginning = str2double(RADACC.RADACCipt.('Beginning'));
        RADACC.DecayShift1 = str2double(RADACC.RADACCipt.('DecayShift1')); 
        RADACC.DecayRate1 = str2double(RADACC.RADACCipt.('DecayRate1'));
        RADACC.DecayShift2 = str2double(RADACC.RADACCipt.('DecayShift2')); 
        RADACC.DecayRate2 = str2double(RADACC.RADACCipt.('DecayRate2'));     
    end
end 

%==================================================================
% InitViaCompass
%==================================================================  
function InitViaCompass(RADACC,RADACCipt)    
    RADACC.RADACCipt = RADACCipt;
    RADACC.RampRate = str2double(RADACCipt.('RampRate')); 
    RADACC.Beginning = str2double(RADACCipt.('Beginning')); 
    RADACC.DecayShift1 = str2double(RADACCipt.('DecayShift1')); 
    RADACC.DecayRate1 = str2double(RADACCipt.('DecayRate1'));
    RADACC.DecayShift2 = str2double(RADACCipt.('DecayShift2')); 
    RADACC.DecayRate2 = str2double(RADACCipt.('DecayRate2'));   
end 

%==================================================================
% InitExternal
%==================================================================  
function InitExternal(RADACC,RampRate,Beginning,DecayRate1,DecayShift1,DecayRate2,DecayShift2)    
    RADACC.RampRate = RampRate;
    RADACC.Beginning = Beginning;
    RADACC.DecayRate1 = DecayRate1;
    RADACC.DecayShift1 = DecayShift1;
    RADACC.DecayRate2 = DecayRate2;
    RADACC.DecayShift2 = DecayShift2;    
end 

%====================================================
% RadialAcc
%====================================================
function Val = RadialAcc(RADACC,t,r)
    Val = (1-RADACC.Beginning*exp(-RADACC.RampRate*(r))) - heaviside(r-RADACC.DecayShift1)*(r-RADACC.DecayShift1)*RADACC.DecayRate1 ... 
          + heaviside(r-RADACC.DecayShift2)*(r-RADACC.DecayShift2)*RADACC.DecayRate1 - heaviside(r-RADACC.DecayShift2)*(r-RADACC.DecayShift2)*RADACC.DecayRate2;
end

end
end
