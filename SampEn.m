function [res] = SampEn(X,r,m)
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
% PURPOSE:
% Function that estimates the sample entropy (SampEn) of a signal.
% USE:
% [res] = SampEn(X,r,m)
% ARGUMENTS...
% ...INPUT:
%        .-X ---> signal from which we want to compute SampEn.
%        .-r ---> noise filter threshold.
%        .-m ---> embedded dimension.
% ...OUTPUT:
%        .-res  ---> computed SampEn value.
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
% Initial variables definition.
N = length(X);
X = X(:);
B_m_i = zeros(1,N-m);
A_m_i = zeros(1,N-m);
% Matrix that contains all the template vectors to be compared to each other.
for n = 1:2
M = zeros(N-m,m+n-1);
[f,c] = size(M);
for i = 1:f
    M(i,:) = X(i:i+m+n-2);
end
% Computation of the correlation measure.
for i = 1:f
    % Matrix whose rows are the template vectors to be compared with the rest of the
% vectors.
    Mi = repmat(M(i,:),f,1);
    % For each row, the maximun of the columns from the differences matrix is obtained.
    dist = max(abs(Mi-M),[],2);
    % To avoid selfmatches
    dist(i,:) = [];
    if n == 1
       B_m_i(i) = length(find(dist<=r))/(N-m-1);
    else
       A_m_i(i) = length(find(dist<=r))/(N-m-1);
    end
  end
end
B_m = mean(B_m_i);
A_m = mean(A_m_i);
% ApEn final calculation
res = log(B_m) - log(A_m);
