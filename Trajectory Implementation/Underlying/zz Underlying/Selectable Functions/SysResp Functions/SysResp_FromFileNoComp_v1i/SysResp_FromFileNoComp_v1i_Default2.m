%====================================================
%
%====================================================

function [default] = SysResp_FromFileNoComp_v1i_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'SysRespFIR_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.sysresploc;
default{m,1}.runfunc2 = 'LoadScriptFileDisp';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.sysresploc;


