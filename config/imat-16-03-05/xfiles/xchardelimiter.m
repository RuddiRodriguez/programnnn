function [groups]=xchardelimiter(grup,delimiter)
%------------------------------------------------------------
% function [groups]=xchardelimiter(grup,delimiter)
%------------------------------------------------------------
% 
%------------------------------------------------------------
% Input:
%   grup:
%   delimiter:
% Output:
%   groups:
%------------------------------------------------------------
% Example:
%
ix=grup==delimiter;
pos=find(ix);
sg=size(grup);
sg=sg(2);
subg=[];
groups=[];
for n=1:sg
    if grup(n)~=delimiter
        subg=[subg grup(n)];
    end
    if (grup(n)==delimiter || n==sg) && isstr(subg)
        groups=[groups cellstr(subg)];
        subg=[];
    end      
end


