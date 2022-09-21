%==================================================================
% (v2a)
%   - Convert to Object
%==================================================================

classdef Elip_YarnBallIso_v2a < matlab.mixin.Copyable

properties (SetAccess = private)                   
    Method = 'Elip_YarnBallIso_v2a'
    ELIPipt;
    Elip = 1;
    YbAxisElip = 'z';
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function ELIP = Elip_YarnBallIso_v2a(ELIPipt)    
    ELIP.ELIPipt = ELIPipt;
end 

end
end





