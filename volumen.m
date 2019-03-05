

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



% check number of tracked contour files in the contour directory
contournr = 1;
while exist(sprintf('%s/contours/contour%d.txt',working_directory_path,contournr)) == 2
   contournr = contournr + 1; 
end
contournr = contournr - 1;


% PARAMETERS:
% loads file containing the indexes of the saved and deleted contours
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
deletedcontours = load(sprintf('%s/results/deletedcontours.txt',working_directory_path));

% this sets the index of 'deletedcontourscounter' so that deleted contours
% will be add to the vector 'deletedcontours'
deletedcontourscounter = length(deletedcontours);
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
a = zeros(parameterStruct.nmax,contournr); % coefficients of the fouriertransformation
b = zeros(parameterStruct.nmax,contournr); 
c = zeros(parameterStruct.nmax,contournr);
% r0 = zeros(1,contournr);
wavenumbers = zeros(1,parameterStruct.nmax); % vector holding the wavenumbers
Vo=zeros(length(savedcontours),1);
Ao=zeros(length(savedcontours),1);
q=0;
r0=r0(savedcontours);
for j = savedcontours
% load contour
mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j));
mempos=mempos*(parameterStruct.resolution^2);
q=q+1;

% VARIABLES:
L = 0; % length of circumference
V=0;
A=0;

memposlength = length(mempos); % length of the vector mempos
mempospol = zeros(memposlength,2); % vector containing the membrane position in polar coordinates
ds = zeros(((memposlength)/2) - 1,1); % vector containing the distances between neighbooring membrane positions
vs = zeros(((memposlength)/2) - 1,1);
as = zeros(((memposlength)/2) - 1,1);
sumds = zeros(memposlength,1); % vector containing sum between ds(i) and ds(i + 1)
center = zeros(1,2); % center of the vesicle

for i = 1:((memposlength)/2) -150
    j=i+1;
   ds(i) = sqrt((mempos(i + 1,1) - mempos(i,1))^2 + (mempos(i + 1,2) - mempos(i,2))^2);
   ds1= sqrt((mempos(j + 1,1) - mempos(j,1))^2 + (mempos(j + 1,2) - mempos(j,2))^2);
   L = L + ds(i);
   tempL=L+ds1;
%    x=mempos(i,1);
%    x1=mempos(i+1,1)
%    y=mempos(i,2);
   %vs(i + 1) = (((x(i + 1,1))^2 + (mempos(i,1))^2) * (mempos(i + 1,2) - mempos(i,2)));
   as(i)=(((mempos(i + 1,2))^1) + ((mempos(i,2)))^1)*(tempL-L);
   
   vs(i) = ((((mempos(i + 1,2))^2) + ((mempos(i,2)))^2) * (mempos(i + 1,1) - mempos(i,1)));
   V = V + vs(i);
   A = A + as(i);
   
   
end
% to get the last part between the end and starting point of tracked
% contour
% ds(1) = sqrt((mempos(1,1) - mempos(i + 1,1))^2 + (mempos(1,2) - mempos(i + 1,2))^2); 
% L = L + ds(1);
Lo=L%* parameterStruct.resolution;
Vo(q)=(pi/2).*V%.* (parameterStruct.resolution^3);
Ao(q)=pi*A%* %(parameterStruct.resolution^2);





end
Radio=sqrt(Ao./(4.*pi));
Radio=Radio(1)
r=mean(r0)
L=2*pi*r
L1=Lo(1)
V1o=(4./3).*pi.*(Radio.^3);
v=Vo./V1o
n=1:length(Vo);
plot(n,(Ao-Ao(1))/Ao(1),n,(Vo-Vo(1))/Vo(1))
plot(v)