function [i,j]=xminn(X,n)
%--------------------------------------------------------------
% function [i,j]=xminn(X,n)
%--------------------------------------------------------------
% n Smallest elements in a matrix
%--------------------------------------------------------------
% Input:
%   X:  matrix
%   n:  an integer smaller than the numer of elements in X.
%       It is the number of minimum elements wanted.
% Output:
%   i:  row
%   j:  column
%--------------------------------------------------------------
% Example:
%
[N,M]=size(X);
X=reshape(X,1,N*M);
[X ix]=sort(X);
ix=ix(1:n);
XX=zeros(1,N*M);
XX(ix)=1;
XX=reshape(XX,N,M);
[i,j]=xgetix(XX,1);


