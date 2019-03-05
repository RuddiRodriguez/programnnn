function [grouped]=xgroup_isos(X,s)
%------------------------------------------------------------------
% function xgroup_isos(X,s)
%------------------------------------------------------------------
% Grouping of X. Each group must be of the same size 
% and adjecent in the matrix X
%------------------------------------------------------------------
% Input:
%   X:  matrix where the rows are samples
%   s:  size og the groups
% Output:
%   Grouped:    
%------------------------------------------------------------------
% Example:
%
warning off;
[m n]=size(X);
grn=m/s;
grouped=[];
for g=0:grn-1
    grp=X(g*s+1:g*s+s,:);
    grouped=[grouped mat2cell(grp)];
end

