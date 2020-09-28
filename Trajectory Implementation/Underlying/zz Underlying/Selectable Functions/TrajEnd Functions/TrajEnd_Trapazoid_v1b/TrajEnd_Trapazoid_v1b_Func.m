%=============================================================
% 
%=============================================================

function [TEND,err] = TrajEnd_Trapazoid_v1b_Func(TEND,INPUT)

Status2('busy','End Trajectory',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
SYS = INPUT.SYS;
gseg = SYS.GradSampBase/1000;
Gmom = INPUT.Gmom;
Gend0 = INPUT.Gend;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if round(sum(Gmom(1,1,:))*1e6) || round(sum(Gend0(1,1,:))*1e6)
    err.flag = 1;
    err.msg = 'For Trapazoid trajectory must end at zero';
end

%---------------------------------------------
% Extra Gradient Moment
%---------------------------------------------
Gmomadd = TEND.spoilfactor*PROJdgn.kmax/PROJimp.gamma;

%---------------------------------------------
% Build
%---------------------------------------------
sz = size(Gend0);
nproj = sz(1);
type = 0;
len = gseg*round((Gmomadd/TEND.gmag)/gseg);
gstep = gseg*TEND.slope;
gmag = gstep*round(sqrt(Gmomadd*TEND.slope)/gstep);
risetime = TEND.gmag/TEND.slope;
if (len < risetime*2) && (gmag < TEND.gmag)
    type = 1;
end

if type == 0    
    gstep = gseg*TEND.slope;
    rise = (gstep:gstep:TEND.gmag);
    rem = len/gseg - length(rise);
    trap = [rise TEND.gmag*ones(1,rem) flip(rise)];
end

if type == 1    
    gstep = gseg*TEND.slope;
    gmag = gstep*round(sqrt(Gmomadd*TEND.slope)/gstep);
    rise = (gstep:gstep:gmag);
    trap = [rise flip(rise(1:end-1)) 0];
end

Gend = zeros(nproj,length(trap),3);
Gend(:,:,3) = repmat(trap,nproj,1,1);

TEND.Gend = Gend;

Status2('done','',3);



