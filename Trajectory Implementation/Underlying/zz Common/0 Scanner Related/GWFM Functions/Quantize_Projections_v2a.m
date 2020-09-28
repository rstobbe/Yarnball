%=========================================================
% (v2a)
%       - 'spline' interpolation
%=========================================================

function [GQKSA] = Quantize_Projections_v2a(tro,T,qT,KSA)

dim = length(KSA(1,1,:));

nproj = length(KSA(:,1,1));
realt = tro*T/max(T);
npg = length(qT);
GQKSA = zeros(nproj,npg,dim);

if nproj == 1
    for p = 1:dim
        GQKSA(1,:,p) = interp1(realt,KSA(1,:,p),qT,'spline','extrap');
    end
else  
    for n = 1:nproj
        for p = 1:dim
            GQKSA(n,:,p) = interp1(realt,KSA(n,:,p),qT,'spline','extrap');
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

