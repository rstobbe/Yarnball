%====================================================
% (v2b)
%      - Call Yarnball Object
%====================================================

function [SCRPTipt,SCRPTGBL,err] = Design_Yarnball_v2b(SCRPTipt,SCRPTGBL)

Status('busy','Create Proj3D Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Design_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Load Input
%---------------------------------------------
DES.method = SCRPTGBL.CurrentTree.Func;
DES.desmethfunc = SCRPTGBL.CurrentTree.('DesMethfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
DESMETHipt = SCRPTGBL.CurrentTree.('DesMethfunc');
if isfield(SCRPTGBL,('DesMethfunc_Data'))
    DESMETHipt.DesMethfunc_Data = SCRPTGBL.DesMethfunc_Data;
end

%------------------------------------------
% Get DesMeth Function Info
%------------------------------------------
func = str2func(DES.desmethfunc);           
DESMETH = func(DESMETHipt);

%---------------------------------------------
% Generate Yarnball
%---------------------------------------------
err = DESMETH.DesignYarnball;
if err.flag
    return
end
clear INPUT;
DES = DESMETH;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = DES.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Design:','Name',[1 60],{DES.name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {DES};
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
DES.SetName(name{1});

SCRPTipt(indnum).entrystr = DES.name;
SCRPTGBL.RWSUI.SaveVariables = DES;
SCRPTGBL.RWSUI.SaveVariableNames = 'DES';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = DES.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = DES.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

