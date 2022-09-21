%==================================================================
% (v2a)
%   
%==================================================================

classdef TrajSamp_SiemensStandard_v2a < handle

properties (SetAccess = private)                   
    Method = 'TrajSamp_SiemensStandard_v2a'
    TSMPipt
    DwellCrit
    MinBandPassOSamp
    DwellProt
    Dwell
    ScnrPtsProt
    ScnrSampTimeTotal
    ScnrPtsTot
    TrajOverSamp
    SamplingBandwidth
    BandPassOverSamp
    Panel = cell(0)
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TSMP = TrajSamp_SiemensStandard_v2a(TSMPipt)    
    TSMP.TSMPipt = TSMPipt;
    TSMP.MinBandPassOSamp = str2double(TSMPipt.('MinBandPassOSamp'));
end 

%==================================================================
% DefineTrajSamp
%==================================================================  
function err = DefineTrajSamp(TSMP,DESTYPE,IMPMETH)    
    
    err.flag = 0;
    SYS = DESTYPE.SYS;
    SYSRESP = IMPMETH.FINMETH.SYSRESP;
    %---------------------------------------------
    % Dwell time for critical sampling
    %---------------------------------------------                 
    TSMP.DwellCrit = 1000/(2*DESTYPE.MaxSphereFreq);                            % in ms

    %---------------------------------------------
    % Initial estimate of dwell and npro  
    %---------------------------------------------
    dwell0 = TSMP.DwellCrit/SYS.SysOverSamp;

    %---------------------------------------------
    % Make dwell a multiple of sampbase
    %---------------------------------------------                             
    dwell = dwell0*1e6*1.05 - rem(dwell0*1e6*1.05,SYS.SampBase); 
    while true
        DwellProt0 = dwell*SYS.SysOverSamp; 
        if rem(round(DwellProt0),SYS.SampBase) == 0
            TrajOverSamp0 = TSMP.DwellCrit/(dwell/1e6);
            if TrajOverSamp0 > SYS.SysOverSamp*TSMP.MinBandPassOSamp 
                break
            else
                dwell = dwell - SYS.SampBase;
            end
        else
            dwell = dwell - SYS.SampBase;
        end
    end
    if dwell < SYS.MinDwell
        err.flag = 1;
        err.msg = 'Reduce MinBandPassOSamp';
    end    
    TSMP.DwellProt = DwellProt0/1e6;
    TSMP.Dwell = TSMP.DwellProt/SYS.SysOverSamp;
    
    %---------------------------------------------
    % Increase Total Sampling Time for Accomodations
    %---------------------------------------------
    ScnrSampTimeTotal0 = DESTYPE.SamplingTro + SYSRESP.TrajectoryDelay;
    ScnrPtsProt0 = ceil(ScnrSampTimeTotal0/TSMP.DwellProt);
    while true
        if rem(ScnrPtsProt0,16) == 0                   % make sure protocol data points a multiple of 16                            
            break
        else
            ScnrPtsProt0 = ScnrPtsProt0+1;
        end
    end
    TSMP.ScnrPtsProt = ScnrPtsProt0;
    TSMP.ScnrSampTimeTotal = (TSMP.ScnrPtsProt * TSMP.DwellProt);
    TSMP.ScnrPtsTot = TSMP.ScnrPtsProt * SYS.SysOverSamp;
    
    %---------------------------------------------
    % Return
    %---------------------------------------------
    TSMP.TrajOverSamp = TSMP.DwellCrit/TSMP.Dwell;                  % how much oversampled from design
    TSMP.SamplingBandwidth = 1000/TSMP.Dwell;
    TSMP.BandPassOverSamp = TSMP.TrajOverSamp/SYS.SysOverSamp;
    
    %---------------------------------------------
    % Panel Output
    %--------------------------------------------- 
    TSMP.Panel(1,:) = {'Dwell (ms)',TSMP.Dwell,'Output'};
    TSMP.Panel(2,:) = {'BandPassOverSamp',TSMP.TrajOverSamp/SYS.SysOverSamp,'Output'};
end

end
end






