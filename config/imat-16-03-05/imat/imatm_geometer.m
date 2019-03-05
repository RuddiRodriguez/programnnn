function [areas,borders,icenters,jcenters]=imatm_geometer(X,userpar)
lower_cutoff=userpar(1);
upper_cutoff=userpar(2);
borders=[];
areas=[];
[n m]=size(X);
X1=X>lower_cutoff;
X2=X<upper_cutoff;
Xoff=(X1.*X2);
%Xb=edge((X1.*X2),'canny');
Xb=xedge((X1.*X2),'inner');
cand=Xoff;

Xoff=X.*Xoff;
Xb=X.*Xb;
icenters=[];
jcenters=[];

while any(any(cand));
    [x y]=find(cand);
    x=x(1);
    y=y(1);
    %    function [background] = xconnectedm(pic,bgvalue1,bgvalue2,init)
    aream=xconnectedm(Xoff,lower_cutoff,upper_cutoff,[x y]);
    borderm=xconnectedm(Xb,lower_cutoff,upper_cutoff,[x y]);
    [i,j]=xgetix(borderm,1);
    i=sum(i)/prod(size(i));
    j=sum(j)/prod(size(j));
    
    area=sum(sum(aream));
    border=sum(sum(borderm));
    areas=[areas area];
    borders=[borders border];   
    icenters=[icenters i];
    jcenters=[jcenters j];
    cand=cand.*(reshape(~aream,n,m));    
end    

