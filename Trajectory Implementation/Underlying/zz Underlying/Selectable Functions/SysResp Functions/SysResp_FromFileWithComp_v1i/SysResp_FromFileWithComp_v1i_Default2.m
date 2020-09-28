%====================================================
%
%====================================================

function [default] = SysResp_FromFileWithComp_v1i_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'SysRespFIR_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.sysresploc;
default{m,1}.runfunc2 = 'LoadScriptFileDisp';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.sysresploc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ErrSmoothKern';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Iterations';
default{m,1}.entrystr = '10';