

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

m=2:4%parameterStruct.nmax;
tiempo = load(sprintf('%s/results/tiempo.txt',working_directory_path));
n=1:length(tiempo)-1;
xdata=tiempo(n,1);
ftype= fittype('a*exp(-b*x)^(2/3)-c');
parametrosfit=zeros(m,1);
for j = 1:parameterStruct.nmax%length(savedcontours)
    correlation = load(sprintf('%s/correla/correlation%i.txt',working_directory_path,savedcontours(j)));
    ydata=correlation(n,1);
    [fresult,gof,output] =fit(xdata,ydata,ftype);
    f=feval(fresult,xdata);
    parametrosfit(j)=fresult.b;
     figure(1)
     plot(tiempo,correlation,'.',xdata,f,'k');
     hold on;
    
   
end 
%plot(m,abs(parametrosfit),'.')
hold off;