%=========================================================
% 
%=========================================================

function [default] = TimingAdjust_SingleCastImpProfile_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    gvelprofpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\YarnBall\ConstEvol SubFunctions\GvelProf Functions\'];
elseif strcmp(filesep,'/')
end
gvelproffunc = 'GvelProf_Exp2Decay_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GvelProf';
default{m,1}.entrystr = gvelproffunc;
default{m,1}.searchpath = gvelprofpath;
default{m,1}.path = [gvelprofpath,gvelproffunc];