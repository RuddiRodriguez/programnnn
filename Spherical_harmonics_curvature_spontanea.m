


v=36;
exces=-0.46;
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
flucta = load(sprintf('%s/results/fluctuationsa.txt',working_directory_path));
C0=-0.74;
q=2:v;
flucta=flucta(q,1);
kappa=zeros(1,length(q));
amplitud=zeros(1,length(q));
factor1=zeros(1,length(q));
sigmcn=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
r0=r0(savedcontours);
rmean=mean(r0);
sigmcn=(sigmcn.*2)./(pi*(rmean.^3));
sigmcn=sigmcn(1,q);
flucta=(flucta')-sigmcn;
h=0;
for q=2:v
h=h+1;
j=q:100; 
i=0;
P1=zeros(length(j),1);

for l=q:34
    i=i+1;
        
    i=i+1;
    N=sqrt((((2*l)+1)/2)*((factorial(l-q))/(factorial(l+q))));
    N1=((((2*l)+1)/(4*pi))*((factorial(l-q))/(factorial(l+q))));
    pp=legendre(l,0);
    ppp=(pp).*N;
    pppp=(pp.^2).*N1;
P= legendre(l,0,'norm');
P=(P.^2)./(2*pi);
p=P((q+1));
deno=((l-1)*(l+2)*((l*(l+1))+exces-(4*C0)+(2*(C0^2))));
P1(i)=p./deno;
end
 factor=sum(P1);
factor1(h)=sum(P1);
kappa(h)=((1.38e-23*296)/(flucta(h)))*factor;
amplitud(h) =((1.38e-23*298)/(5.47e-19))*factor;
end
q=2:v;
figure(1)

bar(q(1,1:11),kappa(1,1:11))
figure(2)
hold on
semilogy(q,flucta,'o',q,amplitud,'-')
figure(3)
plot(q,factor1,'o')
hold on
figure (4)
plot(q,(flucta.*(q.^3)),'o')
figure(5)
hold on
% parameterStruct.scalefactor_kappa=1e-19
% ftype= fittype('((1.38e-23*298)/(kappa * scalefactor_kappa))*x','coefficients',{'kappa'},'problem',{'scalefactor_kappa'});
% %ftype= fittype('((1.38e-23*298)/(kappa))*x');
% flucta=flucta
% factor1=factor1'
% q=q'
% 
% [fresult,gof,output] =fit(factor1,flucta,ftype,'StartPoint',[1],'Algorithm','Levenberg-Marquardt','problem',{parameterStruct.scalefactor_kappa});
% %[fresult,gof,output] =fit(factor1,flucta,ftype,'Algorithm','Levenberg-Marquardt');
% f=feval(fresult,factor1);
% figure (15)
% loglog(factor1,f,factor1,flucta,'o')
% figure (16)
% plot(factor1,flucta,'o')
% figure (17)