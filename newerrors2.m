% this program calculates the errors of the values calculated by the program
% evalu

% clear all;


% sets folder of the program file to have relative paths for the other
% *.ini
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

% load variables

r0 = load(sprintf('%s/results/r0.txt',working_directory_path));

% NEXT STEP IN ERROR CALCULATION; NOW ONLY DEPENDENT ON THE WAVENUMBER n
% AND THE CONTOUR INDEX j

% Calculate covariances:
% cov(a_n,r0) := cov_a_r0
cov_a_r0 = zeros(parameterStruct.nmax,1);
% calculate mean m_a of a_n and mean m_r0 of r0
m_a = zeros(parameterStruct.nmax,1);
for n = 1:parameterStruct.nmax
m_a(n) = mean(a(n,:));
end
% mean of r0:
m_r0 = mean(r0(:));
% calculate covariance
for n = 1: parameterStruct.nmax
    cov_a_r0(n) = mean( ( a(n,:) - m_a(n) ) .* ( r0(:)' - m_r0 ) );
end

% cov(b_n,r0) := cov_b_r00
cov_b_r0 = zeros(parameterStruct.nmax,1); 
% calculate mean m_b of b_n (mean of a_n is already calculated)
m_b = zeros(parameterStruct.nmax,1);
for n = 1:parameterStruct.nmax
m_b(n) = mean(b(n,:));
end
% calculate covariance
for n = 1: parameterStruct.nmax
    cov_b_r0(n) = mean( ( b(n,:) - m_b(n) ) .* ( r0(:)' - m_r0 ) );
end

% cov(a_n,b_n) := cov_a_b
cov_a_b = zeros(parameterStruct.nmax,1);
for n = 1: parameterStruct.nmax
    cov_a_b(n) = mean( ( a(n,:) - m_a(n) ) .* ( b(n,:) - m_b(n) ) );
end




% calculate errors sigma_c_squared of c_n and sigma_quad_c_squared of c_n^2;
% these errors will be calculated for all wavenumbers n and contours j
sigma_c_squared = zeros(parameterStruct.nmax,length(savedcontours)); % vector containing the 
                                                                     % error of c_n
                                                                     % of each contour
                                                   
sigma_quad_c_squared = zeros(parameterStruct.nmax,length(savedcontours)); % vector containing the 
                                                                          % error of c_n^2
                                                                          % of each contour

for j = savedcontours
sigma_c_squared(:,j) = (a(:,j).^2 ./ (a(:,j).^2 + b(:,j).^2)) .* sigma_a_squared(:,j) ...
                     + (b(:,j).^2 ./ (a(:,j).^2 + b(:,j).^2)) .* sigma_b_squared(:,j) ...
                     + ( a(:,j) .* b(:,j) ) ./ ( a(:,j).^2 + b(:,j).^2 ) .* cov_a_b(:) .^2;
                 
sigma_quad_c_squared(:,j) = 4 * a(:,j).^2 .* sigma_a_squared(:,j) ...
                          + 4 * b(:,j).^2 .* sigma_b_squared(:,j) ...
                          + 4 * a(:,j) .* b(:,j) .* cov_a_b(:) .^2;
end

% calculate errors (variances) for <r0>, <c_n>, and <c_n^2>

% error sigma_mean_r0_squared for <r0> = m_r0
sigma_mean_r0_squared = mean(sigma_r0_squared);
% NOTE: mean_r0 = mean(r0) was already calculated in newerrors.m

% error sigma_mean_quad_c_squared for <c_n^2> = m_quad_c:
% define variable holding <c_n>^2:
quad_c = c;
mean_quad_c = zeros(parameterStruct.nmax,1);
sigma_mean_quad_c_squared = zeros(parameterStruct.nmax,1);
for n = 1:parameterStruct.nmax
sigma_mean_quad_c_squared(n,:) = mean(sigma_quad_c_squared(n,:));
mean_quad_c(n) = mean(quad_c(n,:));
end

% error sigma_mean_c_squared for <c_n> = mean_c:
mean_c = zeros(parameterStruct.nmax,1);
sigma_mean_c_squared = zeros(parameterStruct.nmax,1);
for n = 1:parameterStruct.nmax
sigma_mean_c_squared(n) = mean(sigma_c_squared(n,:));
mean_c(n) = mean(c(n,:));
end

% calculate covariances
% covariance cov(<c_n^2>,<c_n>):= cov_mean_quad_c_c
cov_mean_quad_c_c = zeros(parameterStruct.nmax,1);
for n = 1:parameterStruct.nmax
cov_mean_quad_c_c(n) = mean( (quad_c(n,:) - mean_quad_c(n)) .* (c(n,:) - mean_c(n)) );
end

% covariance cov(<c_n^2>,<r0>) := cov_mean_quad_c_r0
cov_mean_quad_c_r0 = zeros(parameterStruct.nmax,1);
for n = 1:parameterStruct.nmax
cov_mean_quad_c_r0(n) = mean( (quad_c(n,:) - mean_quad_c(n)) .* (r0(:) - mean_r0)' );
end

% covariances cov(<c_n>,<r0>) := cov_mean_c_r0
cov_mean_c_r0 = zeros(parameterStruct.nmax,1);
for n = 1:parameterStruct.nmax
cov_mean_c_r0(n) = mean( (c(n,:) - mean_c(n)) .* (r0(:) - mean_r0)' ); 
end

% CALCULATE FINAL ERROR FOR FLUCTUATIONS

sigma_fluct_squared = ( (pi/2) * mean_r0^3 ) ^2 * sigma_mean_quad_c_squared ...
                     + ( (pi/2) * mean_r0^3 ) ^2 * (2 * mean_c).^2 .* sigma_mean_c_squared ...
                     + ( 3*(mean_quad_c - mean_c.^2) * (pi/2) * mean_r0^2 ).^2 .* sigma_mean_r0_squared ...
                     - 4 * mean_c * ( (pi/2) * mean_r0^3 ) ^2 .* cov_mean_quad_c_c ...
                     + mean_r0^3 * (mean_quad_c - mean_c.^2) .* ((3 * pi^2/2) * mean_r0^2 * cov_mean_quad_c_r0) ...
                     - mean_c * pi^2 * mean_r0^3 * 3 .* (mean_quad_c - mean_c.^2) * mean_r0^2 .* cov_mean_c_r0;