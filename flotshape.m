% this function plot the fluctuations

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



fluct = load(sprintf('%s/results/shape/fluctuations.txt',working_directory_path));

wavenr = load(sprintf('%s/results/shape/wavenumbers.txt',working_directory_path));

% fluct2=load(sprintf('%s/contours_new/fluctuations.txt',path));
% 
% wavenr2=load(sprintf('%s/contours_new/wavenumbers.txt',path));

figure(4)
semilogy(wavenr,fluct,'o-');
hold on;
% semilogy(wavenr2,fluct2,'.-');
hold off;