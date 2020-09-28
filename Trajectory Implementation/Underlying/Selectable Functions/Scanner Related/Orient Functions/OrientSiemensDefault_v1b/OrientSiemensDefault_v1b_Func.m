%====================================================
% 
%====================================================

function [ORNT,err] = OrientSiemensDefault_v1b_Func(ORNT,INPUT)

Status2('busy','Define Orientation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSA = INPUT.KSA;
PROJdgn = INPUT.PROJdgn;
clear INPUT;

%---------------------------------------------
% Orient
%---------------------------------------------
ORNT.KSA = zeros(size(KSA));
if strcmp(ORNT.ScannerOrient,'Axial')
    if PROJdgn.elip < 0.8
        ORNT.KSA(:,:,1) = KSA(:,:,1);
        ORNT.KSA(:,:,2) = KSA(:,:,2);
        ORNT.KSA(:,:,3) = PROJdgn.elip*KSA(:,:,3);
        ORNT.GradMatRelation = 'XYZ';
        ORNT.PhysMatRelation = 'LRTBIO';
    else
        ORNT.KSA(:,:,1) = KSA(:,:,3);
        ORNT.KSA(:,:,2) = KSA(:,:,2);
        ORNT.KSA(:,:,3) = PROJdgn.elip*KSA(:,:,1);
        ORNT.GradMatRelation = 'ZYX';
        ORNT.PhysMatRelation = 'IOTBLR';
    end
    ORNT.ElipDir = 'Z';    
    ORNT.dimx = PROJdgn.vox;
    ORNT.dimy = PROJdgn.vox;
    ORNT.dimz = PROJdgn.vox/PROJdgn.elip;  
elseif strcmp(ORNT.ScannerOrient,'Sagittal')
    ORNT.KSA(:,:,1) = PROJdgn.elip*KSA(:,:,3);
    ORNT.KSA(:,:,2) = KSA(:,:,2);
    ORNT.KSA(:,:,3) = KSA(:,:,1);
    ORNT.GradMatRelation = 'ZYX';
    ORNT.PhysMatRelation = 'IOTBLR';
    ORNT.ElipDir = 'X'; 
    ORNT.dimx = PROJdgn.vox/PROJdgn.elip;
    ORNT.dimy = PROJdgn.vox;
    ORNT.dimz = PROJdgn.vox;    
elseif strcmp(ORNT.ScannerOrient,'Coronal')
    if PROJdgn.elip < 0.7
        ORNT.KSA(:,:,1) = KSA(:,:,1);
        ORNT.KSA(:,:,2) = PROJdgn.elip*KSA(:,:,3);
        ORNT.KSA(:,:,3) = KSA(:,:,2);
        ORNT.GradMatRelation = 'XZY';
        ORNT.PhysMatRelation = 'LRIOTB';
    else
        ORNT.KSA(:,:,1) = KSA(:,:,3);
        ORNT.KSA(:,:,2) = PROJdgn.elip*KSA(:,:,2);
        ORNT.KSA(:,:,3) = KSA(:,:,1);
        ORNT.GradMatRelation = 'ZYX';
        ORNT.PhysMatRelation = 'IOTBLR';
    end
    ORNT.ElipDir = 'Y'; 
    ORNT.dimx = PROJdgn.vox;
    ORNT.dimy = PROJdgn.vox;
    ORNT.dimz = PROJdgn.vox/PROJdgn.elip;   
end
ORNT.dimLR = ORNT.dimx;    
ORNT.dimTB = ORNT.dimy;    
ORNT.dimIO = ORNT.dimz;  

Status2('done','',2);
Status2('done','',3);