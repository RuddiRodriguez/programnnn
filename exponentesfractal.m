
function [alfa1]=exponentesfractal(m,cc)
%clear ;clc
% s1=2
% s2=5
% s3=1000


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
parameterStruct;

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

a = load(sprintf('%s/results/a.txt',working_directory_path));
b = load(sprintf('%s/results/b.txt',working_directory_path));
c = load(sprintf('%s/results/c.txt',working_directory_path));
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
mediafluct = load(sprintf('%s/results/mediafluct.txt',working_directory_path));
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
% % savedcontours=[4 5 6 7 8];
% tiempo1(q)=(parameterStruct.integration_time.*j);
% waitbar (j/length(savedcontours))
% end
% close(w)
% mediafluct=mediafluct';
% tiempo1=tiempo1';
% save(sprintf('%s/results/mediafluct.txt',working_directory_path),'mediafluct','-ascii');
% save(sprintf('%s/results/tiempo.txt',working_directory_path),'tiempo1','-ascii');



r0=r0(savedcontours);

% mkdir(sprintf('%s/correla',working_directory_path));
mkdir(sprintf('%s/complex',working_directory_path));

% m=s1:s2;
% g=length(m)
% parametrosfit=zeros(g,1);
% parametrosfitc=zeros(g,1);
% parametrosfita=zeros(g,1);
% q=zeros(g,1);
i=0;
d=0;

% for m=s1:s2
% m=25
%  cc=(c(m,savedcontours));
%  i=i+1;
%  q(i)=m./(mean(r0));

% ff=autocov(cc',4)
% h=acfplot(cc',14,s3);
I=[4:(length(cc)/10)]
[alpha, intervals, flucts] = fastdfa(cc')

% ftype=fittype('a*x+b');
%  [fresult,gof,output] =fit(log10(intervals), log10(flucts),ftype);
% % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
%   f=feval(fresult,log10(intervals));

coeffs    = polyfit(log10(intervals), log10(flucts), 1);
f=coeffs(1).*log10(intervals)+coeffs(2)  
  d=d+0.3;
 
 figure(1)
 hold on
%plot(xdata1,ydata1,'o')
alfa1=coeffs(1);
  %plot(xdata,ydata,'o',xdata,f,'k');
  plot(log10(intervals),log10(flucts),'o',log10(intervals),f,'k')
  title('flucts-Intervals Fourier ')
  ylabel('log F(n)')
  xlabel('log n')
  text(0.8,-1.3-d,texlabel(['slope=' num2str(coeffs(1))]))
  axis square
%    save(sprintf('%s/complex/flucts_points%i.txt',working_directory_path,m),'flucts','-ascii');
%    save(sprintf('%s/complex/intervals_points%i.txt',working_directory_path,m),'intervals','-ascii');
   %waitbar (m/length(1:length(s1:s2)))
     
% end

% I=3:s3;
% [alpha, intervals, flucts] = fastdfa(r0',I')
% 
% ftype=fittype('a6*x+b6','coefficients',{'a6','b6'});
%  [fresult,gof,output] =fit(log10(intervals), log10(flucts),ftype);
% % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
%   f=feval(fresult,log10(intervals));
%   
%   d=d+0.1;
%  
%  figure(2)
%  hold on
% %plot(xdata1,ydata1,'o')
% 
%   %plot(xdata,ydata,'o',xdata,f,'k');
%   plot(log10(intervals),log10(flucts),'o',log10(intervals),f,'k')
%   title('flucts-Intervals R ')
%   ylabel('log F(n)')
%   xlabel('log n')
%   text(0.8,-5-d,texlabel(['slope=' num2str(fresult.a6)]))
%   for m1=[300]
%   ccc=mediafluct(m1,1:length(savedcontours));
%   
% end
% %   
%   I=[8:(length(ccc)/10)];
% [alpha, intervals, flucts] = fastdfa(ccc',I')
% coeffs    = polyfit(log10(intervals), log10(flucts), 1);
% f=coeffs(1).*log10(intervals)+coeffs(2)  
%   d=d+0.3;
%  
%  figure(2)
%  hold on
% %plot(xdata1,ydata1,'o')
% 
%   %plot(xdata,ydata,'o',xdata,f,'k');
%   plot(log10(intervals),log10(flucts),'o',log10(intervals),f,'k')
%   title('flcuts-Intervals Fluctuations ')
%   ylabel('log F(n)')
%   xlabel('log n')
%   text(0.3,-1.3-d,texlabel(['slope=' num2str(coeffs(1))]))


% ftype=fittype('a6*x+b6','coefficients',{'a6','b6'});
%  [fresult,gof,output] =fit(log10(intervals), log10(flucts),ftype);
% % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
%   f=feval(fresult,log10(intervals));
%   
%   d=d+0.1;
%  
%  figure(3)
%  hold on
% %plot(xdata1,ydata1,'o')
% 
%   %plot(xdata,ydata,'o',xdata,f,'k');
%   plot(log10(intervals),log10(flucts),'o',log10(intervals),f,'k')
%   title('flucts-Intervals Pure Fluctuations ')
%   ylabel('log F(n)')
%   xlabel('log n')
%   text(0.8,-13.8,texlabel(['slope=' num2str(fresult.a6)]))
%   
% 
% 
