%====================================================
% 
%====================================================

function [ORNT,err] = OrientStandard_v1a_Func(ORNT,INPUT)

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
% System
%---------------------------------------------
%ORNT.GradMatRelation = 'XYZ';

%---------------------------------------------
% Orient
%---------------------------------------------
if PROJdgn.elip ~= 1
    error;                              % will need more RAM to implement this...
end
if strcmp(ORNT.ScannerOrient,'Axial')
    %ORNT.KSA(:,:,1) = KSA(:,:,1);
    %ORNT.KSA(:,:,2) = KSA(:,:,2);
    %ORNT.KSA(:,:,3) = PROJdgn.elip*KSA(:,:,3);
    ORNT.KSA = KSA;
    ORNT.ElipDir = 'Z';    
    ORNT.dimx = PROJdgn.vox;
    ORNT.dimy = PROJdgn.vox;
    ORNT.dimz = PROJdgn.vox/PROJdgn.elip;  
elseif strcmp(ORNT.ScannerOrient,'Sagittal')
    error;                              % will need more RAM to implement this
    %ORNT.KSA = zeros(size(KSA));
    %ORNT.KSA(:,:,1) = PROJdgn.elip*KSA(:,:,2);
    %ORNT.KSA(:,:,2) = KSA(:,:,3);
    %ORNT.KSA(:,:,3) = KSA(:,:,1);
    ORNT.ElipDir = 'X'; 
    ORNT.dimx = PROJdgn.vox/PROJdgn.elip;
    ORNT.dimy = PROJdgn.vox;
    ORNT.dimz = PROJdgn.vox;    
elseif strcmp(ORNT.ScannerOrient,'Coronal')
    error;                              % will need more RAM to implement this
    %ORNT.KSA = zeros(size(KSA));
    %ORNT.KSA(:,:,1) = KSA(:,:,3);
    %ORNT.KSA(:,:,2) = PROJdgn.elip*KSA(:,:,1);
    %ORNT.KSA(:,:,3) = KSA(:,:,2);
    ORNT.ElipDir = 'X'; 
    ORNT.dimx = PROJdgn.vox;
    ORNT.dimy = PROJdgn.vox/PROJdgn.elip;
    ORNT.dimz = PROJdgn.vox;    
end
if strcmp(SYS.PhysMatRelation,'LRTBIO')
    ORNT.dimLR = ORNT.dimx;
    ORNT.dimTB = ORNT.dimy;    
    ORNT.dimIO = ORNT.dimz;
    ORNT.GradMatRelation = 'XYZ';
    ORNT.PhysMatRelation = 'LRTBIO';
else
    error();
end

Status2('done','',2);
Status2('done','',3);