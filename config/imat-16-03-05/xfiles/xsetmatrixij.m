function [X]=xsetmatrixij(X,iv,jv,val)
%--------------------------------------------------------
% function [X]=xsetmatrixij(X,iv,jv,val)
%--------------------------------------------------------
% Insert the value val into indices iv and jv in a matrix
%--------------------------------------------------------
% Input:
%   X:
%   iv:
%   jv:
%   val:
% Output:
%   X:
%--------------------------------------------------------
% Example:
%
[N M]=size(X);
jvv=jv*N;
X=reshape(X,1,N*M);
X(iv+jvv)=val;
X=reshape(X,N,M);

