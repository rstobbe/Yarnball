%==================================================================
% (v2c)
%   - Add 'Beginning'
%   - Change Constructor.
%==================================================================

classdef RadialAcc_Ramp2Uniform_v2c < handle

properties (SetAccess = private)                   
    Method = 'RadialAcc_Ramp2Uniform_v2c'
    RADACCipt;
    RampRate;
    Beginning;
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function RADACC = RadialAcc_Ramp2Uniform_v2c(varargin)    
    if length(varargin) == 1
        RADACC.RADACCipt = varargin{1};
        RADACC.RampRate = str2double(RADACC.RADACCipt.('RampRate')); 
        RADACC.Beginning = str2double(RADACC.RADACCipt.('Beginning'));
    end
end 

%==================================================================
% InitViaCompass
%==================================================================  
function InitViaCompass(RADACC,RADACCipt)    
    RADACC.RADACCipt = RADACCipt;
    RADACC.RampRate = str2double(RADACCipt.('RampRate')); 
    RADACC.Beginning = str2double(RADACCipt.('Beginning')); 
end 

%==================================================================
% InitViaCompass
%==================================================================  
function InitExternal(RADACC,RampRate,Beginning)    
    RADACC.RampRate = RampRate;
    RADACC.Beginning = Beginning;
end 

%====================================================
% RadialAcc
%====================================================
function Val = RadialAcc(RADACC,t,r)
    Val = 1-RADACC.Beginning*exp(-RADACC.RampRate*(r)); 
end

end
end
