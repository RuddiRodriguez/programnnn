function [path,file]=xpathfile(t)
%
%

pos=xlastcol(find(t==xgetos),1);
path=t(1:pos);
[n,m]=size(t);
file=t(pos+1:m);
