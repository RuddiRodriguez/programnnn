% this program shows the current path for the membrane tracking programs

clear all; %clear all variables

% sets the rootpath of the files being analyzed; ie: the directory
% containing the image directory
% for windows
% fid = fopen('D:/membrane_tracking_project/medidas/workingdirectory.txt','rt'); 
% for linux
% fid =fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
fid =fopen('config/working_directory_path.ini','rt');
path = fscanf(fid,'%s')
fclose('all');

% sets filename of the files being analyzed
% for windows
% fid = fopen('D:/membrane_tracking_project/medidas/filename.txt','rt'); 
% for linux
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt'); 
fid =fopen('config/file_name.ini','rt');
filename = fscanf(fid,'%s')
fclose('all');
