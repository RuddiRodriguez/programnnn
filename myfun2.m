function F = myfun2(x)
% this function plot the fluctuations

%clear all;

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






Res=ydata-x(1)*exp(-x(2)*xdata)

 F=0.5.*sum(Res.^2);