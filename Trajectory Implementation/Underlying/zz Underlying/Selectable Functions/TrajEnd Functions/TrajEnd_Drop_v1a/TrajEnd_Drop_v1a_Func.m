%=============================================================
% 
%=============================================================

function [TEND,err] = TrajEnd_Drop_v1a_Func(TEND,INPUT)

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
% Solve Rephase
%---------------------------------------------
sz = size(Gend0);
nproj = sz(1);
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
% Return
%---------------------------------------------
TEND.Gend = Grphs;
TEND.rphsslope = slope;

Status2('done','',3);
end

