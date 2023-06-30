%==================================================================
% (v2a)
%   
%==================================================================

classdef Spin_Uniform_v2a < handle

properties (SetAccess = private)                   
    Method = 'Spin_Uniform_v2a';
    SPINipt
    NumSpokes
    NumDiscs
    MatRad
    DoSpin = 1
    RelSpin
    SpinTheta
    SpinPhi
    NumProj
    p
    AziSampFact
    PolSampFact
    type
    number
    number1
    number2
    name
    GblSampFact
    Panel = cell(0);
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function SPIN = Spin_Uniform_v2a(SPINipt)    
    SPIN.SPINipt = SPINipt;
    SPIN.NumSpokes = str2double(SPINipt.('NumSpokes'));
    SPIN.NumDiscs = str2double(SPINipt.('NumDiscs'));
    SPIN.RelSpin = str2double(SPINipt.('RelSpin'));  
end 

%==================================================================
% Set
%==================================================================  
function SetMatRad(SPIN,MatRad) 
    SPIN.MatRad = MatRad;
end
function SetDoSpin(SPIN,DoSpin) 
    SPIN.DoSpin = DoSpin;
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
    % Relative Spin
    %---------------------------------------------
    if SPIN.DoSpin == 1
        RelativeSpin = @(r) SPIN.RelSpin;
    elseif SPIN.DoSpin == 0
        RelativeSpin = @(r) 0;
    end
    
    %---------------------------------------------
    % Calculate Spin Functions
    %---------------------------------------------
    SPIN.SpinTheta = @(rad) pi*SPIN.MatRad*RelativeSpin(rad)/SPIN.NumDiscs;  
    SPIN.SpinPhi = @(rad) 2*pi*SPIN.MatRad*RelativeSpin(rad)/SPIN.NumSpokes;    
    SPIN.NumProj = SPIN.NumDiscs*SPIN.NumSpokes;
    SPIN.AziSampFact = SPIN.RelSpin;
    SPIN.PolSampFact = SPIN.RelSpin;
    SPIN.GblSampFact = SPIN.AziSampFact * SPIN.PolSampFact;
    
    %------------------------------------------
    % Name
    %------------------------------------------
    SPIN.type = 'Uniform';
    SPIN.number = num2str(100*SPIN.RelSpin,'%3.0f');
    SPIN.name = ['U',SPIN.number];

    %--------------------------------------------- 
    % Panel Output
    %--------------------------------------------- 
    SPIN.Panel(1,:) = {'Method',SPIN.Method,'Output'};
    SPIN.Panel(2,:) = {'RelativeSpin',SPIN.number,'Output'};
    SPIN.Panel(3,:) = {'NumDiscs',SPIN.NumDiscs,'Output'};
    SPIN.Panel(4,:) = {'NumSpokes',SPIN.NumSpokes,'Output'};
    SPIN.Panel(5,:) = {'NumProj',SPIN.NumProj,'Output'};
    
end

end
end


