function Histogram_Par = Histogram(Data)
% Function to calculate Histogram of displacements,
% Data in input is displacements of particle motion.

% Assign a number of bins to histogram 
Bins = sqrt(numel(Data));

% Calculate Histgram
Histogram_Par.X = min(Data):(max(Data)-min(Data))/Bins:max(Data);
Histogram_Par.Y = hist(Data,Histogram_Par.X); 





