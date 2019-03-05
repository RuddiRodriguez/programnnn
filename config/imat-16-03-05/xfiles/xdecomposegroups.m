function [out]=xdecomposegroups(STRINGARRAY,NUMBERARRAY,sortafter,syntax)
%------------------------------------------------------------------------------
% function [out]=xdecomposegroups(STRINGARRAY,NUMBERARRAY,sortafter,syntax)
%------------------------------------------------------------------------------
% 
%------------------------------------------------------------------------------
% Input:
%   STRINGARRAY:
%   NUMBERARRAY:
%   sortafter:
%   syntax:
% Output:
%   Out:
%------------------------------------------------------------------------------
% Example:
%
[N,M]=size(NUMBERARRAY);
syntax=char(syntax);
sortafter=str2num(sortafter);
size_sortafter=size(sortafter);
size_sortafter=size_sortafter(2);
out=[];
for ii=1:size_sortafter
    if syntax(1,sortafter(ii))=='s'
        outsn=STRINGARRAY(:,sortafter(ii));
    end
    if syntax(1,sortafter(ii))=='n'
        %        str2num(sortafter(ii))
        outsn=NUMBERARRAY(:,sortafter(ii));
    end
    if ii<size_sortafter
        ntilde=sortafter(ii+1)-sortafter(ii);
        if ntilde>1
            tilde=cellstr(repmat('~',N,ntilde-1));
        else
            tilde=[];
        end
        outsn=[outsn tilde];
    end
    out=[out outsn];
end
