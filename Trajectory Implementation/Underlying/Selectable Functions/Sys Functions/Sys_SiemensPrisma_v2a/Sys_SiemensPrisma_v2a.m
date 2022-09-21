%==================================================================
% (v2a)
%   
%==================================================================

classdef Sys_SiemensPrisma_v2a < handle

properties (SetAccess = private)                   
    Method = 'Sys_SiemensPrisma_v2a'
    SYSipt
    System = 'SiemensPrisma';

    %----------------------------------------------------
    % ADC 
    %----------------------------------------------------
    MinDwell = 1000;                % in ns
    SampBase = 25;                  % in ns
    SampTransitTime = 0;            % should be 0 
    SysOverSamp = 1.25;             % this is my coding...
    
    %----------------------------------------------------
    % Gradient 
    %----------------------------------------------------
    GradSampBase = 10;              % in us        
    MaxSlew = 200;                  % in mT/m/ms (confirm)
    GradMax = 80;
    GradMaxWorking = 70;
    AcousticFreqsCen = [590 1140];
    AcousticFreqsHBW = [50 100];
    PhysMatRelation = 'LRTBIO';     % X-Y-Z   
    
    %----------------------------------------------------
    % Output
    %----------------------------------------------------
    PanelOutput
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function SYS = Sys_SiemensPrisma_v2a(SYSipt)    
    SYS.SYSipt = SYSipt;
    Panel(1,:) = {'System','SiemensPrisma','Output'};
    SYS.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
end 


end
end






