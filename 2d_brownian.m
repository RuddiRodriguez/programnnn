n=1000;
m=5;
X0=zeros(1,m);
sigma=0.3;
X=[X0;sigma*sqrt(1/n)*randn(n,m)];
Y=[X0;sigma*sqrt(1/n)*randn(n,m)];
Xt=cumsum(X);
Yt=cumsum(Y);
t=[0:1/n:1];
plot(Xt,Yt)
xlabel('$W_x(t)$','interpreter','latex','FontSize',13)
ylabel('$W_y(t)$','interpreter','latex','FontSize',13)
title('$2~Dimension ~Brownian ~Motion~:~~\vec{W}(t)=(W_x(t)~~W_y(t))$','interpreter','latex','FontSize',13)
axis([-1 1 -1 1])



u=zeros(1,length(Yt));
u3=zeros(1,length(savedcontours));
tiempo1=zeros(1,length(savedcontours));
% for g2=2:2
%     for j =2:length(savedcontours)-1
%         i=i+1
% gg2=2:(j)
% test=mediafluct(g2,gg2)
% test=length(mediafluct(g2,gg2));
% rm=(mean(mediafluct(g2,gg2).^2))-((mean(mediafluct(g2,gg2))).^2);
% rm3=((std(mediafluct(g2,gg2))).*(length(mediafluct(g2,gg2))-1)).^2;
rm3=auto1(Yt,13)
% u(i)=rm;
u=rm3;
% figure(34)
% tiempo1=(1./4000).*j

%     end
  figure (7)   
   loglog(u,'o') 
hold on 
% end