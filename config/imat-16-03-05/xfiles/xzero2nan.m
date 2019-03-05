function [x]=xzero2nan(x)
%-------------------------------------------
% function [y]=xzero2nan(x)
%-------------------------------------------
% Convert zeros to NaN
%-------------------------------------------
% Input:
%   x:  vector
% Ouput:
%   x:  vector
% Example:
%
x(find(x==0))=NaN;


