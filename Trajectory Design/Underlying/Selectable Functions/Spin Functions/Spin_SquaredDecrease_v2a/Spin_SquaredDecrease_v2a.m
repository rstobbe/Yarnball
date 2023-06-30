%==================================================================
% (v2a)
%   
%==================================================================

classdef Spin_SquaredDecrease_v2a < handle

properties (SetAccess = private)                   
    Method = 'Spin_SquaredDecrease_v2a';
    SPINipt;
    NumSpokes;
    NumDiscs;
    MatRad
    DoSpin = 1
    RelSpinCentre;
    RelSpinEdge;
    DecreaseStart;
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
function SPIN = Spin_SquaredDecrease_v2a(SPINipt)    
    SPIN.SPINipt = SPINipt;
    SPIN.NumSpokes = str2double(SPINipt.('NumSpokes'));
    SPIN.NumDiscs = str2double(SPINipt.('NumDiscs'));
    SPIN.RelSpinCentre = str2double(SPINipt.('RelSpinCentre'));
    SPIN.RelSpinEdge = str2double(SPINipt.('RelSpinEdge'));
    SPIN.DecreaseStart = str2double(SPINipt.('DecreaseStart'));    
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
        Decrease = (SPIN.RelSpinCentre - SPIN.RelSpinEdge)/(1 - SPIN.DecreaseStart)^2;
        RelativeSpin = @(r) SPIN.RelSpinCentre - heaviside(r-SPIN.DecreaseStart).*(r-SPIN.DecreaseStart).^2*Decrease;
        figure; r = 0:0.01:1; plot(r,RelativeSpin(r));
    elseif SPIN.DoSpin == 0
        RelativeSpin = @(r) 0;
    end
    
    %---------------------------------------------
    % Calculate Spin Functions
    %---------------------------------------------
    SPIN.SpinTheta = @(rad) pi*SPIN.MatRad*RelativeSpin(rad)/SPIN.NumDiscs;  
    SPIN.SpinPhi = @(rad) 2*pi*SPIN.MatRad*RelativeSpin(rad)/SPIN.NumSpokes;    
    SPIN.NumProj = SPIN.NumDiscs*SPIN.NumSpokes;
    SPIN.AziSampFact = SPIN.RelSpinEdge;
    SPIN.PolSampFact = SPIN.RelSpinEdge;
    SPIN.GblSampFact = SPIN.AziSampFact * SPIN.PolSampFact;
    
    %------------------------------------------
    % Name
    %------------------------------------------
    SPIN.type = 'SquaredDecrease';
    SPIN.number1 = num2str(100*SPIN.RelSpinCentre,'%3.0f');
    SPIN.number2 = num2str(100*SPIN.RelSpinEdge,'%3.0f');
    SPIN.number = [SPIN.number1,SPIN.number2];
    SPIN.name = ['SD',SPIN.number1,SPIN.number2];

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


