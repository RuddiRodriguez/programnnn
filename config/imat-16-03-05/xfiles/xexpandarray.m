function [X,v]=xexpandarray(X,v,expandwith)
%----------------------------------------------------------
% function [X,v]=xexpandarray(X,v,expandwith)
%----------------------------------------------------------
% Column expansion of arrays...
%----------------------------------------------------------
% Input:
%   X:           Matrix
%   v:           Vector 
%   expandwith: element with wich to expand
% Output:
%   X:      Exapaned matrix (if it was necesary)
%   v:      Exapaned vector (if it was necesary)
%----------------------------------------------------------
% Example:
%   X=[1 2 3;5 6 7];
%   v=[1 2 3 4 5];  and expandwith=NaN
%   New values: 
%   X=[1 2 3 NaN NaN; 5 6 7 NaN NaN];
%   v has more columns than X, hence no change
%
[Xn Xm]=size(X);
[vn vm]=size(v);
xex=Xm-vm;
if xex<0
    zz=zeros(Xn,-xex)*expandwith;
    X=[X zz];
end

if xex>0
    zz=zeros(1,xex)*expandwith;
    v=[v zz];
end
