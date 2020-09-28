%=====================================================
% (v1b)
%       - AIDrp removed
%=====================================================

function [G] = SolveGradQuant_v1b(T,GQKSA,gamma)

dim = length(GQKSA(1,1,:));

nproj = length(GQKSA(:,1,1));
G = zeros(nproj,length(T)-1,dim);

for n = 1:nproj 
    Status2('busy',['Solving Gradient Quantization - Projection Number: ',num2str(n)],3);
    for p = 1:dim
        for m = 2:length(T)
            G(n,m-1,p) = ((GQKSA(n,m,p)-GQKSA(n,m-1,p))/(T(m)-T(m-1)))/gamma;
        end
    end
end
Status2('done','',3);
