







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
%POPC familia de curvas 

%parametros 
%kappa=1.6375e-019 polimero
%kappa=1.6375e-020 dopc
%kappa=4.0938e-020 popc
% r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
% 
% 
% rmean=mean(r0)
% r0=mean(r0);




kappa=2.06e-19;                         %J
sigma=3e-7;                                %N/m
b=11e8;                                     %N*s/m3
h=4.4e-9;                                    %m
epsilon=0.1;                                     %N/m
modos=1:150;
rmean=[30.6e-006];        %m
% rmean=rmean*1e-6
wavenr=modos./(rmean);                          %m-1 
kbt=1.38e-23*298.65;
integration_time=0.0667;
n=1:150;
t=integration_time*n;
c=2;
eta=0.001;
temperature=296.65
%espectro estatico
mo=2
f=1:90
bending=27875976884861368019686522917955130027505434715./113078212145816597093331040047546785012958969400039613319782796882727665664.*296.65./pi./integration_time.^2.*wavenr.^3./(4816437861622157./4503599627370496.*(sigma).*wavenr.^2+5151007104157705./4503599627370496.*(kappa).*wavenr.^4).^3.*((602054732702769625./2328696403508554.*(sigma).*wavenr.^2+643875888019713125./2328696403508554.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-602054732702769625./2328696403508554.*(sigma).*wavenr.^2-643875888019713125./2328696403508554.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)+29851504503965847925354055635351390910053567435./56539106072908298546665520023773392506479484700019806659891398441363832832.*296.65./pi./integration_time.^2.*wavenr.^3./(3375119391557767./1125899906842624.*(sigma).*wavenr.^2+5058811550670793./562949953421312.*(kappa).*wavenr.^4).^3.*((675023878311553400./1559496659010233.*(sigma).*wavenr.^2+2023524620268317200./1559496659010233.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-675023878311553400./1559496659010233.*(sigma).*wavenr.^2-2023524620268317200./1559496659010233.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)+13216177793986403278477768978236182487742188595./28269553036454149273332760011886696253239742350009903329945699220681916416.*296.65./pi./integration_time.^2.*wavenr.^3./(7844301334923487./562949953421312.*(sigma).*wavenr.^2+1707885594978209/8796093022208.*(kappa).*wavenr.^4).^3.*((784430133492348700./840566387252587.*(sigma).*wavenr.^2+10930467807860537600./840566387252587.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-784430133492348700./840566387252587.*(sigma).*wavenr.^2-10930467807860537600./840566387252587.*(kappa ).*wavenr.^4).*integration_time./wavenr)-1)+18479460224682247805707570423683430840847347905./226156424291633194186662080095093570025917938800079226639565593765455331328.*296.65./pi./integration_time.^2.*wavenr.^3./(7206984303956217./140737488355328.*(sigma).*wavenr.^2+720820941233925./274877906944.*(kappa).*wavenr.^4).^3.*((2882793721582486800./1611393727821037.*(sigma).*wavenr.^2+147624128764707840000./1611393727821037.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-2882793721582486800./1611393727821037.*(sigma).*wavenr.^2-147624128764707840000./1611393727821037.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)+187721319900814691551178886958946645927508125./113078212145816597093331040047546785012958969400039613319782796882727665664.*296.65./pi./integration_time.^2.*wavenr.^3./(5657289769229875./35184372088832.*(sigma).*wavenr.^2+1776630372431643./68719476736.*(kappa).*wavenr.^4).^3.*((707161221153734375./223074084249452.*(sigma).*wavenr.^2+28426085958906288000./55768521062363.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-707161221153734375./223074084249452.*(sigma).*wavenr.^2-28426085958906288000./55768521062363.*(kappa).*wavenr.^4).*integration_time./wavenr)-1);%sin kappa gorrito ;
friction=31742826741287./1157717398025177260465509317957105523538546212548663912901503255728869890897370054530621333538622167984447880036700018328704101824593920.*rmean.*temperature.*c.*b.*(3026826037704147407303018546135974741819862953500710289188037925556404607266286669857476206978777309.*integration_time.*epsilon.*wavenr.^2+2577357380414799558636504080492972281215686976020742433995393090492592613690900677787525083941568512.*exp(-4816437861622157./4503599627370496.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b-2666949911022952845507815221952147750453969154959494132680453903906716140848021198781916448913620992.*c.*b+89422763612080341258748589466991457883963596544273078308590608158345975597501760557943250233589760.*exp(-3375119391557767./1125899906842624.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b+169604447100029593391568501072624668417499776936241337298201856359007257759363156807820918128640.*exp(-7844301334923487./562949953421312.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b+162515003473634154046803726730943438274287793590280889412203664454867824706234840394015703040.*exp(-7206984303956217./140737488355328.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b+33969442385016936687384655742462808329748788758282591195754089434034691044799899804631040.*exp(-5657289769229875./35184372088832.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b)./pi./h./integration_time.^2./epsilon.^3./wavenr.^5;
P=(bending+friction);
P=(P./P(1))';
wavenr=wavenr';
%bending=(bending./bending(1))';
save('C:/membrane_tracking_project/program/simulacion/fluct.txt','bending','-ascii');
figure(1)
semilogy(wavenr,friction,'o',wavenr,bending,'.',wavenr,P,'+');
hold on;
save('C:/membrane_tracking_project/program/simulacion/wave.txt','wavenr','-ascii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%amplitud

Ahybrido=kbt.*((12.*(rmean./h)).*(1./(epsilon.*(wavenr.^2))));
Abending=kbt.*(1./((sigma.*(wavenr.^2))+(kappa.*(wavenr.^4))));

N=sqrt((Ahybrido.^2)+(Abending.^2));
AhybridoN=Ahybrido./N;
AbendingN=Abending./N;
figure(2)
plot(wavenr,AhybridoN,'-o',wavenr,AbendingN,'-.');
hold on;
save('C:/membrane_tracking_project/program/simulacion/Ahybridonormalizado.txt','AhybridoN','-ascii');
save('C:/membrane_tracking_project/program/simulacion/Abendingnormalizado.txt','AbendingN','-ascii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%funcion de autocorrelacion
wavenr=wavenr(mo);
Ahybrido=kbt.*((12.*(rmean./h)).*(1./(epsilon.*(wavenr.^2))));
Abending=kbt.*(1./((sigma.*(wavenr.^2))+(kappa.*(wavenr.^4))));

N=sqrt((Ahybrido.^2)+(Abending.^2));
AhybridoN=Ahybrido./N;
AbendingN=Abending./N;

gammahy=(epsilon.*(wavenr.^2))./(2.*b);
gammabe=(kappa.*(wavenr.^3))./(4.*eta);
gammaten=(sigma.*(wavenr.^1))./(4.*eta);
gammazg=0.025*((kbt./kappa)^0.5).*(kbt./eta).*(wavenr.^3);

G=(AhybridoN.*exp(-gammahy.*t))+(AbendingN.*exp(-gammabe.*t));
Ghy=(Ahybrido.*exp(-gammahy.*t));
Gbe=(Abending.*exp(-gammabe.*t));
Gte=(Abending.*exp(-gammaten.*t));
GZG=(Abending.*exp(-(gammazg.*t).^0.5));

G=(G./G(1))';
Ghy=(Ghy./Ghy(1))';
Gbe=(Gbe./Gbe(1))';
Gte=(Gte./Gte(1))';
GZG=(GZG./GZG(1))';
t=t';

correlaexp = load(sprintf('%s/correla/correlation%i.txt',working_directory_path,savedcontours(mo))) % 
tiempoexp = load(sprintf('%s/correla/tiempo.txt',working_directory_path));


correlaexp=correlaexp(f,1);
tiempoexp=tiempoexp(f,1);


figure(3)
plot(t,G./G(1),'-r',t,Ghy./Ghy(1),'-g',t,Gbe./Gbe(1),'-b',tiempoexp,correlaexp,'o',t,Gte,'-.d',t,GZG./GZG(1),'*');
save('C:/membrane_tracking_project/program/simulacion/Correlationhy.txt','Ghy','-ascii');
save('C:/membrane_tracking_project/program/simulacion/Correlationbe.txt','Gbe','-ascii');
save('C:/membrane_tracking_project/program/simulacion/Dobleexponencial.txt','G','-ascii');
save('C:/membrane_tracking_project/program/simulacion/tiempo.txt','t','-ascii');
hold on;





