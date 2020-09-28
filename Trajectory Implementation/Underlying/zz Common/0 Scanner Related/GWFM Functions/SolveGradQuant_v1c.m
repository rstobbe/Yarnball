%=====================================================
% (v1c)
%       - Vectorized
%=====================================================

function [G] = SolveGradQuant_v1c(T,GQKSA,gamma)

nproj = length(GQKSA(:,1,1));

% dim = length(GQKSA(1,1,:));
% G0 = zeros(nproj,length(T)-1,dim);
% for n = 1:nproj 
%     Status2('busy',['Solving Gradient Quantization - Projection Number: ',num2str(n)],3);
%     for p = 1:dim
%         for m = 2:length(T)
%             G0(n,m-1,p) = ((GQKSA(n,m,p)-GQKSA(n,m-1,p))/(T(m)-T(m-1)))/gamma;
%         end
%     end
% end

m = 2:length(T);
TStep = T(m)-T(m-1);
TStepMat = repmat(TStep,nproj,1,3);
G = ((GQKSA(:,m,:)-GQKSA(:,m-1,:))./TStepMat)/gamma;

%test = isequal(G0,G);

Status2('done','',3);
