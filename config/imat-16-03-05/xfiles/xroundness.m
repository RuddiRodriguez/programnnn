function [r]=xroundness(l,a)
%----------------------------------------------------------
% function [r]=xroundness(l,a)
%----------------------------------------------------------
% Calculates the roundness 4*a/(pi*l^2)
%----------------------------------------------------------
% Input:
%    l:    vector with maximum projected lengths
%    a:    vector with areas
% Output:
%    r:    the roundness   
%----------------------------------------------------------
% Example:
%
r=4*(a./(pi*l.^2));


