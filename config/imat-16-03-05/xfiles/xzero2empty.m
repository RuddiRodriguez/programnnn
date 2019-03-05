function [x]=xzero2empty(x)
%-------------------------------------------
% function [y]=xzero2nan(x)
%-------------------------------------------
% Convert zeros to [], i.e. remove zeros
%-------------------------------------------
% Input:
%   x:  vector
% Ouput:
%   x:  vector
% Example:
%
x(find(x==0))=[];


