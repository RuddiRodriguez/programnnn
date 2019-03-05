% curve fit

clear all;

% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all');

% read working directory from config file 'working_directory_path.ini'
fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}), c{1});

% output of parameters
parameterStruct

% fitting parameters:
% x(1)=sigma
% x(2)=kappa


% ydata=load('/home/micha/praktikum_complutense/program/contours/fluctuations.txt');
% xdata=load('/home/micha/praktikum_complutense/program/contours/wavenumbers.txt');

ydata = load(sprintf('%s/fluctuations.txt',working_directory_path));
xdata = load(sprintf('%s/wavenumbers.txt',working_directory_path));

fluct = ydata;
wavenr = xdata;

xdata = transpose(xdata);
ydata = transpose(ydata);

% firstdatapoint = input('Enter the number of the first data point for the fit: ')
% lastdatapoint = input('Enter the number of the last data point for the fit: ')

% x0=[1*10^(-7);1*10^(-20)];
% 
% % x = lsqcurvefit(fluctuationfunction,x0,xdata,ydata);
% 
% x= lsqcurvefit(@fluctuationfunction,x0,xdata,ydata);

% fitting parameters:
% a=sigma
% b=kappa
% x=q_x; the wavenumbers

% k=1.38e-23;
% T=290;

% F = (k*T)/(2*sigma)*((1/x)-1/sqrt((sigma/kappa)+x^2));

% opts = fitoptions('StartPoint',[1e-7 1e-19]);
opts = fitoptions('method','NonlinearLeastSquares','StartPoint',[1e-7 1e-19],'TolFun',1e-25,'TolX',1e-25,'DiffMaxChange',1e-25);

fluct_function = fittype('((1.38e-23*290)/(2*a))*((1/x)-1/sqrt((a/b)+x^2))');
[fit_fluct_function,gof1] = fit(xdata(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint)',ydata(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint)',fluct_function,opts);

sigma = fit_fluct_function.a
kappa = fit_fluct_function.b
rsquare = gof1.rsquare

% 
% %opts=fitoptions('method','NonlinearLeastSquares','StartPoint',[- 0.5 30 0.1],'TolFun',1e-9,'TolX',1e-9,'DiffMaxChange',1e-3);   % Optional! There are more things that can be changed - look in matlab help. 
% 
% Weibull_Log_Acc=fittype('-a*(x-1)^b');
% 
% [fit_Weibull_Log_Acc,gof1,out1] = fit([startpoint:length_survival]',HISTOGRAM(survival).log_average(startpoint:end),Weibull_Log_Acc); %,opts);
% 
% a=fit_Weibull_Log_Acc.a; 
% b=fit_Weibull_Log_Acc.b;
% rsquare=gof1.rsquare;

% calculate the values of the fitting function for comparison

a = sigma;
b = kappa;

for i = parameterStruct.firstdatapoint : parameterStruct.lastdatapoint
    fitfunction(i) = ((1.38e-23*290)/(2*a))*((1/xdata(i))-1/sqrt((a/b)+xdata(i)^2));
end

semilogy(wavenr,fluct,'bo-');
hold on;
semilogy(wavenr(parameterStruct.firstdatapoint : parameterStruct.lastdatapoint),fitfunction(parameterStruct.firstdatapoint : parameterStruct.lastdatapoint),'r.-');
hold off;
