clear
t=input('End Value = ')
filenamesaved=input('Name = ')

while t==1
     


fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all');

% read working directory from config file 'working_directory_path.ini'
fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s');
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
fileextensions = {'*.tif','tif';'*.*','All Files'};
[filename,pathname,filterindex] = uigetfile(fileextensions,'Open First Image File',working_directory_path);

if filename ~= 0 | pathname ~=0 % check whether the load dialog was canceled or not
% remove the 'image\' part from pathname to get the working-folder
pathname = pathname(1:end - 7);
pathname = strrep(pathname, '\', '/');

%
if strcmp('',pathname) == 0
handles.working_directory_path = pathname;
end

% remove file extension from filename including dot
filename = filename(1:end - (length(fileextensions{filterindex,2}) + 1));

% save pathname to 'working_directory_paht.ini'
fid = fopen('config/working_directory_path.ini','w');
fprintf(fid,'%s',pathname);
fclose('all');

% save filename to 'file_name.ini'
fid = fopen('config/file_name.ini','w');
fprintf(fid,'%s',filename);
fclose('all');
end
% output of parameters
parameterStruct;


h=0;
contournr=2
while exist(sprintf('%s/complex/entropias_modos%i.txt',working_directory_path,contournr)) == 2
   
   data= load(sprintf('%s/complex/entropias_modos%i.txt',working_directory_path,contournr));
   h=h+1;
   for j=1:length(data)
       variable(j,h)=data(j);
   end
   
   
   
   contournr = contournr + 1;
end
contournr = contournr - 1;



t=input('End Value = ')

save(sprintf('D:/entropia/mediag1/media%i.txt',filenamesaved),'variable','-ascii');
filenamesaved=input('Name = ')
clear('variable');
end




if t==0
    break;
end


    
% variable = zeros(101,1)
% 
% for j = 1:contournr
    
