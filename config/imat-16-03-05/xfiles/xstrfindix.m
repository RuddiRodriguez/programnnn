function [ix]=xstrfindix(s,sa)
%--------------------------------------------------------
% function [ix]=xstrfindix(s,sa)
%--------------------------------------------------------
% 
%--------------------------------------------------------
% Input:
%   s:
%   sa:
% Output:
%   ix:
%--------------------------------------------------------
% Example:
%
[N,M]=size(sa);
ix=[];
for n=1:N
    a1=xdespace(char(s));
    a2=xdespace(char(sa(n,:)));
    if all(size(a1)==size(a2))
        if a1==a2        
            ix=[ix 1];
        else
            ix=[ix 0];
        end
    else
        ix=[ix 0];
    end
end
