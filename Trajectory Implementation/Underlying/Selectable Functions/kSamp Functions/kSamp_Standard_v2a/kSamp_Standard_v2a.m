%==================================================================
% (v2a)
%   
%==================================================================

classdef kSamp_Standard_v2a < handle

properties (SetAccess = private)                   
    Method = 'kSamp_Standard_v2a'
    KSMPipt
    Panel = cell(0)
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function KSMP = kSamp_Standard_v2a(KSMPipt)    
    KSMP.KSMPipt = KSMPipt;
end 

%==================================================================
% Sample
%==================================================================  
function err = Sample(KSMP,IMPMETH)

    Status2('busy','Sample k-Space',2); 
    err.flag = 0;
    TSMP = IMPMETH.TSMP;
    SYSRESP = IMPMETH.FINMETH.SYSRESP;
    NUC = IMPMETH.NUC;
    KINFO = IMPMETH.KINFO; 
    
    %---------------------------------------------
    % Sample k-Space
    %---------------------------------------------
    Samp0 = (0:TSMP.Dwell:TSMP.ScnrSampTimeTotal);    
    [kSpace0,~] = ReSampleKSpace_v7a(SYSRESP.GradResp,SYSRESP.TimeResp,Samp0,NUC.gamma);
    
    %---------------------------------------------
    % Sample to very end
    %---------------------------------------------
    KINFO.SetSamplingStart(ceil((KINFO.DesignTimingStart+SYSRESP.TrajectoryDelay)/TSMP.Dwell));                   
    KINFO.SetSamplingPts(floor(KINFO.tro/TSMP.Dwell));
    KINFO.SetTro(KINFO.SamplingPts*TSMP.Dwell);
    KINFO.SetSamplingTimeOnTrajectory(Samp0(KINFO.SamplingArray));
    KINFO.SetkSpace(kSpace0(:,KINFO.SamplingArray,:));
 

    Status2('done','',2);
    Status2('done','',3);

end




end
end






