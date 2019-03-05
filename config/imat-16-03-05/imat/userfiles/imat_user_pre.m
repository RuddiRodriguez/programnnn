function [X,background,userpar,N,M]=imat_user_pre(X,background)
% Image (X) must be of type uint8
% Output N and M are the new dimensions of the image
% --- If you know what you are doing, then change ...
userpar=[];
X=double(X);
[N,M]=size(X);
% --- Type Your Matlab code here ...
X=reshape(X,1,N*M);
X=xcconv(X,N,M,2);
X=reshape(X,N,M);
X=xpoly2fit(X,20,20);


