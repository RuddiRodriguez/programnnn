% this program calculates the errors of the values calculated by the program
% evalu

clear all;

% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
fid = fopen('config/program_directory_path.ini','rt')
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all')

% read working directory from config file 'working_directory_path.ini'
fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt')
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all')


% % check number of tracked contour files in the contour directory
contournr = 1;
while exist(sprintf('%s/contours/contour%d.txt',working_directory_path,contournr)) == 2
   contournr = contournr + 1; 
end
contournr = contournr - 1;


% PARAMETERS:
% loads file containing the indexes of the saved and deleted contours
savedcontours = load(sprintf('%s/savedcontours.txt',working_directory_path));
deletedcontours = load(sprintf('%s/deletedcontours.txt',working_directory_path));

% nmax = 20; % maximum number of calculated wavenumbers

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}), c{1});

% output of parameters
parameterStruct


% load the values calculted by the program evalu
a = load(sprintf('%s/a.txt',working_directory_path));
b = load(sprintf('%s/b.txt',working_directory_path));
c = load(sprintf('%s/c.txt',working_directory_path));
wavenumbers = load(sprintf('%s/wavenumbers.txt',working_directory_path));
r0 = load(sprintf('%s/r0.txt',working_directory_path));

% Format of the loaded data (meant as a reference):
% a=zeros(parameterStruct.nmax,contournr); % coefficients of the fouriertransformation
% b=zeros(parameterStruct.nmax,contournr); 
% c=zeros(parameterStruct.nmax,contournr);
% r0=zeros(1,contournr);
% wavenumbers=zeros(1,parameterStruct.nmax); % vector holding the wavenumbers




% variables:
% L:    this variable holds the length of the circumference of the vesicle
% memposlength: this variable hold the length of the mempos vector of the
%               vesicles
% ds:   this vector holds the distances between the membrane points along the
%       membrane
% sumds: this vector is the pairwise sum of the vector ds (i.e.: ds(i)+ds(i+1));
%        it is used to calculate the center coordinates (x_c,y_c)
% center: this vector holds the coordinates of the center; i.e.: center=(x_c,y_c)


% this sets the index of 'deletedcontourscounter' so that deleted contours
% will be add to the vector 'deletedcontours'
deletedcontourscounter=length(deletedcontours)

% 
 savedcontourslength = length(savedcontours) % length of the vector containing the indices of the saved contours
% 
 sigma_r0_squared = zeros(length(savedcontours),1) % vector containing the 
%                                                    % error of the mean radius 
%                                                    % of each contour
 sigma_a_squared = zeros(parameterStruct.nmax,length(savedcontours)) % vector containing the 
%                                                    % error of a
%                                                    % of each contour
sigma_b_squared = zeros(parameterStruct.nmax,length(savedcontours)) % vector containing the 
%                                                    % error of b
%                                                    % of each contour
% 
sigma_0 = 0.1*parameterStruct.resolution % standard deviation of the tracked
%                                           % points of the contour; this value +
%                                           % is fixed empiricaly; it is set
%                                           % to one tenth a pixel

for j = 1%savedcontours

% load contour
 mempospol = load(sprintf('%s/contours/polarcontour%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates

% DEFINE VARIABLES
 mempospollength = length(mempospol);

sigma_r = zeros(mempospollength,1); % errors of the radius of the membrane positions
sigma_theta = zeros(mempospollength,1); % errors of the radius of the membrane positions


% calculated errors for the radius r(i) and the angle theta(i)
for i = 1:mempospollength
    sigma_r(i) = 1.4142 * sigma_0;
    sigma_theta(i) = 1.4142 * sigma_0 / mempospol(i,1);
end


% calculate differences-vector 
% 1. difftheta(i) = theta(i+1) - theta(i-1)
% 2. diffr(i) = r(i-1) - r(i+1)
difftheta = zeros(mempospollength,1);
diffr = zeros(mempospollength,1);

% calculate differences for i = 1
if abs(mempospol(2,2) - mempospol(mempospollength,2)) < pi
    difftheta(1) = mempospol(2,2) - mempospol(mempospollength,2);
    else
    difftheta(1) = mempospol(2,2) + mempospol(mempospollength,2);
end
    diffr(1) = mempospol(mempospollength,1) - mempospol(2,1);

for i = 2:mempospollength - 1
    if abs(mempospol(i + 1,2) - mempospol(i-1,2)) < pi
    difftheta(i) = mempospol(i+1,2) - mempospol(i-1,2);
    else
    difftheta(i) = mempospol(i+1,2) + mempospol(i-1,2);
    end
    diffr(i) = mempospol(i-1,1) - mempospol(i+1,1);
end

% calculate differences for i = mempospollength
if abs(mempospol(1,2) - mempospol(mempospollength-1,2)) < pi
    difftheta(mempospollength) = mempospol(1,2) - mempospol(mempospollength-1,2);
    else
    difftheta(mempospollength) = mempospol(1,2) + mempospol(mempospollength-1,2);
end
diffr(mempospollength) = mempospol(mempospollength-1,1) - mempospol(1,1);



% calculate the error of the mean radius sigma_r0_squared

tmp = sum(difftheta .^ 2 + (diffr ./ mempospol(:,1)) .^ 2 + (difftheta .* diffr) ./ mempospol(:,1));
sigma_r0_squared(j) = tmp * (2 * (sigma_0 ^ 2) / ((4 * pi) ^ 2));

% calculate sigma_r0_squared with own formula

% term1 = (1 / (2 * pi)) * sum(difftheta) 


% set the radius of the coordinate points before mempospol(:,1) becomes the
% fluctuation amplitude
radius = mempospol(:,1);

%  AS OF HERE mempospol(:,1) will be the fluctuation of the membrane and
%  NOT the radius of the vesicle

mempospol(:,1) = mempospol(:,1) - r0(j);

% this sets any values k of mempospol that are 0 after the substraction to
% mempospol(k)=1*e-100, so that no "divided by zero" occurs
mempospolzeros = find(mempospol == 0);
for k = mempospolzeros
   mempospol(k) = 1e-100;
end

% % calculate term in parenthesis depending also from wavenumber n:
% % parenthesis(i,n) = -r(i)*n*sin(n*theta(i))*((theta(i+1)-theta(i-1))/2)-(r(i+1)*cos(n*theta(i+1)) -
% % r(i-1)*cos(n*theta(i-1)))
% parenthesis = zeros(mempospollength,parameterStruct.nmax);
% 
% for n = 1:parameterStruct.nmax
% % calculate parenthesis for i = 1
% parenthesis(1,n) = - mempospol(1,1) * n * sin(n * mempospol(1,2)) * difftheta(1)/2 ...
%                    - (mempospol(2,1)*cos(n*mempospol(2,2)) - mempospol(mempospollength,1)*cos(n*mempospol(mempospollength,2))) * 0.5;
% 
% for i = 2:mempospollength - 1
% parenthesis(i,n) = - mempospol(i,1) * n * sin(n * mempospol(i,2)) * difftheta(i)/2 ...
%                    - (mempospol(i+1,1)*cos(n*mempospol(i+1,2)) - mempospol(i-1,1)*cos(n*mempospol(i-1,2))) * 0.5 ;
% end
% 
% % calculate parenthesis for i = mempospollength
% parenthesis(i,n) = - mempospol(mempospollength,1) * n * sin(n * mempospol(mempospollength,2)) * difftheta(mempospollength)/2 ...
%                    - (mempospol(1,1)*cos(n*mempospol(1,2)) - mempospol(mempospollength-1,1)*cos(n*mempospol(mempospollength-1,2))) * 0.5;
% 
% end

% % calculate the error of fourier coefficient sigma_a_squared for all
% % wavenumbers n
% 
% term1 = zeros(1,parameterStruct.nmax);
% term2 = zeros(1,parameterStruct.nmax);
% term3 = zeros(1,parameterStruct.nmax);
% term4 = zeros(1,parameterStruct.nmax);
% term5 = zeros(1,parameterStruct.nmax);
% 
% for n = 1 : parameterStruct.nmax
% tmp = 0;
% tmp2 = 0;
% 
% term1(n) = sigma_r0_squared(j) * a(n,j) + transpose(sigma_0 ^ 2 * (1/(pi * r0(j))) * cos(n * mempospol(:,2)) .^ 2) * difftheta .^ 2;
% term2(n) = transpose((2 * sigma_0 ^ 2) ./ mempospol(:,1)) * (1/(pi * r0(j))) ^ 2 * parenthesis(:,n) .^ 2;
% term3(n) = transpose((sigma_0 ^ 2/(2 * pi)) * (difftheta + diffr)) * ((-a(n,j) / pi* r0(j) ^ 2) * cos(n*mempospol(:,2)) .* difftheta);
% term4(n) = transpose((sigma_0 ^ 2 ./ (2 * pi * mempospol(:,1))) .* (difftheta + (diffr ./ mempospol(:,1)))) * (-a(n,j) / (pi * r0(j) ^ 2 )) * parenthesis(:,n);
% term5(n) = transpose((4 * sigma_0 ^ 2 / mempospol(:,1)) * (1 / (pi * r0(j))) ^ 2 * (cos(n * mempospol(:,2)) / 2) .* difftheta) * parenthesis(:,n);
% 
% sigma_a_squared(n,j) = term1(n) + term2(n) + term3(n) + term4(n) + term5(n); 
% end

% clear mempospol



% caculate parenthesis

% calculate term in parenthesis depending also from wavenumber n:
% parenthesis(i,n) = -r(i)*n*sin(n*theta(i))*((theta(i+1)-theta(i-1))/2)-(r(i+1)*cos(n*theta(i+1)) -
% r(i-1)*cos(n*theta(i-1)))
parenthesis = zeros(mempospollength,parameterStruct.nmax);

for n = 1:parameterStruct.nmax
% calculate parenthesis for i = 1
parenthesis(1,n) = - mempospol(1,1) * n * sin(n * mempospol(1,2)) * difftheta(1)/2 ...
                   - (mempospol(2,1)*cos(n*mempospol(2,2)) - mempospol(mempospollength,1)*cos(n*mempospol(mempospollength,2))) * 0.5;

for i = 2:mempospollength - 1
parenthesis(i,n) = - mempospol(i,1) * n * sin(n * mempospol(i,2)) * difftheta(i)/2 ...
                   - (mempospol(i+1,1)*cos(n*mempospol(i+1,2)) - mempospol(i-1,1)*cos(n*mempospol(i-1,2))) * 0.5 ;
end

% calculate parenthesis for i = mempospollength
parenthesis(i,n) = - mempospol(mempospollength,1) * n * sin(n * mempospol(mempospollength,2)) * difftheta(mempospollength)/2 ...
                   - (mempospol(1,1)*cos(n*mempospol(1,2)) - mempospol(mempospollength-1,1)*cos(n*mempospol(mempospollength-1,2))) * 0.5;

end



% calculate erros in a_n with sum function

term = zeros(6,parameterStruct.nmax);
if j == 1
sigma_a_squared = zeros(parameterStruct.nmax,contournr);
end

for n = 1 : parameterStruct.nmax

term(1,n) = sigma_r0_squared(j) .* (a(n,j) ./ r0(j)) .^ 2; % term 1 
term(2,n) = sum( sigma_0 .* (1/(pi .* r0(j))) .^2 .* (cos(n .* mempospol(:,2)) .^2) / 2 .* difftheta(:) .^2 ); % term 2
term(3,n) = sum( (2 .* sigma_0 .^2 ./ radius(:)) .* (1 / (pi * r0(j))) .^2 .* parenthesis(:,n) .^2 ); % term 3
term(4,n) = 2 * sum( (sigma_0 .^2 / (4*pi)) .* (difftheta(:) + diffr(:)./radius(:)) .* ... % term 4
        (- a(n,j)/r0(j)) .* (1./(pi .* r0(j))) .* cos(n .* mempospol(:,2)) .* difftheta(:) );
term(5,n) = 2 * sum( (sigma_0 ^ 2 ./ (4 * pi * radius(:))) .* (difftheta(:) + diffr(:)./radius(:)) .* ... % term 5
           (- a(n,j) / r0(j)) .* (1 / (pi * r0(j))) .* parenthesis(:,n) );
term(6,n) = 2 * sum( (2 * sigma_0^2 ./radius(:) ) .* (1 / (pi*r0(j)))^2 .* cos(n .* difftheta(:)) / 2 .* difftheta(:) .* ... % term 6
           parenthesis(:,n));

sigma_a_squared(n,j) = term(1,n) + term(2,n) + term(3,n) + term(4,n) + term(5,n) + term(6,n); 
       
end

% sigma_a_squared(:,j) = term(1,:) + term(2,:) + term(3,:) + term(4,:) + term(5,:) + term(6,:); 


 end