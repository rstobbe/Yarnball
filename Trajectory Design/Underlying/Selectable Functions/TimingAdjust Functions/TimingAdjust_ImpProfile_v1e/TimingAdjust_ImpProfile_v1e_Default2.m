%=========================================================
% 
%=========================================================

function [default] = TimingAdjust_ImpProfile_v1e_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    gvelprofpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\YarnBall\ConstEvol SubFunctions\GvelProf Functions\'];
elseif strcmp(filesep,'/')
end
gvelproffunc = 'GvelProf_Exp2Uniform_v1c';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GvelProffunc';
default{m,1}.entrystr = gvelproffunc;
default{m,1}.searchpath = gvelprofpath;
default{m,1}.path = [gvelprofpath,gvelproffunc];