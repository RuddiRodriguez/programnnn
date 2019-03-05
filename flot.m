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
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
%savedcontours=[4 5 6];
r0=r0(savedcontours);
% 
 flucta = load(sprintf('%s/results/fluctuationsa.txt',working_directory_path));
fluct = load(sprintf('%s/results/fluctuations.txt',working_directory_path));

wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));

sigma2u=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
sigma2a=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
fluct=(fluct-sigma2u');
flucta = (flucta-sigma2a);


% fluct2=load(sprintf('%s/contours_new/fluctuations.txt',path));
% 
% wavenr2=load(sprintf('%s/contours_new/wavenumbers.txt',path));

figure(4)
semilogy(wavenr,fluct,'o-','MarkerEdgeColor','r', 'MarkerFaceColor','k')%,wavenr,sigma2u');
hold on;
figure(6)
semilogy(wavenr,flucta,'o-','MarkerEdgeColor','r', 'MarkerFaceColor','k')%,wavenr,sigma2u');
% hold on;
% hold on;
% semilogy(wavenr2,fluct2,'.-');
% hold off;