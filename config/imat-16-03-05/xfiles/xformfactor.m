function [ff]=xformfactor(a,p)
%--------------------------------------------
% function [ff]=xformfactor(a,p)
%--------------------------------------------
% Calculates the formfactor 4*pi*a/p^2
%--------------------------------------------
% Input:
%    a:    vector with areas
%    p:    vector with perimeters
% Output:
%    ff:   the form factors
%--------------------------------------------
% Example:
%
ff=4*pi*(a./(p.^2));


