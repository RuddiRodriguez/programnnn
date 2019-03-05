 
 function [F,h,T]=correlationandfitfast(s1,s2,s3,s4,s5,s6,ini,fin)
%clear
% s1=2
% s2=2
% s3=100
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


dis=[s1:s2];

r0=r0(savedcontours);

mkdir(sprintf('%s/correla',working_directory_path));

variable = zeros (s3+1,length(dis)) 
m=s1:s2;
g=length(m);
parametrosfit=zeros(g,1);
parametrosfitc=zeros(g,1);
parametrosfita=zeros(g,1);
 parametrosfitexpo=zeros(g,1);
% q=zeros(g,1);
i=0;
f3=100
for m=s1:s2
% m=25
 cc=(c(m,savedcontours));
 i=i+1;
%  q(i)=m./(mean(r0));

% ff=autocov(cc',4)
% h=acfplot(cc',2000,s3);
if s5==0
cc=smooth(cc,3,'moving');
end
% 
if s5==1
cc=smooth(cc,1,'rloess');
end
%cc1=sgolayfilt(cc,2,11)
cc1=detrend(cc,'lineal',30);
figure (2345)
plot(cc)
figure(4567)
plot(cc1)

[h,T]=acfplot(cc1,s6,s3,m,s3,sprintf('modo%i',m));
%h=auto(cc,s3);
%acfplot(Y, Fs, maxlag,m,s3,titlestr)
%correlationandfitfast(2,12,4000,1,1,3000,[1 0.5 65],1,4000)
%correlationandfitfast(s1,s2,s3,s4,s5,s6,,ini,fin)
n=ini:fin;
ydata=h(n,1);
xdata=T(n,1);
variable(:,i)=h;

% assignin('base', 'seriefilter', cc1);

h=h;
save(sprintf('%s/correla/correlation%i.txt',working_directory_path,m),'h','-ascii');
save(sprintf('%s/correla/correlationtotal.txt',working_directory_path),'variable','-ascii');

% tf=fft(c)
assignin('base', 'tiempo', xdata);
assignin('base', sprintf('correlation%i',m), ydata);
assignin('base', 'serie', cc);

n=ini:fin;
tiempo=T;
%tiempo=(parameterStruct.integration_time*(0:s3))';
save(sprintf('%s/correla/tiempo.txt',working_directory_path),'tiempo','-ascii');

ydata=h(n,1);
xdata=tiempo(n,1);
% figure(1)
% plot(xdata,ydata);
% hold on;
% 
% hold off;
% s = fitoptions('Method','NonlinearLeastSquares',...
%                 'Startpoint',[1 0.6 0.003],'TolFun',10e-12,'Tolx',1e-12,'Algorithm',...
%                'Levenberg-Marquardt');
            
%    try         
%    %x0=[0.2,30,1,3]     
%    s = fitoptions('Method','NonlinearLeastSquares',...
%                'Startpoint',x0,'TolFun',10e-90,...
%                'Tolx',1e-90,'DiffMinChange',10e-1000000,'Algorithm',...
%                'Levenberg-Marquardt','MaxFunEvals',...
%                1000000000000,'MaxIter',100000000000000);         
% %     [x,fval,exitflag,output]=fminsearch(@myfunstret,x0,options)
% %            
% % teorica=(1-x(1)).*exp(-(x(2).*xdata).^x(3))+A.*exp(-x(4)*xdata);
% % res=ydata-teorica
% % F=0.5.*sum(Res.^2);         
%            
% ftype= fittype('(1-A)*exp(-(frecuencia1*x)^expo)+A*exp(-frecuencia2*x);')
% % 
% [fresult,gof,output] =fit(xdata,ydata,ftype,s)
%     f=feval(fresult,xdata);
%     parametrosfit(i)=fresult.frecuencia1;
%      parametrosfitc(i)=fresult.frecuencia2;
% %     parametrosfita(i)=fresult.amplitud;
% %      figure(1)
%     figure(234)  
%      semilogx(xdata,ydata,'-o',xdata,f,'-r','LineWidth',2);
%      title('Autocorrelation function (fourier)')
%      xlabel('Time (s)')
%      ylabel('G (u.a)')
%      hold on;
% 
% %try
% % s = fitoptions('Method','NonlinearLeastSquares',...
% %                'Startpoint',[1,0.667,30],'TolFun',10e-90,...
% %                'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
% %                'Levenberg-Marquardt','MaxFunEvals',...
% %                1000000000,'MaxIter',10000000000);         
%            
% % ftype1= fittype('amplitud*exp(-(frecuencia11*x)^e)');
% %  f3=f3+1
% % [fresult,gof,output] =fit(xdata,ydata,ftype1,s);
% %     f=feval(fresult,xdata);
% %     parametrosfit1(i)=fresult.frecuencia11;
%    parametrosfitexpo(i)=fresult.expo;
%      %parametrosfitc1(i)=fresult.frecuencia2;
% %     parametrosfita(i)=fresult.amplitud;
% % %      figure(1)
% %     figure(f3)  
% %      plot(xdata,ydata,'-o',xdata,f,'k');
% %      title('Autocorrelation function (fourier)')
% %      xlabel('Time (s)')
% %      ylabel('G (u.a)')
% % %      hold on;
%  catch exception
%     display('###################### An error occured! ######################')
%     display(getReport(exception));
%    
%     %save(camino,'tempp','-ascii'); % save the contour
% %    s = fitoptions('Method','NonlinearLeastSquares',...
% %                'Startpoint',[1,30,0],'TolFun',10e-90,...
% %                'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
% %                'Levenberg-Marquardt','MaxFunEvals',...
% %                1000000000,'MaxIter',10000000000);   
% keyboard
%    end
% %            
% % ftype1= fittype('amplitud*exp(-frecuencia11*x)+y0');
% %  f3=f3+1
% % [fresult,gof,output] =fit(xdata,ydata,ftype1,s);
% %     f=feval(fresult,xdata);
% %     parametrosfit1(i)=fresult.frecuencia11;
% %      %parametrosfitc1(i)=fresult.frecuencia2;
% % %     parametrosfita(i)=fresult.amplitud;
% % %      figure(1)
% %     figure(f3)  
% %      plot(xdata,ydata,'-o',xdata,f,'k');
% %      title('Autocorrelation function (fourier)')
% %      xlabel('Time (s)')
% %      ylabel('G (u.a)')
% % end 
% 
% 
% 
% 
% 
% 
% 
% 
%  end      
% %      ci = confint(fresult,0.95);
% %      errorfrecuencia=fresult.frecuencia-ci(1,3);
% %      erroramplitud=fresult.amplitud-ci(1,1);
% %      errorexponente=fresult.frecuencia2-ci(1,2);
%       
% %  figure(2)  
% % 
% %  subplot(2,1,1)
% % [YfreqDomain,frequencyRange] = positiveFFT(cc,parameterStruct.integration_time);
% % title('Power Spectrum (cc)')
% % loglog(frequencyRange,abs(YfreqDomain))
% % xlabel('Freq (Hz)')
% % ylabel('Amplitude')
% % hold on
% % subplot(2,1,2)
% % [YfreqDomain,frequencyRange] = positiveFFT(h,parameterStruct.integration_time);
% % title('Power Spectrum (h)')
% % loglog(frequencyRange,abs(YfreqDomain))
% % xlabel('Freq (Hz)')
% % ylabel('Amplitude')
% % q=m./(mean(r0));
% % % hold on
% % %      
% % %   
% % if (s4==1)
% %     fid = fopen(sprintf('%s/correla/parametrofit.txt',working_directory_path),'a+');
% %     fprintf(fid,'%6.9f\t  %6.9f\t  %6.9f\t  %6.9f\t  %6.9f\t  %6.9f\t  %6.9f\n',q,fresult.frecuencia,fresult.amplitud,fresult.frecuencia2,errorfrecuencia,erroramplitud,errorexponente)
% %     fclose(fid)
% % end
% % %      
% % %      
% %  end
% % % save(sprintf('%s/correla/parametrofit.txt',working_directory_path),'parametrosfit','-ascii');
% % % save(sprintf('%s/correla/parametrofitc.txt',working_directory_path),'parametrosfitc','-ascii');
% % % save(sprintf('%s/correla/parametrofita.txt',working_directory_path),'parametrosfita','-ascii');
% % % save(sprintf('%s/correla/tiempo.txt',working_directory_path),'tiempo','-ascii');
% % mean(r0)
% % fresult
% % output
% % gof;
% % ci;
% % ci(1,1)
% % % q = wavenumbers(n,1); % 
% % 
%  q=wavenr((s1:s2),1);
%  assignin('base', 'frecuencia', parametrosfit);
% assignin('base', 'frecuencia1', parametrosfitc);
% assignin('base', 'q', q);
% %assignin('base', 'frecuenciasingle', parametrosfit1');
% assignin('base', 'exponencial', parametrosfitexpo);
% 
% % %  q=(s1:s2)'
% % %   xdata1=q.^3;
% %  xdata1=q.^1;
% %  ydata1=parametrosfit;
% %  
% % %  tiempos=1./parametrosfit
% % %  parametrosfit
% %   ftype=fittype('power1');
% %  [fresult,gof,output] =fit(xdata1,ydata1,ftype);
% % % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
% %   f=feval(fresult,xdata1);
% %   figure(3)
% % %plot(xdata1,ydata1,'o')
% %   plot(xdata1,ydata1,'o',xdata1,f,'k');
% %   
% %   xdata2=log10(q);
% %  ydata2=log10(parametrosfit);
% %   
% %   ftype=fittype('a6*x+b6','coefficients',{'a6','b6'});
% %  [fresult1,gof,output] =fit(xdata2,ydata2,ftype);
% % % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
% %   f1=feval(fresult1,xdata2);
% %   
% %   
% %   figure(3)
% % %plot(xdata1,ydata1,'o')
% %   plot(xdata1,ydata1,'o',xdata1,f,'k');
% %   figure(4)
% %   plot(xdata2,ydata2,'o',xdata2,f1,'k');
% %   
% % %   kappa=fresult.a*4*0.001
% % %   fresult
% % %   gof
% %   %w=fresult.a
% % %   fid=fopen('C:/membrane_tracking_project/pendambiente.txt','a+');
% % %   fprintf(fid,'%6.3e\n',w);
% % % fclose(fid)
% % %tiempos=1./parametrosfit
% % 
% % b=0.166/(fresult.a*2);
% % b1=0.166/(fresult.a*8);
% % pendiente1=fresult.b;
% % % kappa=4*0.001*fresult.a;
% % % sigma=4*0.001*fresult.a;
% % 
% % expo=10^(fresult1.b6);
% % % sigma=4*0.001*expo;
% % b3=0.166/(expo*2);
% % b4=0.166/(expo*8);
% % pendiente=fresult1.a6;
% % msgbox(sprintf('b = %g \n b1 = %g \n pendiente1 = %g \n b3 = %g \n b4 = %g \n pendiente = %g \n',b,b1,pendiente1,b3,b4,pendiente),'Fitting Results','none','non-modal')
% % 
% % % hmediafluct=auto(mediafluct,length(mediafluct)-1);
% % % 
% % %  hmediafluct=hmediafluct';
% % %  
% % % save(sprintf('%s/correla/correlationmediafluct.txt',working_directory_path),'hmediafluct','-ascii');
% % % 
% % % n=1:s3;
% % % hmediafluct=hmediafluct(n,1);
% % % xdata=tiempo1(n,1);
% % % 
% % % figure (3)
% % % plot(tiempo1,mediafluct)
% % % title('Fluctuation')
% % % xlabel('Time (s)')
% % % ylabel('Fluctuation')
% % % 
% % % figure (4)
% % % plot(xdata',hmediafluct)
% % % title('Correlation function (pure fluctuations)')
% % % xlabel('Time (s)')
% % % ylabel('G (a.u)')
% % % 
% % % figure(5)
% % % 
% % % subplot(2,1,1)
% % % 
% % % [YfreqDomain,frequencyRange] = positiveFFT(mediafluct,parameterStruct.integration_time);
% % % loglog(frequencyRange,abs(YfreqDomain))
% % % title('Power Spectrum (pure fluctuation)')
% % % xlabel('Freq (Hz)')
% % % ylabel('Amplitude')
% % % 
% % % subplot(2,1,2)
% % % 
% % % [YfreqDomain,frequencyRange] = positiveFFT(hmediafluct,parameterStruct.integration_time);
% % % loglog(frequencyRange,abs(YfreqDomain))
% % % title('Power Spectrum (autocorrelation pure fluctuation)')
% % % xlabel('Freq (Hz)')
% % % ylabel('Amplitude')
% % assignin('base', 'frecuencias',parametrosfit);
% % 
% % assignin('base', 'wave', q);
% % % 
% % % p=5:length(r0);
% % % r01=r0(1,p)
% % % r01=smooth(r01,'moving')
% % % 
% % % hr0=auto(r01',length(r0)-1);
% % % 
% % % hr0=hr0';
% % % save(sprintf('%s/correla/correlationr0.txt',working_directory_path),'hr0','-ascii');
% % % 
% % % n=1:s3;
% % % hr0=hr0(n,1);
% % % xdata=tiempo(n,1);
% % % 
% % % 
% % % figure (6)
% % % plot(tiempo1,r0)
% % % title('R')
% % % xlabel('Time (s)')
% % % ylabel('R(m)')
% % % 
% % % figure (7)
% % % plot(xdata',hr0)
% % % title('Correlation function (R)')
% % % xlabel('Time (s)')
% % % ylabel('G (a.u)')
% % % 
% % % %transformada de fourier 
% % % 
% % % figure (8)  %create a new figure
% % % subplot(2,1,1)
% % % [YfreqDomain,frequencyRange] = positiveFFT(r0,parameterStruct.integration_time);
% % % loglog(frequencyRange,abs(YfreqDomain))
% % % title('Power Spectrum (R)')
% % % xlabel('Freq (Hz)')
% % % ylabel('Amplitude')
% % % hold on
% % % subplot(2,1,2)
% % % [YfreqDomain,frequencyRange] = positiveFFT(hr0,parameterStruct.integration_time);
% % % % Hpsd = dspdata.psd(hr0)
% % % % plot(Hpsd)
% % % loglog(frequencyRange,abs(YfreqDomain))
% % % title('Power Spectrum (autocorrelation R)')
% % % xlabel('Freq (Hz)')
% % % ylabel('Amplitude')
% % % hold on
% % % 
% % % 
% % % 
 end
% % % 
% % % 
% % % 
% % %    