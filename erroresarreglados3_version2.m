
clear;
fid1=fopen('resultsdesv.txt','w+');

fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all');


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s');
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
sigma2u=zeros(parameterStruct.nmax,1);
sigma2cnmodulo2_1=zeros(parameterStruct.nmax,1);
variii=zeros(parameterStruct.nmax,1);
%sigma2u=zeros(5,1);
sigma2cn2modulo=zeros(50,length(savedcontours));
sigma2q=zeros(50,length(savedcontours));
sigmacne=zeros(50,length(savedcontours));

%m=3%for m=1:3
for m=1:parameterStruct.nmax
cc=zeros(50,length(savedcontours));
aa=zeros(50,length(savedcontours));
bb=zeros(50,length(savedcontours));   


cc=(c(m,savedcontours));
aa=(a(m,savedcontours));
bb=(b(m,savedcontours));



sumatheta=zeros(length(savedcontours),1);
sumarho=zeros(length(savedcontours),1);
sumarhotheta=zeros(length(savedcontours),1); 
sigmaR2=zeros(length(savedcontours),1);
sigma2an=zeros(length(savedcontours),1);
sigma2bn=zeros(length(savedcontours),1);
sigma2cn=zeros(length(savedcontours),1);
sigma2cnsq=zeros(length(savedcontours),1);
% sumaan1=zeros(length(savedcontours),1);
% sumaan2=zeros(length(savedcontours),1);

R=zeros(length(savedcontours),1);
 for j = 1:length(savedcontours)
mempospol = load(sprintf('%s/contours/polarcontour%i.txt',working_directory_path,savedcontours(j))); % load the membrane position in polar coordinates
mempospollength = length(mempospol);
savedcontourslength=length(savedcontours);

mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j));


% VARIABLES:
L = 0; % length of circumference
memposlength1 = length(mempos); % length of the vector mempos
%mempospol = zeros(memposlength1,2); % vector containing the membrane position in polar coordinates
ds = zeros(memposlength1,1); % vector containing the distances between neighbooring membrane positions
sumds = zeros(memposlength1,1); % vector containing sum between ds(i) and ds(i + 1)
center = zeros(1,2); % center of the vesicle


% % calculate length of circumference
% for i = 1:memposlength1 - 1
%    ds(i + 1) = sqrt((mempos(i + 1,1) - mempos(i,1))^2 + (mempos(i + 1,2) - mempos(i,2))^2);
%    L = L + ds(i);
% end
% % to get the last part between the end and starting point of tracked
% % contour
% ds(1) = sqrt((mempos(1,1) - mempos(i + 1,1))^2 + (mempos(1,2) - mempos(i + 1,2))^2); 
% L = L + ds(1);
% 
% 
% 
% % calculate the center position of the contour
% 
% for i = 1:memposlength1 - 1
% sumds(i) = ds(i) + ds(i + 1);
% end
% % to get the last part between the end and starting point of tracked
% % contour
% sumds(i + 1) = ds(i + 1) + ds(1);
% 
% center(1) = (1/(2*L)) * mempos(:,1)' * sumds;
% center(2) = (1/(2*L)) * mempos(:,2)' * sumds;
% 
% 
% % transformation of coordinate origin to center of vesicle
% 
% mempos(:,1) = (mempos(:,1) - center(1))* parameterStruct.resolution;
% mempos(:,2) = (mempos(:,2) - center(2))* parameterStruct.resolution;
% 
% %sigma0=std(mempos(:,1)./sqrt(2))


n=1:mempospollength;
rho=mempospol(n,1);
theta=mempospol(n,2);
thetar=zeros(length(theta),1);

for b1=1:length(theta)
    if (theta(b1)>2*pi)& (theta(b)>0)
        thetar(b1)=theta(b1)-(2*pi);
    end
    
    if (theta(b1)>2*pi)& (theta(b1)<0)
        thetar(b1)=abs(theta(b1))-(2*pi);
    end
    
    if (theta(b1)<2*pi)& (theta(b1)>0)
        thetar(b1)=(theta(b1));
    end
    
    if (theta(b1)<2*pi)& (theta(b1)<0)
        thetar(b1)=abs(theta(b1));
    end
end
        
        
    
factor1=zeros(length(rho)-1,1);
factor11=zeros(length(rho)-1,1);
factor2=zeros(length(rho)-1,1);
factor3=zeros(length(rho)-1,1);
factor4=zeros(length(rho)-1,1);
factor5=zeros(length(rho)-1,1);
factor6=zeros(length(rho)-1,1);
factor7=zeros(length(rho)-1,1);
termino9=zeros(length(rho)-1,1);
termino10=zeros(length(rho)-1,1);
termino11=zeros(length(rho)-1,1);
termino12=zeros(length(rho)-1,1);
termino13=zeros(length(rho)-1,1);
termino14=zeros(length(rho)-1,1);
termino15=zeros(length(rho)-1,1);
termino16=zeros(length(rho)-1,1);
termino17=zeros(length(rho)-1,1);
termino18=zeros(length(rho)-1,1);


%Calculo del radio 
g=0;
for g=1:(length(rho)-1)
    factor2(g)=(rho(g)+rho(g+1));%/2;
    
end
 ulti=rho(g+1)+rho(1);
 g=0;
for g=1:(length(rho)-1)

    
end
ultidiff=abs(thetar(1)-thetar(g+1));
% temp=0
% for k=1:(length(rho)-1)
%     sumar=(rho(k)+rho(k+1))*(thetar(k+1)-thetar(k));
%     sumar=sumar+temp
%     temp=sumar
%     last=(rho(k)+rho(1))*(thetar(1)-thetar(k))
%     R=(1/(4.*pi))*(temp+last)
% end

factor3=abs(diff(thetar));
sumar=((sum(factor2.*factor3)));
R(j)=(1/(4.*pi)).*(((sum(factor2.*factor3)))+((ulti.*ultidiff)));

%Calculo de sigma cuadrado R
g=0;
for g=2:(length(rho)-1)
factor4(g)=thetar(g+1);
factor5(g)=thetar(g-1);
end


% factor4-factor5
% temp=0
% for d=2:(4)
%     prueba=thetar(d+1)-thetar(d-1)
%     
% end


%sumatheta(j)=2.*(sigma0.^2).*sum(((((factor4-factor5)).^2)/(4.*pi)).^2);
sumatheta(j)=sum((((factor4-factor5)./(4*pi)).^2).*(2.*(sigma0.^2)));
sumatheta(j)=sum((((factor4-factor5)./(4.*pi)).^2).*(2.*(sigma0.^2)));



% factor1=zeros(length(rho)-1,1); 
% 
g=0;
for g=2:(length(rho)-1)
factor6(g)=rho(g+1);
factor7(g)=rho(g-1);
end

g=0;
  for g=2:(length(rho)-1)
      factor1(g)=(2*((sigma0).^2))./((rho(g)).^2);
      factor11(g)=(2*((sigma0).^2))./((rho(g))); 
  end
 sumarho(j)=sum((((factor7-factor6).^2)/((4.*pi).^2)).*factor1);
 sumarhotheta(j)=sum((((abs(factor4-factor5)).*abs((factor7-factor6)))./((4.*pi)^2)).*factor11);
 sigmaR2(j)= sumatheta(j)+sumarho(j)+(2.*sumarhotheta(j));
 sigmaR21=sigmaR2(j);
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%bien
 factor1=zeros(length(rho)-1,1);
 factor2=zeros(length(rho)-1,1);
%  
%  %Calculo de sigma cuadrado an
  sigmar0=sigmaR21;%1.41.*(sigma0);
  termino8=sigma0.*(((aa(j))./sigmar0).^2);
  
  
  g=0;
  for g=2:(length(rho)-1)
      termino9(g)=((cos(m.*thetar(g)))^2)./2;
        
  end
  
  
  termino1suma1=sigmar0.*((aa(j)./r0(j)).^2);%(((sigmar0).^1).*(((aa(j))./r0(j)).^2));
  termino2suma2=(sigma0.^2).*((1./(pi.*r0(j))).^2);
  termino3suma3=(factor4-factor5).^2;
  
%   sumaan1=sum(((sigmar0.^2).*((aa(j)/(pi.*r0(j))).^2)).*(((factor4-factor5).^2).*termino9));     
%   sumaan1=(((sigmar0).^2).*((aa(j)./r0(j)).^2))+sum (((sigma0.^2).*((1./(pi.*r0(j))).^2)).*(((factor4-factor5).^2).*termino9));
% g=0 
% temp=0
% for g=2:(length(rho))
%     summm=termino2suma2.*termino3suma3.*termino9(g);
%     temp=summm+temp;
% end 
  sumaan1=termino1suma1+sum(termino2suma2.*termino3suma3.*termino9);
  
  
  
  for s2=2:(length(rho)-1)
      termino10(s2)=-m.*rho(s2).*sin(m.*thetar(s2));
                
  end
  
  for s3=2:(length(rho)-1)
      termino11(s3)=rho(s3+1).*cos(m.*thetar(s3+1));
                
  end
  
  
  for s4=2:(length(rho)-1)
      termino12(s4)=(rho(s4-1)*cos(m*thetar(s4-1)));%./2;
                
  end
  
  for s5=2:(length(rho)-1)
      termino13(s5)=1/(rho(s5));
                
  end
  
  
  
  sumaan2=sum(((termino13.^1).*(2.*(sigma0.^2)).*(1./((pi.*r0(j)).^2))).*((((termino10.*(abs(factor4-factor5)))-termino11-termino12)./2).^2));%sum(((termino13.^1).*(2.*(sigma0^2))).*(((1/(pi.*r0(j))).^2)).*((((termino10.*(factor4-factor5))-termino11-termino12)./2).^2));%((((termino10.*(factor4-factor5))-termino11-termino12)./2).^2));
  
  for s5=2:(length(rho)-1)
      termino13(s5)=1/(rho(s5));
                
  end
  
  for s6=2:(length(rho)-1)
      termino14(s6)=cos(m*thetar(s6));
                
  end
  
  
  sumaan3=2.*sum((((sigma0.^2)./(4.*pi)).*((((abs(factor4-factor5)))+(((abs(factor7-factor6))).*termino13)))).*((((-(aa(j))./r0(j))).*(1/(pi.*r0(j)))).*termino14.*((abs(factor4-factor5)))));
  
  
  for s7=2:(length(rho)-1)
      termino15(s7)=-m*rho(s7).*sin(m*thetar(s7));
                
  end
  
  for s8=2:(length(rho)-1)
      termino16(s8)=(rho(s8+1)*(cos(m*thetar(s8+1))))+((rho(s8-1)*cos(m*thetar(s8-1))))/2;
                
  end
  
  factor1=(abs(factor4-factor5))+((abs(factor7-factor6)).*(termino13));
  factor2=termino15.*((factor4-factor5)./2);
  
  sumaan4=2.*sum((((((sigma0).^2)./(4.*pi)).*termino13).*factor1.*(((-aa(j))./(r0(j)))).*((1./(pi.*r0(j)))).*(factor2-termino16)));
  
  
  for s9=2:(length(rho)-1)
      termino18(s9)=(cos(m*thetar(s9)))./2;
      
  end
  
  
  sumaan5=2.*sum((((2.*(sigma0.^2)).*termino13).*(1./((pi.*r0(j)).^2)).*termino18.*(abs(factor4-factor5)).*(factor2-termino16)));
  
  sigma2an(j)=sumaan1+sumaan2+sumaan3+sumaan4+sumaan5;
  
  
  
  
  %  %Calculo de sigma cuadrado bn
  factor1=zeros(length(rho)-1,1);
 factor2=zeros(length(rho)-1,1);
  
  sigmar0=sigmaR21;%1.41.*sigma0;
  termino8=sigma0.*(((bb(j))./sigmar0).^2);
  
  for s1=2:(length(rho)-1)
      termino9(s1)=((sin(m.*thetar(s1)))^2)./2;
                
  end
  termino1suma1=(((sigmar0).^1).*((bb(j)./r0(j)).^2));
  termino2suma2=(sigma0.^2).*((inv(pi*r0(j)))^2);
  termino3suma3=(factor4-factor5).^2;
  
  sumabn1=termino1suma1+sum(termino2suma2.*termino3suma3.*termino9);
  
  for s2=2:(length(rho)-1)
      termino10(s2)=m.*rho(s2).*cos(m.*thetar(s2));
                
  end
  
  for s3=2:(length(rho)-1)
      termino11(s3)=rho(s3+1).*sin(m.*thetar(s3+1));
                
  end
  
  
  for s4=2:(length(rho)-1)
      termino12(s4)=(rho(s4-1)*sin(m*thetar(s4-1)));
                
  end
  
  for s5=2:(length(rho)-1)
      termino13(s5)=1/(rho(s5));
                
  end
  
  sumabn2=sum(((termino13.^1).*(2.*(sigma0^2))).*(((1/(pi.*r0(j))).^2)).*((((termino10.*(abs(factor4-factor5)))-termino11-termino12)./2).^2));
  
  for s5=2:(length(rho)-1)
      termino13(s5)=1/(rho(s5));
                
  end
  
  for s6=2:(length(rho)-1)
      termino14(s6)=sin(m*thetar(s6));
                
  end
  
  
  sumabn3=2.*sum((((sigma0.^2)./(4.*pi)).*(((factor4-factor5))+(((abs(factor7-factor6))).*termino13))).*((((-bb(j))./r0(j))).*(1/(pi.*r0(j)))).*termino14.*((abs(factor4-factor5))));
  
  
  for s7=2:(length(rho)-1)
      termino15(s7)=m*rho(s7).*cos(m*thetar(s7));
                
  end
  
  for s8=2:(length(rho)-1)
      termino16(s8)=(rho(s8+1)*m*(sin(m*thetar(s8+1))))+((rho(s8-1)*sin(m*thetar(s8-1))))/2;
                
  end
  
  factor1=(abs(factor4-factor5))+((abs(factor7-factor6)).*(termino13));
  factor2=termino15.*((factor4-factor5)./2);
  
  sumabn4=2.*sum((((((sigma0).^2)./(4.*pi)).*termino13).*factor1.*(((-bb(j))./(r0(j)))).*((1./(pi.*r0(j)))).*(factor2-termino16)));
  
  
  for s9=2:(length(rho)-1)
      termino18(s9)=(-sin(m*thetar(s9)))./2;
      
  end
  
  
  sumabn5=2.*sum((((2.*(sigma0.^2)).*termino13).*(1./((pi.*r0(j)).^2)).*termino18.*(abs(factor4-factor5)).*(factor2-termino16)));
  
  sigma2bn(j)=sumabn1+sumabn2+sumabn3+sumabn4+sumabn5;
  raiz=sqrt(((aa(j)).^2)+((bb(j)).^2));
  stdan=sqrt(-sigma2an(j));
  stdbn=sqrt(sigma2bn(j));
 cova=(2*abs(aa(j))*abs(bb(j))*stdbn*stdan/(raiz^2));
    sigma2cn(j)=abs(((aa(j)./raiz).*(stdan))+((bb(j)./raiz).*(stdbn)));%lineal
    
 sigma2cn(j)=abs(((aa(j).^2./raiz.^2).*(stdan^2))+((bb(j)^2./raiz^2).*(stdbn^2)))+(2*abs(aa(j))*abs(bb(j))*stdbn*stdan/(raiz^2));
%    sigma2cn(j)=(sigma2cn(j)-mean(sigma2cn)).^1;
   
  sigma2cnsq(j)=abs((2.*aa(j).*(stdan))+(2.*bb(j).*(stdbn)));%cuadrado
  sigma2cnsq(j)=abs(((2.*aa(j).*(stdan))^2)+((2.*bb(j).*(stdbn)))^2)+(2*2*abs(aa(j))*abs(bb(j))*stdbn*stdan);

  sigmacne(m,j)=abs(((aa(j)./raiz).*(stdan))+((bb(j)./raiz).*(stdbn)));
 
 
 
    

%     (3.*(pi./2).*((mean(r0))^2).*((mean(cc.^2))-(mean(cc)).^2)).^2
    
 

  end
 
%  cov=1cov(sigma2an,sigmaR2)
 
 
 sigma2cnmodulo2=(1/(j^2)).*sum((sigma2cnsq).^1);%cuadrado
 sigmacnlineal=(1/((j)^2)).*sum((sigma2cn).^1);%lineal
% sigmacnlineal=(sigma2cn.^1)-((mean(sigma2cn))^1);
 sigmaR2mean=(1/(j^2)).*sum(sigmaR2);
%  sigma2q(m)=(sigmaR2.*(m^2))./(mean(r0)^4);
 
 cov1=sqrt(sigma2cnmodulo2*sigmacnlineal);
 cov2=sqrt(sigma2cnmodulo2*sigmaR2mean);
 cov3=sqrt(sigmacnlineal*sigmaR2mean);





 %calculo de sigma2u
 R=mean(r0);
  termino20=(((pi/2)*R^3)^2).*sigma2cnmodulo2;%(((pi/2).*((mean(r0))^3))^2).*sigma2cnmodulo2;
  
  termino21=(((pi/2)*R^3)^2).*((2.*mean(cc)).^2).*sigmacnlineal;%((((pi/2).*((mean(r0))^3)))^2).*((2.*mean(cc)).^2).*sigmacnlineal;
  
  termino22=(3.*(((mean(cc.^2))-((mean(cc)).^2))).*(((pi/2).*(R.^2))^2)).*(sigmaR2mean);
  
  termino23=4*mean(cc)*(((pi/2).*(R^3))^2).*cov1;
  
  termino24=R.^3.*((mean(cc.^2))-((mean(cc)).^2));
  
  termino25=((3*(pi^2))/2).*R^2.*cov2;
  
  termino26=mean(cc).*(pi^2).*(R^3).*3.*((mean(cc.^2))-((mean(cc)).^2));
  
  termino27=R^2.*cov3;
  
  sigmacnlineal_1(m)=(sigmacnlineal)'.*((((mean(r0)).^3).*pi)./2);
  
  sigma2u(m)=termino20+termino21+termino22-termino23+(termino24*termino25)-(termino26*termino27);
  sigma2u(m)=sqrt(sigma2u(m));
  variii(m)=var(cc);
% save(sprintf('%s/results/wavenumbers.txt',working_directory_path),'wavenumbers','-ascii')
% 
% save(sprintf('%s/results/a.txt',working_directory_path),'a','-ascii')
 
%  save(sprintf('%s/results/sigmacn%i.txt',working_directory_path,m),'sigma2cn','-ascii')
%  sigmacne(m)=sigma2cn
end
% varianzacn=sigmacnlineal1(m).*(((mean(r0).^3).*pi)./2);
save(sprintf('%s/results/errores.txt',working_directory_path),'sigma2u','-ascii')
save(sprintf('%s/results/sigmar2.txt',working_directory_path),'sigmaR2','-ascii')
 save(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path),'sigmacnlineal_1','-ascii')
msgbox(sprintf('Finish'));
%end
% figure(7)
% semilogy(wavenumbers,fluctuations,'.')
% hold on;
% errorbar(wavenumbers,fluctuations,sigma2u)
% hold off