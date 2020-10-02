%====================================================
%
%====================================================

function [TIMADJ,err] = TimingAdjust_Dummy_v1a_Func(TIMADJ,INPUT)

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
if not(isfield(INPUT,'IMPTYPE'))
    err.flag = 1;
    err.msg = 'This ''TimingAdjustfunc'' is not for trajectory design';
    return
end
IMPTYPE = INPUT.IMPTYPE;
DESOL = INPUT.DESOL;
CLR = INPUT.CLR;
TST = INPUT.TST;
clear INPUT;

%------------------------------------------
% Get DE solution timing
%------------------------------------------
func = str2func([DESOL.method,'_Func']);        
INPUT.PROJdgn = PROJdgn;
INPUT.DESTYPE = IMPTYPE;
INPUT.TST = TST;
INPUT.courseadjust = 'yes';    
[CDESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Do ImpType Things
%------------------------------------------
func = str2func([IMPTYPE.method,'_Func']);     
INPUT.DESOL = CDESOL;
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
INPUT.PSMP.phi = [0,pi/4,pi/2,3*pi/4];
INPUT.PSMP.theta = [0,0,0,0];
INPUT.PROJdgn = PROJdgn;
INPUT.GENPRJ = GENPRJ;
INPUT.DESOL = CDESOL;
INPUT.func = 'GenerateOut';
INPUT.PROJdgn.elip = 1;
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;
T = IMPTYPE.T;
KSA = IMPTYPE.KSA;

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
Tout = T;

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
INPUT.PSMP.phi = [0,pi/4,pi/2,3*pi/4];
INPUT.PSMP.theta = [0,0,0,0];
INPUT.PROJdgn = PROJdgn;
INPUT.GENPRJ = GENPRJ;
INPUT.DESOL = DESOL;
INPUT.func = 'GenerateOut';
INPUT.PROJdgn.elip = 1;
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;
KSA = IMPTYPE.KSA;

%------------------------------------------
% Solve T at Evolution Constraint
%------------------------------------------
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
T = interp1(TIMADJ.ConstEvolRad,TIMADJ.ConstEvolT,Rad,'spline');
testtro = interp1(Rad,T,1,'spline'); 
if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
    error
end
TIMADJ.TrajOutTimEnd = T(end);

%---------------------------------------------
% Return
%---------------------------------------------
TIMADJ.T = T;
TIMADJ.CACC = struct();

Status2('done','',2);
Status2('done','',3);



    