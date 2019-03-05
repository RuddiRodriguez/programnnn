function x=xconvert2numtype(x,bit,type)
%-----------------------------------------------------------------
% function x=xconvert2numtype(x,bit,type)
%-----------------------------------------------------------------
% Convert x specified type
%-----------------------------------------------------------------
% Input:
%   x:      Any numeric thing
%   bit:    bits
%   type:   0~signed, 1~unsigned, 2~single, 3~double
% Output:
%   x:      converted x
%-----------------------------------------------------------------
% Example:
%
switch [num2str(bit) num2str(type)]
    case ['80']
        x=int8(x);
    case ['160']
        x=int16(x);
    case ['320']
        x=int32(x);
    case ['640']
        x=int64(x);
    case ['81']
        x=uint8(x);
    case ['161']
        x=uint16(x);
    case ['321']
        x=uint32(x);
    case ['641']
        x=uint64(x);
    case ['02']
        x=single(x);
    case ['03']
        x=double(x);
end

