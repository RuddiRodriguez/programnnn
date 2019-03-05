
clear;
S=0.5;
g=S.*(1-S);
t=0:0.1:30;
q=2./4e-6;
kbt=1.38e-23.*(298);
D=1e-12;
tao=1e-3;
alfa=D.*(q.^2);
beta=(1./tao)+D.*(q.^2);
num=1;
kappa=1e-19;
w=(kappa.*q.^3)./(4.*0.001);
% prueba=3.*exp(-w.*t);

factor1=(kbt./(kappa.*(q.^4))).*exp(-w.*t);
factor11=(kbt./(kappa.*(q.^4))).*exp(-(w.*t).^0.7);

factor2=((num.*S)./(w.*((w.^2)-(alfa.^2)))).*(w.*exp(-alfa.*t)-alfa.*exp(-w.*t));

factor3=((num.*g)./(w.*((w.^2)-(beta.^2)))).*(w.*exp(-beta.*t)-beta.*exp(-w.*t));

Auto=factor1+factor2+factor3;
figure (1)
semilogx(t,factor1./factor1(1),'o',t,factor2./factor2(1),'-k',t,factor11./factor11(1),t,factor3./factor3(1),t,Auto./Auto(1),'*')
h = legend('bending','Collective Diff','Bending Granek','Function','Sum',1);
set(h,'Interpreter','none')
axis square;

 figure (2)
% semilogx(t,Auto./Auto(1))

q1=[2:50]./4e-6;
alfa=D.*(q1.^2);
beta=(1./tao)+D.*(q1.^2);
w=(kappa.*q1.^3)./(4.*0.001);
loglog(q1,alfa,'o',q1,beta,'*',q1,w,'+');
 figure(3)
 plot(q1,beta)
