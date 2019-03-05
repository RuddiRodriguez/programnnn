function [X]=xpoly2fit(X,Ni,Nj)
XX=X;
[N,M]=size(X);

di=round(N/Ni);
dj=round(M/Nj);
gammai=1/di;
gammaj=1/dj;
[n m]=size(X);

Xri=[];
for i=1:di:n-di
    Xrj=[];
    for j=1:dj:m-dj
        sub=X(i:i+di,j:j+dj);
        maxsub=max(max(sub));
        minsub=min(min(sub));
        Xrj=[Xrj (maxsub+minsub)/2];
    end
    Xri=[ Xri; Xrj ];
end
Xr=Xri;

[m n]=size(Xr);

[datax datay]=find(ones(m,n));
data=[datax datay]';
a0=ones(1,16);
Xr=reshape(Xr,1,n*m);
hh=optimset('MaxIter',100000);
[a,resnorm] = lsqcurvefit('xpolyxy2',a0,data,Xr,[],[],hh);


[Xm Xn]=size(X);
[datai dataj]=find(ones(Xm,Xn));
dataX=[datai*gammai dataj*gammaj]';
dataX=dataX;
surface=xpolyxy2(a,dataX);
surface=reshape(surface,Xm,Xn);
maxsurface=max(max(surface));
minsurface=min(min(surface));
elevator=X-surface;
pos=elevator>0;

Xtemp1=pos.*(maxsurface*ones(Xm,Xn)-surface);            % over
Xtemp2=(~pos).*(maxsurface*ones(Xm,Xn)-surface).*0.6;    % under
%X1=Xtemp1+X;
X2=X+Xtemp1+Xtemp2;
X=double(X2);





function F = xpolyxy(a,data)
x=data(1,:);
y=data(2,:);

F = a(1)*(x-a(4)).^2+a(2)*(y-a(5)).^2+a(3);




function F = xpolyxy2(a,data)
x=data(1,:);
y=data(2,:);

F = a(1)*(x-a(2)) + a(3)*(y-a(4))   +  a(5)*(x-a(6)).^2+a(7)*(y-a(8)).^2  +  a(9)*(x-a(10)).^3+a(11)*(y-a(12)).^3  +  a(13)*(x-a(14)).*(y-a(15))   +  a(16);

