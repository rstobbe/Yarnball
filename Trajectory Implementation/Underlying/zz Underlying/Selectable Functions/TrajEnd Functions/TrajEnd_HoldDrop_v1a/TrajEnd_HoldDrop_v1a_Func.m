%=============================================================
% 
%=============================================================

function [TEND,err] = TrajEnd_HoldDrop_v1a_Func(TEND,INPUT)

Status2('busy','End Trajectory',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYS = INPUT.SYS;
gseg = SYS.GradSampBase/1000;
slope = sqrt((TEND.slope^2)/3);
Gend0 = INPUT.Gend;
clear INPUT;

%---------------------------------------------
% Hold
%---------------------------------------------
sz = size(Gend0);
nproj = sz(1);

holdsteps = (TEND.hold/1000) / gseg;
if rem(holdsteps,1)
    err.flag = 1;
    err.msg = 'Make TrajEnd Hold a multiple of gseg';
    return
end

Ghold = ones(nproj,holdsteps,3);
for n = 1:nproj
    for i = 1:3
        Ghold(n,:,i) = Gend0(n,1,i).*Ghold(n,:,i);
    end
end

%---------------------------------------------
% Drop
%---------------------------------------------
gstep = gseg*slope;
Grphs = zeros(nproj,1000,3);
for n = 1:nproj
    for i = 1:3 
         drop = (Gend0(n,1,i)-sign(Gend0(n,1,i))*gstep:-sign(Gend0(n,1,i))*gstep:0);
         Grphs(n,1:length(drop),i) = drop;
    end
end

test = sum(abs(Grphs),1);
test = sum(test,3);
test = squeeze(test);
ind = find(test == 0,1,'first');
Grphs = Grphs(:,1:ind,:);

%---------------------------------------------
% Join
%---------------------------------------------
Gend = cat(2,Ghold,Grphs);

%---------------------------------------------
% Return
%---------------------------------------------
TEND.Gend = Gend;
TEND.rphsslope = slope;

Status2('done','',3);
end

