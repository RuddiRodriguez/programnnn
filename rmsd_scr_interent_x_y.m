fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all')


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s');
fclose('all');


% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});

% output of parameters


savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

% a = load(sprintf('%s/results/a.txt',working_directory_path));
% b = load(sprintf('%s/results/b.txt',working_directory_path));
%data = load(sprintf('%s/results/c.txt',working_directory_path));
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
% fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));

j=404
for j=[9]% 75 100 125 150 175 200 225 250 275 300 325 350 375 400]
data=load(sprintf('%s/correla/data%i.txt',working_directory_path,j));

kk=size(data)
%k=700        %maximum time
          %time step
t=data(1:kk(1),1);      %

x=zeros(size(t));   %place to store x location
y=zeros(size(t));   %place to store y loaction



px=data(1:kk(1),2);
py=data(1:kk(1),3);
save(sprintf('%s/correla/coordinatesmodes%i.txt',working_directory_path,j),'px','-ascii');  
save(sprintf('%s/correla/coordinatesmodes%i.txt',working_directory_path,j),'py','-ascii');  
k=1000; % Number of Interval Time
m=1000;   % Maximum interesting Frame
%@@@ Wanning m + k <= N @@@@
h=waitbar (0,'Internal Calculation.........')
for dt = 1:m  
    
     diffxA = px(1:k) - px((1+dt):(k+dt));
     diffyA = py(1:k) - py((1+dt):(k+dt));
     ACxsquare = diffxA.*diffxA;
     ACysquare = diffyA.*diffyA;
     ACrsquare = diffxA.*diffxA+ diffyA.*diffyA;
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
     if (dt==t)
         figure(m)
         normplot(diffxA)
         
     end
     test(dt)=lillietest(diffxA);
%      figure(45)
 %normplot(diffxA)
% hold on

%save(sprintf('%s/diff/diffx.txt',working_directory_path),'diffxA','-ascii');

 bins=log2(length(diffxA))+1
% bins=sqrt(length(diffxA))
[n,xout] = hist(diffxA,bins)
%  s = fitoptions('Method','NonlinearLeastSquares',...
%                'Startpoint',[5.719e-005 3.37e-007 -1.047e-008],'TolFun',10e-90,...
%                'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
%                'Levenberg-Marquardt','MaxFunEvals',...
%                1000000000,'MaxIter',10000000000);   
%            
%            s1 = fitoptions('Method','NonlinearLeastSquares',...
%                'Startpoint',[2 4 4],'TolFun',10e-90,...
%                'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
%                'Levenberg-Marquardt','MaxFunEvals',...
%                1000000000,'MaxIter',10000000000);   
           
%ftype= fittype('(A/(w*sqrt(3.14/2)))*exp(-2*((x-xc)/w)^2)');
% ftype= fittype(' a1*exp(-((x-b1)/c1)^2)');

% 
% xout=xout'
% n=n'
% % [fresult,gof,output] =fit(xout,n,ftype,s1);
% %     f=feval(fresult,xout);
%     
% figure(57)  
%      plot(xout,n,'-o');
%      title('Hist')
%      xlabel('Time (s)')
%      ylabel('G (u.a)')
 waitbar (dt/length(1:m))
% rmsd1(dt)=((fresult.w)/2)^2;
end;
close(h)
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
figure(1)
plot(px,py);
grid on
title('Brownain Motion Trajectory');
xlabel('x');
ylabel('y');
hold on
% figure(2)
% subplot(311);
% plot(log10(wx(10:pxN)),log10(Pxx(10:pxN)),'-*r');
% title({' ';'PowerSpectrum Density x,y,R positions'});
% xlabel('frequency');
% ylabel('P(x)');
% subplot(312);
% plot(log10(wy(5:pyN)),log10(Pyy(5:pyN)),'-*g');
% xlabel('frequency');
% ylabel('P(y)');
% subplot(313);
% plot(log10(wrs(5:prsN)),log10(Prs(5:prsN)),'-*b');
% xlabel('frequency');
% ylabel('P(R)');
figure(3)
loglog((StepTime(1:m)),(RMSD(1:m)),'-o')%,log10(StepTime(1:m)),log10(rmsd1(1:m)),'-o');
title('Mean Square Displacement of Brownain Motion');
xlabel('time step');
ylabel('MSD');
hold on

save(sprintf('%s/correla/RMSD%i.txt',working_directory_path,j),'RMSD','-ascii');
 figure(4)
% plot(midPx,'-*')
% xlabel('position');
% ylabel('population normalized');
end