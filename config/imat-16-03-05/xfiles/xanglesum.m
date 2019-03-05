function A=xanglesum(B)
%-------------------------------------------------------
% function A=xanglesum(B)
%-------------------------------------------------------
% Calculates the sum over angles
%-------------------------------------------------------
% Input:
%   B:  Matrix   
% Output:
%   A:  summed matrix, A(angle), i.e. a vector
%-------------------------------------------------------
% Example:
%
[N,M]=size(B);
q=1:N;
v=[];
N2=floor(N/2)-1;
f=pi/180;
A=[];
da=1;
for a=1:da:360
    I=0;
    for r=1:N2
        x=round(r*cos(a*f)+N2)+1;
        y=round(r*sin(a*f)+N2)+1;
        I=I+B(x,y);
    end
    A=[A I/N2];
end

