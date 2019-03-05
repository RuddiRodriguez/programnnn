

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

xdata= load(sprintf('%s/results/wrs_modos2.txt',working_directory_path));
h=0;
contournr=2
d=0
while exist(sprintf('%s/results/Prs_modos%i.txt',working_directory_path,contournr)) == 2
   h=h+1;
   ydata= load(sprintf('%s/results/Prs_modos%i.txt',working_directory_path,contournr));
   
   
   xdata1=xdata(5:500,1);
 ydata1=ydata(5:500,1);
   coeffs    = polyfit(log10(xdata1), log10(ydata1), 1);
f=coeffs(1).*log10(xdata1)+coeffs(2) ; 
  d=d+0.3;
 figure(1)

 
%plot(xdata1,ydata1,'o')
alfa(h)=coeffs(1);

plot(log10(xdata),log10(ydata),'o',log10(xdata1),f,'k')
  title('flucts-Intervals Fourier ')
  ylabel('log F(n)')
  xlabel('log n')
  text(0.8,-1.3-d,texlabel(['slope=' num2str(coeffs(1))]))
  axis square
   
   alfa=alfa';
   
   save(sprintf('D:/DFA/coefpowerrbc%i.txt',filenamesaved),'alfa','-ascii');
   contournr = contournr + 1
end
contournr = contournr - 1;
clear
t=input('End Value = ')


filenamesaved=input('Name = ')



end
if t==0
    break;
end
