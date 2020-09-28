%=====================================================
% (v1i)
%       - same as 'SysResp_FromFileWithComp_v1i'
%       - just 'Comp' part removed
%=====================================================

function [SCRPTipt,SYSRESP,err] = SysResp_FromFileNoComp_v1i(SCRPTipt,SYSRESPipt)

Status2('busy','Get SysResp Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
SYSRESP.method = SYSRESPipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = SYSRESPipt.Struct.labelstr;
if not(isfield(SYSRESPipt,[CallingLabel,'_Data']))
    if isfield(SYSRESPipt.('SysRespFIR_File').Struct,'selectedfile')
        file = SYSRESPipt.('SysRespFIR_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SysRespFIR_File';
            ErrDisp(err);
            return
        else
            load(file);
            SYSRESPipt.([CallingLabel,'_Data']).('SysRespFIR_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SysRespFIR_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SYSRESP.GSYSMOD = SYSRESPipt.([CallingLabel,'_Data']).('SysRespFIR_File_Data').GSYSMOD;

Status2('done','',2);
Status2('done','',3);