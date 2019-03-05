function [X,par]=xreyscale(X,low,high,par)
%-----------------------------------------------------
%function [X,par]=xreyscale(X,low,high,par)
%-----------------------------------------------------
% Formerly called xnormalize, by mistake!
% Re-scales the values of a matrix to within the
% interval [low;high]
%-----------------------------------------------------
% Input:
%   X:      A matrix or image (must be double)
%   low:    New lower limit
%   high:   New upper limit
% Output:
%   X:      Scaled matrix / image
%   par:    parameters used to scale
%------------------------------------------------------
% Example:
%
X=double(X);
if nargin==3
    smallest=min(min(X));
    largest=max(max(X));
    mulle=(high-low)/(largest-smallest);
    X=X*mulle-(smallest*mulle-low);
    par=[mulle smallest low];
end
if nargin==4
    mulle=par(1);
    smallest=par(2);
    low=par(3);
    X=X*mulle-(smallest*mulle-low);
end

