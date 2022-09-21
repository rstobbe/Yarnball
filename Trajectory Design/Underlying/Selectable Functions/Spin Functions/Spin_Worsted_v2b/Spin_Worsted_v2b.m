%==================================================================
% (v2b)
%   - Convert to Object
%==================================================================

classdef Spin_Worsted_v2b < handle

properties (SetAccess = private)                   
    Method = 'Spin_Worsted_v2b';
    SPINipt;
    nspokes;
    ndiscs;
    p
    rad
    RelativeSpin;
    spincalcndiscsfunc
    spincalcnspokesfunc
    stheta
    sphi
    nproj
    AziSampUsed
    PolSampUsed
    type
    number
    name
    GblSamp
    Panel = cell(0);
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function SPIN = Spin_Worsted_v2b(SPINipt)    
    SPIN.SPINipt = SPINipt;
    SPIN.nspokes = str2double(SPINipt.('NumSpokes'));
    SPIN.ndiscs = str2double(SPINipt.('NumDiscs'));
    SPIN.RelativeSpin = str2double(SPINipt.('RelativeSpin'));
end 

%==================================================================
% Set
%==================================================================  
function SetRad(SPIN,rad) 
    SPIN.rad = rad;
end
function SetRelativeSpin(SPIN,RelativeSpin) 
    SPIN.RelativeSpin = RelativeSpin;
end

%==================================================================
% DefineSpin
%==================================================================  
function DefineSpin(SPIN) 

    %---------------------------------------------
    % Find Constraint
    %---------------------------------------------
    if 2*SPIN.ndiscs < SPIN.nspokes
        SPIN.p = SPIN.ndiscs/(pi*SPIN.rad);
    else
        SPIN.p = SPIN.nspokes/(2*pi*SPIN.rad);
    end

    %---------------------------------------------
    % Calculate Spin Functions
    %---------------------------------------------
    SPIN.spincalcndiscsfunc = @(r) SPIN.ndiscs/SPIN.RelativeSpin;
    SPIN.spincalcnspokesfunc = @(r) SPIN.nspokes/SPIN.RelativeSpin;
    SPIN.stheta = @(r) 1/SPIN.spincalcndiscsfunc(r);  
    SPIN.sphi = @(r) 1/SPIN.spincalcnspokesfunc(r);   
    SPIN.nproj = SPIN.ndiscs*SPIN.nspokes;

    %------------------------------------------
    % Name
    %------------------------------------------
    undersamptot = SPIN.RelativeSpin;
    SPIN.AziSampUsed = SPIN.RelativeSpin;
    SPIN.PolSampUsed = SPIN.RelativeSpin;

    SPIN.type = 'Worsted';
    SPIN.number = num2str(100*undersamptot,'%3.0f');
    SPIN.name = ['W',SPIN.number];
    SPIN.GblSamp = undersamptot;

    %--------------------------------------------- 
    % Panel Output
    %--------------------------------------------- 
    SPIN.Panel(1,:) = {'Method',SPIN.Method,'Output'};
    SPIN.Panel(2,:) = {'RelativeSpin',SPIN.RelativeSpin,'Output'};
    SPIN.Panel(3,:) = {'Ndiscs',SPIN.ndiscs,'Output'};
    SPIN.Panel(4,:) = {'Nspokes',SPIN.nspokes,'Output'};

end

end
end


