%The script modify to study dynamics system in living cells to classify the type of motion 
%and to compair result fromsimulation to experimental result
%test brownian_2d simulate a two-dimensional brownian motion
%to compare 1. power spectrum density 2. MSD 
%+++++++ 03/29/07 +++++++++%
%+++ Good Luck +++%

% clear all

N=14552;         % no. step to take
T=3.82;           %maximum time
h=T/N;          %time step
t=(0:h:T);      %
sigma=0.93;      %strength of noise

% x=zeros(size(t));   %place to store x location
% y=zeros(size(t));   %place to store y loaction
% 
% x(1)=0.0;           %initial x location
% y(1)=0.0;           %initial y location

% for i=1:N
%     x(i+1)=sigma*x(i)+randn;
%     y(i+1)=sigma*y(i)+randn;
% end



%     Nx = N;  % number of samples to synthesize
% B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
% A = [1 -2.494956002   2.017265875  -0.522189400];
% nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.
% v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
% x = filter(B,A,v);    % Apply 1/F roll-off to PSD
% x = x(nT60+1:end);    % Skip transient response
% y = x(nT60+1:end);



px=x;
py=y;

k=100;  % Number of Interval Time
m=50;   % Maximum interesting Frame
%@@@ Wanning m + k <= N @@@@
for dt = 1:m  
     diffxA = px(1:k) - px((1+dt):(k+dt));
     diffyA = py(1:k) - py((1+dt):(k+dt));
     ACxsquare = diffxA.*diffxA;
     ACysquare = diffyA.*diffyA;
     ACrsquare = diffxA.*diffxA + diffyA.*diffyA;
     ACmeanxsquare(dt) = mean(ACxsquare);
     ACmeanysquare(dt) = mean(ACysquare);
     ACmeanrsquare(dt) = mean(ACrsquare);
     RMSACx(1:k,dt)  = sqrt(ACxsquare);
     RMSACy(1:k,dt)  = sqrt(ACysquare);
     RMSAC(1:k,dt)   = sqrt(ACrsquare);
     ACvxsquare = (1/(m*m)).*(diffxA.*diffxA);
     ACvysquare = (1/(m*m)).*(diffyA.*diffyA);
     ACvsquare  = (1/(m*m)).*(diffxA.*diffxA + diffyA.*diffyA);
     ACmeanvxsquare(dt) = mean(ACvxsquare);
     ACmeanvysquare(dt) = mean(ACvysquare);
     ACmeanvsquare(dt)  = mean(ACvsquare);
     pv=sqrt(ACrsquare);
     Vel(dt)=pv(1).*pv(dt);
     AvgVel=mean(Vel);
end; 
 aa1 = 1:m;
 StepTime = aa1';
 Tcutoff = 1./StepTime;
 xMSD = ACmeanxsquare';XMSD=xMSD;
 yMSD = ACmeanysquare';YMSD=yMSD;
 RMSD = ACmeanrsquare';
 %---------- Velocity -------%
 XVel = ACmeanvxsquare';
 YVel = ACmeanvysquare';
 RVel = ACmeanvsquare';
 %XYRVelocity=[StepTime,XVel,YVel,RVel];
 %---------------------------%
     prx  = sqrt(ACxsquare);
     pry  = sqrt(ACysquare);
     prr  = sqrt(ACrsquare);
     prs  = sqrt(px.*px + py.*py);


% Find Waiting Time - PDF by FFT
    fftpr = abs(fft(prr)); wfftpr = 1:k;
   Lfftpr = log10(fftpr); Lwfftpr = log10(wfftpr)';
   
% Find Waiting Time - PDF by pwelch-Function
 [Pxx,wx] = pwelch(px);
 [Pyy,wy] = pwelch(py);
 [Prx,wrx]  = pwelch(prx);
 [Pry,wry]  = pwelch(pry);
 [Pr,wr]  = pwelch(prr);
 [Prs,wrs]  = pwelch(prs);
%-----------Histogram------------%
[midpx,npx]=hist(px);
[midpy,npy]=hist(py);
maxPx=max(max(midpx));
midPx=midpx/maxPx;
maxPy=max(max(midpy));
midPy=midpy/maxPy;
[pxN wxN]=size(Pxx);
[pyN wyN]=size(Pyy);
[prsN wrsN]=size(Prs);
%--------------Graph-------------%
figure(133)
plot(px,py);
grid on
title('Brownain Motion Trajectory');
xlabel('x');
ylabel('y');
figure(233)
subplot(311);
plot(log10(wx(10:pxN)),log10(Pxx(10:pxN)),'-*r');
title({' ';'PowerSpectrum Density x,y,R positions'});
xlabel('frequency');
ylabel('P(x)');
subplot(312);
plot(log10(wy(5:pyN)),log10(Pyy(5:pyN)),'-*g');
xlabel('frequency');
ylabel('P(y)');
subplot(313);
plot(log10(wrs(5:prsN)),log10(Prs(5:prsN)),'-*b');
xlabel('frequency');
ylabel('P(R)');
figure(444)
plot(log10(StepTime(1:50)),log10(RMSD(1:50)),'-*');
title('Mean Square Displacement of Brownain Motion');
xlabel('time step');
ylabel('MSD');
figure(333)
plot(midPx,'-*')
xlabel('position');
ylabel('population normalized');

% cc=sqrt((px.^2)+(py.^2));
% cc=MIX(N,1)
% exponentesfractal(2,cc)
%  H = genhurst(cc,3)
%  H1= wfbmesti(cc)
%  r=0.15
%  [entropies] = MSE(cc,20,r,2);
% 
% figure(1000)
% hold on
% n = 1:20;
% plot(n,entropies,'-o')
% ylabel('Sample Entropy')
% xlabel('Scale factor')
% title('Entropy Fourier')
% I=[8:(length(c)/10)]
% [alpha, intervals, flucts] = fastdfa(c',I')
% 
% d=0
% coeffs    = polyfit(log10(intervals), log10(flucts), 1);
% f=coeffs(1).*log10(intervals)+coeffs(2)  
%   d=d+0.3;
%  
%   figure(2)
%  hold on
% %plot(xdata1,ydata1,'o')
% 
%   %plot(xdata,ydata,'o',xdata,f,'k');
%   plot(log10(intervals),log10(flucts),'o',log10(intervals),f,'k')
%   title('flcuts-Intervals Fluctuations ')
%   ylabel('log F(n)')
%   xlabel('log n')
%   text(1,100,texlabel(['slope=' num2str(coeffs(1))]))