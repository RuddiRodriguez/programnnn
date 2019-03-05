% this program calculates the errors of the values calculated by the program
% evalu

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
a = load(sprintf('%s/results/a.txt',working_directory_path));
b = load(sprintf('%s/results/b.txt',working_directory_path));
c = load(sprintf('%s/results/c.txt',working_directory_path));
wavenumbers = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));

% load(sprintf('%s/evalu-variables.mat',working_directory_path));

% Format of the loaded data (meant as a reference):
% a=zeros(parameterStruct.nmax,contournr); % coefficients of the fouriertransformation
% b=zeros(parameterStruct.nmax,contournr); 
% c=zeros(parameterStruct.nmax,contournr);
% r0=zeros(1,contournr);
% wavenumbers=zeros(1,parameterStruct.nmax); % vector holding the wavenumbers

savedcontourslength = length(savedcontours); % length of the vector containing the indices of the saved contours


% VARIABLES
sigma_r0_squared = zeros(contournr,1);                   % vector containing the 
                                                                     % error of
                                                                     % the mean radius r0
                                                                     % of EACH contour
sigma_a_squared = zeros(parameterStruct.nmax,contournr); % vector containing the 
                                                                     % error of a_n
                                                                     % of each contour
sigma_b_squared = zeros(parameterStruct.nmax,contournr); % vector containing the 
                                                                     % error of b_n
                                                                     % of each contour
                                                   
sigma_c_squared = zeros(parameterStruct.nmax,contournr); % vector containing the 
                                                                     % error of c_n
                                                                     % of each contour
                                                   
sigma_quad_c_squared = zeros(parameterStruct.nmax,contournr); % vector containing the 
                                                                          % error of c_n^2
                                                                          % of each contour

sigma_0 = 0.1 * parameterStruct.resolution; % standard deviation of the tracked
                                            % points of the contour; this value +
                                            % is fixed empiricaly; it is set
                                            % to one tenth a pixel     


for j =  savedcontours

% load contour
mempos = load(sprintf('%s/contours/polarcontour%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates

% DEFINE VARIABLES
memposlength = length(mempos); % length of the coordinate vectors

% coordinates of the contour; taking into account the indices i = 0 and 
% i = N+1 the vectors will be augmented by these elements
r_ext = zeros(memposlength + 2,1);

r_ext(1) = mempos(end,1);
r_ext(2:end-1) = mempos(:,1);
r_ext(end) = mempos(1,1);

r = r_ext(2:end-1);

theta_ext = zeros(memposlength + 2,1);

theta_ext(1) = mempos(end,2);
theta_ext(2:end-1) = mempos(:,2);
theta_ext(end) = mempos(1,2);

theta = theta_ext(2:end-1);

% calclated the mean value of all the calculated radii r0 of the different contours
mean_r0 = mean(r0);

% fluctuation u(theta) of the membrane (seen as a function of theta)
u_ext = r_ext - mean_r0;

u = u_ext(2:end-1);


% Define variables of the derivatives

DaDr0 = zeros(parameterStruct.nmax,1);
DaDu = zeros(memposlength,parameterStruct.nmax);
DaDtheta = zeros(memposlength,parameterStruct.nmax);

DbDr0 = zeros(parameterStruct.nmax,1);
DbDu = zeros(memposlength,parameterStruct.nmax);
DbDtheta = zeros(memposlength,parameterStruct.nmax);


% calculate differences-vector 
% 1. difftheta(i) = theta(i+1) - theta(i-1)
% 2. diffr(i) = r(i-1) - r(i+1)
difftheta = zeros(memposlength,1);
diffr = zeros(memposlength,1);

% calculate difftheta(i) = theta(i+1) - theta(i-1) taking into account a possible sign
% change
for i = 2:memposlength + 1
    if theta_ext(i+1) * theta_ext(i-1) > 0
    difftheta(i-1) = abs(theta_ext(i+1) - theta_ext(i-1));
    else
    difftheta(i-1) = abs(theta_ext(i+1) + theta_ext(i-1));
    end
end

% calculate diffr(i) = r(i-1) - r(i+1)
diffr = r_ext(1:end-2) - r_ext(3:end);


% CALCULATE DERIVATIVES:

% calculate derivative Dr0/Dr := Dr0Dr; this is done for membrane position i
Dr0Dr = (1/(4*pi)) * difftheta;

% calculate derivative Dr0/Dtheta := Dr0Dtheta; this is done for membrane position
% i
Dr0Dtheta = (1/(4*pi)) * diffr;

% calculate derivative Da/Dr0 := DaDr0; this is done for each
% wavenumber n
DaDr0(:) = - a(:,j) / r0(j);

% calculate derivative Da/Du := DaDu; this is done for each
% wavenumber n and each membrane position i
for n = 1 : parameterStruct.nmax
    DaDu(:,n) = cos(n*theta) .* difftheta;
end
DaDu = DaDu * 1/(2 * pi * r0(j));

% calculate derivative Da/Dtheta := DaDtheta; this is done for each
% wavenumber n and each membrane position i
for n = 1 : parameterStruct.nmax
    DaDtheta(:,n) =   - u .* n .* sin(n * theta) .* difftheta - (u_ext(3:end) .* cos(n * theta_ext(3:end)) - u_ext(1:end-2) .* cos(n * theta_ext(1:end-2)));
end
DaDtheta(:,n) = DaDtheta(:,n) * 1/(2*pi*r0(j));



% calculate derivative Db/Dr0 := DbDr0; this is done for each
% wavenumber n
DbDr0(:) = - b(:,j) / r0(j);

% calculate derivative Db/Du := DbDu; this is done for each
% wavenumber n and each membrane position i
for n = 1 : parameterStruct.nmax
    DbDu(:,n) = sin(n*theta) .* difftheta;
end
DbDu = DbDu * 1/(2 * pi * r0(j));

% calculate derivative Db/Dtheta := DbDtheta; this is done for each
% wavenumber n and each membrane position i
for n = 1 : parameterStruct.nmax
    DbDtheta(:,n) =   u .* n .* cos(n * theta) .* difftheta - (u_ext(3:end) .* sin(n * theta_ext(3:end)) - u_ext(1:end-2) .* sin(n * theta_ext(1:end-2)));
end
DbDtheta(:,n) = DbDtheta(:,n) * 1/(2*pi*r0(j));




% CALCULATE ERRORS

% Basic Variances
sigma_r = sqrt(2) * sigma_0 * ones(memposlength,1); % errors of the radius of the membrane positions
sigma_theta = sqrt(2) * sigma_0 ./ r; % errors of the radius of the membrane positions

% Basic Covariances
cov_r0_r = sigma_r .* (Dr0Dr .* sigma_r + Dr0Dtheta .* sigma_theta);
cov_r0_theta = sigma_theta .* (Dr0Dr .* sigma_r + Dr0Dtheta .* sigma_theta);
cov_u_theta = sigma_r .* sigma_theta;

% calculate the error of the mean radius sigma_r0_squared
sigma_r0_squared(j) = sum(difftheta .^ 2 + (diffr ./ r) .^ 2 + (difftheta .* diffr) ./ r);
sigma_r0_squared(j) = sigma_r0_squared(j) * (2 * (sigma_0 ^ 2) / ((4 * pi) ^ 2));

% calculate error for a_n with error-propagation formula
for n = 1 : parameterStruct.nmax
sigma_a_squared(n,j) = DaDr0(n) .^2 .* sigma_r0_squared(j) ...
                     + sum( DaDu(:,n) .^2 .* sigma_r .^2 ) ...
                     + sum( DaDtheta(:,n) .^ 2 .* sigma_theta .^2 ) ...
                     + sum( DaDr0(n) .* DaDu(:,n) .* cov_r0_r .^2 ) ...
                     + sum( DaDr0(n) .* DaDtheta(:,n) .* cov_r0_theta .^2 ) ...
                     + sum( DaDu(:,n) .* DaDtheta(:,n) .* cov_u_theta .^2 );
end


% calculate error for b_n with error-propagation formula
for n = 1 : parameterStruct.nmax
sigma_b_squared(n,j) = DbDr0(n) .^2 .* sigma_r0_squared(j) ...
                     + sum( DbDu(:,n) .^2 .* sigma_r .^2 ) ...
                     + sum( DbDtheta(:,n) .^ 2 .* sigma_theta .^2 ) ...
                     + sum( DbDr0(n) .* DbDu(:,n) .* cov_r0_r .^2 ) ...
                     + sum( DbDr0(n) .* DbDtheta(:,n) .* cov_r0_theta .^2 ) ...
                     + sum( DbDu(:,n) .* DbDtheta(:,n) .* cov_u_theta .^2 );
end

end  % this ends the loop that cycles through the contours


