%=========================================================
% 
%=========================================================

function [max_step] = Max_Grad_Step_v1a(G,T)

if (length(T)-1) == 1
    max_step = max(G(:));
else
    m = (2:length(T)-1);
    steps = G(:,m,:)-G(:,m-1,:);
    steps = [G(:,1,:) steps];
    max_step = max(abs(steps(:)));
end

