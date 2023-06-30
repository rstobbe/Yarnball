%==================================================================
% (v2b)
%   
%==================================================================

classdef TrajEnd_Trapazoid_v2b < handle

properties (SetAccess = private)                   
    Method = 'TrajEnd_Trapazoid_v2b'
    TENDipt
    GRAD
    Slope
    Gmag
    Dir
    SpoilFactor
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function TEND = TrajEnd_Trapazoid_v2b(TENDipt)    
    TEND.TENDipt = TENDipt;
    TEND.Slope = str2double(TENDipt.('Slope'));
    TEND.Gmag = str2double(TENDipt.('Gmag'));
    TEND.SpoilFactor = str2double(TENDipt.('SpoilFactor'));
    TEND.Dir = TENDipt.('Dir');
    %------------------------------------------
    % Create Shell Objects
    %------------------------------------------
    func = str2func('Gradient_Calculations_v2a');           
    TEND.GRAD = func('');     
end 

%==================================================================
% Constructor
%==================================================================  
function err = EndTrajectories(TEND,FINMETH,DESTYPE)    
    err.flag = 0;

    %---------------------------------------------
    % Extra Gradient Moment
    %---------------------------------------------
    TEND.GRAD.SetGamma(DESTYPE.NUC.gamma);
    Gmomadd = TEND.SpoilFactor*DESTYPE.KINFO(end).kmax/TEND.GRAD.Gamma;

    %---------------------------------------------
    % Build
    %---------------------------------------------
    sz = size(FINMETH.SYSRESP.GradComp);
    nproj = sz(1);
    type = 0;
    gseg = DESTYPE.GradTimeQuant;
    len = gseg*round((Gmomadd/TEND.Gmag)/gseg);
    gstep = gseg*TEND.Slope;
    gmag = gstep*round(sqrt(Gmomadd*TEND.Slope)/gstep);
    risetime = TEND.Gmag/TEND.Slope;
    if (len < risetime*2) && (gmag < TEND.Gmag)
        type = 1;
    end

    if type == 0    
        gstep = gseg*TEND.Slope;
        rise = (gstep:gstep:TEND.Gmag);
        rem = round(1000*len/gseg)/1000 - length(rise);
        trap = [rise TEND.Gmag*ones(1,rem) flip(rise)];
    end

    if type == 1    
        gstep = gseg*TEND.Slope;
        gmag = gstep*round(sqrt(Gmomadd*TEND.Slope)/gstep);
        rise = (gstep:gstep:gmag);
        trap = [rise flip(rise(1:end-1)) 0];
    end

    GradEnd = zeros(nproj,length(trap),3);
    if strcmp(TEND.Dir,'x')
        GradEnd(:,:,1) = repmat(trap,nproj,1,1); 
    elseif strcmp(TEND.Dir,'y')
        GradEnd(:,:,2) = repmat(trap,nproj,1,1); 
    elseif strcmp(TEND.Dir,'z')
        GradEnd(:,:,3) = repmat(trap,nproj,1,1);
    end
    GradFull = cat(2,FINMETH.SYSRESP.GradComp,GradEnd);

    TEND.GRAD.SetGamma(DESTYPE.NUC.gamma);
    TEND.GRAD.SetTimeQuant(DESTYPE.GradTimeQuant);
    TEND.GRAD.DefineGradients(GradFull);
    TEND.GRAD.CalculateGradientChars;
end 


end
end



