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
mkdir(sprintf('%s/contourscorregido',working_directory_path));

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

a = zeros(parameterStruct.nmax,contournr); % coefficients of the fouriertransformation
b = zeros(parameterStruct.nmax,contournr); 
c = zeros(parameterStruct.nmax,contournr);
r0 = zeros(1,contournr);
wavenumbers = zeros(1,parameterStruct.nmax); % vector holding the wavenumbers
h=waitbar (0,'Please wait.........')
q=0;
Lo=zeros(1,length(savedcontours));
for j = savedcontours
% load contour
mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j));


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
q=q+1;
Lo(q)=L;


% calculate the center position of the contour

for i = 1:memposlength - 1
sumds(i) = ds(i) + ds(i + 1);
end
% to get the last part between the end and starting point of tracked
% contour
sumds(i + 1) = ds(i + 1) + ds(1);

center(1) = (1/(2*L)) * mempos(:,1)' * sumds;
center(2) = (1/(2*L)) * mempos(:,2)' * sumds;


% transformation of coordinate origin to center of vesicle

mempos(:,1) = mempos(:,1) - center(1);
mempos(:,2) = mempos(:,2) - center(2);
camino=sprintf('%s/contourscorregido/contour%i.txt',working_directory_path,j);
save(camino,'mempos','-ascii'); % save the contour

% TRANSFORMATION TO POLAR COORDINATES

% with 
% mempos(i,1) = r_i
% mempos(i,2) = theta_i

% matlab-version would be:
% [mempos(:,2),mempos(:,1)]=cart2pol(mempos(:,1),mempos(:,2));

% calculate radii (now the x_i and y_i are relative to center-position)
for i = 1:memposlength
mempospol(i,1) = sqrt(mempos(i,1)^2 + mempos(i,2)^2);

% calculate angles theta in range (-pi,pi]
if mempos(i,1) > 0
mempospol(i,2) = atan(mempos(i,2) / mempos(i,1));
elseif mempos(i,1) < 0 && mempos(i,2) >= 0
    mempospol(i,2) = atan(mempos(i,2) / mempos(i,1)) + pi;
elseif mempos(i,1) < 0 && mempos(i,2) < 0
    mempospol(i,2) = atan(mempos(i,2) / mempos(i,1)) - pi;
elseif mempos(i,1) == 0 && mempos(i,2) > 0
    mempospol(i,1) = pi / 2;
elseif mempos(i,1) == 0 && mempos(i,2) < 0
    mempospol(i,1) = - pi / 2;
end

end % closes the angles calculation loop

% change radius from pixels to meters
mempospol(:,1) = mempospol(:,1) * parameterStruct.resolution;

% set mempos to the polar coordinates for further processing
mempos = mempospol;

% save contours in polar coordinates

% save files in ascii text format
save(sprintf('%s/contours/polarcontour%i.txt',working_directory_path,j),'mempospol','-ascii'); % save the contour
save(sprintf('%s/memposs/mempos%i.txt',working_directory_path,j),'mempos','-ascii')

% FOURIER TRANFORMATION

% a = zeros(parameterStruct.nmax,1); % coefficients of the fouriertransformation
% b = zeros(parameterStruct.nmax,1); 

tmp = 0;
tmp2 = 0;

% calculate r0(j)
for i = 1:memposlength - 1
    if mempos(i + 1,2) * mempos(i,2) > 0
    tmp = (mempos(i,1) + mempos(i + 1,1)) * abs(mempos(i + 1,2) - mempos(i,2));
    else
        tmp = (mempos(i,1) + mempos(i + 1,1)) * abs(mempos(i + 1,2) + mempos(i,2));
    end
    tmp2 = tmp2 + tmp;
end
% to get the last membrane part
if mempos(i + 1,2) * mempos(i,2) > 0
tmp2 = tmp2 + (mempos(i + 1,1) + mempos(1,1)) * abs(mempos(1,2) - mempos(i + 1,2));
else
    tmp2 = tmp2 + (mempos(i + 1,1) + mempos(1,1)) * abs(mempos(1,2) + mempos(i + 1,2));
end

r0(j) = (1/(4*pi)) * tmp2;

% substract the mean radius of the vesicle to get the fluctuations
% AS OF HERE mempos(:,1) will be the fluctuation of the membrane and NOT
% the radius of the membrane position

for i=1:memposlength
   mempos(i,1) = mempos(i,1) - r0(j);
end
j;


for n = 1:parameterStruct.nmax % loop to calculate the fourier coefficients 
    
% calculate a_n
tmp = 0;
tmp2 = 0;

for i = 1:memposlength - 1
    if mempos(i + 1,2) * mempos(i,2) > 0
    tmp = (mempos(i,1) * cos(n*mempos(i,2)) + mempos(i + 1,1) * cos(n*mempos(i + 1,2))) * abs(mempos(i + 1,2) - mempos(i,2)) / 2;
    else
        tmp = (mempos(i,1) * cos(n*mempos(i,2)) + mempos(i + 1,1) * cos(n*mempos(i + 1,2))) * abs(mempos(i + 1,2) + mempos(i,2)) / 2;
    end
    tmp2 = tmp2 + tmp;
end
% to get the last membrane part
if mempos(1,2) * mempos(i + 1,2) > 0
tmp2 = tmp2 + (mempos(i + 1,1) * cos(n*mempos(i + 1,2)) + mempos(1,1) * cos(n*mempos(1,2))) * abs(mempos(1,2) - mempos(i + 1,2)) / 2;
else
    tmp2 = tmp2 + (mempos(i + 1,1) * cos(n*mempos(i + 1,2)) + mempos(1,1) * cos(n*mempos(1,2))) * abs(mempos(1,2) + mempos(i + 1,2)) / 2;
end

a(n,j) = (1/(pi*r0(j))) * tmp2;



% calculate b_n
tmp = 0;
tmp2 = 0;

for i = 1:memposlength - 1
    if mempos(i + 1,2) * mempos(i,2) > 0
    tmp = (mempos(i,1) * sin(n*mempos(i,2)) + mempos(i + 1,1) * sin(n*mempos(i + 1,2))) * abs(mempos(i + 1,2) - mempos(i,2)) / 2;
    else
        tmp = (mempos(i,1) * sin(n*mempos(i,2)) + mempos(i + 1,1) * sin(n*mempos(i + 1,2))) * abs(mempos(i + 1,2) + mempos(i,2)) / 2;
    end
    tmp2 = tmp2 + tmp;
end
% to get the last membrane part
if mempos(1,2) * mempos(i + 1,2) > 0
tmp2 = tmp2 + (mempos(i + 1,1) * sin(n*mempos(i + 1,2)) + mempos(1,1) * sin(n*mempos(1,2))) * abs(mempos(1,2) - mempos(i + 1,2)) / 2;
else
    tmp2 = tmp2 + (mempos(i + 1,1) * sin(n*mempos(i + 1,2)) + mempos(1,1) * sin(n*mempos(1,2))) * abs(mempos(1,2) + mempos(i + 1,2)) / 2;  
end

b(n,j) = (1/(pi*r0(j))) * tmp2;


c(n,j) = sqrt(a(n,j)^2 + b(n,j)^2);

end

% this checks if one of the coefficients of c is larger than 1.5; if so the
% contour will be deleted
if any(c(:,j)>parameterStruct.maxc) == 1
    deletedcontourscounter = deletedcontourscounter + 1;
    deletedcontours(deletedcontourscounter) = j;
end

clear mempos L mempospol

waitbar (j/length(savedcontours))
end
close (h)


% this creates a new index of the NOT deleted contours and saves it

% variables:
% savecontours: will contain the saved contours
savedcontourscounter = 0; %counter

clear savedcontours;
for j = 1:contournr
    if any(j == deletedcontours) == 0
        savedcontourscounter = savedcontourscounter + 1;
        savedcontours(savedcontourscounter) = j;
    end
end

% save c.mat 'c'


% calculate fluctuation of the modulus of c(n)
fluctuation = zeros(1,parameterStruct.nmax);
cmean = zeros(1,parameterStruct.nmax);
cmeansquare = zeros(1,parameterStruct.nmax);

for j = savedcontours
    cmean = cmean + transpose(c(:,j));
end
cmean = cmean/length(savedcontours);

for j = savedcontours
    cmeansquare = cmeansquare + transpose(c(:,j).^2);
end
cmeansquare = cmeansquare/length(savedcontours);

for n = 1:parameterStruct.nmax
fluctuation(n) = cmeansquare(n) - cmean(n)^2;

end

tmp = 0;
for j = savedcontours
    tmp = tmp + r0(j);
end
rmean = tmp/length(savedcontours);
fluctuationa = fluctuation;

%fluctuation = ((pi*(rmean*parameterStruct.resolution)^3)/2)*fluctuation;
fluctuation = ((pi*rmean^3)/2)*fluctuation;

% wave numbers

for j = 1:parameterStruct.nmax
   wavenumbers(j) = j/(rmean); 
end
fluctuationa = transpose(fluctuationa);

fluctuation = transpose(fluctuation);
wavenumbers = transpose(wavenumbers);

% save fluctuations
save(sprintf('%s/results/fluctuationsa.txt',working_directory_path),'fluctuationa','-ascii')

save(sprintf('%s/results/fluctuations.txt',working_directory_path),'fluctuation','-ascii')

save(sprintf('%s/results/wavenumbers.txt',working_directory_path),'wavenumbers','-ascii')

save(sprintf('%s/results/a.txt',working_directory_path),'a','-ascii')

save(sprintf('%s/results/b.txt',working_directory_path),'b','-ascii')

save(sprintf('%s/results/c.txt',working_directory_path),'c','-ascii')

save(sprintf('%s/results/r0.txt',working_directory_path),'r0','-ascii')
diametro=rmean*2*100

save(sprintf('%s/results/longitud.txt',working_directory_path),'Lo','-ascii'); % save the contour
% for n=1:parameterStruct.nmax % calculates the fluctuation of c(n) of the ensemble for each n
% fluctuation(n)=mean(c(n,:).^2)-mean(c(n,:)).^2;
% end


% for j=savedcontours
%     j
% contornos = load(sprintf('%s/contours/polarcontour%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates
% end
% % n1=lenght(contornos)
% % n=1:n1;
% % teta=contornos(2,n)
% % radiopolar=(1,n)
% % sigmacero=0.1*parameterStruct.resolution;
% % temp=0
% % for i=2:(n1-1)
% %     factor1=((teta(i+1)-teta(i-1))./(4*pi)).*(2*(sigmacero^2))
% %     factor2=((radiopolar(i+1)-radiopolar(i-1))./(4*pi)).*((2*(sigmacero^2))./(radiopolar(i)^2))
% %     factor3=((teta(i+1)-teta(i-1))./(4*pi)).*((radiopolar(i+1)-radiopolar(i-1))./(4*pi)).*((2*(sigmacero^2))./(radiopolar(i)^2))
% %     factor4=factor1+factor2+factor3+temp
% %     temp=factor4
% % end 


% contornos =load('C:/membrane_tracking_project/medidas/ruddi/popcambiente19/contours/polarcontour165.txt')%load(sprintf('%s/contours/polarcontour%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates
% 
% n1=length(contornos)
% n=1:n1;
% teta=contornos(n,2)
% radiopolar=contornos(n,1)
% sigmacero=0.1*parameterStruct.resolution;
% temp=0
% for i=2:(n1-1)
%     factor1=((teta(i+1)-teta(i-1))./(4*pi)).*(2*(sigmacero^2))
%     factor2=((radiopolar(i+1)-radiopolar(i-1))./(4*pi)).*((2*(sigmacero^2))./(radiopolar(i)^2))
%     factor3=((teta(i+1)-teta(i-1))./(4*pi)).*((radiopolar(i+1)-radiopolar(i-1))./(4*pi)).*((2*(sigmacero^2))./(radiopolar(i)^2))
%     factor4=factor1+factor2+factor3+temp
%     temp=factor4
% end 
% 
% m=32
% 
% c=(c(m,savedcontours))
% a=(a(m,savedcontours))
% b=(b(m,savedcontours))
% desviaciona=std(a)
% desviacionb=std(b)
% desviacionc=std(c)
% sumadesviacionc=(sum(desviacionc))
% 
% lon=length(savedcontours)^2
% desviacioncmedia=sumadesviacionc*(1/lon)













% c=(c(1,savedcontours))
% c=c.^2
% fid=fopen('results.txt','w+')
% 
% j=length(c)
% for tao=1:j
%     j=length(c)
%     temp=0
% for i=1:(j-tao)
% P=c(i)*c(i+tao)
% suma=temp+P
% temp=suma; 
% i
% end
% suma=suma./j
% tiempo=tao*0.0666;
% fid=fopen('results.txt','a+')
% fprintf(fid,'%6.9e       %6.3e\n',suma,tiempo)
% fclose(fid)
% end
% Autofunctiondatos=load('D:/membrane_tracking_project/program/results.txt')
% h=1:j;
% Function=(Autofunctiondatos(h,1))/(Autofunctiondatos(1,1))
% tiempo=Autofunctiondatos(h,2)
% figure(4)
% plot(tiempo,Function,'o')





%  V=diff(c)
%  tiempo1=0:0.066:((0.066*(j-1)))
% %  figure(3)
% %  plot(tiempo1,V)
%  fid=fopen('resultsvelocidad.txt','a+')
%  fprintf(fid,'%6.4e\n',V)
%  fclose(fid)
%  fid=fopen('resultstiempo.txt','a+')
%  fprintf(fid,'%6.4e\n',tiempo1)
%  fclose(fid)
% 
% j=0
% h=0
%   velocidad=load('D:/membrane_tracking_project/program/resultsvelocidad.txt')
%   tiemporeal=load('D:/membrane_tracking_project/program/resultstiempo.txt')
% 
%   j=length(velocidad)
%   for taov=1:j
%    j=length(velocidad)
%     tempv=0
%   for i=1:(j-taov)
%   Pv=velocidad(i)*velocidad(i+taov)
%   sumav=tempv+Pv
%   tempv=sumav; 
%   i
%   end
%    sumav=sumav./j
%    tiempov=taov*0.0666;
%    fid=fopen('resultscorrelation.txt','a+')
%    fprintf(fid,'%6.9e       %6.3e\n',sumav,tiempov)
%    fclose(fid)
%    end
%  Autofunctivelocidaddatos=load('D:/membrane_tracking_project/program/resultscorrelation.txt')
%  h=1:j;
%  Functionv=Autofunctivelocidaddatos(h,1)
%  tiempov=Autofunctivelocidaddatos(h,2)
%  figure(5)
%  plot(tiempov,Functionv,'o')
