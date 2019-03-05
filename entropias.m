 function w=entropias(p1,p2,tau,m,mediafluct)

% p1=2
% p2=2
% tau=2
% m=2


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
parameterStruct;

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

a = load(sprintf('%s/results/a.txt',working_directory_path));
b = load(sprintf('%s/results/b.txt',working_directory_path));
c = load(sprintf('%s/results/c.txt',working_directory_path));
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
%mediafluct = load(sprintf('%s/results/mediafluct.txt',working_directory_path));
% sigmaR2=load(sprintf('%s/results/sigmar2.txt',working_directory_path));
mediafluct = load(sprintf('%s/results/mediafluct.txt',working_directory_path));
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
% mediafluct=mediafluct';
% tiempo1=tiempo1';
% save(sprintf('%s/results/mediafluct.txt',working_directory_path),'mediafluct','-ascii');
% save(sprintf('%s/results/tiempo.txt',working_directory_path),'tiempo1','-ascii');

point=10

r0=r0(savedcontours);

mkdir(sprintf('%s/correla',working_directory_path));


m1=p1:p2;
g=length(m1)
parametrosfit=zeros(g,1);
parametrosfitc=zeros(g,1);
parametrosfita=zeros(g,1);
q=zeros(g,1);
i=0;
d=0;
for i=p1:p2
    
    
    
  cc=mediafluct(i,1:length(savedcontours));

% m=25
%  cc=(c(m,savedcontours));
 i=i+1;
% q(i)=m./(mean(r0));
 
 r=((std(cc))*20)./100
 
 [entropies] = MSE(cc,tau,r,m);

figure(1)
hold on
n = 1:tau;
plot(n,entropies,'-o')
ylabel('Sample Entropy')
xlabel('Scale factor')
title('Entropy Fourier')
 
 
 
 
 
 
% [res] = ApEn(cc,r,m)
% [resSamp] = SampEn(cc,r,m)
end

% r=((std(r0))*20)./100
% 
% [entropies] = MSE(r0,tau,r,m);
% figure(2)
% n = 1:tau;
% plot(n,entropies,'-o')
% ylabel('Sample Entropy')
% xlabel('Scale factor')
% title('Entropy R ')
% 
% [res] = ApEn(r0,r,m)
% [resSamp] = SampEn(r0,r,m)
% 
% r=((std(mediafluct))*20)./100
% 
% [entropies] = MSE(mediafluct,tau,r,m);
% figure(3)
% n = 1:tau;
% plot(n,entropies,'-o')
% ylabel('Sample Entropy')
% xlabel('Scale factor')
% title('Entropy Pure Fluctuation')
% 
% [res] = ApEn(mediafluct,r,m)
% [resSamp] = SampEn(mediafluct,r,m)

 
