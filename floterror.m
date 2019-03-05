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
sigma2u=load(sprintf('%s/results/errores.txt',working_directory_path));
flucta = load(sprintf('%s/results/fluctuationsa.txt',working_directory_path));

fluct = load(sprintf('%s/results/fluctuations.txt',working_directory_path));

wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));

 sigmcn=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
rmean=mean(r0);
sigmcn1=(sigmcn.*2)./(pi*(rmean.^3)); 
fluct1=(fluct-sigmcn');
fluctac=(flucta-sigmcn1');
sigma2ua=(sigma2u.*2)./(pi*(rmean.^3)); 
save(sprintf('%s/results/fluctcorregida.txt',working_directory_path));
save(sprintf('%s/results/erroresa.txt',working_directory_path),'sigma2ua','-ascii');
% fluct=fluct-sigma2u;
% % set region of xdata (predictor) and corresponding ydata (response)
% xdata = wavenr(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
% ydata = fluct(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);


% fluct2=load(sprintf('%s/contours_new/fluctuations.txt',path));
% 
% wavenr2=load(sprintf('%s/contours_new/wavenumbers.txt',path));
%hold on;
figure(12)
semilogy(wavenr,fluct1,'o-',wavenr,sigmcn,wavenr,fluct);
axis square
hold on
figure(16)
semilogy(1:50,fluctac,'o-',1:50,sigmcn1,1:50,flucta,'MarkerEdgeColor','b', 'MarkerFaceColor','g');
axis square
hold on;

% semilogy(wavenr2,fluct2,'.-');
 %hold off;