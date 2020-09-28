%====================================================
% (v1c)
%    
%====================================================


function [SCRPTipt,TEST,err] = TrajTest_YarnBallTestFull_v1c(SCRPTipt,TESTipt) 

Status('busy','Get Trajectory Testing Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEST.method = TESTipt.Func;
TEST.figloc = TESTipt.('FigureLoc');
TEST.timecast = TESTipt.('TimAdj');
TEST.testspeed = TESTipt.('TestSpeed');

Status2('done','',2);
Status2('done','',3);










