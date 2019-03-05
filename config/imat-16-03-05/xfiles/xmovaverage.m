function [aver]=xmovaverage(x,order)
[N M]=size(x);
sumtemp=x;
for n=1:order
    temp=circshift(x',n)';
    temp=[repmat(0,N,n) temp(:,n+1:M)];
    sumtemp=sumtemp+temp;
end
tempi=[sumtemp(:,1:order)./repmat(1:order,N,1)];
temp1=sumtemp(:,order+1:M)/(order+1);
aver=[tempi temp1];



