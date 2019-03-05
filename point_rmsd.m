function RMSDP=point_rmsd(F,point,mediafluct,algo)

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
% output of parameters
parameterStruct;
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
variable=zeros(length(savedcontours),2);
p=0
for j = savedcontours
    p=p+1;
    variable(p+1,1)=((1/F).*j);
%    
 end


% m1=point;
mkdir(sprintf('%s/diff',working_directory_path));
% fff=zeros(length(m1),100);
w=0
for m1=point
  cc=mediafluct(m1,1:length(savedcontours));
  i=0;
  for i=1:length(cc)
     variable(i+1,2)=cc(i);
  end
% save(sprintf('%s/correla/datapuntos%i.txt',working_directory_path,m1),'variable','-ascii');
%cc=1:20
gg2=1;
i=0;
u=zeros(1,length(savedcontours));
u3=zeros(1,length(savedcontours));
tiempo1=zeros(1,length(savedcontours));

% rm3=auto1(cc,100);
 if (algo==0)
rmsd_scr_interent;


 w=w+1;
 
 
% for h=1:length(Pxx) 
%     PSD(h,w)=Pxx(h);
% end

% for h=1:length(entropies) 
%     E(h,w)=entropies(h);
% end
% Z (w)= trapz(entropies)
 end
 
 if algo==2
     rmsd_scr_interent_velocity(m1,cc,F);
 end
     
 j=0;
 for j=1:length(RMSD)
     AveRMSD(j,w)=RMSD(j);
 end
%  if (algo==1)
%      
%   rmsd_scr_interent_desplazamientos
%   w=w+1
%  end
% for h=1:length(wrs) 
%     PSD(h,w)=potencial(h);
% end
 %u(i)=rm;
%  u=rm3;
% % figure(34)
% % tiempo1=(1./4000).*j
% tiempo=0.067.*(0:100);
% %     end
%    figure (7)   
%     plot(log(tiempo),log(u),'-o') 
%  hold on 
% % end
end
meanRMSD=mean(AveRMSD,2);

StepTime=t1(2:m);
RMSD=meanRMSD(2:m);
L = size (StepTime, 1);
 figure(113);
plot((StepTime),(RMSD),'-o')%,(StepTime(1:m)),(rmsd1(1:m)),'-o');
title('Mean Square Displacement of Brownain Motion');
xlabel('time step');
ylabel('MSD');
axis square
hold on

OmegaVector = zeros (1, L);
LnRMSD = zeros (1, L);
LnTau = zeros (1, L);
GlobalFit = zeros (1, L); 
Alpha = zeros (1, L);
GammaApp = zeros (1, L);
Denominator = zeros (1, L);
Gstar = zeros (1,L); Gstar_Record = zeros (2,L);
GpMason = zeros (1, L); 
GppMason = zeros (1, L); 
Gstar_Record =zeros (1, L);
Gp_Record =zeros (1, L);
Gpp_Record =zeros (1, L);
% 'Matrices initialized.'

%%% Now from RMSD(tau) to G*(omega)
OmegaVector =1 ./ StepTime; % from large (left) to small (right) Omega
kB = 1.3806503e-23; % Boltzmann constant in m2 kg s-2 K-1
T = 298; % Temperature in absolute degrees
Radius = 0.44e-5; % Bead radius in meters                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
Factor = kB * T / (pi * Radius);

LnRMSD (1,:) = log (RMSD(:,1)); % in m^2.
LnTau (1,:) = log (StepTime(:,1));
% Below, I've replaced GammaPiece by GammaApp, the approximation of the
% gamma function presented in Mason, Rheol Acta (2000), # 3-8.
n = 5;
PolyGlobalFit = polyfit (LnTau, LnRMSD, n);
GlobalFit = polyval (PolyGlobalFit, LnTau);
% 'RMSD fitted.'

if(1) 
   figure(3)
   loglog(StepTime, RMSD.*1e18,'o-');
   xlabel('\tau'); ylabel('RMSD [nm^2]'); title('RMSD');
end

for k = 1 : n
    Alpha (1,:) = Alpha(1,:) + k * PolyGlobalFit (1, n + 1 - k) .* LnTau (1,:) .^ (k-1);
end
% 'Alpha computed.' % from small Tau = large Omega (left) to large Tau (right).

figure(4)
semilogx( OmegaVector(:,1), Alpha(1,:),'o-'  )
xlabel('\omega'); ylabel('\alpha'); title('\alpha vs \omega');
RMSD=RMSD';
GammaApp (1,:) = 0.457 .* (1 + Alpha(1,:)).^2 - 1.36 .* (1 + Alpha(1,:)) + 1.90;
Denominator (1,:) = RMSD (1,:) .* GammaApp(1,:) .* 1i.^(-Alpha(1,:));

Gstar (1,:) = Factor ./ Denominator (1,:);
GpMason (1,:) = abs (Gstar(1,:)) .* cos ((pi/2) .* Alpha(1,:));
GppMason (1,:) = abs (Gstar(1,:)) .* sin ((pi/2) .* Alpha(1,:));
% Gp = real(Gstar) and Gpp = imag (Gstar) return the same results
OmegaVector=OmegaVector';
% Record it all now :)
Gstar_Record (1,:) = OmegaVector (1,:); Gstar_Record (2,:) = abs(Gstar (1,:));
Gp_Record (1,:) = OmegaVector (1,:); Gp_Record (2,:) = GpMason (1,:);
Gpp_Record (1,:) = OmegaVector (1,:); Gpp_Record (2,:) = GppMason (1,:);


'G*, Gp, Gpp saved'

figure(1)
loglog(OmegaVector, GpMason, 'o')
title(' Storage Modulus G prime,Loss Modulus G double prime ');
xlabel('\omega'); ylabel('pascals');
hold on
% figure(2)
loglog(OmegaVector, GppMason, '+')
% title(' Loss Modulus G double prime ');
% xlabel('\omega'); ylabel('pascals');
% figure(3)
% loglog(OmegaVector,Gstar)
% hold off
figure (356)
Gstar_Record=Gstar_Record';
Gp_Record=Gp_Record';
Gpp_Record=Gpp_Record';
save(sprintf('%s/results_puntos_response/Gmean.txt',working_directory_path),'Gstar_Record','-ascii');
save(sprintf('%s/results_puntos_response/Gprima_mean.txt',working_directory_path),'Gp_Record','-ascii');
save(sprintf('%s/results_puntos_response/G2prima_mean.txt',working_directory_path),'Gpp_Record','-ascii');
save(sprintf('%s/results_puntos/rmsd.txt',working_directory_path),'meanRMSD','-ascii');

% 
% 
% 
% 
% 









%  meanPSD=mean(PSD,2);
% % Emean=mean(E,2)
% % Estd=std(E,0,2)
% 
% stdPSD=std(PSD,0,2)
% figure(600)
% loglog((f),(meanPSD))
% hold on
% 
% % loglog(u,'o') 
% % hold on;
% % potencialme=mean(potencialto,2)
% %  figure (68)
% %       plot((xout./1e-9),(potencialme),'.-r')
% %       hold on
% % figure (46)
% % if algo==0
% % xout=xout'./1e-9;
% % potencialme=potencialme';
% % save(sprintf('%s/complex/potencial_promedio%i.txt',working_directory_path,m1),'potencialme','-ascii');
% % save(sprintf('%s/complex/xout%i.txt',working_directory_path,m1),'xout','-ascii');
% save(sprintf('%s/results_puntos/meanPSD.txt',working_directory_path),'meanPSD','-ascii');
% Z=Z';
% Emean=Emean;
% Estd=Estd;
% save(sprintf('%s/results_puntos/complexindex.txt',working_directory_path),'Z','-ascii');
% save(sprintf('%s/results_puntos/Eentropiamedia.txt',working_directory_path),'Emean','-ascii');
% save(sprintf('%s/results_puntos/entropiastd.txt',working_directory_path),'Estd','-ascii');


% end
% meanensemble=mean(fff);
% %fff=fff';
% error=std(fff,1);
%plot(log10(StepTime(1:50)),log10(meanensemble(1:50)),'-o');

%figure(45)
%normplot(meanensemble)

%hold on

%lillietest(meanensemble)

% figure (42)
% errorbar(log10(StepTime(1:50)),log10(meanensemble(1:50)),log10(error(1:50));