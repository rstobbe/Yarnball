%=========================================================
% (v1b)
%       - as Quantize_Projections_v1b
%=========================================================

function [GQKSA] = Quantize_Projections_VT_v1b(tro,T,qT,KSA)

nproj = length(KSA(:,1,1));
test = max(T(:));
if test == tro
    realt = T;
end
npg = length(qT);
GQKSA = zeros(nproj,npg,3);

if nproj == 1
    for p = 1:3
        GQKSA(1,:,p) = interp1(realt(1,:),KSA(1,:,p),qT,'linear','extrap');
    end
else  
    for n = 1:nproj
        for p = 1:3
            GQKSA(n,:,p) = interp1(realt(n,:),KSA(n,:,p),qT,'linear','extrap');
        end
    end
end

%--------------
show = 0;
if show == 1
    figure;
    hold on
    plot(realt,KSA(1,:,1),'r-');
    plot(qT,GQKSA(1,:,1),'b*');      
    figure;
    hold on
    plot(realt,KSA(1,:,2),'r-');
    plot(qT,GQKSA(1,:,2),'b*');      
    figure;
    hold on
    plot(realt,KSA(1,:,3),'r-');
    plot(qT,GQKSA(1,:,3),'b*'); 
    figure;
    hold on
    KSAabs = sqrt(KSA(1,:,1).^2 + KSA(1,:,2).^2 + KSA(1,:,3).^2);  
    GQKSAabs = sqrt(GQKSA(1,:,1).^2 + GQKSA(1,:,2).^2 + GQKSA(1,:,3).^2); 
    plot(realt,KSAabs,'r-');
    plot(qT,GQKSAabs,'b*');
    error
end
%--------------        

