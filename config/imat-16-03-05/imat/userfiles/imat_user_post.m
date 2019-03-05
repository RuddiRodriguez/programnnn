function [RESX,resx,RESY,resy]=imat_user_post(RESX,resx,RESY,resy)
[N,M]=size(resy);
resy=xcconv(resy,round(M^0.5),round(M^0.5),2);
X=reshape(resy,round(M^0.5),round(M^0.5));
X=imresize(X,0.2);
[N,M]=size(X);
resy=reshape(X,1,N*M);
resx=1:N*M;




