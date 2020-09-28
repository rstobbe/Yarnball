%=========================================================
%
%=========================================================

function [TSMP,err] = TrajSamp_DesignTest_v2a_Func(TSMP,INPUT)

Status2('busy','Define Trajectory Sampling Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
GWFM = INPUT.GWFM;
SYS = INPUT.SYS;

%---------------------------------------------
% Dwell time for critical sampling
%---------------------------------------------                 
%TSMP.maxspherefreq = GWFM.GmaxTraj*PROJdgn.fov/2*PROJimp.gamma;              % Spherical FoV
TSMP.maxspherefreq = GWFM.GmaxTrajEnd*PROJdgn.fov/2*PROJimp.gamma;              % Spherical FoV
TSMP.dwellcrit = 1000/(2*TSMP.maxspherefreq);                            % in ms

%---------------------------------------------
% Initial estimate of dwell and npro  
%---------------------------------------------
dwell0 = TSMP.dwellcrit/TSMP.sysoversamp;
npro0 = round(PROJdgn.tro/dwell0);
dwell0 = PROJdgn.tro/npro0;
npro0 = round(PROJdgn.tro/dwell0);
dwell0 = PROJdgn.tro/npro0;

%---------------------------------------------
% Make dwell a multiple of sampbase
%---------------------------------------------                             
dwell = dwell0*1e6*1.05 - rem(dwell0*1e6*1.05,SYS.SampBase); 
npro = npro0;
while true
    start = PROJdgn.tro*1e6 - npro*dwell;
    if round(start*1e6) > 0
        npro = npro + 1;
    elseif round(start*1e6) < 0
        dwell = dwell - SYS.SampBase;
    elseif round(start*1e6) == 0 
        dwellProt = dwell*TSMP.sysoversamp; 
        if rem(round(dwellProt),SYS.SampBase) == 0
            trajosamp = TSMP.dwellcrit/(dwell/1e6);
            if trajosamp > TSMP.sysoversamp*TSMP.minbaseoversamp
                break
            else
                dwell = dwell - SYS.SampBase;
            end
        end
        dwell = dwell - SYS.SampBase;
    end
end

%---------------------------------------------
% Test for Max Sampling BW
%---------------------------------------------  
if dwell < SYS.MinDwell
    dwell = SYS.MinDwell;
    npro = round(PROJdgn.tro*1e6/dwell);
end
if round(npro*dwell*1e6) ~= round(PROJdgn.tro*1e12)
    test = npro*dwell
    error();                                    % error probably for case of max sampling BW
end

%---------------------------------------------
% Dwell time in protocol
%---------------------------------------------
dwellProt = dwell*TSMP.sysoversamp;
if rem(round(dwellProt),SYS.SampBase) ~= 0
    test = rem(round(dwellProt),SYS.SampBase)
    dwellProt = dwellProt
    error();                                    % fix for graceful exit/fix
end
nproProt = npro/TSMP.sysoversamp;
if rem(nproProt,1) ~= 0
    nproProt = nproProt
    error();                                    % fix for graceful exit/fix
end

%---------------------------------------------
% Increase Tro to accomodate any gradient delay
%---------------------------------------------
minextraptsProt = ceil((GWFM.sampend-PROJdgn.tro+0.001)*1e6/dwellProt);
extraptsProt = minextraptsProt;
while true
    if rem(nproProt+extraptsProt,16) == 0                   % make sure protocol data points a multiple of 16                            
        break
    else
        extraptsProt = extraptsProt+1;
    end
end
totpts = (nproProt+extraptsProt)*TSMP.sysoversamp;

%---------------------------------------------
% Return
%---------------------------------------------
TSMP.dwell = dwell/1e6;
TSMP.dwellProt = dwellProt/1e6;
TSMP.tro = TSMP.dwell*npro;
TSMP.troProt = TSMP.dwellProt*(nproProt+extraptsProt);
TSMP.troMag = TSMP.dwell*(totpts);
if round(1e9*TSMP.troProt) ~= round(1e9*TSMP.troMag)
    error();
end
TSMP.npro = npro;
TSMP.nproProt = nproProt+extraptsProt;  
TSMP.nproMag = totpts;
TSMP.tdpMag = TSMP.nproMag*PROJdgn.nproj;
TSMP.trajosamp = TSMP.dwellcrit/TSMP.dwell;                  % how much oversampled from design
TSMP.samplingBW = 1000/TSMP.dwell;
TSMP.minextraptsProt = minextraptsProt;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'dwell (ms)',TSMP.dwell,'Output'};
Panel(2,:) = {'trajosamp',TSMP.trajosamp,'Output'};
Panel(3,:) = {'sysosamp (Siemens)',TSMP.sysoversamp,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TSMP.Panel = Panel;
TSMP.PanelOutput = PanelOutput;






