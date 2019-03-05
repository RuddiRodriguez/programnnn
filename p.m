function temporal_autoco=tem_point_auto(F,mediafluct,savedcontours,lag)%,x0,lb,ub)
fid1=fopen('resultsdesv.txt','w+');
% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all');

% read working directory from config file 'working_directory_path.ini'
fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s');
fclose('all');

% paramters:
% nmax = 100; % maximal index of the coefficients of the fouriertransformation to be calculated
% maxc = 1; % maximum value permited for the coefficients c(n); if a contour give larger value, it will be deleted
% resolution = 14e-8; %0.0000001; % this parameter gives the resolution of the microscope (meters per pixel)

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});

% output of parameters
parameterStruct;

% max = load(sprintf('%s/results/max.txt',working_directory_path));
% min = load(sprintf('%s/results/min.txt',working_directory_path));
% % this sets the index of 'deletedcontourscounter' so that deleted contours
% % will be add to the vector 'deletedcontours'
% 
% first=max-40;
% last=min+100;

i=0;
p=0;
tiempo=zeros(length(savedcontours),1);
for j = savedcontours
    p=p+1;
    tiempo(p)=( (1/F).*j);
end
mediafluct1=mediafluct';
maxvector=[6];
minvector=[200]
for gg1=[minvector]
g1=1:length(savedcontours);
i=i+1;
u2=mediafluct1(g1,gg1);
correlation=autocorr(u2,lag);
step=tiempo(1:lag+1,1);
n=4:length(correlation);
ydata=correlation(n,1);
xdata=step(n,1);
% m=maxvector(i)
% figure(1)
% x=[gg1/1000 1 gg1/1000]
% d=num2str(maxvector);
plot(tiempo(1:lag+1,1),correlation,'o','MarkerEdgeColor','k','MarkerFaceColor','w')
hold on
% options=optimset('TolFun',1e-19 ,'TolX',1e-19,'MaxFunEvals',50000000,'MaxIter',100000000000000000,'DiffMinChange',1e-54,'DiffMaxChange',0.4);
% [x,resnorm,residual,exitflag,output] = lsqcurvefit(@myfun_lsq,x0,xdata,ydata,lb,ub,options);
% teorica=(1-x(1)).*exp(-(x(2).*xdata).^x(3))+x(1).*exp(-x(4)*xdata)+0;
%  semilogx(xdata,teorica,'-r',xdata,ydata,'o','LineWidth',2,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
%      %semilogx(xdata,ydata,'-o',xdata,teorica,'-k');
%      title('Autocorrelation function (fourier)')
%      xlabel('Time (s)')
%      ylabel('G (u.a)')
%      text(0.002,0.5,sprintf('Amplitud=%2.3e\n Frecuencia1=%2.3e\n Beta=%2.3e\n Frecuencia2=%2.3e',x(1),x(2),x(3),x(4)))

end



i=0;
for gg1=[minvector]
g1=1:length(savedcontours);
i=i+1;
u2=mediafluct1(g1,gg1);
correlation=autocorr(u2,lag);
step=tiempo(1:lag+1,1);
n=4:length(correlation);
ydata=correlation(n,1);
xdata=step(n,1);
m=minvector(i)
figure(1)
x=[gg1/1000 1 gg1/1000]
plot(tiempo(1:lag+1,1),correlation,'s','MarkerEdgeColor','r','MarkerFaceColor','w')
hold on
save(sprintf('%s/correla/pointcorrelation%i.txt',working_directory_path,gg1),'correlation','-ascii')
% options=optimset('TolFun',1e-19 ,'TolX',1e-19,'MaxFunEvals',50000000,'MaxIter',100000000000000000,'DiffMinChange',1e-54,'DiffMaxChange',0.4);
% [x,resnorm,residual,exitflag,output] = lsqcurvefit(@myfun_lsq,x0,xdata,ydata,lb,ub,options);
% teorica=(1-x(1)).*exp(-(x(2).*xdata).^x(3))+x(1).*exp(-x(4)*xdata)+0;
%  semilogx(xdata,teorica,'-r',xdata,ydata,'o','LineWidth',2,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
%      %semilogx(xdata,ydata,'-o',xdata,teorica,'-k');
%      title('Autocorrelation function (fourier)')
%      xlabel('Time (s)')
%      ylabel('G (u.a)')
%      text(0.002,0.5,sprintf('Amplitud=%2.3e\n Frecuencia1=%2.3e\n Beta=%2.3e\n Frecuencia2=%2.3e',x(1),x(2),x(3),x(4)))

end
