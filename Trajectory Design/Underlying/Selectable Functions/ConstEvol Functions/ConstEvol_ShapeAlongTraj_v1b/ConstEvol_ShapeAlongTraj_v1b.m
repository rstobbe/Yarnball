%==================================================
%  (v1b)
%       - Move 'GvelProf' up a level
%==================================================

function [SCRPTipt,CACC,err] = ConstEvol_ShapeAlongTraj_v1b(SCRPTipt,CACCipt)

Status2('done','Get Acceleration Constraint info',3);

err.flag = 0;
err.msg = '';

CACC.method = CACCipt.Func;   

Status2('done','',3);