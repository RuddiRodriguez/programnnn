function [last]=xlastmin(x)
%------------------------------------------------------
% function [last]=xlastmin(x)
%------------------------------------------------------
% The position of the last minimum in a vector
%------------------------------------------------------
% Input:
%   x:  A vector
% Output:
%   last:  The position of the last minimum
%------------------------------------------------------
% Example:
%
[last,val]=xfirstmin(fliplr(x));