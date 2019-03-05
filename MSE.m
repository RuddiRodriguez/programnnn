function   [entropies] = MSE(X,tau,r,m)
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
% PURPOSE:
% Function that estimates the multiscale entropy (MSE) of a signal.
% USE:
% [entropies] = MSE(X,tau,r,m)
% ARGUMENTS...
% ...INPUT:
%        .-X ---> signal from which we want to compute MSE.
%        .-r ---> noise filter threshold.
%        .-m ---> embedded dimension.
% .-tau ---> scale number.
% ...OUTPUT:
%        .-entropies  ---> computed MSE values.
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
X = X(:);
N = length(X);
% Coarse graining process
entropies = zeros(1,tau);
for   n = 1:tau
     y_tau=zeros(1,N/tau);
     for j = 1:N/n
     y_tau(j) =  mean(X(((j-1)*n+1):j*n));
     end
    % SampEn is computed for each coarse grained signal.
    entropies(n) = SampEn(y_tau,r,m);
end

% figure(11)
% hold on
% n = 1:tau
% plot(n,entropies,'-o')
% title('entropies-sample')

