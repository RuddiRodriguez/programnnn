
function h=sacaresultados1(s1,s2,s3)
fid1=fopen('resultsdesv.txt','w+')

fid = fopen('config/program_directory_path.ini','rt')
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all')


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');


% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});

% output of parameters
parameterStruct

h=waitbar (0,'Please wait....');
q=s1
for j=s2:s3
mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j));
q=q+1;
save(sprintf('%s/contour%i.txt',working_directory_path,q),'mempos','-ascii'); % save the contour
waitbar(j/s3);
end
close (h)









