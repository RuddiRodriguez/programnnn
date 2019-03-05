
 [FileName,PathName,FilterIndex] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'mytitle',...
          'C:/Ruddi')

 fileFolder = fullfile(matlabroot,'toolbox','images','imdemos');
dirOutput = dir(fullfile(PathName,'FigureDistri*.tif'));
fileNames = {dirOutput.name}';
numFrames = numel(fileNames);

I = imread(sprintf('%s/FigureDistri710.tif',PathName));

% Preallocate the array
sequence = zeros([size(I) numFrames],class(I));
sequence(:,:,:,1) = I;
q=1
% Create image sequence array
for p = 712:2:790
    q=q+1;
    sequence(:,:,:,p) = imread(sprintf('%s/FigureDistri%i.tif',PathName,p));; 
end

% Process sequence
sequenceNew = stdfilt(sequence,ones(3));

% View results
figure;
for k = 1:numFrames
      imshow(sequence(:,:,k));
      title(sprintf('Original Image # %d',k));
      pause(1);
      imshow(sequenceNew(:,:,k),[]);
      title(sprintf('Processed Image # %d',k));
      pause(1);
end