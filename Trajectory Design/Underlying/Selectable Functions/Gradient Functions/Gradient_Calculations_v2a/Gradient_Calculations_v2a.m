%==================================================================
% (v2a)
%   
%==================================================================

classdef Gradient_Calculations_v2a < handle

properties (SetAccess = private)                   
    Method = 'Gradient_Calculations_v2a'
    GRADipt
    Gamma
    Quant
    Grads
    GradMag
    GradMaxChan
    GradSlew
    GradSlewMag
    GradSlewMaxChan
    GradAcc
    GradAccMag
    GradAccMaxChan
    GradMagMax
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function GRAD = Gradient_Calculations_v2a(GRADipt)    
    GRAD.GRADipt = GRADipt;
end 

%==================================================================
% Set
%==================================================================  
function SetGamma(GRAD,Gamma)
    GRAD.Gamma = Gamma;
end
function SetTimeQuant(GRAD,Quant)
    GRAD.Quant = Quant;
end

%==================================================================
% Return
%================================================================== 
function [sT,sGrads,sGradMag,sGradMaxChan] = GetSteppedGradWfm(GRAD)
    len = length(GRAD.Grads(1,:,1));
    Tro = GRAD.Quant * len;
    sGrads(:,1:2:2*len-1,:) = GRAD.Grads;
    sGrads(:,2:2:2*len,:) = GRAD.Grads;
    sGradMag(:,1:2:2*len-1) = GRAD.GradMag;
    sGradMag(:,2:2:2*len) = GRAD.GradMag;
    sGradMaxChan(:,1:2:2*len-1) = GRAD.GradMaxChan;
    sGradMaxChan(:,2:2:2*len) = GRAD.GradMaxChan;
    sT(1:2:2*len-1) = (0:GRAD.Quant:Tro-GRAD.Quant);
    sT(2:2:2*len) = (GRAD.Quant:GRAD.Quant:Tro);    
end
function [sT,sGradSlew,sGradSlewMag,sGradSlewMaxChan] = GetSteppedGradSlew(GRAD)
    len = length(GRAD.GradSlew(1,:,1));
    Tro = GRAD.Quant * len;
    sGradSlew(:,1:2:2*len-1,:) = GRAD.GradSlew;
    sGradSlew(:,2:2:2*len,:) = GRAD.GradSlew;
    sGradSlewMag(:,1:2:2*len-1) = GRAD.GradSlewMag;
    sGradSlewMag(:,2:2:2*len) = GRAD.GradSlewMag;
    sGradSlewMaxChan(:,1:2:2*len-1) = GRAD.GradSlewMaxChan;
    sGradSlewMaxChan(:,2:2:2*len) = GRAD.GradSlewMaxChan;
    sT(1:2:2*len-1) = (0:GRAD.Quant:Tro-GRAD.Quant) - GRAD.Quant/2;
    sT(2:2:2*len) = (GRAD.Quant:GRAD.Quant:Tro) - GRAD.Quant/2;       
end
function [sT,sGradAcc,sGradAccMag,sGradAccMaxChan] = GetSteppedGradAcc(GRAD)
    len = length(GRAD.GradAcc(1,:,1));
    Tro = GRAD.Quant * len;
    sGradAcc(:,1:2:2*len-1,:) = GRAD.GradAcc;
    sGradAcc(:,2:2:2*len,:) = GRAD.GradAcc;
    sGradAccMag(:,1:2:2*len-1) = GRAD.GradAccMag;
    sGradAccMag(:,2:2:2*len) = GRAD.GradAccMag;
    sGradAccMaxChan(:,1:2:2*len-1) = GRAD.GradAccMaxChan;
    sGradAccMaxChan(:,2:2:2*len) = GRAD.GradAccMaxChan;
    sT(1:2:2*len-1) = (0:GRAD.Quant:Tro-GRAD.Quant) - GRAD.Quant;
    sT(2:2:2*len) = (GRAD.Quant:GRAD.Quant:Tro) - GRAD.Quant;
end
function [MaxAbsGrad] = GetMaxAbsGrad(GRAD)
    MaxAbsGrad = max(abs(GRAD.Grads(:)));
end
function [GradDuration] = GetGradDuration(GRAD)
    len = length(GRAD.Grads(1,:,1));    
    GradDuration = len * GRAD.Quant;
end
function [GradPts] = GetGradPts(GRAD)
    len = length(GRAD.Grads(1,:,1));    
    GradPts = len;
end

%==================================================================
% ReturnSteppedGrads
%================================================================== 
function [sT,sGrads] = ReturnSteppedGrads(GRAD,Grads0,T0)
    len = length(Grads0(1,:,1));
    sGrads(:,1:2:2*len-1,:) = Grads0;
    sGrads(:,2:2:2*len,:) = Grads0;
    sT(1:2:2*len-1) = T0(1:end-1);
    sT(2:2:2*len) = T0(2:end);    
end

%==================================================================
% CalculateGradientsReturn
%==================================================================  
function GradsReturn = CalculateGradientsReturn(GRAD,kSpace)
    GradsReturn = ((kSpace(:,2:end,:)-kSpace(:,1:end-1,:))/GRAD.Quant)/GRAD.Gamma;
end

%==================================================================
% CalculateGradients
%==================================================================  
function CalculateGradients(GRAD,kSpace)
    GRAD.Grads = ((kSpace(:,2:end,:)-kSpace(:,1:end-1,:))/GRAD.Quant)/GRAD.Gamma;
    GRAD.GradMag = [];
    GRAD.GradMaxChan = [];
    GRAD.GradSlew = [];
    GRAD.GradSlewMag = [];
    GRAD.GradSlewMaxChan = [];
    GRAD.GradAcc = [];
    GRAD.GradAccMag = [];
    GRAD.GradAccMaxChan = [];
end

%==================================================================
% DefineGradients
%==================================================================  
function DefineGradients(GRAD,Grads)
    GRAD.Grads = Grads;
    GRAD.GradMag = [];
    GRAD.GradMaxChan = [];
    GRAD.GradSlew = [];
    GRAD.GradSlewMag = [];
    GRAD.GradSlewMaxChan = [];
    GRAD.GradAcc = [];
    GRAD.GradAccMag = [];
    GRAD.GradAccMaxChan = [];
end

%==================================================================
% CalculateGradientChars
%==================================================================  
function CalculateGradientChars(GRAD)
    GRAD.GradMag = sqrt(GRAD.Grads(:,:,1).^2 + GRAD.Grads(:,:,2).^2 + GRAD.Grads(:,:,3).^2);
    GRAD.GradMagMax = max(GRAD.GradMag(:));
    GRAD.GradMaxChan = max(abs(GRAD.Grads),[],[1 3]);
    GRAD.CalculateGradSlew;
    GRAD.CalculateGradAcc;
end

%==================================================================
% CalculateGradSlew
%==================================================================  
function CalculateGradSlew(GRAD)
    sz = size(GRAD.Grads);
    tGrads = cat(2,zeros(sz(1),1,3),GRAD.Grads,zeros(sz(1),1,3));
    GRAD.GradSlew = ((tGrads(:,2:end,:)-tGrads(:,1:end-1,:))/GRAD.Quant);
    GRAD.GradSlewMag = sqrt(GRAD.GradSlew(:,:,1).^2 + GRAD.GradSlew(:,:,2).^2 + GRAD.GradSlew(:,:,3).^2);
    GRAD.GradSlewMaxChan = max(abs(GRAD.GradSlew),[],[1 3]);  
end

%==================================================================
% CalculateGradAcc
%==================================================================  
function CalculateGradAcc(GRAD)
    sz = size(GRAD.Grads);
    tGradSlew = cat(2,zeros(sz(1),1,3),GRAD.GradSlew,zeros(sz(1),1,3));
    GRAD.GradAcc = ((tGradSlew(:,2:end,:)-tGradSlew(:,1:end-1,:))/GRAD.Quant);
    GRAD.GradAccMag = sqrt(GRAD.GradAcc(:,:,1).^2 + GRAD.GradAcc(:,:,2).^2 + GRAD.GradAcc(:,:,3).^2);
    GRAD.GradAccMaxChan = max(abs(GRAD.GradAcc),[],[1 3]);  
end

%==================================================================
% Clear
%==================================================================  
function Clear(GRAD)
end
    
end
end
