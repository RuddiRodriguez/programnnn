%function h=correlationandfit(s1,s2,s3,s5)
%clear
s1=2
s2=2
s3=4000
s5=1
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
c = load(sprintf('%s/results/c.txt',working_directory_path));
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
% fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
% sigmaR2=load(sprintf('%s/results/sigmar2.txt',working_directory_path));

% j=0
% q=0
% mediafluct=zeros(1,length(savedcontours));
% tiempo=zeros(1,length(savedcontours));
% w = waitbar(0,'Please wait...');
% for j = savedcontours
%     q=q+1;
% mempospol = load(sprintf('%s/memposs/mempos%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates
% n=1:length(mempospol);
% fluctpura=mempospol(n,1);
% 
% mediafluct(q)=(sum((fluctpura).^2))/(length(fluctpura));%(mean(((fluctpura)).^2))-((mean((fluctpura))).^2);    %mean(fluctpura)%  (sum((fluctpura).^2))/(length(fluctpura))
% %savedcontours=[4 5 6 7 8];
% tiempo1(q)=(parameterStruct.integration_time.*j);
% waitbar (j/length(savedcontours))
% end
% close(w)
% mediafluct=mediafluct;
% mediafluct=smooth(mediafluct,'moving')

% tiempo1=tiempo1';
% save(sprintf('%s/results/mediafluct.txt',working_directory_path),'mediafluct','-ascii');
% save(sprintf('%s/results/tiempo.txt',working_directory_path),'tiempo1','-ascii');



r0=r0(savedcontours);

mkdir(sprintf('%s/correla',working_directory_path));


m=s1:s2;
g=length(m);
parametrosfit=zeros(g,1);
parametrosfitc=zeros(g,1);
parametrosfita=zeros(g,1);
% q=zeros(g,1);
i=0;

for m=s1:s2
% m=25
 cc=(c(m,savedcontours));
 i=i+1;
%  q(i)=m./(mean(r0));

% ff=autocov(cc',4)
% h=acfplot(cc',500,s3);
if s5==0
cc=smooth(cc,'moving');
end

if s5==1
cc=smooth(cc,'rloess');
end
% cc= randn(1000, 1);
h=auto(cc',s3);
 hh=autocorr(cc,s3)
h=h';
save(sprintf('%s/correla/correlation%i.txt',working_directory_path,m),'h','-ascii');

% tf=fft(c)

n=2:s3;

tiempo=(parameterStruct.integration_time*(0:s3))';
save(sprintf('%s/correla/tiempo.txt',working_directory_path),'tiempo','-ascii');

ydata=h(n,1);
xdata=tiempo(n,1);
% figure(1)
% plot(xdata,ydata);
% hold on;
% 
% hold off;
% s = fitoptions('Method','NonlinearLeastSquares',...
%                'Lower',[0,0,0],...
%                'Upper',[2,Inf,Inf],...
%                'Startpoint',[1,1,1],'TolFun',10e-90,...
%                'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
%                'Levenberg-Marquardt','MaxFunEvals',...
%                10000,'MaxIter',10000);
           
 s = fitoptions('Method','NonlinearLeastSquares',...
               'Startpoint',[1,1],'TolFun',10e-90,...
               'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
               'Levenberg-Marquardt','MaxFunEvals',...
               10000,'MaxIter',10000);
                     
           
ftype= fittype('amplitud*exp(-frecuencia*x)');

[fresult,gof,output] =fit(xdata,ydata,ftype,s);
    f=feval(fresult,xdata);
    parametrosfit(i)=fresult.frecuencia;
%     parametrosfitc(i)=fresult.frecuencia1;
     parametrosfita(i)=fresult.amplitud;
     figure(1)
     residual=ydata-f;
     plot(xdata,ydata,'-o',xdata,f,'k');
     title('Autocorrelation function (fourier)')
     xlabel('Time (s)')
     ylabel('G (u.a)')
     hold on;
     
%      ci = confint(fresult,0.95);
%      errorfrecuencia=fresult.frecuencia-ci(1,2);
%      erroramplitud=fresult.amplitud-ci(1,1);
%       errorexponente=fresult.ex-ci(1,2);
%       
%  figure(2)  
% 
%  subplot(2,1,1)
% [YfreqDomain,frequencyRange] = positiveFFT(cc,parameterStruct.integration_time);
% title('Power Spectrum (cc)')
% loglog(frequencyRange,abs(YfreqDomain))
% xlabel('Freq (Hz)')
% ylabel('Amplitude')
% hold on
% subplot(2,1,2)
% [YfreqDomain,frequencyRange] = positiveFFT(h,parameterStruct.integration_time);
% title('Power Spectrum (h)')
% loglog(frequencyRange,abs(YfreqDomain))
% xlabel('Freq (Hz)')
% ylabel('Amplitude')
q=m./(mean(r0));
% hold on
%      
%   
% if (s4==1)
%     fid = fopen(sprintf('%s/correla/parametrofit.txt',working_directory_path),'a+');
%     fprintf(fid,'%6.9f\t  %6.9f\t  %6.9f\t  %6.9f\t  %6.9f\t  %6.9f\t  %6.9f\n',q,fresult.frecuencia,fresult.amplitud,fresult.ex,errorfrecuencia,erroramplitud,errorexponente)
%     fclose(fid)
% end
% %      
%      
 end
% save(sprintf('%s/correla/parametrofit.txt',working_directory_path),'parametrosfit','-ascii');
% save(sprintf('%s/correla/parametrofitc.txt',working_directory_path),'parametrosfitc','-ascii');
% save(sprintf('%s/correla/parametrofita.txt',working_directory_path),'parametrosfita','-ascii');
% save(sprintf('%s/correla/tiempo.txt',working_directory_path),'tiempo','-ascii');
mean(r0);
fresult
output;
gof;
% ci;
% ci(1,1);
% q = wavenumbers(n,1); % 

 q=wavenr((s1:s2),1);
%  q=(s1:s2)'
%   xdata1=q.^3;
 xdata1=q.^1;
 ydata1=parametrosfit;
%  yadata4=parametrosfitc
 D=parametrosfit./(q.^2);
%  tiempos=1./parametrosfit
%  parametrosfit
%   ftype=fittype('power1');
%  [fresult,gof,output] =fit(xdata1,ydata1,ftype);
% % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
%   f=feval(fresult,xdata1);
%   figure(3)
% %plot(xdata1,ydata1,'o')
%   plot(xdata1,ydata1,'o',xdata1,f,'k');
  
  xdata2=log10(q);
 ydata2=log10(parametrosfit);
%  ydata4=log10(parametrosfitc);
  
  ftype=fittype('a6*x+b6','coefficients',{'a6','b6'});
 [fresult1,gof,output] =fit(xdata2,ydata2,ftype);
% [fresult,gof,output] =fit(xdata1,ydata1,ftype);
  f1=feval(fresult1,xdata2);
  
  
 % figure(3)
%plot(xdata1,ydata1,'o')
%  plot(xdata1,ydata1,'o',xdata1,f,'k');
  figure(3)
  plot(xdata2,ydata2,'o',xdata2,f1,'k');
  
%   ftype=fittype('a6*x+b6','coefficients',{'a6','b6'});
%  [fresult4,gof,output] =fit(xdata2,ydata4,ftype);
% % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
%   f4=feval(fresult4,xdata2);
  assignin('base', 'frecuencias',parametrosfit);

assignin('base', 'wave', q);
% assignin('base', 'frecuencias1',parametrosfitc );

%   figure (5)
%    plot(xdata1,ydata4,'o',xdata1,f,'k');
%    figure(4)
%   plot(xdata2,ydata4,'o',xdata2,f4,'k');
%   
%   kappa=fresult.a*4*0.001
%   fresult
%   gof
  %w=fresult.a
%   fid=fopen('C:/membrane_tracking_project/pendambiente.txt','a+');
%   fprintf(fid,'%6.3e\n',w);
% fclose(fid)
%tiempos=1./parametrosfit

% b=0.166/(fresult.a*2);
% b1=0.166/(fresult.a*8);
% pendiente1=fresult.b;
% % kappa=4*0.001*fresult.a;
% % sigma=4*0.001*fresult.a;
% 
% expo=10^(fresult1.b6);
%   sigma=4*0.001*expo
% b3=0.166/(expo*2);
% b4=0.166/(expo*8);
% pendiente=fresult1.a6;
% msgbox(sprintf('sigma = %g \n b1 = %g \n pendiente1 = %g \n b3 = %g \n b4 = %g \n pendiente = %g \n',sigma,b1,pendiente1,b3,b4,pendiente),'Fitting Results','none','non-modal');
% D=expo
% hmediafluct=auto(mediafluct,length(mediafluct)-1);
% 
%  hmediafluct=hmediafluct';
%  
% save(sprintf('%s/correla/correlationmediafluct.txt',working_directory_path),'hmediafluct','-ascii');
% 
% n=1:s3;
% hmediafluct=hmediafluct(n,1);
% xdata=tiempo1(n,1);
% 
% figure (3)
% plot(tiempo1,mediafluct)
% title('Fluctuation')
% xlabel('Time (s)')
% ylabel('Fluctuation')
% 
% figure (4)
% plot(xdata',hmediafluct)
% title('Correlation function (pure fluctuations)')
% xlabel('Time (s)')
% ylabel('G (a.u)')
% 
% figure(5)
% 
% subplot(2,1,1)
% 
% [YfreqDomain,frequencyRange] = positiveFFT(mediafluct,parameterStruct.integration_time);
% loglog(frequencyRange,abs(YfreqDomain))
% title('Power Spectrum (pure fluctuation)')
% xlabel('Freq (Hz)')
% ylabel('Amplitude')
% 
% subplot(2,1,2)
% 
% [YfreqDomain,frequencyRange] = positiveFFT(hmediafluct,parameterStruct.integration_time);
% loglog(frequencyRange,abs(YfreqDomain))
% title('Power Spectrum (autocorrelation pure fluctuation)')
% xlabel('Freq (Hz)')
% ylabel('Amplitude')
% 
% 
% 
% 
% 
% 
% p=5:length(r0);
% r01=r0(1,p)
% r01=smooth(r01,'moving')
% 
% hr0=auto(r01',length(r0)-1);
% 
% hr0=hr0';
% save(sprintf('%s/correla/correlationr0.txt',working_directory_path),'hr0','-ascii');
% 
% n=1:s3;
% hr0=hr0(n,1);
% xdata=tiempo(n,1);
% 
% 
% figure (6)
% plot(tiempo1,r0)
% title('R')
% xlabel('Time (s)')
% ylabel('R(m)')
% 
% figure (7)
% plot(xdata',hr0)
% title('Correlation function (R)')
% xlabel('Time (s)')
% ylabel('G (a.u)')
% 
% %transformada de fourier 
% 
% figure (8)  %create a new figure
% subplot(2,1,1)
% [YfreqDomain,frequencyRange] = positiveFFT(r0,parameterStruct.integration_time);
% loglog(frequencyRange,abs(YfreqDomain))
% title('Power Spectrum (R)')
% xlabel('Freq (Hz)')
% ylabel('Amplitude')
% hold on
% subplot(2,1,2)
% [YfreqDomain,frequencyRange] = positiveFFT(hr0,parameterStruct.integration_time);
% % Hpsd = dspdata.psd(hr0)
% % plot(Hpsd)
% loglog(frequencyRange,abs(YfreqDomain))
% title('Power Spectrum (autocorrelation R)')
% xlabel('Freq (Hz)')
% ylabel('Amplitude')
% hold on
% 
% 
% 
%  end
% 
% 
% 
%    