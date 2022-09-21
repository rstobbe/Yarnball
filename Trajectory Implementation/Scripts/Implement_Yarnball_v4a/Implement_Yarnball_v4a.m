%=========================================================
% (v4a)
%   - Facilitate objects
%   - Drop all sub-calls to lower level
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Implement_Yarnball_v4a(SCRPTipt,SCRPTGBL)

Status('busy','Implement Trajectory Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

global COMPASSINFO
drv = COMPASSINFO.USERGBL.softwaredrive;

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Imp_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Des_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Des_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Des_File').Struct.selectedfile;
        if not(exist(file,'file'))
            file = [drv file(4:end)];
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load Des_File - path no longer valid';
                ErrDisp(err);
                return
            end
        end
        Status('busy','Load Trajectory Implementation');
        load(file);
        saveData.path = file;
        SCRPTGBL.('Des_File_Data') = saveData;
    else
        err.flag = 1;
        err.msg = '(Re) Load Des_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
IMP.method = SCRPTGBL.CurrentTree.Func;
IMP.impmethfunc = SCRPTGBL.CurrentTree.('ImpMethfunc').Func;

%---------------------------------------------
% Get Trajectory Design
%---------------------------------------------
DES = SCRPTGBL.Des_File_Data.DES;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMPMETHipt = SCRPTGBL.CurrentTree.('ImpMethfunc');  
if isfield(SCRPTGBL,('ImpMethfunc_Data'))
    IMPMETHipt.ImpMethfunc_Data = SCRPTGBL.ImpMethfunc_Data;
end

%---------------------------------------------
% Implement Design
%---------------------------------------------
func = str2func(IMP.impmethfunc);           
[IMPMETH,err] = func(IMPMETHipt);
if err.flag
    return
end
err = IMPMETH.Implement(DES);
if err.flag
    return
end
IMP = IMPMETH;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = IMP.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
if IMP.BLD.Testing
    name = ['IMPt_',DES.name(5:end)];
else
    name = ['IMP_',DES.name(5:end)];
end
    
%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Implementation:','Name',[1 60],{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
IMP.name = name{1};

SCRPTipt(indnum).entrystr = IMP.name;
SCRPTGBL.RWSUI.SaveVariables = IMP;
SCRPTGBL.RWSUI.SaveVariableNames = 'IMP';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = IMP.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = IMP.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

