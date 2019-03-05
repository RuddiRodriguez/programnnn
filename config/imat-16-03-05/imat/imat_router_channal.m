function [imgdat]=imat_router_channel(imgdat,channel)
sii=size(size(imgdat));
channel=str2num(num2str(channel)');
imgdat=imgdat(:,:,channel);
%imgdat=reshape(imgdat,n,m,prod(size(channel)));

