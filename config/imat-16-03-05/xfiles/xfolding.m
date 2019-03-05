function [y]=xfolding(x,n,m,type,dir)
%-----------------------------------------------------------
% function [y]=xfolding(x,n,m,type,dir)
%-----------------------------------------------------------
% Folding of a vector into a matrix
%-----------------------------------------------------------
% Input:
%   x:      the vector
%   n:      rows of the wanted matrix
%   m:      columns of the wanted matrix
%   type:   folding type, classic or snake
%   dir:    folding direction, hor(izontal) or ver(tical)
% Output:
%   y:      the matrix
%-----------------------------------------------------------
% Example:
% >> v=[1 2 3 4 5 6 7 8 9];
% >> xfolding(v,3,3,'snake','hor')
% 
% ans =
% 
%      1     2     3
%      6     5     4
%      7     8     9
%
y=zeros(n,m);
if strcmp(type,'snake')
    y1=reshape(x,n,m);
    y2=y1(:,2:2:m);
    y3=flipud(y2);
    y1(:,2:2:m)=y3;
    y=y1;
end
if strcmp(type,'snake') && strcmp(dir,'hor')
    y=y';
end
if strcmp(type,'classic') && strcmp(dir,'ver')
    y=reshape(x,n,m);
end
if strcmp(type,'classic') && strcmp(dir,'hor')
    y=reshape(x,n,m)';
end








