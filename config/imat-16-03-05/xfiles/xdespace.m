function [s]=xdespace(s)
%--------------------------------------
% function [s]=xdespace(s)
%--------------------------------------
% Removes any space chars in a string
%--------------------------------------
% Input:
%   s:  a string
% Output:
%   s:  the string without spaces
%--------------------------------------
% Example:
%
s(find(s==' '))='';
