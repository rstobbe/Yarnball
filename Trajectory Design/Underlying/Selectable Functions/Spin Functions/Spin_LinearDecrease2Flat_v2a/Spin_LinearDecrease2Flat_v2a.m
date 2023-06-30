%==================================================================
% (v2a)
%   
%==================================================================

classdef Spin_LinearDecrease2Flat_v2a < handle

properties (SetAccess = private)                   
    Method = 'Spin_LinearDecrease2Flat_v2a';
    SPINipt;
    NumSpokes;
    NumDiscs;
    MatRad
    DoSpin = 1
    RelSpinCentre;
    RelSpinEdge;
    DecreaseStart;
    DecreaseEnd;
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
function SPIN = Spin_LinearDecrease2Flat_v2a(SPINipt)    
    SPIN.SPINipt = SPINipt;
    SPIN.NumSpokes = str2double(SPINipt.('NumSpokes'));
    SPIN.NumDiscs = str2double(SPINipt.('NumDiscs'));
    SPIN.RelSpinCentre = str2double(SPINipt.('RelSpinCentre'));
    SPIN.RelSpinEdge = str2double(SPINipt.('RelSpinEdge'));
    SPIN.DecreaseStart = str2double(SPINipt.('DecreaseStart'));
    SPIN.DecreaseEnd = str2double(SPINipt.('DecreaseEnd'));    
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
    StopSpan = 0.15;
    DecreaseEndStart = SPIN.DecreaseEnd-(StopSpan/2);
    DecreaseEndStop = SPIN.DecreaseEnd+(StopSpan/2);
    if SPIN.DoSpin == 1
        Decrease = (SPIN.RelSpinCentre - SPIN.RelSpinEdge)/(SPIN.DecreaseEnd - SPIN.DecreaseStart);
        RelativeSpin = @(r) SPIN.RelSpinCentre ...
                            - heaviside(r-SPIN.DecreaseStart) .*(1-exp(-(r-SPIN.DecreaseStart)/0.1)).*(r-SPIN.DecreaseStart)*Decrease ...
                            - heaviside(r-DecreaseEndStart) .* (SPIN.RelSpinCentre - (1-exp(-(r-SPIN.DecreaseStart)/0.1)).*(r-SPIN.DecreaseStart)*Decrease) ...
                            + heaviside(r-DecreaseEndStart) .* (SPIN.RelSpinCentre - (1-exp(-(DecreaseEndStart-SPIN.DecreaseStart)/0.1)).*(DecreaseEndStart-SPIN.DecreaseStart)*Decrease) ...
                            - heaviside(r-DecreaseEndStart) .* ((r-DecreaseEndStart)*Decrease - ((Decrease/StopSpan)/2*(r-DecreaseEndStart).^2)) ...
                            + heaviside(r-DecreaseEndStop) .* ((r-DecreaseEndStart)*Decrease - ((Decrease/StopSpan)/2*(r-DecreaseEndStart).^2)) ...
                            - heaviside(r-DecreaseEndStop) .* ((DecreaseEndStop-DecreaseEndStart)*Decrease - ((Decrease/StopSpan)/2*(DecreaseEndStop-DecreaseEndStart).^2));
        figure(2346); hold on; r = 0:0.001:1; plot(r,RelativeSpin(r)); ylim([0 1]);
    elseif SPIN.DoSpin == 0
        RelativeSpin = @(r) 0;
    end
    
    %---------------------------------------------
    % Calculate Spin Functions
    %---------------------------------------------
    SPIN.SpinTheta = @(rad) pi*SPIN.MatRad*RelativeSpin(rad)/SPIN.NumDiscs;  
    SPIN.SpinPhi = @(rad) 2*pi*SPIN.MatRad*RelativeSpin(rad)/SPIN.NumSpokes;    
    SPIN.NumProj = SPIN.NumDiscs*SPIN.NumSpokes;
    r = 0:0.001:1;
    SPIN.AziSampFact = sum(RelativeSpin(r).*(r.^2))/sum(r.^2);
    SPIN.PolSampFact = SPIN.AziSampFact;
    SPIN.GblSampFact = SPIN.AziSampFact * SPIN.PolSampFact;
    
    %------------------------------------------
    % Name
    %------------------------------------------
    SPIN.type = 'LinearDecrease2Flat';
    SPIN.number = num2str(100*SPIN.GblSampFact,'%3.0f');
    SPIN.name = ['LD2F',SPIN.number];

    %--------------------------------------------- 
    % Panel Output
    %--------------------------------------------- 
    SPIN.Panel(1,:) = {'Method',SPIN.Method,'Output'};
    SPIN.Panel(2,:) = {'TotalUnderSamp',SPIN.GblSampFact,'Output'};
    SPIN.Panel(3,:) = {'NumDiscs',SPIN.NumDiscs,'Output'};
    SPIN.Panel(4,:) = {'NumSpokes',SPIN.NumSpokes,'Output'};
    SPIN.Panel(5,:) = {'NumProj',SPIN.NumProj,'Output'};
    
end

end
end


