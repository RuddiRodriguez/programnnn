 
function w=correlationandfit(s1,s2,s3)


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

a = load(sprintf('%s/results/shape/a.txt',working_directory_path));
b = load(sprintf('%s/results/shape/b.txt',working_directory_path));
c = load(sprintf('%s/results/shape/c.txt',working_directory_path));
wavenumbers = load(sprintf('%s/results/shape/wavenumbers.txt',working_directory_path));
fluctuations = load(sprintf('%s/results/shape/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/shape/r0.txt',working_directory_path));
%savedcontours=[4 5 6 7 8];
r0=r0(savedcontours);
wavenr = load(sprintf('%s/results/shape/wavenumbers.txt',working_directory_path));
mkdir(sprintf('%s/correla/shape',working_directory_path));
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
 vv=(a(m,savedcontours));
 cc=vv
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
h=auto(cc,350);
h=h';
save(sprintf('%s/correla/shape/correlation%i.txt',working_directory_path,m),'h','-ascii');



n=1:s3;
tiempo=(0.066*(0:350))';

save(sprintf('%s/correla/shape/tiempo.txt',working_directory_path),'tiempo','-ascii');

ydata=h(n,1);
xdata=tiempo(n,1);
figure(1)
plot(xdata,ydata);
hold on;

hold off;
ftype= fittype('a*exp(-(b*x)^(1))');

[fresult,gof,output] =fit(xdata,ydata,ftype);
    f=feval(fresult,xdata);
    parametrosfit(i)=fresult.b
%     parametrosfitc(m)=fresult.c
    parametrosfita(i)=fresult.a;
     figure(2)
     plot(xdata,ydata,'.',xdata,f,'k');
     hold on;
end
save(sprintf('%s/correla/parametrofit.txt',working_directory_path),'parametrosfit','-ascii');
% save(sprintf('%s/correla/parametrofitc.txt',working_directory_path),'parametrosfitc','-ascii');
save(sprintf('%s/correla/parametrofita.txt',working_directory_path),'parametrosfita','-ascii');
save(sprintf('%s/correla/tiempo.txt',working_directory_path),'tiempo','-ascii');
mean(r0)
 fresult
%  q = wavenumbers(n,1); % 

 q=wavenr((s1:s2),1)
%  q=(s1:s2)'
  xdata1=q.^3
 xdata2=q.^2
 ydata1=parametrosfit
 1/ydata1
 
  ftype=fittype('a*x+b');
  [fresult,gof,output] =fit(xdata2,ydata1,ftype);
 [fresult,gof,output] =fit(xdata1,ydata1,ftype);
 fresult
 f=feval(fresult,xdata2);
%   figure(3)
%   plot(xdata2,ydata1,'.',xdata2,f,'k');
%   kappa=fresult.a*4*0.001
%   fresult
%   gof
%   w=fresult.a
% %   fid=fopen('C:/membrane_tracking_project/pendambiente.txt','a+');
%   fprintf(fid,'%6.3e\n',w);
% fclose(fid)

ydata1=parametrosfit
 tiempo=1./parametrosfit
   