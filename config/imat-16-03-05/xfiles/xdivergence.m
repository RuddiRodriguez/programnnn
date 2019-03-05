function [H,V,DL,DR,MINI]=xdivergence(X)
%------------------------------------------------
% function [H,V,DL,DR,MINI]=xdivergence(X)
%------------------------------------------------
% Calculates the divergence in 4 directions
% of the image
%------------------------------------------------
% Input:
%   X:  Matrix
% Ouput:
%   H:  Horizontal difference (-)
%   V:  Vertical (|)
%   DL: Diagonal (\)
%   DR: Diagonal (/)
%------------------------------------------------
% Example:
%
[N M]=size(X);
H=zeros(N-1,M-1);
V=H;
DL=H;
DR=H;
MINI=H;

for n=2:N-1
    for m=2:M-1
     sx=X(n-1:n+1,m-1:m+1);
     H(n,m)=(sx(2,3)-sx(2,1));
     V(n,m)=(sx(3,2)-sx(1,2));
     DL(n,m)=(sx(3,3)-sx(1,1));
     DR(n,m)=(sx(3,1)-sx(1,3));          
    end
end



