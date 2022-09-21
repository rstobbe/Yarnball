%====================================================
% 
%====================================================

function [ORNT,err] = Orient_Flexible_v1d_Func(ORNT,INPUT)

Status2('busy','Define Orientation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSA = INPUT.KSA;
PROJdgn = INPUT.PROJdgn;
SYS = INPUT.SYS;
clear INPUT;

%---------------------------------------------
% Orient
%---------------------------------------------
% x -> ORNT.kxyz(1)
% y -> ORNT.kxyz(2)
% z -> ORNT.kxyz(3)
%---------------------------------------------
ind1 = strfind(ORNT.kxyz,'x');
ind2 = strfind(ORNT.kxyz,'y');
ind3 = strfind(ORNT.kxyz,'z');

ORNT.KSA = zeros(size(KSA));
ORNT.KSA(:,:,1) = KSA(:,:,ind1);
ORNT.KSA(:,:,2) = KSA(:,:,ind2);
ORNT.KSA(:,:,3) = KSA(:,:,ind3);

%---------------------------------------------
% Assign Resolution
%---------------------------------------------
if isfield(PROJdgn,'elip')
    elip = PROJdgn.elip;
else
    elip = 1;
end
if isfield(PROJdgn,'YbAxisElip')
    if strcmp(PROJdgn.YbAxisElip,'z')
        dimx = PROJdgn.vox;
        dimy = PROJdgn.vox;
        dimz = PROJdgn.vox/elip;
    elseif strcmp(PROJdgn.YbAxisElip,'y')
        dimx = PROJdgn.vox;
        dimy = PROJdgn.vox/elip;
        dimz = PROJdgn.vox;
    elseif strcmp(PROJdgn.YbAxisElip,'x')
        dimx = PROJdgn.vox/elip;
        dimy = PROJdgn.vox;
        dimz = PROJdgn.vox;
    end
else
    dimx = PROJdgn.vox;
    dimy = PROJdgn.vox;
    dimz = PROJdgn.vox/elip;
end

if strcmp(ORNT.kxyz,'xyz')
    ORNT.dimx = dimx;                     
    ORNT.dimy = dimy;   
    ORNT.dimz = dimz;
elseif strcmp(ORNT.kxyz,'yxz')
    ORNT.dimx = dimy;
    ORNT.dimy = dimx;   
    ORNT.dimz = dimz;
elseif strcmp(ORNT.kxyz,'zxy')
    ORNT.dimx = dimy;
    ORNT.dimy = dimz;   
    ORNT.dimz = dimx;    
elseif strcmp(ORNT.kxyz,'xzy')
    ORNT.dimx = dimx;
    ORNT.dimy = dimz;   
    ORNT.dimz = dimy;   
elseif strcmp(ORNT.kxyz,'yzx')
    ORNT.dimx = dimz;
    ORNT.dimy = dimx;   
    ORNT.dimz = dimy;   
elseif strcmp(ORNT.kxyz,'zyx')
    ORNT.dimx = dimz;
    ORNT.dimy = dimy;   
    ORNT.dimz = dimx;  
end
    
ORNT.PhysMatRelation = SYS.PhysMatRelation;
ORNT.dimLR = ORNT.dimx;                                  % should take 'PhysMatRelation' into account (now assuming Prisma...)
ORNT.dimTB = ORNT.dimy;   
ORNT.dimIO = ORNT.dimz; 

if elip == 1
    ORNT.ElipDim = 1;
else
    ORNT.ElipDim = find([ORNT.dimx ORNT.dimy ORNT.dimz] == max([ORNT.dimx ORNT.dimy ORNT.dimz]));
end

Status2('done','',2);
Status2('done','',3);