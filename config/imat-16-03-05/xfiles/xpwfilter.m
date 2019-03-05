function [X]=xpwfilter(X,N,M,S,cut,pixn)
%---------------------------------------------------------------
% function [X]=xpwfilter(X,N,M,S,cut,pixn)
%---------------------------------------------------------------
% Cover m-file for xcpwfilter.c
% Calculates piecewise linear conditional blurring
% or contrast enhancement.
%---------------------------------------------------------------
% Input:
%   X:      image
%   N:      rows
%   M:      columns
%   S:      size of submatrix
%   cut:    Cutoff
%   pixn:   the condition. If the submatrix contain more than
%           pixn pixels of values lower than cut, then all
%           pixels in the submatrix are attributed the smaller
%           value of the submatrix and the opposite. If the
%           condition is not met, then the submatrix is left
%           unchanged.
% Output:
%   X:  
%---------------------------------------------------------------
% Example:
%
X=reshape(X,1,N*M);
X=xcpwfilter(X,N,M,S,cut,pixn);
X=reshape(X,N,M);
