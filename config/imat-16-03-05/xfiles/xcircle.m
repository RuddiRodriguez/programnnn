function [x,y]=xcircle(cx,cy,r)
%-----------------------------------------------------------
% function [x,y]=xcircle(cx,cy,r)
%-----------------------------------------------------------
% Generates a matrix, that when unfolded (classic vertical)
% is a sinus curve X=a*sin(w*[1:N*M])
%-----------------------------------------------------------
% Input:
%	N:	rows
%	M:	columns
%	a:	amplitude
%	w:	frequency
% Output:
%	X:	image
%-----------------------------------------------------------
% Exxample:
%
dp=1/r;
p=0:dp:2*pi;
x=cx+r*cos(p);
y=cy+r*sin(p);

