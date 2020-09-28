%====================================================
%
%====================================================

function [TIMADJ,err] = TimingAdjust_SingleCastImpProfile_v1b_Func(TIMADJ,INPUT)

Status2('busy','Adjust Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
PROJdgn = INPUT.PROJdgn;
GENPRJ = INPUT.GENPRJ;
DESTYPE = INPUT.DESTYPE;
IMPTYPE = INPUT.IMPTYPE;
DESOL = INPUT.DESOL;
CLR = INPUT.CLR;
TST = INPUT.TST;
CACC = TIMADJ.CACC;
GVP = TIMADJ.GVP;
clear INPUT;

%------------------------------------------
% Get DE solution timing
%------------------------------------------
func = str2func([DESOL.method,'_Func']);        
INPUT.PROJdgn = PROJdgn;
INPUT.DESTYPE = IMPTYPE;
INPUT.TST = TST;
INPUT.courseadjust = 'yes';    
[DESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Do ImpType Things
%------------------------------------------
func = str2func([IMPTYPE.method,'_Func']);     
INPUT.DESOL = DESOL;
INPUT.CLR = CLR;
INPUT.DESTYPE = DESTYPE;
INPUT.func = 'PreGeneration';   
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Generate outward trajectories
%---------------------------------------------  
func = str2func([DESTYPE.method,'_Func']);    
INPUT.PSMP.phi = 0;
INPUT.PSMP.theta = 0;
INPUT.PROJdgn = PROJdgn;
INPUT.GENPRJ = GENPRJ;
INPUT.DESOL = DESOL;
INPUT.func = 'GenerateOut';      
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;
T = IMPTYPE.T;
KSA = IMPTYPE.KSA;

%------------------------------------------
% Test Solution Fineness
%------------------------------------------
% SOLFINTEST.method = 'SolFinTest_YarnBall_v1a';
% func = str2func([SOLFINTEST.method,'_Func']);    
% INPUT.T = T;
% INPUT.KSA = KSA;
% INPUT.PROJdgn = PROJdgn;
% INPUT.TST = TST;
% [SOLFINTEST,err] = func(SOLFINTEST,INPUT);
% if err.flag
%     return
% end
% clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
testtro = interp1(Rad,T,1,'spline');         % ensure proper timing  
if round(testtro*1e5) ~= round(PROJdgn.tro*1e5)
    error
end

%---------------------------------------------
% Constrain acceleration
%---------------------------------------------
func = str2func([CACC.method,'_Func']);  
INPUT.TArr = T;
INPUT.type = '3D';
INPUT.PROJdgn = PROJdgn;
INPUT.TST = TST;
INPUT.GVP = GVP;
INPUT.check = 0;
INPUT.ProfileTest = 'Yes';
INPUT.kArr = squeeze(KSA);
[CACC,err] = func(CACC,INPUT);
if err.flag ~= 0
    return
end
clear INPUT;   
Tout = CACC.TArr;

%---------------------------------------------
% Test
%---------------------------------------------
testtro = interp1(Rad,Tout,1,'spline'); 
if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
    error
end

%---------------------------------------------
% Determine Initial Radial Speed
%---------------------------------------------    
ind = find(Tout > 1,1,'first');
TIMADJ.kRadAt1ms = Rad(ind)*PROJdgn.kmax;
ind = find(Tout > 0.3,1,'first');
TIMADJ.kRadAt03ms = Rad(ind)*PROJdgn.kmax;

%---------------------------------------------
% Return
%--------------------------------------------- 
TIMADJ.ConstEvolT = Tout;
TIMADJ.ConstEvolRad = Rad;

%---------------------------------------------
% Return
%---------------------------------------------
TIMADJ.CACC = CACC;

Status2('done','',2);
Status2('done','',3);



    