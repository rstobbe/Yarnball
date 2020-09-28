%=============================================================
% 
%=============================================================

function [TEND,err] = TrajEnd_HoldDropConstMag_v1a_Func(TEND,INPUT)

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
slope = TEND.slope;
Gend0 = INPUT.Gend;
Gmom = INPUT.Gmom;
clear INPUT;

%---------------------------------------------
% Hold
%---------------------------------------------
sz = size(Gend0);
nproj = sz(1);

%---------------------------------------------
% Calculate Hold
%---------------------------------------------
GMomNeed = TEND.spoilfactor*PROJdgn.kmax/PROJimp.gamma;

for n = 1:nproj
    func = @(Hold) HoldOpt(squeeze(Gmom(n,1,:)),squeeze(Gend0(n,1,:)),GMomNeed,gseg,slope,Hold);
    Hold0 = 0.5;
    Hold(n) = fminsearch(func,Hold0);
end

%---------------------------------------------
% Build
%---------------------------------------------
Gspoil = zeros(nproj,1000,3);
for n = 1:nproj
    Gspoil(n,:,:) = BuildHoldDrop(Gend0(n,1,:),gseg,slope,Hold(n));
end

test = sum(abs(Gspoil),1);
test = sum(test,3);
test = squeeze(test);
ind = find(test == 0,1,'first');
Gspoil = Gspoil(:,1:ind,:);

%---------------------------------------------
% Return
%---------------------------------------------
TEND.Gend = Gspoil;
TEND.rphsslope = slope;

Status2('done','',3);


%======================================================================
%
%======================================================================
function x = HoldOpt(GMom0,Gend,GMomNeed,gseg,slope,hold)

Gspoil = BuildHoldDrop(Gend,gseg,slope,hold);

GMom = sum(Gspoil,1)*gseg;
GMomTot = GMom0 + GMom.';
GMomTotMag = sqrt(GMomTot(1).^2 + GMomTot(2).^2 + GMomTot(3).^2);

x = abs(GMomTotMag - GMomNeed);


%======================================================================
%
%======================================================================
function Gspoil = BuildHoldDrop(Gend,gseg,slope,hold)

GendMag = sqrt(Gend(1).^2 + Gend(2).^2 + Gend(3).^2);

holdsteps = round(hold/gseg);
Gspoil = zeros(1000,3);
for i = 1:3
    Gspoil(1:holdsteps,i) = Gend(i).*ones(holdsteps,1);
end
DropTime = GendMag/slope; 
for i = 1:3 
    gstep = gseg*abs(Gend(i))/DropTime;
    drop = (Gend(i)-sign(Gend(i))*gstep:-sign(Gend(i))*gstep:0);
    Gspoil(holdsteps+(1:length(drop)),i) = drop;
end



