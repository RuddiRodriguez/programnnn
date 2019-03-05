%The script modify to study dynamics system in living cells to classify the type of motion 
%and to compair result fromsimulation to experimental result
%test brownian_2d simulate a two-dimensional brownian motion
%to compare 1. power spectrum density 2. MSD 
%+++++++ 03/29/07 +++++++++%
%+++ Good Luck +++%

%clear all
mkdir(sprintf('%s/complex',working_directory_path));
T=length(cc)/F           %maximum time
h=T/length(cc);          %time step
t1=(0:h:T); 
t1=t1';%
sigma=1.0;
%strength of noise
fs=F;     %strength of noise

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
px=cc;%(1:4000);
py=cc;
 %px=px-(mean(px));
 px=detrend(px,'linear',40)
% bins=sqrt(length(px));
%  [n,xout] = hist(px,bins);
%  figure(57)  
%       plot(xout./1e-9,(n./max(n)),'-r')%,xout,f,'k');
%       title('Hist')
%       xlabel('<x> (m)')
%       ylabel('F (u.a)')
%       
%       axis square
%       hold on
%       potencial=-log((n./max(n)));
%       figure (58)
%       plot((xout./1e-9),(potencial),'.-g')
%       hold on
%dt=0
k=3000; % Number of Interval Time
m=1000;   % Maximum interesting Frame
%@@@ Wanning m + k <= N @@@@
h=waitbar (0,'Internal Calculation.........');
for dt = 1:m 
    %dt=dt+1;
     diffxA = px(1:k) - px((1+dt):(k+dt));
     diffyA = py(1:k) - py((1+dt):(k+dt));
     ACxsquare = diffxA.*diffxA;
     ACysquare = diffyA.*diffyA;
     ACrsquare = diffxA.*diffxA;% + diffyA.*diffyA;
     ACmeanxsquare(dt) = mean(ACxsquare);
     ACmeanysquare(dt) = mean(ACysquare);
     ACmeanrsquare(dt) = mean(ACrsquare);
     RMSACx(1:k,dt)  = sqrt(ACxsquare);
     RMSACy(1:k,dt)  = sqrt(ACysquare);
     RMSAC(1:k,dt)   = sqrt(ACrsquare);
     ACvxsquare = (1/(m*m)).*(diffxA.*diffxA);
     ACvysquare = (1/(m*m)).*(diffyA.*diffyA);
     ACvsquare  = (1/(m*m)).*(diffxA.*diffxA);% + (diffyA.*diffyA);
     ACmeanvxsquare(dt) = mean(ACvxsquare);
     ACmeanvysquare(dt) = mean(ACvysquare);
     ACmeanvsquare(dt)  = mean(ACvsquare);
     pv=sqrt(ACrsquare);
     Vel(dt)=pv(1).*pv(dt);
     AvgVel=mean(Vel);
% %       if (dt==4)
% %           figure(45)
% %         normplot(diffxA)
% %         axis square
% %         hold on
% %       end
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
bins=log2(length(diffxA))+1;
 bins=sqrt(length(diffxA));
 [n,xout] = hist(diffxA,bins);
 variable =zeros(length(n),2);
% % 
% bins=log2(length(diffxA))+1
%  bins=sqrt(length(diffxA));
%  [n,xout] = hist(diffxA,bins);
%  variable =zeros(length(n),2);
% % 
  if (dt==4)
       n=smooth(n);
       potencial=zeros(length(n),1);
       potencial=-log((n./max(n)));
       %potencial=smooth(potencial);
      
       
       filename=sprintf('%s/results_puntos/tiempo4/FigurePote%i%i',working_directory_path,dt,m1);
       filename1=sprintf('%s/results_puntos/tiempo4/FigureDistri%i%i',working_directory_path,dt,m1);
       figure (2)
      plot((xout./1e-9),(potencial),'.-g');
      text(-50,3,sprintf('Point=%2.3e\n ',m1));
      print ('-f2', '-dtiff ',filename);
      
      figure (3)
      
      semilogy((xout./1e-9),(n./max(n)),'.-r');
      text(-20,0.5,sprintf('Point=%2.3e\n ',m1));

      print ('-f3', '-dtiff ',filename1);
     
      
  end
%  
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
%  figure(61)  
%       semilogy((xout./1e-9),n,'-o')%,xout,f,'k');
%       title('Hist')
%       xlabel('<x> (um)')
%       ylabel('F (u.a)')

      variable(:,1)=xout;
      variable(:,2)=n;
%       axis square
%       
 save(sprintf('%s/results_puntos/hist%i_%i.txt',working_directory_path,dt,m1),'variable','-ascii');      
% %save(sprintf('%s/results/ajustet%i_%i.txt',working_directory_path,dt,m1),'f','-ascii'); 
% % end
  waitbar (dt/length(1:m))
%  for k=1:length
     
% %  rmsd1(dt)=((fresult.w)/2)^2;
 end;
% 
% 
% % figure (68)
% % plot(test,'o')
% 
 close(h)
 aa1 = 1:m;
 StepTime = aa1';
 Tcutoff = 1./StepTime;
 xMSD = ACmeanxsquare';XMSD=xMSD;
 yMSD = ACmeanysquare';YMSD=yMSD;
 RMSD = ACmeanrsquare';
%  %---------- Velocity -------%
 XVel = ACmeanvxsquare';
 YVel = ACmeanvysquare';
 RVel = ACmeanvsquare';
 XYRVelocity=[StepTime,XVel,YVel,RVel];
%  %---------------------------%
%      prx  = sqrt(ACxsquare);
%      pry  = sqrt(ACysquare);
%      prr  = sqrt(ACrsquare);
%      prs  = sqrt(px.*px );%+ py.*py);
% 
% 
% % Find Waiting Time - PDF by FFT
%     fftpr = abs(fft(prr)); wfftpr = 1:k;
%    Lfftpr = log10(fftpr); Lwfftpr = log10(wfftpr)';
%    
% % Find Waiting Time - PDF by pwelch-Function
%  [Pxx,wx] = pwelch(px);
%  [Pyy,wy] = pwelch(py);
%  [Prx,wrx]  = pwelch(prx);
%  [Pry,wry]  = pwelch(pry);
%  [Pr,wr]  = pwelch(prr);
%  [Prs,wrs]  = pwelch(prs);
   [Pxx,f] = pwelch(px,[],[],[],fs);
% % 
% % %-----------Histogram------------%
% % [midpx,npx]=hist(px);
% % [midpy,npy]=hist(py);
% % maxPx=max(max(midpx));
% % midPx=midpx/maxPx;
% % maxPy=max(max(midpy));
% % midPy=midpy/maxPy;
% %[pxN wxN]=size(Pxx);
% %[pyN wyN]=size(Pyy);
 [prsN wrsN]=size(Pxx);
% % %--------------Graph-------------%
% %  figure(111)
% % plot((px./1e-9),'-r');
% % grid on
% % title('Brownain Motion Trajectory');
% % xlabel('x');
% % ylabel('y');
% % axis square
% % hold on
%   % figure(112);
% % % subplot(311);
% % % plot(log10(wx(10:pxN)),log10(Pxx(10:pxN)),'-*r');
% % % title({' ';'PowerSpectrum Density x,y,R positions'});
% % % xlabel('frequency');
% % % ylabel('P(x)');
% % % subplot(312);
% % % plot(log10(wy(5:pyN)),log10(Pyy(5:pyN)),'-*g');
% % % xlabel('frequency');
% % % ylabel('P(y)');
% % % subplot(313);
% Pxx=smooth(Pxx);
% plot(log10(f(1:prsN)),log10(Pxx(1:prsN)),'-b');
% xlabel('frequency');
% ylabel('P(R)');
% axis square
% hold on;
%   figure(113);
% plot((StepTime(1:m)),(RMSD(1:m)),'-o')%,(StepTime(1:m)),(rmsd1(1:m)),'-o');
% title('Mean Square Displacement of Brownain Motion');
% xlabel('time step');
% ylabel('MSD');
% axis square
% hold on
%potencial=potencial';
px=px';
 save(sprintf('%s/results/rmsd%i.txt',working_directory_path,m1),'RMSD','-ascii');
 save(sprintf('%s/results_puntos/Step%i.txt',working_directory_path,m1),'t1','-ascii');
%  save(sprintf('%s/results_puntos/xtrayectoria%i.txt',working_directory_path,m1),'px','-ascii');
%  save(sprintf('%s/results_puntos/ytrayectoria%i.txt',working_directory_path,m1),'py','-ascii');
  save(sprintf('%s/results_puntos/wrs%i.txt',working_directory_path,m1),'f','-ascii');
  save(sprintf('%s/results_puntos/Prs%i.txt',working_directory_path,m1),'Pxx','-ascii');
 %save(sprintf('%s/results_puntos/potencial_distri%i.txt',working_directory_path,m1),'potencial','-ascii');
 %PSD=zeros(length(Pxx,length(point)))
 %exponentesfractal(2,cc);
 %I=[8:30:(length(cc)/10)]
%  I=[4:(length(cc)/10)];
% [alpha, intervals, flucts] = fastdfa(cc',I');
%     save(sprintf('%s/complex/flucts_points%i.txt',working_directory_path,m1),'flucts','-ascii');
%     save(sprintf('%s/complex/intervals_points%i.txt',working_directory_path,m1),'intervals','-ascii');
%  H = genhurst(cc,3);
%  H1= wfbmesti(cc);
%   r=((std(px))*20)./100;
%  [entropies] = MSE(px,50,r,2);
%  entropies=entropies';
%   save(sprintf('%s/complex/entropias%i.txt',working_directory_path,m1),'entropies','-ascii');

% figure(1000)
% hold on
% n = [1:30];
% plot(n,entropies,'-b')
% ylabel('Sample Entropy')
% xlabel('Scale factor')
% title('Entropy Fourier')
% 
% % axis square
%alpha
 
%  exponentesfractal(2,3,2,mediafluct)
% figure(4)
% plot(midPx,'-*')
% xlabel('position');
% ylabel('population normalized');
% StepTime=t1(2:m);
% RMSD=RMSD(2:m)
% L = size (StepTime, 1)
% 
% 
% OmegaVector = zeros (1, L);
% LnRMSD = zeros (1, L);
% LnTau = zeros (1, L);
% GlobalFit = zeros (1, L); 
% Alpha = zeros (1, L);
% GammaApp = zeros (1, L);
% Denominator = zeros (1, L);
% Gstar = zeros (1,L); Gstar_Record = zeros (2,L);
% GpMason = zeros (1, L); 
% GppMason = zeros (1, L); 
% Gstar_Record =zeros (1, L);
% Gp_Record =zeros (1, L);
% Gpp_Record =zeros (1, L);
% % 'Matrices initialized.'
% 
% %%% Now from RMSD(tau) to G*(omega)
% OmegaVector =1 ./ StepTime; % from large (left) to small (right) Omega
% kB = 1.3806503e-23; % Boltzmann constant in m2 kg s-2 K-1
% T = 298; % Temperature in absolute degrees
% Radius = 0.44e-5; % Bead radius in meters                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
% Factor = kB * T / (pi * Radius);
% 
% LnRMSD (1,:) = log (RMSD(:,1)); % in m^2.
% LnTau (1,:) = log (StepTime(:,1));
% % Below, I've replaced GammaPiece by GammaApp, the approximation of the
% % gamma function presented in Mason, Rheol Acta (2000), # 3-8.
% n = 5;
% PolyGlobalFit = polyfit (LnTau, LnRMSD, n);
% GlobalFit = polyval (PolyGlobalFit, LnTau);
% % 'RMSD fitted.'
% 
% if(1) 
%    figure(3)
%    loglog(StepTime, RMSD.*1e18,'o-');
%    xlabel('\tau'); ylabel('RMSD [nm^2]'); title('RMSD');
% end
% 
% for k = 1 : n
%     Alpha (1,:) = Alpha(1,:) + k * PolyGlobalFit (1, n + 1 - k) .* LnTau (1,:) .^ (k-1);
% end
% % 'Alpha computed.' % from small Tau = large Omega (left) to large Tau (right).
% 
% figure(4)
% semilogx( OmegaVector(:,1), Alpha(1,:),'o-'  )
% xlabel('\omega'); ylabel('\alpha'); title('\alpha vs \omega');
% RMSD=RMSD';
% GammaApp (1,:) = 0.457 .* (1 + Alpha(1,:)).^2 - 1.36 .* (1 + Alpha(1,:)) + 1.90;
% Denominator (1,:) = RMSD (1,:) .* GammaApp(1,:) .* 1i.^(-Alpha(1,:));
% 
% Gstar (1,:) = Factor ./ Denominator (1,:);
% GpMason (1,:) = abs (Gstar(1,:)) .* cos ((pi/2) .* Alpha(1,:));
% GppMason (1,:) = abs (Gstar(1,:)) .* sin ((pi/2) .* Alpha(1,:));
% % Gp = real(Gstar) and Gpp = imag (Gstar) return the same results
% OmegaVector=OmegaVector';
% % Record it all now :)
% Gstar_Record (1,:) = OmegaVector (1,:); Gstar_Record (2,:) = abs(Gstar (1,:));
% Gp_Record (1,:) = OmegaVector (1,:); Gp_Record (2,:) = GpMason (1,:);
% Gpp_Record (1,:) = OmegaVector (1,:); Gpp_Record (2,:) = GppMason (1,:);
% 
% 
% 'G*, Gp, Gpp saved'
% 
% figure(1)
% loglog(OmegaVector, GpMason, 'o')
% title(' Storage Modulus G prime,Loss Modulus G double prime ');
% xlabel('\omega'); ylabel('pascals');
% hold on
% % figure(2)
% loglog(OmegaVector, GppMason, '+')
% % title(' Loss Modulus G double prime ');
% % xlabel('\omega'); ylabel('pascals');
% % figure(3)
% % loglog(OmegaVector,Gstar)
% % hold off
% figure (356)
% Gstar_Record=Gstar_Record';
% Gp_Record=Gp_Record';
% Gpp_Record=Gpp_Record';
% save(sprintf('%s/results_puntos_response/G%i.txt',working_directory_path,m1),'Gstar_Record','-ascii');
% save(sprintf('%s/results_puntos_response/G_prima%i.txt',working_directory_path,m1),'Gp_Record','-ascii');
% save(sprintf('%s/results_puntos_response/G_2prima%i.txt',working_directory_path,m1),'Gpp_Record','-ascii');
% 
% 
% 
% 
% 
% 
