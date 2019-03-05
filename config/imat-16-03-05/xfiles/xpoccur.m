function [ix,pos]=xpoccur(x,element,n)
%------------------------------------------------------------
% function [ix,pos]=xpoccur(x,element,n)
%------------------------------------------------------------
% The indexed matrix (ix) and of the n'th occurence
% and position (pos) of an element in a matrix
%------------------------------------------------------------
% Input:
%   x:          a matrix or vector
%   element:    element to look for
%   n:          pay atention to the n'th ocurrence
% Output:
%   ix:         indexed matrix (0's and 1's)
%   pos:        the position (not ij)
%------------------------------------------------------------
% Example:
%
[N M]=size(x);
ix=(x==element);
poss=find(ix);
if isempty(poss)
    pos=size(x);
    pos=pos(1)+1;
else
    pos=poss(n);
    ix=zeros(N,M);
    ix(pos)=1;
end


