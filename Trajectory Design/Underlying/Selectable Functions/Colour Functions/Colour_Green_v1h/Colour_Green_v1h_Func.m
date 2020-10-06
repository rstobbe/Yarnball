%====================================================
%
%====================================================

function [CLR,err] = Colour_Green_v1h_Func(CLR,INPUT)

err.flag = 0;
err.msg = '';

CLR.ybcolourin = @GreenYarnIn;
CLR.ybcolourout = @GreenYarnOut;
CLR.radevin = @RadEvIn;
CLR.radevout = @RadEvOut;

%====================================================
% Green Yarn In
%====================================================
function dy = GreenYarnIn(t,y,INPUT)  

turnradfunc = INPUT.turnradfunc;
turnspinfunc = INPUT.turnspinfunc;
deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;
dir = INPUT.dir;
turnloc = INPUT.turnloc;
r = y(1);
if r > turnloc  
    dr = turnradfunc(p,r)*(1/deradsolfunc(r));    
    dr0 = turnspinfunc(p,r)*(1/deradsolfunc(r));   
else
    dr = (p^2/r^2)*(1/deradsolfunc(r));
    dr0 = dr;
end
dtheta = dir*stheta(r)*pi*rad*abs(dr0);
dphi = 2*(sphi(r)*pi*rad*r + 0.5)*dtheta;
dy = [dr;dphi;dtheta];

%====================================================
% Green Yarn Out
%====================================================
function dy = GreenYarnOut(t,y,INPUT)  

turnradfunc = INPUT.turnradfunc;
turnspinfunc = INPUT.turnspinfunc;
deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;
dir = INPUT.dir;
turnloc = INPUT.turnloc;
r = y(1);
if r > turnloc  
    dr = dir*turnradfunc(p,r)*(1/deradsolfunc(r));    
    dr0 = dir*turnspinfunc(p,r)*(1/deradsolfunc(r));   
else
    dr = dir*(p^2/r^2)*(1/deradsolfunc(r));
    dr0 = dir*dr;
end
dtheta = stheta(r)*pi*rad*abs(dr0);
dphi = 2*(sphi(r)*pi*rad*r + 0.5)*dtheta;
dy = [dr;dphi;dtheta];

%====================================================
% RadEvIn
%====================================================
function dr = RadEvIn(t,r,INPUT) 

turnradfunc = INPUT.turnradfunc;
deradsolfunc = INPUT.deradsolfunc;
turnloc = INPUT.turnloc;
p = INPUT.p;
if r > turnloc
    dr = turnradfunc(p,r)*(1/deradsolfunc(r));   
else
    dr = (p^2/r^2)*(1/deradsolfunc(r));
end

%====================================================
% RadEvOut
%====================================================
function dr = RadEvOut(t,r,INPUT) 

turnradfunc = INPUT.turnradfunc;
deradsolfunc = INPUT.deradsolfunc;
turnloc = INPUT.turnloc;
p = INPUT.p;
if r > turnloc
    dr = turnradfunc(p,r)*(1/deradsolfunc(r));   
else
    dr = (p^2/r^2)*(1/deradsolfunc(r));
end


