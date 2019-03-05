

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
m=341;
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
% Radio=zeros(length(savedcontours),1);
q=0;
r0=r0(savedcontours);
for j = savedcontours
% load contour
mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j));
 mempos=mempos*(parameterStruct.resolution);
q=q+1;

% VARIABLES:
L = 0; % length of circumference
V=0;
A=0;
m=370;
n=+40
memposlength = length(mempos);
m=floor(memposlength/2);% length of the vector mempos
mempospol = zeros(memposlength,2); % vector containing the membrane position in polar coordinates
ds = zeros((m+n),1); % vector containing the distances between neighbooring membrane positions
vs = zeros((m+n),1);
as = zeros((m+n),1);
% x=zeros((memposlength/2)-1,1);
% y=zeros((memposlength/2)-1,1);
sumds = zeros(memposlength,1); % vector containing sum between ds(i) and ds(i + 1)
center = zeros(1,2); % center of the vesicle
a=mempos(1,1);
b=mempos(1,2);
for i = 1:((m+n))
    j=i+1;
   ds(i) = sqrt((mempos(i + 1,1) - mempos(i,1))^2 + (mempos(i + 1,2) - mempos(i,2))^2);
   ds1= sqrt((mempos(j + 1,1) - mempos(j,1))^2 + (mempos(j + 1,2) - mempos(j,2))^2);
   L = L + ds(i);
   tempL=L+ds1;
   
   
   as(i)=((((mempos(i + 1,2)-b))^1) + (((mempos(i,2)-b)))^1)*(tempL-L);
   
   vs(i) = ((((mempos(i + 1,2)-b)^2) + ((mempos(i,2)-b))^2) * ((mempos(i + 1,1)-a) - (mempos(i,1)-a)));
   V = V + vs(i);
   A = A + as(i);
   
   
end
L1=0;
V1=0;
A1=0;
 %m=370;
 n=43
% memposlength = length(mempos);
% m=floor(memposlength/2);% length of the vector mempos
% mempospol = zeros(memposlength,2); % vector containing the membrane position in polar coordinates
ds1 = zeros((n),1); % vector containing the distances between neighbooring membrane positions
vs1 = zeros((n),1);
as1 = zeros((n),1);




for i = 1:120
    j=i+1;
   ds1(i) = sqrt((mempos(i + 1,1) - mempos(i,1))^2 + (mempos(i + 1,2) - mempos(i,2))^2);
   ds11= sqrt((mempos(j + 1,1) - mempos(j,1))^2 + (mempos(j + 1,2) - mempos(j,2))^2);
   L1 = L1 + ds1(i);
   tempL1=L1+ds11;
   
   
   as1(i)=((((mempos(i + 1,2)-b))^1) + (((mempos(i,2)-b)))^1)*(tempL-L);
   
   vs1(i) = ((((mempos(i + 1,2)-b)^2) + ((mempos(i,2)-b))^2) * ((mempos(i + 1,1)-a) - (mempos(i,1)-a)));
   V1 = V1 + vs1(i);
   A1 = A1 + as1(i);
   
   
end





% to get the last part between the end and starting point of tracked
% contour
% ds(1) = sqrt((mempos(1,1) - mempos(i + 1,1))^2 + (mempos(1,2) - mempos(i + 1,2))^2); 
% L = L + ds(1);
Lo1=(L+L1)%* parameterStruct.resolution;
Vo(q)=((pi)).*(V+V1);%.* (parameterStruct.resolution^3);
Ao(q)=2*pi*(A+A1);%*(parameterStruct.resolution^2);
% Radio(q)=sqrt(Ao./(4.*pi));%*parameterStruct.resolution;




end
% VARIABLES:
L = 0; % length of circumference
memposlength = length(mempos); % length of the vector mempos
mempospol = zeros(memposlength,2); % vector containing the membrane position in polar coordinates
ds = zeros(memposlength,1); % vector containing the distances between neighbooring membrane positions
sumds = zeros(memposlength,1); % vector containing sum between ds(i) and ds(i + 1)
center = zeros(1,2); % center of the vesicle


% calculate length of circumference
for i = 1:memposlength - 1
   ds(i + 1) = sqrt((mempos(i + 1,1) - mempos(i,1))^2 + (mempos(i + 1,2) - mempos(i,2))^2);
   L = L + ds(i);
end
% to get the last part between the end and starting point of tracked
% contour
ds(1) = sqrt((mempos(1,1) - mempos(i + 1,1))^2 + (mempos(1,2) - mempos(i + 1,2))^2); 
L = L + ds(1);
   
   

Lo(q)=L%*parameterStruct.resolution);

Radio=sqrt(Ao./(4.*pi));
V1o=(4./3).*pi.*((Radio).^3);
v=Vo./V1o;

V=(4/3)*pi*((r0(1))^3)
% vv=Vo./V

% Vo=Vo(1)
% V1o=V1o(1)
Radio=Radio(1)
r0=r0(1)
v1=v(1)
Lo1=Lo1
mitad=Lo(q)/2
Lreal=2*pi*r0
v=Vo./V1o;
n=1:length(Vo);
figure (1)
subplot(2,1,1)
plot(n,(Ao-Ao(1))/Ao(1),n,(Vo-Vo(1))/Vo(1))
subplot(2,1,2)
plot(v)
