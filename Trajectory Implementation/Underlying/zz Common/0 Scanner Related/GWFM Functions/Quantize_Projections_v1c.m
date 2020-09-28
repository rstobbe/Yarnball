%=========================================================
% (v1c)
%       - no normalizing the 'T' vector
%           (allow input to go beyond kmax = 1);
%=========================================================

function [GQKSA] = Quantize_Projections_v1c(T,KSA,qT)

nproj = length(KSA(:,1,1));
npg = length(qT);
GQKSA = zeros(nproj,npg,3);

if nproj == 1
    for p = 1:3
        GQKSA(1,:,p) = interp1(T,KSA(1,:,p),qT);
    end
else  
    for n = 1:nproj
        for p = 1:3
            GQKSA(n,:,p) = interp1(T,KSA(n,:,p),qT);
        end
    end
end
  

