% this program sets the working directory, i.e.: the root-directory of the
% images, the contours, etc., that will be used by the analysis-programs


path = input('Enter the directory containing the directory of the image files: ','s');

path = strrep(path, '\', '/');

% for linux
fid = fopen('config/working_directory_path.ini','w');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','w');

fprintf(fid,'%s',path);

fclose('all');

filename = input('Enter filename of images (without numeration): ','s');

% for linux
fid = fopen('config/file_name.ini','w');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','w');

fprintf(fid,'%s',filename);

fclose('all');