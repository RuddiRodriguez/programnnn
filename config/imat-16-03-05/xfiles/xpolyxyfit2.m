function [X]=xpolyxyfit2(X)
global IMBIT;
XX=X;


dd=1480/(2*2*2*5);
gamma=1/dd;
[n m]=size(X);

Xri=[];
for i=1:dd:n-dd
    Xrj=[];
    for j=1:dd:m-dd
        sub=X(i:i+dd,j:j+dd);
        maxsub=max(max(sub));
        minsub=min(min(sub));
        Xrj=[Xrj (maxsub+minsub)/3];
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
[datax datay]=find(ones(Xm,Xn));
dataX=[datax datay]';
dataX=dataX*gamma;
surface=xpolyxy2(a,dataX);
surface=reshape(surface,Xm,Xn);
maxsurface=max(max(surface));
minsurface=min(min(surface));
elevator=X-surface;
pos=elevator>0;

Xtemp1=pos.*(maxsurface*ones(Xm,Xn)-surface);
Xtemp2=(~pos).*(maxsurface*ones(Xm,Xn)-surface).*0.6;
X1=Xtemp1+X;
X2=pos*255;


%X2=xreyscale(X2,255);
%X2=double(histeq(uint8(X2)));
X=double(X2);
% 
% % Visualization
% [datax datay]=find(ones(m,n));
% dataXr=[datax datay]';
% z=xpolyxy2(a,dataXr);
% %figure, plot3(data(1,:),data(2,:),z);
% figure;
% gd=reshape(z,n,m);
% Xr=reshape(Xr,n,m);
% mesh(gd);
% hold on
% surf(Xr);
% 
