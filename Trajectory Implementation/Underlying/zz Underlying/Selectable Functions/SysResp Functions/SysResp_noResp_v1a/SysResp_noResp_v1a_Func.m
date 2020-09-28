%=====================================================
% 
%=====================================================

function [SYSRESP,err] = SysResp_noResp_v1a_Func(SYSRESP,INPUT)

Status2('busy','No System Response',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
qT0 = INPUT.qT0;
if isfield(INPUT,'GQKSA0')
    GQKSA0 = INPUT.GQKSA0;
end
if isfield(INPUT,'G0')
    G0 = INPUT.G0;
end
mode = INPUT.mode;
clear INPUT

%==================================================================
% Delay Gradient (potentially relevant for Siemens which starts the Gradients early)
%==================================================================
if strcmp(mode,'Delay')
    SYSRESP.GQKSA = GQKSA0;
    SYSRESP.qT = qT0;
    SYSRESP.efftrajdel = 0;
    Status2('done','',3);
end

%==================================================================
% Compensate 
%==================================================================
if strcmp(mode,'Compensate')
    SYSRESP.Gcomp = G0;
    SYSRESP.Tcomp = qT0;
    SYSRESP.efftrajdel = 0;                                  % for calculating end of trajectory
    Status2('done','',3);
    return
end

%==================================================================
% Analyze
%==================================================================
if strcmp(mode,'Analyze')
    SYSRESP.Grecon = G0;
    SYSRESP.Trecon = qT0;
    SYSRESP.efftrajdel = 0;
    Status2('done','',3);
end
