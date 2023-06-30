%==================================================================
% (v2b)
%   - update call to TEND (give all FINMETH)
%==================================================================

classdef FinMeth_CompensateThenEnd_v2b < handle

properties (SetAccess = private)                   
    Method = 'FinMeth_CompensateThenEnd_v2b'
    FINMETHipt
    sysrespfunc
    SYSRESP
    CompDurPastGrad = 400
    Panel = cell(0)
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function FINMETH = FinMeth_CompensateThenEnd_v2b(FINMETHipt)    
    FINMETH.FINMETHipt = FINMETHipt;
    FINMETH.sysrespfunc = FINMETHipt.('SysRespfunc').Func;    
    
    %---------------------------------------------
    % Get Working Structures from Sub Functions
    %---------------------------------------------    
    CallingFunction = FINMETHipt.Struct.labelstr;
    SYSRESPipt = FINMETHipt.('SysRespfunc');
    if isfield(FINMETHipt,([CallingFunction,'_Data']))
        if isfield(FINMETHipt.([CallingFunction,'_Data']),('SysRespfunc_Data'))
            SYSRESPipt.SysRespfunc_Data = FINMETHipt.([CallingFunction,'_Data']).SysRespfunc_Data;
        end
    end
    
    %------------------------------------------
    % Create Shell Objects
    %------------------------------------------
    func = str2func(FINMETH.sysrespfunc);                   
    [FINMETH.SYSRESP,err] = func(SYSRESPipt); 
    if err.flag
        return
    end
end 

%==================================================================
% Finish
%==================================================================  
function err = Finish(FINMETH,qkSpace,DESTYPE,IMPMETH)
    
    %----------------------------------------------------
    % Compensate
    %----------------------------------------------------
    err = FINMETH.SYSRESP.Compensate(DESTYPE.SolutionTiming,qkSpace,FINMETH.CompDurPastGrad,DESTYPE,IMPMETH);
    if err.flag
        return
    end
    
    %----------------------------------------------------
    % End
    %----------------------------------------------------
    err = IMPMETH.TEND.EndTrajectories(FINMETH,DESTYPE);
    if err.flag
        return
    end
    
end

end
end






