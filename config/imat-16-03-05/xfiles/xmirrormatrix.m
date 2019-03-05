function [x]=xmirrormatrix(n)
%-------------------------------------------------------
% function [x]=xmirrormatrix(n)
%-------------------------------------------------------
% Indentity matrix with the ones in the other diagonal.
%-------------------------------------------------------
% Input:
%   n:  rows
% Output:
%   x:  matrix
%-------------------------------------------------------
% Example:
%
x=zeros(1,n^2)
ix=n:(n-1):(n^2-1);
x(ix)=1;
x=reshape(x,n,n);
