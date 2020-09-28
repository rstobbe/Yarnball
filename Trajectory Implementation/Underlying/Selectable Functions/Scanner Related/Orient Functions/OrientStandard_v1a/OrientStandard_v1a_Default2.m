%=========================================================
% 
%=========================================================

function [default] = OrientSiemensDefault_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ScannerOrient';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Axial','Coronal','Sagittal'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ReconOrient';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Axial','Coronal','Sagittal'};



