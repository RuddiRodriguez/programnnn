function [y,x]=xsinusimg(N,M,a,w)
%---------------------------------------------
%function [y,x]=xsinusimg(N,M,a,w)
%---------------------------------------------
% Generates a matrix, that when
% unfolded (classic vertical) is a
% sinus curve X=a*sin(w*[1:N*M])
%---------------------------------------------
% Input:
%	N:	rows
%	M:	columns
%	a:	amplitude
%	w:	frequency
% Output:
%	y:  The image
%   x:  x
%---------------------------------------------
% Example:
%
x=(1:N*M)*w;
y=a*sin(x);
y=reshape(y,N,M);
