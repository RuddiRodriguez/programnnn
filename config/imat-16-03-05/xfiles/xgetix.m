function [i,j]=xgetix(x,s)
%----------------------------------------------
% function [i,j]=xgetix(x,s)
%----------------------------------------------
% Get the indices of occurencies of a value
% in a matrix.
%----------------------------------------------
% Input:
%   x   matrix or vector
%   s   scalar value
% Output:
%   [i,j]   row,column
%----------------------------------------------
% Example:
%
[n m]=size(x);
ix=find(x==s);
if size(x,1)>1
    ix=ix-1;
    six=size(ix);
    j=max([ floor(ix/n+1) ones(six(1),1)]');
    i=(ix'-(j-1)*n+1)';
    j=j';
else
    i=1;
    j=ix;
end



