function [y]=xaccumulate(x)
%-----------------------------------------
% function [y]=xaccumulate(x)
%-----------------------------------------
% Accumulation along rows of a matrix
%-----------------------------------------
% Input:
%   x:  matrix
% Output:
%   y:  accumulated matrix
%-----------------------------------------
% Example:
%
% a =
% 
%      1     2     3
%      3     2     1
%      1     1     1
% 
% xaccumulate(a)
% 
% ans =
% 
%      1     3     6
%      3     5     6
%      1     2     3
% 
[n m]=size(x);
y=x;
for i=2:m
    y(:,i)=sum(x(:,1:i)')';    
end