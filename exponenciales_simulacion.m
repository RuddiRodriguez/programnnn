
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
r0=r0(savedcontours);
r0=mean(r0);
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



%r0=r0(savedcontours);

mkdir(sprintf('%s/correla',working_directory_path));
% m=12;
correla = cell(5,1);

i=0;
for j = 20:30
    i=i+1;
    correla{i} = load(sprintf('%s/correla/correlation%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates
end

tiempo= load(sprintf('%s/correla/tiempo.txt',working_directory_path));
%gg=2;
length(correla)
 h = correla{2};

n=1:3000;
ydata=h(n,1);
xdata=tiempo(n,1);

x=tiempo;
f=12;
f1=0.5;
expo=0.2;
A=0.3;
A1=1

yexpo=A1.*exp(-f.*x);
yexpostretched=A1.*exp(-(f.*x).^expo);
yexpostretchedfija=A1.*exp(-(f.*x).^0.667);
ydoblestretched=(1-A).*exp(-(f.*x).^expo)+A.*exp(-f1*x);
ydoble=(1-A).*exp(-f.*x)+A.*exp(-f1.*x);
figure (305)
%semilogx(x,y,'b',x,y1,'r',x,y2,'o',x,y3,'g')
semilogx(xdata,ydata,'o',x,yexpo,'-b',x,yexpostretched,'-r',x,ydoblestretched,'-g',x,ydoble,'-k')
legend('data','expo','expostretched','doblestretched','doble')