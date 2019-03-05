function [X]=xaddborder(X,add,value)
%---------------------------------------------------------------------
% function [X]=xaddborder(X,add,value)
%---------------------------------------------------------------------
% Add border rows and columns to a matrix / image
%---------------------------------------------------------------------
% Input:
%   X:      Matrix / image
%   add:    width in units of elements/pixels to be added
%   value:  if empty or not specified the value will be
%           equal to the initial border
% Ouput:    
%   X:      New matrix / image in the same format as the input X
% Note:
%           See also padarray.m from the dipum toolbox!
%---------------------------------------------------------------------
% Example:
%
[bit type]=xnumtype(X);
X=double(X);
if nargin==3
    if isempty(value)
        extra=1;          
    end
    [n m]=size(X);
    madd=value*ones(n,add);
    nadd=value*ones(add,m);
    nmadd=value*ones(add,add);    
else
    extra=1;
end
[n m]=size(X);
L=repmat(X(:,1),1,add)
R=repmat(X(:,m),1,add)
U=repmat(X(1,:),add,1)
D=repmat(X(n,:),add,1)
X=[repmat(L(1),add,add) U repmat(R(1),add,add);L X R;  repmat(X(n,1),add,add) D repmat(X(n,m),add,add)    ];
X=xconvert2numtype(X);


