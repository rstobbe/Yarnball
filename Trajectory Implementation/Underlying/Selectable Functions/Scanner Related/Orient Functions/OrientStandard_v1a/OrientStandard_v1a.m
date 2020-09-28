%====================================================
% (v1b)
%    - Include Physical Space Info
%====================================================

function [SCRPTipt,ORNT,err] = OrientSiemensDefault_v1b(SCRPTipt,ORNTipt)

Status2('busy','Orient Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ORNT.method = ORNTipt.Func;
ORNT.ScannerOrient = ORNTipt.('ScannerOrient');
ORNT.ReconOrient = ORNTipt.('ReconOrient');

Status2('done','',2);
Status2('done','',3);
