function [out]=xcells2str_h(x,y)
%------------------------------------------------------------------
% function [out]=xcells2str_h(x,y)
%------------------------------------------------------------------
% Catenates a string array with a single string vertically
%------------------------------------------------------------------
% Input:
%   x:  string array  / (or a string)
%   y:  string        / (or a string array)
% Output:
%   out:    string array
%------------------------------------------------------------------
% Example:
%    x=[cellstr('gfdg');       out=[cellstr('gfdga');    
%       cellstr('gg')];             cellstr('gga')];
%    y='a';
%
if nargin==1
    out=[];
    sx=size(x);
    sx=sx(2);
    for i=1:sx
        out=[out char(x(i))];
    end
end
if nargin==2
    sx=size(x);
    sy=size(y);
    if sx(1)==1
        out=[];
        for i=1:sy(1)
            outj=[];
            for j=1:sy(2)
              outj=[outj char(y(i,j))];
            end
            out=[out; cellstr([x outj])];
        end
    end
    
    if sy(1)==1
        out=[];
        for i=1:sx(1)
            outj=[];
            for j=1:sx(2)
              outj=[outj char(x(i,j)) ];
            end
            out=[out; cellstr([outj y]) ];
        end
    end    
end
