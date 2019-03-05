
clear
fid1=fopen('resultsdesv.txt','w+');

fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all');


fid = fopen(sprintf('%s/config/file_name.ini',program_directory_path),'rt');
filename = fscanf(fid,'%s')
fclose('all');

fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s');
fclose('all');


% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});











 fileFolder = fullfile('D:\ftp\jpg\analisis')
 
 %fileFolder = fullfile(sprintf('%s/images',working_directory_path));
 
 dirOutput = dir(fullfile(fileFolder,'images*.tif'))


% fileFolder = fullfile(matlabroot,'toolbox','images','imdemos');
% dirOutput = dir(fullfile(fileFolder,'AT3_1m4_*.tif'));

fileNames = {dirOutput.name}'
numFrames = numel(fileNames)

I =imread('D:\ftp\jpg\analisis\images01.tif');

% % Preallocate the array
sequence = zeros([size(I) numFrames],class(I));
sequence(:,:,1) = I;


% if exist(sprintf('%s/images/%s.tif',working_directory_path,filename)) == 2
%     filenumberdigits = 3;
%     filename = filename(1:end-3);
% elseif exist(sprintf('%s/images/%s.tif',working_directory_path,filename)) == 2
%     filenumberdigits = 4;
%     filename = filename(1:end-4);
% end
% 
% % check number image files in image directory; the if-query is to select
% % the adequate formatting of the file numeration
% if filenumberdigits == 3
% p=2
% contournr = 1;
% while exist(sprintf('%s/images/%s%03d.tif',working_directory_path,filename,contournr)) == 2
%     
%    sequence(:,:,contournr) = imread(fileNames{contournr});
%    p=p+1
%    contournr = contournr + 1;
%    
% end
% end
% 
% if filenumberdigits == 4
%   p=2;
%   contournr = 1;
% while exist(sprintf('%s/images/%s%04d.tif',working_directory_path,filename,contournr)) == 2
%    sequence(:,:,p) = imread(fileNames{p}); 
%    p=p+1
%    contournr = contournr + 1;
% end
% end














% Create image sequence array
for p = 2:numFrames
    sequence(:,:,p) = imread(fileNames{p}); 
end


% 
1/parameterStruct.integration_time
implay(sequence,1/parameterStruct.integration_time)


% % Process sequence
% sequenceNew = stdfilt(sequence,ones(3));
% 
% % View results
% figure;
% for k = 1:numFrames
%       imshow(sequence(:,:,k));
%       title(sprintf('Original Image # %d',k));
%       pause(1);
%       imshow(sequenceNew(:,:,k),[]);
%       title(sprintf('Processed Image # %d',k));
%       pause(1);
% end