%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef DesMeth_YarnBall_v2b < handle

properties (SetAccess = private)                   
    Method = 'DesMeth_YarnBall_v2b'
    DESMETHipt
    destypefunc
    nucfunc
    sysfunc
    DESTYPE
    NUC
    SYS
    Panel
    PanelOutput
    ExpDisp
    Figure
end
properties (SetAccess = public)    
    name
    path
    saveSCRPTcellarray
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function DESMETH = DesMeth_YarnBall_v2b(DESMETHipt)    
    DESMETH.DESMETHipt = DESMETHipt;

    %---------------------------------------------
    % Load Panel Input
    %---------------------------------------------
    DESMETH.destypefunc = DESMETHipt.('DesTypefunc').Func;
    DESMETH.nucfunc = DESMETHipt.('Nucfunc').Func;
    DESMETH.sysfunc = DESMETHipt.('Sysfunc').Func;
    
    %---------------------------------------------
    % Get Working Structures from Sub Functions
    %---------------------------------------------
    DESTYPEipt = DESMETHipt.('DesTypefunc');
    if isfield(DESMETHipt,('DesTypefunc_Data'))
        DESTYPEipt.DesTypefunc_Data = DESMETHipt.DesTypefunc_Data;
    end
    NUCipt = DESMETHipt.('Nucfunc');
    if isfield(DESMETHipt,('Nucfunc_Data'))
        NUCipt.Nucfunc_Data = DESMETHipt.Nucfunc_Data;
    end
    SYSipt = DESMETHipt.('Sysfunc');
    if isfield(DESMETHipt,('Sysfunc_Data'))
        SYSipt.Sysfunc_Data = DESMETHipt.Sysfunc_Data;
    end
    
    %------------------------------------------
    % Build Object Shells
    %------------------------------------------
    func = str2func(DESMETH.destypefunc);                   
    DESMETH.DESTYPE = func(DESTYPEipt);
    func = str2func(DESMETH.nucfunc);                   
    DESMETH.NUC = func(NUCipt);
    func = str2func(DESMETH.sysfunc);                   
    DESMETH.SYS = func(SYSipt);
end 

%==================================================================
% DesignYarnball
%==================================================================  
function err = DesignYarnball(DESMETH) 
    err.flag = 0;
    err.msg = '';
    DESMETH.DESTYPE.Initialize(DESMETH.SYS,DESMETH.NUC);
    DESMETH.Figure = DESMETH.DESTYPE.Test;
    DESMETH.Panel = DESMETH.DESTYPE.Panel;
    DESMETH.PanelOutput = cell2struct(DESMETH.Panel,{'label','value','type'},2);
    DESMETH.ExpDisp = PanelStruct2Text(DESMETH.PanelOutput);
    DESMETH.ExpDisp = [newline DESMETH.ExpDisp];
    DESMETH.name = DESMETH.DESTYPE.Name;
end

%==================================================================
% SetName
%==================================================================  
function SetName(DESMETH,Name)
    DESMETH.name = Name;
end

end
end









