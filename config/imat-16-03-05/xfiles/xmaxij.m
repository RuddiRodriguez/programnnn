function [i,j]=xmaxij(x)
%-------------------------------------------------------
% function [i,j]=xmaxij(x)
%-------------------------------------------------------
% The index (ij) of the maximum element in a matrix
%-------------------------------------------------------
% Input:
%   x:  matrix
% Output:
%   i:  row
%   j:  column
% Note: If multiple solutions then all are listed
%-------------------------------------------------------
% Example:
%
mm=max(max(x));
[i,j]=xgetix(x,mm);

