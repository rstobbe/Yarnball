%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef Orient_YarnFlex_v2a < handle

properties (SetAccess = private)                   
    Method = 'Orient_YarnFlex_v2a'
    ORNTipt
    kxyz
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function ORNT = Orient_YarnFlex_v2a(ORNTipt)    
    ORNT.ORNTipt = ORNTipt;
    ORNT.kxyz = ORNTipt.('YarnBall_xyz');
end 

%==================================================================
% GetOrientation
%==================================================================  
function kSpaceOut = Orient(ORNT,kSpace,SYS,ELIP,KINFO)    

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

    kSpaceOut = zeros(size(kSpace));
    kSpaceOut(:,:,1) = kSpace(:,:,ind1);
    kSpaceOut(:,:,2) = kSpace(:,:,ind2);
    kSpaceOut(:,:,3) = kSpace(:,:,ind3);

    KINFO.SetDimNorm(KINFO.vox);
    KINFO.SetDimElip(KINFO.vox/ELIP.Elip);
    
    %---------------------------------------------
    % Assign Resolution
    %---------------------------------------------
    if strcmp(ELIP.YbAxisElip,'z')
        dimx = KINFO.vox;
        dimy = KINFO.vox;
        dimz = KINFO.vox/ELIP.Elip;
    elseif strcmp(ELIP.YbAxisElip,'y')
        dimx = KINFO.vox;
        dimy = KINFO.vox/ELIP.Elip;
        dimz = KINFO.vox;
    elseif strcmp(PROJdgn.YbAxisElip,'x')
        dimx = KINFO.vox/ELIP.Elip;
        dimy = KINFO.vox;
        dimz = KINFO.vox;
    end
    if strcmp(ORNT.kxyz,'xyz')
        KINFO.SetDimx(dimx);
        KINFO.SetDimy(dimy);
        KINFO.SetDimz(dimz);
    elseif strcmp(ORNT.kxyz,'yxz')
        KINFO.SetDimx(dimy);
        KINFO.SetDimy(dimx);
        KINFO.SetDimz(dimz);
    elseif strcmp(ORNT.kxyz,'zxy')
        KINFO.SetDimx(dimy);
        KINFO.SetDimy(dimz);
        KINFO.SetDimz(dimx);  
    elseif strcmp(ORNT.kxyz,'xzy')
        KINFO.SetDimx(dimx);
        KINFO.SetDimy(dimz);
        KINFO.SetDimz(dimy);    
    elseif strcmp(ORNT.kxyz,'yzx')
        KINFO.SetDimx(dimz);
        KINFO.SetDimy(dimx);
        KINFO.SetDimz(dimy);  
    elseif strcmp(ORNT.kxyz,'zyx')
        KINFO.SetDimx(dimz);
        KINFO.SetDimy(dimy);
        KINFO.SetDimz(dimx);  
    end
    KINFO.SetPhysMatRelation(SYS.PhysMatRelation);
    
end


end
end


