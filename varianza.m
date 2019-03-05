


clear
fid1=fopen('resultsdesv.txt','w+')

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

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
sigma0=(0.1*parameterStruct.resolution);%1e-007
a = load(sprintf('%s/results/a.txt',working_directory_path));
b = load(sprintf('%s/results/b.txt',working_directory_path));
c = load(sprintf('%s/results/c.txt',working_directory_path));
wavenumbers = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
%savedcontours=[4 5 6];
r0=r0(savedcontours);
%sigma2u=zeros(parameterStruct.nmax,1);
% sigma2u=zeros(5,1);
% sigma2cn2modulo=zeros(50,length(savedcontours));
%
vari=zeros(50,1);
hh=zeros(50,1);
%m=3%for m=1:3
for m=1:parameterStruct.nmax
cc=zeros(50,length(savedcontours));
aa=zeros(50,length(savedcontours));
bb=zeros(50,length(savedcontours));   


cc=(c(m,savedcontours));
aa=(a(m,savedcontours));
bb=(b(m,savedcontours));
varian=0;
varians=0;
temp=0;
hh(m)=var(cc);
for j =1:length(savedcontours)
%     cc(j);
%     cc;
varian=((cc(j)-mean(cc))^2);%/((length(savedcontours)-1));
varians=varian+temp;
temp=varians;
end
vari(m)=temp./(length(savedcontours)-1);



end

termino=vari.*pi*(mean(r0).^3)./2;

save(sprintf('%s/results/varianza.txt',working_directory_path),'termino','-ascii')