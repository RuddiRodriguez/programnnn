function velocity=rmsd_scr_inernet_velocity(m1,cc,F)

fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all')


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
mkdir(sprintf('%s/results_puntos',working_directory_path));
mkdir(sprintf('%s/results_puntos/tiempo4',working_directory_path));
mkdir(sprintf('%s/results_puntos_response',working_directory_path));
m1=0;

T=length(cc)/F           %maximum time
h=T/length(cc);          %time step
t1=(0:h:T); 
t1=t1(1:length(t1)-1);%
sigma=1.0;
%strength of noise
fs=F;     %strength of noise
variable=zeros(length(cc),2);

% x=zeros(size(t));   %place to store x location
% y=zeros(size(t));   %place to store y loaction
% 
% x(1)=0.0;           %initial x location
% y(1)=0.0;           %initial y location

% for i=1:N
%     x(i+1)=x(i)+sigma*sqrt(h)*randn;
%     y(i+1)=y(i)+sigma*sqrt(h)*randn;
% end

t=80;
px=cc;%(1:4000);
py=cc;
 %px=px-(mean(px));
 px=detrend(px,'linear',40)
% bins=sqrt(length(px));
variable(:,1)=t1;

variable(:,2)=px;

%save(sprintf('%s/results_puntos/radiocoordenadas%i.txt',working_directory_path,m1),'variable','-ascii');
AutoCorr_Vel_Par = AutoCorr_Vel(cc,t1,50)