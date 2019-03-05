function [X]=xconv(X,S)
%----------------------------------------------------------
% function [X]=xconv(X,S)
%----------------------------------------------------------
% Arithmetric mean (blurring) of image
% Cover function of xcconv.c / xcconv.dll
%----------------------------------------------------------
% Input:
%   X:  A matrix or one-layer image
%   S:  integer, (2*S+1) is the size of a submatrix
%       over wich to calculate a mean value
% Output:
%   X:  Averaged matrix / image
%----------------------------------------------------------
% Example:
%
[N,M]=size(X);
X=reshape(X,1,N*M);
X=xcconv(X,N,M,S);
X=reshape(X,N,M);
