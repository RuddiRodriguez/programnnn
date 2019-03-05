function [res] = ApEn(X,r,m)
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
% PURPOSE:
% Function that estimates the aproximate entropy (ApEn) of a signal.
% USE:
% [res] = ApEn(X,r,m)
% ARGUMENTS...
% ...INPUT:
%       .-X ---> signal from which we want to compute ApEn.
%       .-r ---> noise filter threshold.
%       .-m ---> embedded dimension.
% ...OUTPUT:
%       .-res  ---> computed ApEn value.
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
X = X(:);
% ApEn final calculation.
                                       
res = Phym(m,r,X)-Phym(m+1,r,X);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Phy computation
function phym = Phym(m,r,X)
N = length(X);
% Matrix that contains all the template vectors to be compared to each other.
M = zeros(N-m+1,m);
[f,c] = size(M);
for i = 1:f
    M(i,:) = X(i:i+m-1);
end
% Computation of the correlation measure.
cm = zeros(f,1);
for i = 1:f
% Matrix whose rows are the template vectors to be compared with the rest of the
% vectors.
 Mi = repmat(M(i,:),f,1);
% For each row, the maximun of the columns from the differences matrix is obtained.
 dist = max(abs(Mi-M),[],2);
 cm(i) = length(find(dist<=r))/(N-m+1);
end
phym = mean(log(cm));
