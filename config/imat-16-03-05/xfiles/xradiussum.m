function vv=xradiussum(x)
%------------------------------------------------------------
% function vv=xradiussum(x)
%------------------------------------------------------------
% Calculates the radius sum of a matrix, with respect to the
% center of the matrix.
%---------------------------------------------------------------
% Input:
%   x:  a square matrix
%   vv: a vector with the radius sum.
%---------------------------------------------------------------
% Example:
%
[N,M]=size(x);
q=1:N;
v=[];
N2=round(N/2);
vv=[];
f=pi/180;
for r=1:N2-1
    v=0;
    da=1;
    for a=1:da:360
        xx=ceil(r*cos(a*f)+N2);
        yy=ceil(r*sin(a*f)+N2);
        v=v+x(xx,yy);
    end
    vv=[vv v];
end

