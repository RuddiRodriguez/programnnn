function [first,val]=xfirstmin(x)
%----------------------------------------------------
% function [first]=xfirstmin(x)
%----------------------------------------------------
% The position of the first minimum in a vector
%----------------------------------------------------
% Input:
%   x:  A vector
% Output:
%   first:  The position of the first minimum
%   val:    The minimum value
%----------------------------------------------------
% Example:
% x=[5 4 3 2 4 5 4 1 5 6];
%          |       |
%          minimums
% [m,v]=xfirstmin(x)
% m=4, v=2
% 
first=find(diff(x)>0);
if ~isempty(first)
    first=first(1);
end
val=x(first);


