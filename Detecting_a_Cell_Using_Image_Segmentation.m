clear


fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all');

% read working directory from config file 'working_directory_path.ini'
fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s');
fclose('all');

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);


p = which('images0001.tif');
filelist = dir([fileparts(p) filesep 'images*.tif']);
fileNames = {filelist.name}'
% 
% 
% I = imread(fileNames{1});
% imshow(I)
% text(size(I,2),size(I,1)+15, ...
%     'Image files courtesy of Alan Partin', ...
%     'FontSize',7,'HorizontalAlignment','right');
% text(size(I,2),size(I,1)+25, ...
%     'Johns Hopkins University', ...
%     'FontSize',7,'HorizontalAlignment','right');
% 
% 
I = imread(fileNames{1});

[mrows,ncols] = size(I);
nImages =3% length(fileNames);
segmentedCellSequence = zeros(mrows,ncols,nImages,class(I));

for (k = 1:nImages)    

    J = imread(fileNames{k});
    %segmentedCellSequence(:,:,k) = fcn(I); 

%J = imread('ima0004.tif');
 J = imadjust(J);
 I=J;%imcrop(J);

% I = imread('Stack0002.tif');
figure(1); imshow(I), title('original image');
text(size(I,2),size(I,1)+15, ...
    'Image courtesy of Alan Partin', ...
    'FontSize',7,'HorizontalAlignment','right');
text(size(I,2),size(I,1)+25, ....
    'Johns Hopkins University', ...
    'FontSize',7,'HorizontalAlignment','right');
[junk threshold] = edge(I, 'sobel');
fudgeFactor = .5;
BWs = edge(I,'sobel', threshold * fudgeFactor);
% figure, imshow(BWs), title('binary gradient mask');
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90 se0]);
% figure, imshow(BWsdil), title('dilated gradient mask');

BWdfill = imfill(BWsdil, 'holes');
% figure, imshow(BWdfill);
title('binary image with filled holes');

BWnobord = imclearborder(BWdfill, 4);
% figure, imshow(BWnobord), title('cleared border image');

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
% figure, imshow(BWfinal), title('segmented image');

BWoutline = bwperim(BWfinal);
Segout = I;
Segout(BWoutline) = 255;
figure(33); 
imshow(Segout), title('outlined original image');

%sequence(:,:,p) = imread(fileNames{p});

end