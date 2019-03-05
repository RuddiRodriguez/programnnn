function s=xstd(x2,d)
%-------------------------------------------------------
% function s=xstd(x2,d)
%-------------------------------------------------------
% Standard deviation. Interpreting NaN as missing.
%-------------------------------------------------------
% Input:
%   x2: matrix
%   d:  1~over rows, 2~over cols
% Output:
%   s:  The standard deviation
%-------------------------------------------------------
% Example:
%
if nargin==2
    if d==2
        x2=x2';    
    end
end
[N,M]=size(x2);
[m,nanix2]=xmean(x2,1);
x2=xnan2val(x2,m);
s=sqrt(std(x2).^2*(N-1)./(N-sum(nanix2)-1));




