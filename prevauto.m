 clc
clear


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
mkdir(sprintf('%s/correla',working_directory_path));
% c=(c(m,savedcontours))
% termino1=zeros(2,(length(c)-1))
% termino1=zeros(2,(length(c)-1))
% termino1=zeros(2,(length(c)-1))
 parametrosfit=zeros(20,1);
for m=1:40
% m=25
 vv=(c(m,savedcontours));
 cc=vv
 
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
save(sprintf('%s/correla/correlation%i.txt',working_directory_path,m),'h','-ascii');
n=1:2;
tiempo=(0.066*(0:350))';
ydata=h(n,1);
xdata=tiempo(n,1);
figure(1)
plot(xdata,ydata);
hold on;

hold off;
ftype= fittype('a*exp((-x/b))');

[fresult,gof,output] =fit(xdata,ydata,ftype);
    f=feval(fresult,xdata);
    parametrosfit(m)=fresult.b
     figure(2)
     plot(xdata,ydata,'.',xdata,f,'k');
     hold on;
end
 