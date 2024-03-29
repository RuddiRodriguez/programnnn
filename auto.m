

% This function calculates the autocorrelation function for the 
% data set "origdata" for a lag timescale of 0 to "endlag" and outputs 
% the autocorrelation function in to "a".
%function a = auto( origdata, endlag);

function a = auto(data, endlag);

 


fid = fopen('config/program_directory_path.ini','rt')
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all')


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});

% output of parameters
parameterStruct
mkdir(sprintf('%s/correla',working_directory_path));
m=30
N=length(data);

%now solve for autocorrelation for time lags from zero to endlag
% n=0:endlag;
% a=zeros(1,n);
for lag=0:endlag
  data1=data(1:N-lag);
   data1=data1-mean(data1);
  data2=data(1+lag:N);
   data2=data2-mean(data2);
  a(lag+1) = (sum(data1.*data2)/sqrt(sum(data1.^2).*sum(data2.^2)))';
  a=a';
%   save(sprintf('%s/correla/correlation%i.txt',working_directory_path,m),'b','-ascii'); % save the contour
  clear data1
  clear data2
end
