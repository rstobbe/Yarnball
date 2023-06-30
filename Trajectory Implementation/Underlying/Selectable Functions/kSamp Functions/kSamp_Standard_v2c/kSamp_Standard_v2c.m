%==================================================================
% (v2c)
%   - Timing Fiddle
%==================================================================

classdef kSamp_Standard_v2c < handle

properties (SetAccess = private)                   
    Method = 'kSamp_Standard_v2c'
    KSMPipt
    TimingFiddle
    Panel = cell(0)
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function KSMP = kSamp_Standard_v2c(KSMPipt)    
    KSMP.KSMPipt = KSMPipt;
    KSMP.TimingFiddle = str2double(KSMPipt.TimingFiddle)/1000;
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
    if KSMP.TimingFiddle > 0
        [kSpace0,~] = ReSampleKSpace_v7a(SYSRESP.GradResp,SYSRESP.TimeResp,Samp0+KSMP.TimingFiddle,NUC.gamma);
    else
        [kSpace0,~] = ReSampleKSpace_v7a(SYSRESP.GradResp,SYSRESP.TimeResp+abs(KSMP.TimingFiddle),Samp0,NUC.gamma);
    end
        
    %---------------------------------------------
    % Sample to very end
    %---------------------------------------------
    for n = 1:length(KINFO)
        KINFO(n).SetSamplingPtStart(ceil((KINFO(n).DesignSamplingTimeStart+SYSRESP.TrajectoryDelay)/TSMP.Dwell));                   
        KINFO(n).SetSamplingPts(floor(KINFO(n).DesignTro/TSMP.Dwell));
        KINFO(n).SetTro(round(KINFO(n).SamplingPts*TSMP.Dwell*1e9)/1e9);
        KINFO(n).SetSamplingTimeOnTrajectory(Samp0(KINFO(n).SamplingArray));
        KINFO(n).SetSamplingTimeToCentre(TSMP.Dwell*ceil((KINFO(n).DesignSamplingTimeToCentre+SYSRESP.TrajectoryDelay)/TSMP.Dwell));
        KINFO(n).SetkSpace(kSpace0(:,KINFO(n).SamplingArray,:));
    end

    Status2('done','',2);
    Status2('done','',3);

end


end
end






