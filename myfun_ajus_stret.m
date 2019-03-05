function F =myfun_ajus_stret(x)



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

% output of parameters


savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

% a = load(sprintf('%s/results/a.txt',working_directory_path));
% b = load(sprintf('%s/results/b.txt',working_directory_path));
c = load(sprintf('%s/results/c.txt',working_directory_path));
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
% fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
% sigmaR2=load(sprintf('%s/results/sigmar2.txt',working_directory_path));

% j=0
% q=0
% mediafluct=zeros(1,length(savedcontours));
% tiempo=zeros(1,length(savedcontours));
% w = waitbar(0,'Please wait...');
% for j = savedcontours
%     q=q+1;
% mempospol = load(sprintf('%s/memposs/mempos%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates
% n=1:length(mempospol);
% fluctpura=mempospol(n,1);
% 
% mediafluct(q)=(sum((fluctpura).^2))/(length(fluctpura));%(mean(((fluctpura)).^2))-((mean((fluctpura))).^2);    %mean(fluctpura)%  (sum((fluctpura).^2))/(length(fluctpura))
% %savedcontours=[4 5 6 7 8];
% tiempo1(q)=(parameterStruct.integration_time.*j);
% waitbar (j/length(savedcontours))
% end
% close(w)
% mediafluct=mediafluct;
% mediafluct=smooth(mediafluct,'moving')

% tiempo1=tiempo1';
% save(sprintf('%s/results/mediafluct.txt',working_directory_path),'mediafluct','-ascii');
% save(sprintf('%s/results/tiempo.txt',working_directory_path),'tiempo1','-ascii');



r0=r0(savedcontours);

mkdir(sprintf('%s/correla',working_directory_path));
m=12;
correla = cell(m,1);

parametrosfit=zeros(m,1);
parametrosfitc=zeros(m,1);
parametrosfita=zeros(m,1);
 parametrosfitexpo=zeros(m,1);
% q=zeros(g,1);
i=0;
f3=100;
m=12;
for j = 2:m
    i=i+1;
    correla{i} = load(sprintf('%s/correla/correlation%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates
end
tiempo= load(sprintf('%s/correla/tiempo.txt',working_directory_path));
gg=2;
%for gg=1:length(correla)
    h = correla{gg};

n=2:1000;
ydata=h(n,1);
xdata=tiempo(n,1);
x(5)=0;
%x(3)=0.667
teorica=(1-x(1)).*exp(-(x(2).*xdata).^x(3))+x(1).*exp(-x(4)*xdata)+x(5);
Res=ydata-teorica;
F=0.5.*sum(Res.^2); 
figure(gg)  
     semilogx(xdata,teorica,'-r',xdata,ydata,'o','LineWidth',2,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
     %semilogx(xdata,ydata,'-o',xdata,teorica,'-k');
     title('Autocorrelation function (fourier)')
     xlabel('Time (s)')
     ylabel('G (u.a)')
     text(0.002,0.5,sprintf('Amplitud=%2.3e\n Frecuencia1=%2.3e\n Beta=%2.3e\n Frecuencia2=%2.3e',x(1),x(2),x(3),x(4)))
%end

 

