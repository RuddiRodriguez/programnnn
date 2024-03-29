
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
for j = savedcontours
% load contour
i=i+1;
p=0;
mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j));
for p=1:length(mempos)
    x(i,p)=mempos(p,1).* parameterStruct.resolution;
    y(i,p)=mempos(p,2).* parameterStruct.resolution;
    
end

    

end
k=size(x)
temp=zeros(k(1),3);
for h=1:k(2)
    temp(:,1)=t';
    temp(:,2)=x(1:k(1),h);
    temp(:,3)=y(1:k(1),h);
  save(sprintf('%s/correla/coordinates%i.txt',working_directory_path,h),'temp','-ascii');  
end



save(sprintf('%s/correla/coordinatex.txt',working_directory_path),'x','-ascii')
save(sprintf('%s/correla/coordinatey.txt',working_directory_path),'y','-ascii')




    
