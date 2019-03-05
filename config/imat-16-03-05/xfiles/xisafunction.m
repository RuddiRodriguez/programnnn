function ok=isafunction(fn)
%----------------------------------------------------------------
% function ok=isafunction(fn)
%----------------------------------------------------------------
% Determines wheter a file is a function or a script
%----------------------------------------------------------------
% Input:
%   fn: file name
% Output:
%   ok: 1~function, 0~non-function (script)
%----------------------------------------------------------------
% Example:
%
ok=0;
if ~isstruct(fn)
    fn=dir(fn);
    sf=1;
end
sf=size(fn);
sf=sf(1);
for i=1:sf    
    if isstruct(fn)
        fn2=fn(i).name;
    else
        fn2=fn;
    end
    [line1] = textread(fn2,'%c',1);    
    ask=findstr('function',line1);
    if ~isempty(ask)
     ok=1;
    else
        ok=0;
    end
end
