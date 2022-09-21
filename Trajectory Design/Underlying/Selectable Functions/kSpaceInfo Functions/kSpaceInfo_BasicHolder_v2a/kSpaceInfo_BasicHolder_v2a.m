%==================================================================
% (v2a)
%   
%==================================================================

classdef kSpaceInfo_BasicHolder_v2a < handle

properties (SetAccess = private)                   
    Method = 'kSpaceInfo_BasicHolder_v2a'
    KINFOipt
    fov
    vox
    tro
    nproj
    kstep                                        
    kmax
    rad
    DesignTro
    DesignSamplingTimeStart
    SamplingPtStart
    SamplingPts
    SamplingArray
    SamplingTimeOnTrajectory
    DesignSamplingTimeToCentre
    SamplingTimeToCentre
    SamplingPtAtCentre
    SamplingStartTimeOnTrajectory
    Elip
    YbAxisElip
    dimnorm
    dimelip
    dimx
    dimy
    dimz
    dimLR
    dimTB
    dimIO
    PhysMatRelation
    kSpace
    SampDensComp
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function KINFO = kSpaceInfo_BasicHolder_v2a(KINFOipt)    
    KINFO.KINFOipt = KINFOipt;
end 

%==================================================================
% Set
%==================================================================  
function SetFov(KINFO,fov)
    KINFO.fov = fov;
    KINFO.kstep = 1000/KINFO.fov;  
end
function SetVox(KINFO,vox)
    KINFO.vox = vox;
    KINFO.kmax = 1000/(2*KINFO.vox);
    KINFO.rad = KINFO.kmax/KINFO.kstep;  
end
function SetDesignTro(KINFO,DesignTro)
    KINFO.DesignTro = DesignTro;
end
function SetTro(KINFO,tro)
    KINFO.tro = tro;
end
function SetNproj(KINFO,nproj)
    KINFO.nproj = nproj;
end
function SetDesignSamplingTimeStart(KINFO,DesignSamplingTimeStart)
    KINFO.DesignSamplingTimeStart = DesignSamplingTimeStart;
end
function SetSamplingPtStart(KINFO,SamplingPtStart)
    KINFO.SamplingPtStart = SamplingPtStart;
end
function SetSamplingPts(KINFO,SamplingPts)
    KINFO.SamplingPts = SamplingPts;
    KINFO.SamplingArray = KINFO.SamplingPtStart + (1:1:KINFO.SamplingPts);
end
function SetSamplingTimeOnTrajectory(KINFO,SamplingTimeOnTrajectory)
    KINFO.SamplingTimeOnTrajectory = SamplingTimeOnTrajectory;
    KINFO.SamplingStartTimeOnTrajectory = KINFO.SamplingTimeOnTrajectory(1);
end
function SetElip(KINFO,Elip)
    KINFO.Elip = Elip;
end
function SetYbAxisElip(KINFO,YbAxisElip)
    KINFO.YbAxisElip = YbAxisElip;
end
function SetDimNorm(KINFO,dimnorm)
    KINFO.dimnorm = dimnorm;
end
function SetDimElip(KINFO,dimelip)
    KINFO.dimelip = dimelip;
end
function SetDimx(KINFO,dimx)
    KINFO.dimx = dimx;
end
function SetDimy(KINFO,dimy)
    KINFO.dimy = dimy;
end
function SetDimz(KINFO,dimz)
    KINFO.dimz = dimz;
end
function SetPhysMatRelation(KINFO,PhysMatRelation)
    KINFO.PhysMatRelation = PhysMatRelation;
    KINFO.dimLR = KINFO.dimx;                                  
    KINFO.dimTB = KINFO.dimy; 
    KINFO.dimIO = KINFO.dimz; 
end
function SetkSpace(KINFO,kSpace)
    KINFO.kSpace = kSpace;
end
function AddSampDensComp(KINFO,SampDensComp)
    KINFO.SampDensComp = SampDensComp;
end
function SetDesignSamplingTimeToCentre(KINFO,DesignSamplingTimeToCentre)
    KINFO.DesignSamplingTimeToCentre = DesignSamplingTimeToCentre;
end
function SetSamplingTimeToCentre(KINFO,SamplingTimeToCentre)
    KINFO.SamplingTimeToCentre = SamplingTimeToCentre;
end
function SetSamplingPtAtCentre(KINFO,SamplingPtAtCentre)
    KINFO.SamplingPtAtCentre = SamplingPtAtCentre;
end

end
end
