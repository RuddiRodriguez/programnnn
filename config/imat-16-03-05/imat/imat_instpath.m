function [path]=imat_instpath
if isunix
    path='/gbar/bohr/home1/s91/s918527/utils';
else
    path='C:\MATLAB6p5\work\imat-16-03-05';
end
if path(1,end)=='\' path=path(1:end-1); end
%
%   IMPORTANT !!!!!
%   The path must be the full path to 'imat-16-03-05'.
%   The path must point exactly to 'imat-16-03-05'.
%



