function [X]=xinvertimage8(X);
%----------------------------------------------------------------
% function [X]=xinvertimage8(X);
%----------------------------------------------------------------
% Inversion / negation of an 8 bit image
%---------------------------------------------------------------
% Input:
%   X:  8 bit image (other formats are allowed)
% Output:
%   X:  Inverted 8 bit image (output format is maintained
%   8bit=>8bit, double=>double).
%---------------------------------------------------------------
% Example:
%
convert=0;
if isa(X,'uint8')
    convert=8;
end
X=double(X);
X=255-X;
if convert==8
    X=uint8(X);
end
