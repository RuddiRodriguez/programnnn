function [val,locm]=xlocmins(x,cir)
%-----------------------------------------------------
% function [val,locm]=xlocmins(x,cir)
%-----------------------------------------------------
% Get all minimums in a vector.
%-----------------------------------------------------
% Input:
% Output:
%-----------------------------------------------------
% Example:
%
[n0 m0]=size(x);
if nargin==2 && cir==1
    x=[xlastcol(x,2) x x(:,1:2)];    
end
[n m]=size(x);
dx=diff(x);
cand=find(dx<0);
cand=cand(find(cand+1<m));
cand2=dx(cand+1)>0;
locm=cand(find(cand2));
locm=locm(find(locm<m0));
val=x(locm+1);




