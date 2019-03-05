% this program takes the tracked position of the membrane saved by the 
% 'testcontourprogram.m' program and evaluates them 

clear all;
fid1=fopen('resultsdesv.txt','w+')
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
parameterStruct
mkdir(sprintf('%s/memposs',working_directory_path));
q=0
% variables:
% L:    this variable holds the length of the circumference of the vesicle
% memposlength: this variable hold the length of the mempos vector of the
%               vesicles
% ds:   this vector holds the distances between the membrane points along the
%       membrane
% sumds: this vector is the pairwise sum of the vector ds (i.e.: ds(i) + ds(i + 1));
%        it is used to calculate the center coordinates (x_c,y_c)
% center: this vector holds the coordinates of the center; i.e.: center = (x_c,y_c)





% PARAMETERS:
% loads file containing the indexes of the saved and deleted contours
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
deletedcontours = load(sprintf('%s/results/deletedcontours.txt',working_directory_path));

% this sets the index of 'deletedcontourscounter' so that deleted contours
% will be add to the vector 'deletedcontours'
deletedcontourscounter = length(deletedcontours);


% wavenumbers = zeros(1,parameterStruct.nmax); % vector holding the wavenumbers
% h=waitbar (0,'Please wait.........')
q=0;
N=length(savedcontours);         % no. step to take
          %maximum time
h=7500/N;          %time step
t=h.*(0:length(savedcontours)-1);
%mempos = cell(length(savedcontours),1);
i=0;
xc=0;
yc=0;
for j = savedcontours(1:end-10)
% load contour
i=i+1;
p=0;
xymempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j));
[ center ] = length_center( xymempos )
figure(1) ; 
 plot (xymempos (:,1),xymempos(:,2))  ; hold on   
plot(round(center(1)),round(center(2)),'bo');hold on ;
xc(i)= center(1);
yc(i)= center(2);



end
% distt=0;
% k=0;
% endindex=length(xc)
% for k = 1:endindex-3
%     
%     distt(k) = sqrt(((xc(k+1)-xc(k)).^2)+((yc(k+1)-yc(k)).^2));
%     
% end
% disttt=distt-distt(1);
% 
% for n = 0:1:((length(disttt(1:end)))/1)
% msd(n+1) = mean((distt(n+1:end)-distt(1:end-n)).^2);
% end
% msd=msd(1:(end/4));
% % semmsd=semmsd(1:(end/4))
% timet = 1.*[0:1:length(msd)-1];
% figure(3) ; plot (disttt); hold on 
%  figure(5) ;plot(timet, msd); hold on 
% 
% 
