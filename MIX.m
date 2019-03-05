function [res]= MIX(n,p)

X=sqrt(2)*sin((2*pi*(1:n))/12);

Y=sqrt(3)+(-sqrt(3)-sqrt(3))*rand(1,n);
Z=zeros(1,n);

t=rand(1,n);

uno=find(t<p);

cero=find(t>p);

Z(uno)=1;

Z(cero)= 0;

res=(1-Z).*X+Z.*Y;
%plot(res)