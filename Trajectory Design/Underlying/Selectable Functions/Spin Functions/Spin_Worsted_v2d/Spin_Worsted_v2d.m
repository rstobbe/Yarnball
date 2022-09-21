%==================================================================
% (v2d)
%   - Update 'terms'
%==================================================================

classdef Spin_Worsted_v2d < handle

properties (SetAccess = private)                   
    Method = 'Spin_Worsted_v2d';
    SPINipt;
    NumSpokes;
    NumDiscs;
    MatRad
    RelativeSpin;
    SpinTheta
    SpinPhi
    NumProj
    p
    AziSampFact
    PolSampFact
    type
    number
    name
    GblSampFact
    Panel = cell(0);
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function SPIN = Spin_Worsted_v2d(SPINipt)    
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
    SPIN.NumProj = SPIN.NumDiscs*SPIN.NumSpokes;
    SPIN.AziSampFact = SPIN.RelativeSpin;
    SPIN.PolSampFact = SPIN.RelativeSpin;
    SPIN.GblSampFact = SPIN.AziSampFact * SPIN.PolSampFact;
    
    %------------------------------------------
    % Name
    %------------------------------------------
    SPIN.type = 'Worsted';
    SPIN.number = num2str(100*SPIN.RelativeSpin,'%3.0f');
    SPIN.name = ['W',SPIN.number];

    %--------------------------------------------- 
    % Panel Output
    %--------------------------------------------- 
    SPIN.Panel(1,:) = {'Method',SPIN.Method,'Output'};
    SPIN.Panel(2,:) = {'RelativeSpin',SPIN.RelativeSpin,'Output'};
    SPIN.Panel(3,:) = {'NumDiscs',SPIN.NumDiscs,'Output'};
    SPIN.Panel(4,:) = {'NumSpokes',SPIN.NumSpokes,'Output'};
    SPIN.Panel(5,:) = {'NumProj',SPIN.NumProj,'Output'};
    
end

end
end


