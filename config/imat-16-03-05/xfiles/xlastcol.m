function [y]=xlastcol(x,n)
%----------------------------------------------------
% function [y]=xlastcol(x,n)
%----------------------------------------------------
% The n last elements/columns in a vector/matrix
%----------------------------------------------------
% Input:
%   x:  vector or matrix
%   n:  
% Ouput:
%   y:  the last ...   
%----------------------------------------------------
% Example:
%
[N,M]=size(x);
y=x(:,M-n+1:M);


