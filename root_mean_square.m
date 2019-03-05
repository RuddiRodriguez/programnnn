
function RMSmode=root_mean_square(F,j,jfinal,algo)


fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all')


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s');
fclose('all');

mkdir(sprintf('%s/results_modos',working_directory_path));
mkdir(sprintf('%s/complex',working_directory_path));

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});

% output of parameters


savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

 a = load(sprintf('%s/results/a.txt',working_directory_path));
 b = load(sprintf('%s/results/b.txt',working_directory_path));
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
s1=j;    
s2=jfinal;
s3=1000;

r0=r0(savedcontours);
r0=mean(r0);
tiempo=zeros(1,length(savedcontours));
mkdir(sprintf('%s/correla',working_directory_path));
p=0;
variable=zeros(length(savedcontours),3);
for j = savedcontours
    p=p+1;
   
variable(p+1,1)=( (1/F).*j);

%    
 end

m1=s1:s2;
g=length(m1);
parametrosfit=zeros(g,1);
parametrosfitc=zeros(g,1);
parametrosfita=zeros(g,1);
% q=zeros(g,1);
i=0;
tiempo=tiempo';
%h1=waitbar (0,'Please wait.........')
% tiempo=(parameterStruct.integration_time*(0:s3))';
w=0;
for m1=s1:s2
% m=25
 cc=(c(m1,savedcontours));
 aa=(a(m1,savedcontours));
 bb=(b(m1,savedcontours));
 cc=cc';
 aa=aa';
 bb=bb';
 i=i+1;
 for i=1:length(aa)
     variable(i+1,2)=aa(i);
     variable(i+1,3)=bb(i);
     
 end
 save(sprintf('%s/correla/data%i.txt',working_directory_path,m1),'variable','-ascii');

  if algo==2
     rmsd_scr_interent_velocity(m1,cc,F);
 end
 if (algo==0)
rmsd_scr_interent_modos;
w=w+1;
 end
 
 if (algo==1)
exponentesfractal(m1,cc)
 H = genhurst(cc)
 H1= wfbmesti(cc)
%[hurst] = estimate_hurst_exponent(cc)
 end
 if (algo==2)
     w=w+1;
rmsd_scr_interent_gauss_parameter
 end
%waitbar (m1/s2)
% h=auto1(ccc',s3);
% tiempo=(parameterStruct.integration_time*(0:s3))';
end
%close(h1)
% for h=1:length(potencial) 
%     potencialto(h,w)=potencial(h);
% end
% 
% delta=83.5
% intervalos=[2:8].*delta;
% r0=r0.*1e6; 
% modos=s1:s2; 
% q=modos./r0;
% landa=((2.*pi)./q);
% landa=landa';
% gauss_parameter_modo=gauss_parameter_modo';
%  figure (5)
% plot(landa,gauss_parameter_modo,'-o')
% hold on
% %plot(intervalos,2,'*')
% save(sprintf('%s/results/gauss_parameter%i.txt',working_directory_path,d),'gauss_parameter_modo','-ascii');
% save(sprintf('%s/results/landa%i.txt',working_directory_path,d),'landa','-ascii');
