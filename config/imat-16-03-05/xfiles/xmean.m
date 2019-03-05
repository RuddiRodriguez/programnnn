function [m,nanix2]=xmean(x2,d)
%-----------------------------------------------------
% function m=xmean(x2,d)
%-----------------------------------------------------
% Averaging. Interpreting NaN as missing.
%-----------------------------------------------------
% Input:
%   x2: matrix
%   d:  1~over rows, 2~over cols
% Output:
%   m:          The average
%   nanix2:     NaN ix
%------------------------------------------------------
% Example:
%
if nargin==2
    if d==2
        x2=x2';    
    end
end
[N,M]=size(x2);
[x2,nanix2]=xnan2val(x2,0);
mx2=mean(x2,1);
nans=sum(nanix2,1);
m=(mx2*N)./(N-nans);






