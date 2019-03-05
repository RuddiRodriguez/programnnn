fileFolder = fullfile('D:','analisis');
dirOutput = dir(fullfile(fileFolder,'images*.TIF'));
fileNames = {dirOutput.name}';
numFrames = numel(fileNames);

I = imread(fileNames{1});