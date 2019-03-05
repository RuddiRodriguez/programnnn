function [x2,nanix2]=xnan2val(x2,val)
%------------------------------------------------------------------
% function [x2,nanix2]=xnan2val(x2,val)
%------------------------------------------------------------------
% Replace NaN by specified value in a matrix / vector
%------------------------------------------------------------------
% Input:
%   x2:     matrix / vector
%   val:    scalar / vector
% Output:
%   x2:     New matrix / vector
%   nanix2: Index
%------------------------------------------------------------------
% Example:
%   If val is a vector, then the lenght must be equal to the number
%   of columns in the matrix x2.
%   q=[1 2 NaN 4; 6 NaN 8 9];
%   xnan2val(q,[1 2 3 4]);
% ans =
%
%     1     2     3     4
%     6     2     3     9
%
ix1=[];
ix2=[];
[N,M]=size(x2);
nanix2=isnan(x2);
if any(any(nanix2))
    [ix1,ix2]=xmaxij(nanix2);
end
if size(val,2)>1
    val=repmat(val,N,1);
    x2(ix1,ix2)=val(ix1,ix2);
else
    x2(ix1,ix2)=repmat(val,size(ix1,1),size(ix2,1));
end

