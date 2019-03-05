function [resx,resy] = imatm_logabsfft2(y,N,M)
resy0=fft2(y);
[N,M]=size(y);
resy=log(abs(fftshift(resy0)));        
resy=reshape(resy,1,N*M);        
zeroix=abs(resy)==Inf;
resy(find(zeroix))=0;
resx=1:size(resy,2);
