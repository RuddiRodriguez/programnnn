function [bit,type]=xnumtype(x)
%---------------------------------------------------------
% function [bit,type]=xnumtype(x)
%---------------------------------------------------------
% Returns the bit of x and its type.
%---------------------------------------------------------
% Input:
%   x:  Any numeric thing
% Output:
%   bit:    bits
%   type:   0~signed, 1~unsigned, 2~single, 3~double
%---------------------------------------------------------
% Example:
%
if isa(x,'numeric')
    if isa(x,'int8');
        bit=8;
        type=0;
    end
    if isa(x,'int16')
        bit=16;
        type=0;
    end
    if isa(x,'int32')
        bit=32    
        type=0;
    end
    if isa(x,'int64')
        bit=64;    
        type=0;
    end
    if isa(x,'uint8');
        bit=8;
        type=1;
    end
    if isa(x,'uint16')
        bit=16;
        type=1;
    end
    if isa(x,'uint32')
        bit=32 
        type=1;
    end
    if isa(x,'uint64')
        bit=64;
        type=1;
    end
    
    if isa(x,'single')
        type=2;
        bit=0;
    end
    
    if isa(x,'double')
        type=3;
        bit=0;
    end
else
    type=0;
    bit=0;
end
