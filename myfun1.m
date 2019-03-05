function F = myfun1(x1,x2,x3,x4,x5,x6)



% % this function plot the fluctuations
% function f=fitfriction(s1,s2,s3)
% clear all;

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

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}), c{1});

% output of parameters
parameterStruct;

% n = 6:26;
% sigma = 1e-07;
% kappa = 1e-20;

% PARAMETERS
% temperature = 304.15;
% integration_time = 1/15;
% scalefactor_sigma = 1e-07;
% scalefactor_kappa = 1e-20;
% TolX = 1e-50;
% TolFun =1e-50;
% first_plot_point = 1;
% last_plot_point = 25;
% MaxFunEvals = 2000;
% MaxIter = 2000;
parameterStruct.firstdatapoint;
parameterStruct.lastdatapoint;

% load data of spectrum7
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path)); % 
fluct = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
sigma2u=load(sprintf('%s/results/errores.txt',working_directory_path));
sigmcn=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
temperature=parameterStruct.temperature;
integration_time=parameterStruct.integration_time;
fluct=(fluct-sigmcn');
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));


rmean=mean(r0);
r0=mean(r0);
%fluct=fluct-sigma2u;
% set region of xdata (predictor) and corresponding ydata (response)
xdata = wavenr(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
ydata = fluct(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
F = (2.4652e-028.*temperature./pi./integration_time.^2.*xdata.^3./(1.0695.*(x1).*xdata.^2+1.1438.*(x2).*xdata.^4).^3.*((258.5372.*(x1).*xdata.^2+276.4963.*(x2).*xdata.^4).*integration_time./xdata+exp((- 258.5372.*(x1).*xdata.^2-276.4963.*(x2).*xdata.^4).*integration_time./xdata)-1)+5.2798e-028.*temperature./pi./integration_time.^2.*xdata.^3./(2.9977.*(x1).*xdata.^2+8.9863.*(x2).*xdata.^4).^3.*((432.8473.*(x1).*xdata.^2+1.2975e+003.*(x2).*xdata.^4).*integration_time./xdata+exp((-432.8473.*(x1).*xdata.^2-1.2975e+003.*(x2).*xdata.^4).*integration_time./xdata)-1)+4.6751e-028.*temperature./pi./integration_time.^2.*xdata.^3./(13.9343.*(x1).*xdata.^2+194.1641.*(x2).*xdata.^4).^3.*((933.2162.*(x1).*xdata.^2+1.3004e+004.*(x2).*xdata.^4).*integration_time./xdata+exp((-933.2162.*(x1).*xdata.^2-1.3004e+004.*(x2).*xdata.^4).*integration_time./xdata)-1)+ 8.1711e-029.*temperature./pi./integration_time.^2.*xdata.^3./(51.2087.*(x1).*xdata.^2+2.6223e+003.*(x2).*xdata.^4).^3.*((1.7890e+003.*(x1).*xdata.^2+ 9.1613e+004.*(x2).*xdata.^4).*integration_time./xdata+exp((-1.7890e+003.*(x1).*xdata.^2-9.1613e+004.*(x2).*xdata.^4).*integration_time./xdata)-1)+1.6601e-030.*temperature./pi./integration_time.^2.*xdata.^3./(160.7898.*(x1).*xdata.^2+2.5853e+004.*(x2).*xdata.^4).^3.*((3.1701e+003.*(x1).*xdata.^2+5.0972e+005.*(x2).*xdata.^4).*integration_time./xdata+exp((-3.1701e+003.*(x1).*xdata.^2-5.0972e+005.*(x2).*xdata.^4).*integration_time./xdata)-1)+( 2.7418e-122.*rmean.*temperature.*(x5).*(x4).*(3.0268e+099.*integration_time.*(x3).*xdata.^2+2.5774e+099.*exp(-1.0695.*integration_time./(x5)./(x4).*(x3).*xdata.^2).*(x5).*(x4)-2.6669e+099.*(x5).*(x4)+8.9423e+097.*exp(-2.9977.*integration_time./(x5)./(x4).*(x3).*xdata.^2).*(x5).*(x4)+1.6960e+095.*exp(-13.9343.*integration_time./(x5)./(x4).*(x3).*xdata.^2).*(x5).*(x4)+1.6252e+092.*exp(-51.2087.*integration_time./(x5)./(x4).*(x3).*xdata.^2).*(x5).*(x4)+3.3969e+088.*exp(-160.7898.*integration_time./(x5)./(x4).*(x3).*xdata.^2).*(x5).*(x4))./pi./x6./integration_time.^2./(x3).^3./xdata.^5));

% figure(11)
% semilogy(xdata,F,wavenr,fluct,'o');
% ylabel('Amplitud')
% xlabel('modo')
% h = legend('Fit_S_H','Experimental Amplitude',1);
% set(h,'Interpreter','none')
% text(20,1e-6,sprintf('kappa=%2.3e\n sigmaR=%2.3e\n CE=%2.3e',x(1),x(2),x(3)))