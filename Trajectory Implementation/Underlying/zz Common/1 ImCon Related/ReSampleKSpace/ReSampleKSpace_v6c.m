%=====================================================
% (v6c)
%       - posterity
%=====================================================

function [samp,Kmat,Kend] = ReSampleKSpace_v6c(PROJimp,G,T,zerotime)

gamma = PROJimp.gamma;

tro = PROJimp.tro;
npro = PROJimp.npro;
[nproj,~,~] = size(G);
dwell = PROJimp.dwell;
start = PROJimp.sampstart;

samp = [0 (start:dwell:tro) zerotime];           

samp = round(samp*1e6);
T = round(T*1e6);

if nproj > 1
    Kmat = zeros(nproj,npro+2,3);
    K = zeros(nproj,3);
    ind = 2;
    for m = 2:npro+2
        d = 0;
        while d == 0;
            if T(ind) < samp(m)                
                if T(ind) > samp(m-1)
                    if T(ind-1) < samp(m-1)
                        K = K + (T(ind)-samp(m-1))*(squeeze(G(:,ind-1,:)))*gamma/1e6;
                        ind = ind+1;
                    elseif T(ind-1) >= samp(m-1)
                        K = K + (T(ind)-T(ind-1))*(squeeze(G(:,ind-1,:)))*gamma/1e6;
                        ind = ind+1;
                    end
                elseif T(ind) <= samp(m-1)
                    if ind == length(T)
                        K = K + (samp(m)-T(ind))*(squeeze(G(:,ind,:)))*gamma/1e6;
                        d = 1; 
                        Kmat(:,m,:) = K;
                    else
                        if T(ind+1) >= samp(m)                
                            K = K + (samp(m)-samp(m-1))*(squeeze(G(:,ind,:)))*gamma/1e6;
                            d = 1; 
                            Kmat(:,m,:) = K;
                        elseif T(ind+1) < samp(m)
                            ind = ind+1;
                        end
                    end
                end
            elseif T(ind) >= samp(m)   
                if T(ind-1) <= samp(m-1)
                    K = K + (samp(m)-samp(m-1))*(squeeze(G(:,ind-1,:)))*gamma/1e6;
                    d = 1; 
                    Kmat(:,m,:) = K;
                elseif T(ind-1) > samp(m-1)
                    K = K + (samp(m)-T(ind-1))*(squeeze(G(:,ind-1,:)))*gamma/1e6;
                    d = 1;
                    Kmat(:,m,:) = K;
                end
            end
        end
        Status2('busy',['Sample Number: ',num2str(m)],2);     
    end
elseif nproj == 1
    Kmat = zeros(nproj,npro+2,3);
    K = zeros(nproj,3);
    ind = 2;
    for m = 2:npro+2
        d = 0;
        while d == 0;
            if T(ind) < samp(m)                
                if T(ind) > samp(m-1)
                    if T(ind-1) < samp(m-1)
                        K = K + (T(ind)-samp(m-1))*(squeeze(G(:,ind-1,:)))'*gamma/1e6;
                        ind = ind+1;
                    elseif T(ind-1) >= samp(m-1)
                        K = K + (T(ind)-T(ind-1))*(squeeze(G(:,ind-1,:)))'*gamma/1e6;
                        ind = ind+1;
                    end
                elseif T(ind) <= samp(m-1)
                    if ind == length(T)
                        K = K + (samp(m)-T(ind))*(squeeze(G(:,ind,:)))'*gamma/1e6;
                        d = 1; 
                        Kmat(:,m,:) = K;
                    else
                        if T(ind+1) >= samp(m)                
                            K = K + (samp(m)-samp(m-1))*(squeeze(G(:,ind,:)))'*gamma/1e6;
                            d = 1; 
                            Kmat(:,m,:) = K;
                        elseif T(ind+1) < samp(m)
                            ind = ind+1;
                        end
                    end
                end
            elseif T(ind) >= samp(m)   
                if T(ind-1) <= samp(m-1)
                    K = K + (samp(m)-samp(m-1))*(squeeze(G(:,ind-1,:)))'*gamma/1e6;
                    d = 1; 
                    Kmat(:,m,:) = K;
                elseif T(ind-1) > samp(m-1)
                    K = K + (samp(m)-T(ind-1))*(squeeze(G(:,ind-1,:)))'*gamma/1e6;
                    d = 1;
                    Kmat(:,m,:) = K;
                end
            end
         end
        Status2('busy',['Re-Sample: ',num2str(m)],3);     
    end
end
    
samp = samp(2:npro+1)/1e6;
Kend = Kmat(:,npro+2,:);
Kmat = Kmat(:,2:npro+1,:);

