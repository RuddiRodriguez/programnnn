% sig = [0 1 -2 1 0 1 -2 1 0];
% figure (1)% signal with no linear trend
% plot(sig)
% trend = [0 1 2 3 4 3 2 1 0];      % two-segment linear trend
% x = sig+trend;
% figure (2) 
% plot(x)
% % signal with added trend
% y = detrend(x,'linear',10)         % breakpoint at 5th element
% figure (3)
% 
% plot(y)
%clear;
[filename,pathname] = uigetfile('*.txt','Select the data-file');
a=fullfile(pathname, filename)
%data=load(sprintf('%s/%s.txt',pathname,filename)); 
data=load(a)
p=size(data);
xc=zeros(p(1),1);
yc=zeros(p(1),1);



for i=1:p(1)
    q=0;
xarray=zeros(p(2),1);
yarray=zeros(p(2),1);
    for l=2:2:(p(2)-1)
q=q+1;
    
%  if mod(l,2)==0;
yarray(q)=data(i,l+1)
xarray(q)=data(i,l)
% end

% % if mod(l,2)~0;
% % yarray(q)=data(i,l+2);
% % xarray(q)=data(i,l+1);
% 

% end   
    end
%     xarray=xarray-mean(xarray);
%     yarray=yarray-mean(yarray);
    xc(i)=sum(xarray)./length(xarray);
    yc(i)=sum(yarray)./length(xarray);
    
    
end
for j=2:2:(p(2)-1)
    

time=zeros(p(1),1);
x=zeros(p(1),1);
y=zeros(p(1),1);
% if mod(j,2)==0;
y(:)=data(1:p(1),j+1)
x(:)=data(1:p(1),j)
% end

% if mod(j,2)~0;
% y(:)=data(1:p(1),j)
% x(:)=data(1:p(1),j+1)
% end


time(:)=data(1:p(1),1)
% x=x-mean(x);
% y=y-mean(y);
px=x-xc;
py=y-yc;
 px = detrend(px,'linear',40)
 py = detrend(py,'linear',40)
 

figure(500)
subplot(2,2,1)
plot(time,x)%,time,xc,'o')
 subplot(2,2,2)
plot(time,y)%time,yc,'o')
subplot(2,2,3)
plot(time,px)
subplot(2,2,4)
 plot(time,py)
 %The script modify to study dynamics system in living cells to classify the type of motion 
%and to compair result fromsimulation to experimental result
%test brownian_2d simulate a two-dimensional brownian motion
%to compare 1. power spectrum density 2. MSD 
%+++++++ 03/29/07 +++++++++%
%+++ Good Luck +++%

%clear all

% N=10053;         % no. step to take
% T=length(cc)/F           %maximum time
% h=T/length(cc);          %time step
% t1=(0:h:T); 
% t1=t1';%
% sigma=1.0;
% %strength of noise
 fs=14;

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
% px=cc%(1:5000);
% py=cc%(1:5000);
%px=px-mean(px)
% bins=sqrt(length(px));
%  [n,xout] = hist(px,bins);
%  
%        potencial=-log((n./max(n)));
%        figure (70)
%       plot((xout),(potencial),'.-r')
%       hold on
%        figure(58)  
%       plot(xout,(n./max(n)),'-o')%,xout,f,'k');
%       title('Hist')
%       xlabel('<x> (m)')
%       ylabel('F (u.a)')
%       hold on
%       
%       axis square
% pxx=aa;
% pyy=bb;
%dt=0
k=160; % Number of Interval Time
m=50;   % Maximum interesting Frame
%@@@ Wanning m + k <= N @@@@
%h=waitbar (0,'Internal Calculation.........');
for dt = 1:m 
    %dt=dt+1;
     diffxA = px(1:k) - px((1+dt):(k+dt));
     diffyA = py(1:k) - py((1+dt):(k+dt));
     ACxsquare = diffxA.*diffxA;
     ACysquare = diffyA.*diffyA;
     ACrsquare = diffxA.*diffxA+diffyA.*diffyA;
     ACmeanxsquare(dt) = mean(ACxsquare);
     ACmeanysquare(dt) = mean(ACysquare);
     ACmeanrsquare(dt) = mean(ACrsquare);
     RMSACx(1:k,dt)  = sqrt(ACxsquare);
     RMSACy(1:k,dt)  = sqrt(ACysquare);
     RMSAC(1:k,dt)   = sqrt(ACrsquare);
     ACvxsquare = (1/(m*m)).*(diffxA.*diffxA);
     ACvysquare = (1/(m*m)).*(diffyA.*diffyA);
     ACvsquare  = (1/(m*m)).*(diffxA.*diffxA)+ (diffyA.*diffyA);
     ACmeanvxsquare(dt) = mean(ACvxsquare);
     ACmeanvysquare(dt) = mean(ACvysquare);
     ACmeanvsquare(dt)  = mean(ACvsquare);
     pv=sqrt(ACrsquare);
     Vel(dt)=pv(1).*pv(dt);
     AvgVel=mean(Vel);
%       if (dt==4)
%           figure(45)
%         normplot(diffxA)
%         axis square
%         hold on
%       end
% %          
% %      end
%      test(dt)=lillietest(diffxA);
%      testtemp=lillietest(diffxA);
% %      figure(45)
% 
% % hold on
% 
% %save(sprintf('%s/diff/diffx.txt',working_directory_path),'diffxA','-ascii');
% % if (testtemp==1)
% %      figure(56)
% %          normplot(diffxA)
% % bins=log2(length(diffxA))+1
 bins=sqrt(length(diffxA));
 [n,xout] = hist(diffxA,bins);
%  potencial=zeros(length(n),1);
%        potencial=-log((n./max(n)));
%  variable =zeros(length(n),2);
%  
% %            %s = fitoptions('Method','NonlinearLeastSquares',...
% %                'Startpoint',[5.719e-005 3.37e-007 -1.047e-008],'TolFun',10e-90,...
% %                'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
% %                'Levenberg-Marquardt','MaxFunEvals',...
% %                1000000000,'MaxIter',10000000000);   
% %            
% %            s1 = fitoptions('Method','NonlinearLeastSquares',...
% %                'Startpoint',[2 4 4],'TolFun',10e-90,...
% %                'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
% %                'Levenberg-Marquardt','MaxFunEvals',...
% %                1000000000,'MaxIter',10000000000);   
% %            
% % ftype= fittype('(A/(w*sqrt(3.14/2)))*exp(-2*((x-xc)/w)^2)');
% %  ftype= fittype(' a1*exp(-((x-b1)/c1)^2)');
% % 
% % % 
% %  xout=xout'
% %  n=n'
% % [fresult,gof,output] =fit(xout,n,ftype,s1)
% %     f=feval(fresult,xout);
%     
%  figure(57)  
%       plot(xout,n,'-o')%,xout,f,'k');
%       title('Hist')
%       xlabel('<x> (m)')
%       ylabel('F (u.a)')
%       variable(:,1)=xout;
%       variable(:,2)=n;
%       axis square
%       %hold on
% save(sprintf('%s/results/hist%i_%i.txt',working_directory_path,dt,m1),'variable','-ascii');      
% %save(sprintf('%s/results/ajustet%i_%i.txt',working_directory_path,dt,m1),'f','-ascii'); 
% % end
%  waitbar (dt/length(1:m))
% %  rmsd1(dt)=((fresult.w)/2)^2;
 end;
% 
% figure (69)
% plot(test,'o')
% 
% close(h)
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
     prs  = sqrt(px.*px );%+ py.*py);


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
 [Pxxx,f] = pwelch(px,[],[],[],fs);
%-----------Histogram------------%
[midpx,npx]=hist(px);
[midpy,npy]=hist(py);
maxPx=max(max(midpx));
midPx=midpx/maxPx;
maxPy=max(max(midpy));
midPy=midpy/maxPy;
[pxN wxN]=size(Pxx);
[pyN wyN]=size(Pyy);
 [prsN wrsN]=size(Pxxx);
%--------------Graph-------------%
figure(111)
plot(px,py,xc,yc,'o');
grid on
title('Brownain Motion Trajectory');
xlabel('x');
ylabel('y');
hold on
% figure(141)
% plot(t1(1:(length(t1)-1)),px);
% grid on
% title('Temporal Trace');
% xlabel('Time');
% ylabel('px');
% hold on
figure(122)
% % subplot(311);
% % plot(log10(wx(10:pxN)),log10(Pxx(10:pxN)),'-*r');
% % title({' ';'PowerSpectrum Density x,y,R positions'});
% % xlabel('frequency');
% % ylabel('P(x)');
% % subplot(312);
% % plot(log10(wy(5:pyN)),log10(Pyy(5:pyN)),'-*g');
% % xlabel('frequency');
% % ylabel('P(y)');
% % subplot(313);
Pxxx=smooth(Pxxx);
plot(log10(f(1:prsN)),log10(Pxxx(1:prsN)),'-*b');
xlabel('frequency');
ylabel('P(R)');
% hold on;
figure(113)
plot(log10(StepTime(1:m)),log10(RMSD(1:m)),'-*')%,(StepTime(1:m)),(rmsd1(1:m)),'-o');
title('Mean Square Displacement of Brownain Motion');
xlabel('time step');
ylabel('MSD');
hold on
figure(144)
%  save(sprintf('%s/results/rmsd_modos%i.txt',working_directory_path,m1),'RMSD','-ascii');
%  save(sprintf('%s/results/Step_modos%i.txt',working_directory_path,m1),'t1','-ascii');
% [pks,locs] = findpeaks(Pxxx)
%  save(sprintf('%s/results_modos/xtrayectoria_modos%i.txt',working_directory_path,m1),'pxx','-ascii');
%  save(sprintf('%s/results_modos/ytrayectoria_modos%i.txt',working_directory_path,m1),'pyy','-ascii');
%  save(sprintf('%s/results_modos/wrs_modos%i.txt',working_directory_path,m1),'f','-ascii');
%  save(sprintf('%s/results_modos/Prs_modos%i.txt',working_directory_path,m1),'Pxxx','-ascii');
 %save(sprintf('%s/complex/potencial_distri_modo%i.txt',working_directory_path,m1),'potencial','-ascii');
%   I=[4:(length(cc)/10)];
%  [alpha, intervals, flucts] = fastdfa(cc);
%     save(sprintf('%s/complex/flucts_modos%i.txt',working_directory_path,m1),'flucts','-ascii');
%     save(sprintf('%s/complex/intervals_modos%i.txt',working_directory_path,m1),'intervals','-ascii');
%  H = genhurst(cc,3);
%  H1= wfbmesti(cc);
%   r=((std(cc))*20)./100;
%  [entropies] = MSE(cc,100,r,2);
%  entropies=entropies';
%   save(sprintf('%s/complex/entropias_modos%i.txt',working_directory_path,m1),'entropies','-ascii');
% 
% figure(1000)
% hold on
% n = [1:100];
% plot(n,entropies,'-g')
% ylabel('Sample Entropy')
% xlabel('Scale factor')
% title('Entropy Fourier')
% %  
% % %  exponentesfractal(2,3,2,mediafluct)
% % % figure(4)
% % % plot(midPx,'-*')
% % % xlabel('position');
% % % ylabel('population normalized');
end
