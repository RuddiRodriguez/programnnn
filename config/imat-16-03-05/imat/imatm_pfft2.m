function [resx,resy] = imatm_pfft2(y,N,M)
resy0=fft2(y);
[N,M]=size(y);
resy0=log(abs(fftshift(resy0)));        
zeroix=abs(resy0)==Inf;
resy0(find(zeroix))=0;
resy1=xradiussum(resy0);    
resy2=xanglesum(resy0);
resy=[resy1 resy2];
resx=1:size(resy,2);
