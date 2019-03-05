function [ij]=xmin2ij(x)
%-----------------------------------------------------------------
% function [ij]=xmin2ij(x)
%-----------------------------------------------------------------
% Like xminij, but output is a Nx2 matrix with the
% rows being the indicies.
%-----------------------------------------------------------------
% Input:
%   x:  a matrix
% Output:
%   ij: a matrix
%-----------------------------------------------------------------
% Example:
%
dacc=1e-9;
minval=min(min(x));
ij=abs(x-minval)<dacc;
i=find(max(ij'));
j=find(max(ij));
ij=[i j];






