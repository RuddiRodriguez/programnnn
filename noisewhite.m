X=0
N=1000
   for i = 1: N
      U = rand(1,100)
      X = X + U
   end
	
   % for uniform randoms in [0,1], mu = 0.5 and var = 1/12 */
   % adjust X so mu = 0 and var = 1 */
	
   X = X - N./2                % set mean to 0 */
   X = X.* sqrt(12./ N)       % adjust variance to 1 */
   
%     hh=autocorr(X,1000)
%    h=auto(X,99);
%    plot(X)
%    
%    figure(5)
%    plot(h)
%    hold on
%    plot(hh,'r-')
%    
   
%    for m=2:8
%   cc=mediafluct(m,1:length(savedcontours))
% %cc=1:20
% gg2=1;
% i=0;
u=zeros(1,length(X));
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
rm3=auto1(X,13)
% u(i)=rm;
u=rm3;
% figure(34)
% tiempo1=(1./4000).*j

%     end
  figure (7)   
   loglog(u,'o') 
hold on 
% end
%end
n=100000;
m=50;
X0=ones(1,m);
r=0.35;
sigma=.25;
X=[X0;1+r/n+sigma*sqrt(1/n)*randn(n,m)];
t=[0:1/n:1];
Xt=cumprod(X);
plot(t,Xt)
xlabel('$t$','interpreter','latex','FontSize',13)
ylabel('$X_t$','interpreter','latex','FontSize',13)
title('$Geometric ~Brownian ~Motion~:~~dX_t=r X_t dt+ \sigma X_t dW_t$','interpreter','latex','FontSize',13)
axis([0 1 0 3])



% n=10000;
% m=5;
% X0=zeros(1,m);
% sigma=0.3;
% X=[X0;sigma*sqrt(1/n)*randn(n,m)];
% Y=[X0;sigma*sqrt(1/n)*randn(n,m)];
% Xt=cumsum(X);
% Yt=cumsum(Y);
% t=[0:1/n:1];
% figure(5)
% plot(Xt,Yt)
% xlabel('$W_x(t)$','interpreter','latex','FontSize',13)
% ylabel('$W_y(t)$','interpreter','latex','FontSize',13)
% title('$2~Dimension ~Brownian ~Motion~:~~\vec{W}(t)=(W_x(t)~~W_y(t))$','interpreter','latex','FontSize',13)
% axis([-1 1 -1 1])



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
rm3=auto1(Xt,8000)
% u(i)=rm;
u=rm3;
% figure(34)
% tiempo1=(1./4000).*j

%     end
  figure (7)   
   loglog(u,'o') 

% end
