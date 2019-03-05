 
 %function w=correlationandfit(s1,s2,s3)

s1=2
s2=2
s3=120
fid = fopen('config/program_directory_path.ini','rt')
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all')


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});

% output of parameters
parameterStruct

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

a = load(sprintf('%s/results/a.txt',working_directory_path));
b = load(sprintf('%s/results/b.txt',working_directory_path));
c = load(sprintf('%s/results/c.txt',working_directory_path));
wavenumbers = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
%savedcontours=[4 5 6 7 8];
r0=r0(savedcontours);
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
mkdir(sprintf('%s/correla',working_directory_path));
% c=(c(m,savedcontours))
% termino1=zeros(2,(length(c)-1))
% termino1=zeros(2,(length(c)-1))
% termino1=zeros(2,(length(c)-1))
s=15
m=s1:s2;
g=length(m)
 parametrosfit=zeros(g,1);
  parametrosfitc=zeros(g,1);
   parametrosfita=zeros(g,1);
 q=zeros(g,1)
 i=0
for m=s1:s2
% m=25
 vv=(c(m,savedcontours));
 cc=vv
 cc=smooth(cc,'moving')
 i=i+1
 q(i)=m./(mean(r0))
%  N=length(cc);
%  endlag=350
% %now solve for autocorrelation for time lags from zero to endlag
% % n=0:endlag;
% % a=zeros(1,n);
% for lag=0:endlag
%   data1=cc(1:N-lag);
%   data1=data1-mean(data1);
%   data2=cc(1+lag:N);
%    data2=data2-mean(data2);
%   a(lag+1) = sum(data1.*data2);%/sqrt(sum(data1.^2).*sum(data2.^2));
%   tiempo(lag+1)=lag*0.066;
%   clear data1
%   clear data2
% end
%h=autocorr(cc',s3,200,1)
% h= acfplot(cc',14,s3);
  h=auto(cc,s3);
 h=h';
save(sprintf('%s/correla/correlation%i.txt',working_directory_path,m),'h','-ascii');



n=1:s3+1;
n=n';

tiempo=(parameterStruct.integration_time*(0:s3))';
save(sprintf('%s/correla/tiempo.txt',working_directory_path),'tiempo','-ascii');

 ydata=h(n,1);
 
xdata=tiempo(n,1);
% options = optimset('TolFun',1e-20);
% %options.MaxFunEvals = 10000;
% % options.TolFun = 1e-4;
% options.Tolx=1e-1000;
% options.TolFun=1e-99;
% options.MaxFunEvals=1e99;
% 
% 
%  options.LargeScale='off' ;
% options.MaxIter=1000000000000;
% options.Diagnostics='on'
% options.Display='notify';

Res=@(x)0.5.*(sum((ydata-x(1).*exp((-x(2).*xdata).^x(3))).^2));

 %F=0.5.*sum(Res.^2);

% figure(1)
% plot(xdata,ydata);
% hold on;
 x0=[1,1,0.66];
 [x,fval,exitflag,output]=fminsearch(Res,x0)
 
 fun=x(1).*exp((-x(2).*xdata).^x(3));
 figure(1)
 plot(xdata,ydata,'o',xdata,fun)
% hold off;
% ftype= fittype('amplitud*exp(-(frecuencia*x))');
% %ftype= fittype('amplitud*exp(-frecuencia*x)+(1-amplitud)*exp(-frecuencia1*x)');
% 
% [fresult,gof,output] =fit(xdata,ydata,ftype);
%     f=feval(fresult,xdata);
%     parametrosfit(i)=fresult.frecuencia
% %     parametrosfitc(m)=fresult.c
%     parametrosfita(i)=fresult.amplitud;
%      figure(2)
%      plot(xdata,ydata,'-o',xdata,f,'k');
%      hold on;


end
% save(sprintf('%s/correla/parametrofit.txt',working_directory_path),'parametrosfit','-ascii');
% % save(sprintf('%s/correla/parametrofitc.txt',working_directory_path),'parametrosfitc','-ascii');
% save(sprintf('%s/correla/parametrofita.txt',working_directory_path),'parametrosfita','-ascii');
% save(sprintf('%s/correla/tiempo.txt',working_directory_path),'tiempo','-ascii');
% mean(r0)
%  fresult
%  q = wavenumbers(n,1); % 

%  q=wavenr((s1:s2),1)
% %  q=(s1:s2)'
%   xdata1=q.^3
%  xdata1=q.^1
%  ydata1=parametrosfit
%  ydata2=parametrosfita
 
%   tiempos=1./parametrosfit
%   parametrosfit
%   ftype=fittype('power1');
%  [fresult,gof,output] =fit(xdata1,ydata1,ftype)
% % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
%   f=feval(fresult,xdata1);
%   figure(3)
%plot(xdata1,ydata1,'o')
%   plot(xdata1,ydata1,'o',xdata1,f,'k');
  
%   xdata2=log10(q)
%  ydata2=log10(parametrosfit)
  x0=[2.24e-7 3.57e-20 0.04 1e8 1 3.33e-9];
% %   ftype=fittype('a6*x+b6','coefficients',{'a6','b6'});
%   [x,fval,exitflag,output]=fminsearch(@myfun2,x0)
%   
% %  [fresult1,gof,output] =fit(xdata2,ydata2,ftype)
% % % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
% %   f1=feval(fresult1,xdata2);
%   
%   
%   figure(3)
% %plot(xdata1,ydata1,'o')
%   plot(xdata1,ydata1,'o',xdata1,f,'k');
%   figure(4)
%   plot(xdata2,ydata2,'o',xdata2,f1,'k');
%   
% %   kappa=fresult.a*4*0.001
% %   fresult
% %   gof
%   %w=fresult.a
% %   fid=fopen('C:/membrane_tracking_project/pendambiente.txt','a+');
% %   fprintf(fid,'%6.3e\n',w);
% % fclose(fid)
% %tiempos=1./parametrosfit
% 
% b=0.115/(fresult.a*2)
% b1=0.115/(fresult.a*8)
% pendiente1=fresult.b
% kappa=4*0.001*fresult.a
% omega=(4*0.001)*fresult.a;
% mu=(omega^2)/(298.65*1.38e-23)
% 
% expo=10^(fresult1.b6);
% b3=0.115/(expo*2)
% b4=0.115/(expo*8)
% pendiente=fresult1.a6
% 
% omega1=(4*0.001)*expo;
% mu1=(omega1^2)/(298.65*1.38e-23)
% msgbox(sprintf('b = %g \n b1 = %g \n mu = %g \n pendiente1 = %g \n b3 = %g \n b4 = %g \n mu1 = %g \n pendiente = %g \n',b,b1,mu,pendiente1,b3,b4,mu1,pendiente),'Fitting Results','none','non-modal')
% 
% 
%  
%    