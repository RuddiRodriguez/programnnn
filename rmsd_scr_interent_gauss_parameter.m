%The script modify to study dynamics system in living cells to classify the type of motion 
%and to compair result fromsimulation to experimental result
%test brownian_2d simulate a two-dimensional brownian motion
%to compare 1. power spectrum density 2. MSD 
%+++++++ 03/29/07 +++++++++%
%+++ Good Luck +++%

%clear all

% N=10053;         % no. step to take
T=length(cc)/F           %maximum time
h=T/length(cc);          %time step
t1=(0:h:T); 
t1=t1';%
sigma=1.0;
%strength of noise
fs=F;

% x=zeros(size(t));   %place to store x location
% y=zeros(size(t));   %place to store y loaction
% 
% x(1)=0.0;           %initial x location
% y(1)=0.0;           %initial y location

% for i=1:N
%     x(i+1)=x(i)+sigma*sqrt(h)*randn;
%     y(i+1)=y(i)+sigma*sqrt(h)*randn;
% end

t=80;
px=cc;
py=cc;
px=px-mean(px)

%dt=0
k=700; % Number of Interval Time
m=100;   % Maximum interesting Frame
%@@@ Wanning m + k <= N @@@@
ACmeanxsquare=zeros(m,1);
ACmeanysquare=zeros(m,1);
h=waitbar (0,'Internal Calculation.........');
for dt = 1:m 
%     %dt=dt+1;
      diffxA = abs(px((1+dt):(k+dt))-px(1:k));
%      diffyA = py(1:k) - py((1+dt):(k+dt));
     ACxsquare = diffxA.^4;
     ACysquare = diffxA.^2;
     
%      
     ACmeanxsquare(dt) = mean(ACxsquare);
     ACmeanysquare(dt) = mean(ACysquare);
     
if dt==60
   gauss_parameter_modo(w)= mean(ACxsquare)./((mean(ACysquare)).^2); 
   d=dt;
    
end
waitbar (dt/length(1:m))
%      
 end;
 close (h)
 
% gauss_parameter= ACmeanxsquare./(ACmeanysquare.^2);
% figure (1)
% plot(1:m,gauss_parameter)
% close(h);