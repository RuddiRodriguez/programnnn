function frecuencias=diagrama(n,p)
%function frecuencias=diagrama(n,p,q1,f1,q2,f2)

%p kappa,sigma,b,u,radio,eta

kappa=p(1)
sigma=p(2)
b=p(3)
u=p(4)
eta=0.001
radio=p(5)
epsilon=p(6)
D=p(7)
c=2.6;
kt=296.65*1.38e-23;
w=c*sqrt(kt*u);

q=n./radio;
%mkdir(sprintf('%s/diagrama',working_directory_path));
%bending
Fb=(kappa.*(q.^3))./(4.*eta)

%friccion
Ff=(epsilon.*(q.^2))./(2.*b)

%cisalla
Fc=(w.*(q.^2))./(4.*eta)

%tension
Ft=(sigma.*(q.^1))./(4.*eta)

%ZG
Fzg=0.025*((kt./kappa).^0.5)*(kt./eta).*(q.^3)

%Difussion
Fd=2.*D.*(q.^2)

figure(1)
%hold on
% loglog(q2,f2,'-g')
% loglog(q1,f1,'-b')
loglog(q,Fb,'-or',q,Ff,'-ob',q,Fc,'-og',q,Ft,'-om',q,Fzg,'-oc',q,Fd,'-*',q,3000,'-ok')
h = legend('bending','friction','shear','tension','ZG','Difu','Limit',2);
set(h,'Interpreter','none')
axis square;
%hold off

Fb=Fb'
Ff=Ff'
Fc=Fc'
Ft=Ft'
Fzg=Fzg'
q=q'


