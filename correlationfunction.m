
% clc
% clear
fid1=fopen('tiempo1.txt','w+')


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
%savedcontours=[4 5 6 7 8];
r0=r0(savedcontours);
mkdir(sprintf('%s/correla',working_directory_path));
% c=(c(m,savedcontours))
% termino1=zeros(2,(length(c)-1))
% termino1=zeros(2,(length(c)-1))
% termino1=zeros(2,(length(c)-1))
 n=1:50;
 vv=c(n,9)
for m=3:3%parameterStruct.nmax
 vv=(c(m,savedcontours));
 cc=vv
 
 correlation=zeros((length(cc)-1),1);
 tiempo=zeros((length(cc)-1),1);
 for tao=1:(length(cc));
     ctiempo=zeros(length(cc)-tao,1);
     ctiempo1=zeros(length(cc)-tao,1);
     P=zeros(length(cc)-tao,1);
     P1=zeros(length(cc)-tao,1);
     C=zeros(length(cc)-tao,1);
     %r0=zeros(length(cc)-tao,1);
     temp=0;
     for i=1:(length(cc)-tao);
         ctiempo(i)=cc(i);
         ctiempo1(i)=cc(i+tao);
         P(i)=cc(1)*cc(i+tao);
%          sum=temp+P
%          temp=P
         P1(i)=(cc(i)-mean(cc))*(cc(i+tao)-mean(cc));
         %r0(i)=r0(i);
     end
     suma=sum(P);
     termino1=mean(abs(P));
     termino2=mean(abs(ctiempo));
     termino3=mean((abs(ctiempo)).^2);
     termino4=mean(abs(ctiempo1));
     termino6=(mean(cc))^2;
     termino7=(mean((abs(ctiempo)).^2))-((mean((abs(ctiempo))))^2);
     
     %
     %correlation(tao)=((termino1)+(termino2.*termino4))/(termino3-((mean(abs(ctiempo))).^2));
%      correlation=correlation;
%       %correlation(tao)=termino1./termino3;
      tiempo(tao)=tao.*parameterStruct.integration_time;
% %      %correlation(tao)=(((suma-termino6))./length(P))/(var(cc));
%       correlation(tao)=termino1/termino3;%*((mean(r0))^3)*pi/2;%./(length(P));
% % %      desv=std(ctiempo)
% correlation(tao)=(termino1-termino6)/var(cc);%(termino3-((mean(abs(ctiempo))).^2));
       %correlation(tao)=((((((termino3-((mean(abs(ctiempo))).^2))))*mean(r0))/2)*((2*pi*mean(r0))));
      correlation(tao)=((((suma/length(suma))/(mean(cc))^2)))*((((mean(r0))^3)*(pi/2))^(0.5));
      %correlation(tao)=suma/length(suma);
     aaa=(correlation)./correlation(1);
%      
     
     
 end
 save(sprintf('%s/correla/correlation%i.txt',working_directory_path,m),'aaa','-ascii'); % save the contour
 save(sprintf('%s/results/tiempo.txt',working_directory_path),'tiempo','-ascii')
end
figure(1)
%plot(tiempo,(aaa),'.') 
plot(tiempo,correlation/correlation(1),'.') 
 

    