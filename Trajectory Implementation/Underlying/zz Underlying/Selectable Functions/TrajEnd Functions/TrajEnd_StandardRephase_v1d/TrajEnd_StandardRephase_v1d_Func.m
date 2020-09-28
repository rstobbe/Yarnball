%=============================================================
% 
%=============================================================

function [TEND,err] = TrajEnd_StandardRephase_v1d_Func(TEND,INPUT)

Status2('busy','End Trajectory',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
gseg = INPUT.SYS.GradSampBase/1000;
slope = TEND.slope;
Gmom = INPUT.Gmom;
Gend0 = INPUT.Gend;
clear INPUT;

%---------------------------------------------
% Solve Rephase
%---------------------------------------------
sz = size(Gmom);
nproj = sz(1);
gstep = gseg*slope;
Grphs = zeros(nproj,1000,3);
for n = 1:nproj;
    for i = 1:3 
        Gend = Gend0(n,1,i);                            % make sure input in this format                       
        Gendtrngle = sign(Gend)*Gend^2/(2*slope);
        Gmomrem = Gmom(n,1,i)+Gendtrngle;
        if Gend < 0 && Gmomrem < 0
            dir = 1;                                    % dir = 1 means toward 0 and dir = -1 means away from 0
            GrphsSgn = 1;
            sol = 1;
        elseif  Gend < 0 && Gmomrem > 0
            dir = -1;
            GrphsSgn = -1;
            sol = 1;
            if Gmomrem < abs(Gend)*gseg
                sol = 2;
            end
        elseif  Gend > 0 && Gmomrem < 0
            dir = -1;
            GrphsSgn = 1;
            sol = 1;
            if abs(Gmomrem) < Gend*gseg
                sol = 2;
            end
        elseif  Gend > 0 && Gmomrem > 0
            dir = 1;
            GrphsSgn = -1;
            sol = 1;
        end
        if sol == 1
            Grphs = Solution1(Grphs,Gmom,Gend,dir,GrphsSgn,slope,gstep,n,i);
        else
            Grphs = Solution2(Grphs,Gmom,Gend,dir,GrphsSgn,slope,gstep,n,i);
        end
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

%=============================================================
% Solution1
%=============================================================
function Grphs = Solution1(Grphs,Gmom,Gend,dir,GrphsSgn,slope,gstep,n,i)

    GrphsMag = sqrt(-dir*sign(Gend)*GrphsSgn*Gend^2/2 - Gmom(n,1,i)*GrphsSgn*slope);

    test = Gmom(n,1,i) + dir*sign(Gend)*Gend^2/(2*slope) + GrphsSgn*GrphsMag^2/(slope);
    if round(test*1e6) ~= 0
        error();
    end    
    GrphsVal = GrphsSgn*GrphsMag;

    if dir == 1
        Grphs1 = (Gend-sign(Gend)*gstep/2:-sign(Gend)*gstep:GrphsVal);
    else
        Grphs1 = (Gend+sign(Gend)*gstep/2:sign(Gend)*gstep:GrphsVal);
    end
    if isempty(Grphs1)
        Grphs1 = GrphsVal;
    end

    lft = GrphsVal - Grphs1(length(Grphs1));
    Grphs2 = (GrphsVal-GrphsSgn*gstep+lft:-GrphsSgn*gstep:0);
    Grphs0 = [Grphs1 Grphs2 0];
    Grphs(n,1:length(Grphs0),i) = Grphs0;
end


%=============================================================
% Solution2
%=============================================================
function Grphs = Solution2(Grphs,Gmom,Gend,dir,GrphsSgn,slope,gstep,n,i)

    GrphsMag = sqrt(abs(Gmom(n,1,i))*2*slope);

    test = Gmom(n,1,i) - dir*sign(Gend)*GrphsMag^2/(2*slope);
    if round(test*1e6) ~= 0
        error();
    end    
    GrphsVal = GrphsSgn*GrphsMag;

    Grphs2 = (GrphsVal-GrphsSgn*gstep/2:-GrphsSgn*gstep:0);
    Grphs0 = [Grphs2 0];
    Grphs(n,1:length(Grphs0),i) = Grphs0;
end
