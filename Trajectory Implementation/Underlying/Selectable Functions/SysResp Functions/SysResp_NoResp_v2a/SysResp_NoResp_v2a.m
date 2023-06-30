%==================================================================
% (v2a)
%      
%==================================================================

classdef SysResp_NoResp_v2a < handle

properties (SetAccess = private)                   
    Method = 'SysResp_NoResp_v2a'
    SYSRESPipt
    GRAD
    TimeComp
    GradComp
    TimeResp
    GradResp
    TrajectoryDelay
    Panel = cell(0)
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function [SYSRESP,err] = SysResp_NoResp_v2a(SYSRESPipt)    
    err.flag = 0;
    %------------------------------------------
    % Create Shell Objects
    %------------------------------------------
    func = str2func('Gradient_Calculations_v2a');           
    SYSRESP.GRAD = func('');         
end 

%==================================================================
% Compensate
%==================================================================  
function err = Compensate(SYSRESP,qT0,qkSpace0,CompDurPastGrad,DESTYPE,IMPMETH)
    
    Status2('busy','Compensate Gradients',2); 
    err.flag = 0;
    NUC = DESTYPE.NUC;

    %---------------------------------------------
    % Generate Initial Gradients
    %---------------------------------------------     
    SYSRESP.GRAD.SetGamma(NUC.gamma);
    SYSRESP.GRAD.SetTimeQuant(DESTYPE.GradTimeQuant);
    Grad0 = SYSRESP.GRAD.CalculateGradientsReturn(qkSpace0); 

    SYSRESP.GradComp = Grad0;
    SYSRESP.TimeComp = qT0;
    SYSRESP.GradResp = Grad0;
    SYSRESP.TimeResp = qT0;
    Status2('done','',2); 
    Status2('done','',3); 
    
    SYSRESP.TrajectoryDelay = 0;
end


end
end






