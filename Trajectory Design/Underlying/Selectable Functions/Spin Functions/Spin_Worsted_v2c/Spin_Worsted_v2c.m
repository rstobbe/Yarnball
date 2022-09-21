%==================================================================
% (v2c)
%   - Convert to Object
%==================================================================

classdef Spin_Worsted_v2c < handle

properties (SetAccess = private)                   
    Method = 'Spin_Worsted_v2c';
    SPINipt;
    NumSpokes;
    NumDiscs;
    MatRad
    RelativeSpin;
    SpinTheta
    SpinPhi
    nproj
    p
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
function SPIN = Spin_Worsted_v2c(SPINipt)    
    SPIN.SPINipt = SPINipt;
    SPIN.NumSpokes = str2double(SPINipt.('NumSpokes'));
    SPIN.NumDiscs = str2double(SPINipt.('NumDiscs'));
    SPIN.RelativeSpin = str2double(SPINipt.('RelativeSpin'));
end 

%==================================================================
% Set
%==================================================================  
function SetMatRad(SPIN,MatRad) 
    SPIN.MatRad = MatRad;
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
    if 2*SPIN.NumDiscs < SPIN.NumSpokes
        SPIN.p = SPIN.NumDiscs/(pi*SPIN.MatRad);
    else
        SPIN.p = SPIN.NumSpokes/(2*pi*SPIN.MatRad);
    end
    
    %---------------------------------------------
    % Calculate Spin Functions
    %---------------------------------------------
    SPIN.SpinTheta = @(rad) pi*SPIN.MatRad*SPIN.RelativeSpin/SPIN.NumDiscs;  
    SPIN.SpinPhi = @(rad) 2*pi*SPIN.MatRad*SPIN.RelativeSpin/SPIN.NumSpokes;    
    SPIN.nproj = SPIN.NumDiscs*SPIN.NumSpokes;
    
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
    SPIN.Panel(3,:) = {'Ndiscs',SPIN.NumDiscs,'Output'};
    SPIN.Panel(4,:) = {'Nspokes',SPIN.NumSpokes,'Output'};

end

end
end


