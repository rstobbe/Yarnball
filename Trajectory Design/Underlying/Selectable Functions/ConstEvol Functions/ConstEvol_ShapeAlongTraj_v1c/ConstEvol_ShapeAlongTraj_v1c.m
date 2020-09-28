%==================================================
%  (v1c)
%       - Gacc from 'GvelProf' 
%==================================================

function [SCRPTipt,CACC,err] = ConstEvol_ShapeAlongTraj_v1c(SCRPTipt,CACCipt)

Status2('done','Get Acceleration Constraint info',3);

err.flag = 0;
err.msg = '';

CACC.method = CACCipt.Func;   

Status2('done','',3);