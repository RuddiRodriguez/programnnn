function xrevert(X)
%-------------------------------------
% function xrevert(X)
%-------------------------------------
% Revert matrix or vector
%-------------------------------------
% Input:
%   x: matrix or vector
% Ouput:
%   x: the reverted matrix/vector
%-------------------------------------
% Example:
%
[n,m]=size(X);
mirror=xmirrormatrix(n);
x=(x*mirror)';

