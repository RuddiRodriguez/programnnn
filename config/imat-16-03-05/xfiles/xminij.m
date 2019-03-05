function [i,j]=xminij(x)
%-----------------------------------------------------------------
% function [i,j]=xminij(x)
%-----------------------------------------------------------------
% The index (ij) of the minimum element in a matrix/vector
%-----------------------------------------------------------------
% Input:
%   x:  matrix
% Output:
%   i:  row
%   j:  column
% Note: If multiple solutions then all are listed
%-----------------------------------------------------------------
% Example:
%
mm=min(min(x));
[i,j]=xgetix(x,mm);

