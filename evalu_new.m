% this program takes the tracked position of the membrane saved by the 
% 'testcontourprogram.m' program and evaluates them 

% clear all;

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

% VARIABLES:
% coordinate variables: these are cells holding the coordinates x
% and y of all the contours
x = cell(contournr,1);
y = cell(contournr,1);
x_ext = cell(contournr,1);
y_ext = cell(contournr,1);


a = zeros(parameterStruct.nmax,contournr); % coefficients of the fouriertransformation
b = zeros(parameterStruct.nmax,contournr); 
c = zeros(parameterStruct.nmax,contournr);
r0 = zeros(1,contournr);
wavenumbers = zeros(1,parameterStruct.nmax); % vector holding the wavenumbers



for j = savedcontours
% load contour
mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j));

x{j} = mempos(:,1);
y{j} = mempos(:,2);
end

for j = savedcontours
x_ext{j} = zeros(length(x{j}) + 2,1);
y_ext{j} = zeros(length(y{j}) + 2,1);
x_ext{j}(2:end-1) = x{j};
x_ext{j}(1) = x{j}(end);
x_ext{j}(end) = x{j}(1);
y_ext{j}(2:end-1) = y{j};
y_ext{j}(1) = y{j}(end);
y_ext{j}(end) = y{j}(1);
end

% define extendend variables of r and theta which are there to aid in the
% calculation of the differences between coordinates; for example
% to calculate (r{j}(N+1) - r{j}(N)) with N being the last entry in the cell
% r{j} and r{j}(N+1) = r{j}(1) we define the variable r_ext which will be
% extended in the end by that coordinate
L = cell(contournr,1);
ds = cell(contournr,1);

% calculate length of circumferences
for j = savedcontours
ds{j} = sqrt( (x_ext{j}(2:end) - x_ext{j}(1:end-1)) .^2 + (y_ext{j}(2:end) - y_ext{j}(1:end-1)) .^2 );
L{j} = sum( ds{j}(1:end-1) ); % sum up to end-1 because ds(end) = ds(1)
end

% calculate the center position of the contour

% calculate the center positions of the contours
sumds = cell(contournr,1);
center = cell(contournr,1);
for j = savedcontours
sumds{j} = ds{j}(1:end-1) + ds{j}(2:end); % help variable representing the sum of the coordinate differences

center{j}(1) = (1/(2*L{j})) * sum(x{j} .* sumds{j});
center{j}(2) = (1/(2*L{j})) * sum(y{j} .* sumds{j});
end

% TRANSFORMATION TO POLAR COORDINATES

% transformation of coordinate origin to center of vesicle

for j = savedcontours
x_ext{j} = x_ext{j} - center{j}(1);
y_ext{j} = y_ext{j} - center{j}(2);
end

% define cells that will be holding the polar coordinates
theta_ext = cell(contournr,1);
r_ext = cell(contournr,1);
theta = cell(contournr,1);
r = cell(contournr,1);

for j = savedcontours
% use matlab-function for transformation:
[theta_ext{j},r_ext{j}]=cart2pol(x_ext{j},y_ext{j});
%[mempos(:,2),mempos(:,1)]=cart2pol(mempos(:,1),mempos(:,2));
r{j} = r_ext{j}(2:end-1);
theta{j} = theta_ext{j}(2:end-1);
end

% change radius from pixels to meters
for j = savedcontours
r_ext{j} = r_ext{j} * parameterStruct.resolution;
r{j} = r{j} * parameterStruct.resolution;
end


% CALCULATE r0{j} the mean radius of each contour

% calculate differences-vector difftheta for each contour j
% 1. difftheta{j}(i) = theta{j}(i+1) - theta{j}(i)
difftheta = cell(contournr,1);
%define array holding the mean radii r0 of the contours
r0 = zeros(contournr,1);

for j = savedcontours
difftheta{j} = zeros(length(theta_ext{j})-1,1); % define difftheta array to accelerate processing
for i = 1:length(theta_ext{j})-1
    if theta_ext{j}(i+1) * theta_ext{j}(i) > 0
    difftheta{j}(i) = abs(theta_ext{j}(i+1) - theta_ext{j}(i));
    else
    difftheta{j}(i) = abs(theta_ext{j}(i+1) + theta_ext{j}(i));
    end
end
difftheta{j} = difftheta{j}(2:end); % remove the first element in difftheta because it corresponds to 'theta(N+1)-theta(N)'
r0(j) = (1/(4*pi)) * sum( (r_ext{j}(2:end-1) + r_ext{j}(3:end)) .* difftheta{j} );
end


% CALCULATE MEAN RADIUS 'mean_r0' over the radii 'r0' of ALL the tracked contours
mean_r0 = mean(r0);

% CALCULATE FLUCTUATIONS OF THE MEMBRANES FOR EACH CONTOUR
u = cell(contournr,1);
u_ext = cell(contournr,1);
for j = savedcontours
u_ext{j} = r_ext{j} - mean_r0;
u{j} = u_ext{j}(2:end-1);
end



% FOURIER TRANFORMATION

% calculate fourier fractors a_n
a = zeros(parameterStruct.nmax,contournr);
for j = savedcontours
    for n = 1:parameterStruct.nmax
    a(n,j) = (1/(2*pi*r0(j))) * sum( (u_ext{j}(2:end-1) .* cos(n*theta_ext{j}(2:end-1)) ...
                                       + u_ext{j}(3:end) .* cos(n*theta_ext{j}(3:end))) .* difftheta{j} );
    end
end

% calculate fourier fractors b_n
b = zeros(parameterStruct.nmax,contournr);
for j = savedcontours
    for n = 1:parameterStruct.nmax
    b(n,j) = (1/(2*pi*r0(j))) * sum( (u_ext{j}(2:end-1) .* sin(n*theta_ext{j}(2:end-1)) ...
                                       + u_ext{j}(3:end) .* sin(n*theta_ext{j}(3:end))) .* difftheta{j} );
    end
end


% calculate fourier coefficient c_n
c = sqrt( a .^2 + b .^2 );


% this checks if one of the coefficients of c is larger than 1.5; if so the
% contour will be deleted
for j = savedcontours
if any(c(:,j)>parameterStruct.maxc) == 1
% add contour index to 'deletedcontours' vector
deletedcontours(end+1) = j;
% remove contour index from 'savedcontours' vector
savedcontours(find(savedcontours == j)) = [];
end
end


% calculate fluctuation of the modulus of c(n)
% CALCULATE FLUCTUATIONS SPECTRUM WITH THE MODULUS OF c(n)

% calculate mean_c
mean_c = zeros(1,parameterStruct.nmax);
for n = 1:parameterStruct.nmax
mean_c(n) = mean(c(n,savedcontours));
end

% calculate mean_quad_c
mean_quad_c = zeros(1,parameterStruct.nmax);
for n = 1:parameterStruct.nmax
mean_quad_c(n) = mean(c(n,savedcontours).^2);
end

% fluctuation = ((pi*(rmean*parameterStruct.resolution)^3)/2)*fluctuation;
fluctuation = ((pi * mean_r0^3) / 2) * (mean_quad_c(:) - mean_c(:).^2);

% wave numbers
wavenumbers = (1:parameterStruct.nmax)'/mean_r0; 


% save fluctuations
save(sprintf('%s/results/evalu-variables.mat',working_directory_path),'fluctuation','wavenumbers','a','b','c','r0','mean_c')

save(sprintf('%s/results/fluctuations.txt',working_directory_path),'fluctuation','-ascii')

save(sprintf('%s/results/wavenumbers.txt',working_directory_path),'wavenumbers','-ascii')

save(sprintf('%s/results/a.txt',working_directory_path),'a','-ascii')

save(sprintf('%s/results/b.txt',working_directory_path),'b','-ascii')

save(sprintf('%s/results/c.txt',working_directory_path),'c','-ascii')

save(sprintf('%s/results/r0.txt',working_directory_path),'r0','-ascii')

% for n=1:parameterStruct.nmax % calculates the fluctuation of c(n) of the ensemble for each n
% fluctuation(n)=mean(c(n,:).^2)-mean(c(n,:)).^2;
% end%

%Calcula la funcion de autocorrelacion para un q especifico

m=10
c=(c(m,savedcontours))
a=(a(m,savedcontours))
b=(b(m,savedcontours))
%   a=a.^2
bn=b./c
an=a./c
fid=fopen('resultsa.txt','w+')

j=length(an)
for tao=1:j
    j=length(an)
    temp=0
for i=1:(j-tao)
P=an(i)*an(i+tao)
suma=temp+P
temp=suma; 
i
end
suma=suma./j
tiempo=tao*0.0666;
fid=fopen('resultsa.txt','a+')
fprintf(fid,'%6.9e       %6.3e\n',suma,tiempo)
fclose(fid)
end
Autofunctiondatos=load('D:/membrane_tracking_project/program/resultsa.txt')
h=1:j;
Function=(Autofunctiondatos(h,1))/(Autofunctiondatos(1,1))
tiempo=Autofunctiondatos(h,2)
figure(4)
plot(tiempo,Function,'o')
% 

fid=fopen('resultsb.txt','w+')

j=length(bn)
for tao=1:j
    j=length(nb)
    temp=0
for i=1:(j-tao)
P=bn(i)*bn(i+tao)
suma=temp+P
temp=suma; 
i
end
suma=suma./j
tiempo=tao*0.0666;
fid=fopen('resultsb.txt','a+')
fprintf(fid,'%6.9e       %6.3e\n',suma,tiempo)
fclose(fid)
end
Autofunctiondatos=load('D:/membrane_tracking_project/program/resultsb.txt')
h=1:j;
Function=(Autofunctiondatos(h,1))/(Autofunctiondatos(1,1))
tiempo=Autofunctiondatos(h,2)
figure(5)
plot(tiempo,Function,'o')
% 
% 
% 
% 
% %  V=diff(a)
% %  tiempo1=0:0.066:((0.066*(j-1)))
% % %  figure(3)
% % %  plot(tiempo1,V)
% %  fid=fopen('resultsvelocidad.txt','a+')
% %  fprintf(fid,'%6.4e\n',V)
% %  fclose(fid)
% %  fid=fopen('resultstiempo.txt','a+')
% %  fprintf(fid,'%6.4e\n',tiempo1)
% %  fclose(fid)
% % 
% % j=0
% % h=0
% %   velocidad=load('D:/membrane_tracking_project/program/resultsvelocidad.txt')
% %   tiemporeal=load('D:/membrane_tracking_project/program/resultstiempo.txt')
% % 
% %   j=length(velocidad)
% %   for taov=1:j
% %    j=length(velocidad)
% %     tempv=0
% %   for i=1:(j-taov)
% %   Pv=velocidad(i)*velocidad(i+taov)
% %   sumav=tempv+Pv
% %   tempv=sumav; 
% %   i
% %   end
% %    sumav=sumav./j
% %    tiempov=taov*0.0666;
% %    fid=fopen('resultscorrelation.txt','a+')
% %    fprintf(fid,'%6.9e       %6.3e\n',sumav,tiempov)
% %    fclose(fid)
% %    end
% %  Autofunctivelocidaddatos=load('D:/membrane_tracking_project/program/resultscorrelation.txt')
% %  h=1:j;
% %  Functionv=Autofunctivelocidaddatos(h,1)
% %  tiempov=Autofunctivelocidaddatos(h,2)
% %  figure(5)
% %  plot(tiempov,Functionv,'o')
% % % % % % 
% % % % % 
% % % % % 
% % % % % 