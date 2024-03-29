clear all;

% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all');

% read working directory from config file 'working_directory_path.ini'
fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}), c{1});
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
% output of parameters
parameterStruct
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path)); % 
fluct = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
xdata = wavenr(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
ydata = fluct(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);


r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
r0=r0(savedcontours);
rmean=mean(r0);
ftype = fittype('27875976884861368019686522917955130027505434715/113078212145816597093331040047546785012958969400039613319782796882727665664*temperature/pi/integration_time^2*qx^3/(4816437861622157/4503599627370496*(sigma * scalefactor_sigma)*qx^2+5151007104157705/4503599627370496*(kappa * scalefactor_kappa)*qx^4)^3*((602054732702769625/2328696403508554*(sigma * scalefactor_sigma)*qx^2+643875888019713125/2328696403508554*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-602054732702769625/2328696403508554*(sigma * scalefactor_sigma)*qx^2-643875888019713125/2328696403508554*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+29851504503965847925354055635351390910053567435/56539106072908298546665520023773392506479484700019806659891398441363832832*temperature/pi/integration_time^2*qx^3/(3375119391557767/1125899906842624*(sigma * scalefactor_sigma)*qx^2+5058811550670793/562949953421312*(kappa * scalefactor_kappa)*qx^4)^3*((675023878311553400/1559496659010233*(sigma * scalefactor_sigma)*qx^2+2023524620268317200/1559496659010233*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-675023878311553400/1559496659010233*(sigma * scalefactor_sigma)*qx^2-2023524620268317200/1559496659010233*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+13216177793986403278477768978236182487742188595/28269553036454149273332760011886696253239742350009903329945699220681916416*temperature/pi/integration_time^2*qx^3/(7844301334923487/562949953421312*(sigma * scalefactor_sigma)*qx^2+1707885594978209/8796093022208*(kappa * scalefactor_kappa)*qx^4)^3*((784430133492348700/840566387252587*(sigma * scalefactor_sigma)*qx^2+10930467807860537600/840566387252587*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-784430133492348700/840566387252587*(sigma * scalefactor_sigma)*qx^2-10930467807860537600/840566387252587*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+18479460224682247805707570423683430840847347905/226156424291633194186662080095093570025917938800079226639565593765455331328*temperature/pi/integration_time^2*qx^3/(7206984303956217/140737488355328*(sigma * scalefactor_sigma)*qx^2+720820941233925/274877906944*(kappa * scalefactor_kappa)*qx^4)^3*((2882793721582486800/1611393727821037*(sigma * scalefactor_sigma)*qx^2+147624128764707840000/1611393727821037*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-2882793721582486800/1611393727821037*(sigma * scalefactor_sigma)*qx^2-147624128764707840000/1611393727821037*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+187721319900814691551178886958946645927508125/113078212145816597093331040047546785012958969400039613319782796882727665664*temperature/pi/integration_time^2*qx^3/(5657289769229875/35184372088832*(sigma * scalefactor_sigma)*qx^2+1776630372431643/68719476736*(kappa * scalefactor_kappa)*qx^4)^3*((707161221153734375/223074084249452*(sigma * scalefactor_sigma)*qx^2+28426085958906288000/55768521062363*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-707161221153734375/223074084249452*(sigma * scalefactor_sigma)*qx^2-28426085958906288000/55768521062363*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)','independent','qx','coefficients',{'sigma','kappa'},'problem',{'scalefactor_sigma','scalefactor_kappa','temperature','integration_time'},'Levenberg-Marquardt')

% ftype = fittype('(1.3806e-23*temperature)/(2*sigma * scalefactor_sigma))*((1/qx)-(1/(((sigma * scalefactor_sigma/kappa * scalefactor_kappa)+(qx^2))^(0.5)))+((sigma * scalefactor_sigma*(1.3559e-005^2))/(kappa * scalefactor_kappa*qx))','independent','qx','coefficients',{'sigma','kappa'},'problem',{'scalefactor_sigma','scalefactor_kappa','temperature'},'Levenberg-Marquardt')

[fresult,gof,output] = fit(xdata,ydata,ftype,'StartPoint',[1 1],'TolX',parameterStruct.TolX,'TolFun',parameterStruct.TolFun,'MaxFunEvals',parameterStruct.MaxFunEvals,'MaxIter',parameterStruct.MaxIter,'Algorithm','Levenberg-Marquardt','problem',{parameterStruct.scalefactor_sigma,parameterStruct.scalefactor_kappa,parameterStruct.temperature,parameterStruct.integration_time})
f=feval(fresult,xdata);

sigma = fresult.sigma * parameterStruct.scalefactor_sigma
kappa = fresult.kappa * parameterStruct.scalefactor_kappa
h=0.7e-9
epsilon=0.078
d=h/4
b=7e10
diametro=rmean*2*100
mkdir('D:/membrane_tracking_project/program/simulacion');
integration_time=0.066
%   sigma=8e-8
%   kappa=2e-20
kappa1=kappa+(2*(d^2)*epsilon)
c=8

temperature=296.65
kappa11=kappa1/(1.3806e-23.*temperature)
% sigma=-1
%  kappa1=2
% fid=fopen('C:/membrane_tracking_project/program/popcambiente.txt','a+');
% fprintf(fid,'%6.9f   %6.9e    %6.9e    %6.3f\n',diametro,sigma,kappa,parameterStruct.temperature);
% fclose(fid);
%    kappa=3E-20
%   sigma=8e-8
%u=(((1.3806e-23.*296.65)./((sigma.*(wavenr.^2))+(kappa1.*((wavenr.^4))))))+(((6.*rmean).*1.3806e-23.*296.65)./(12.*K.*(d).*((wavenr.^2))))
% u1=((1.3806e-23.*296.65)/(2.*sigma))*((1./wavenr)-(1./(((sigma./kappa)+(wavenr.^2)).^(0.5))))%+(((1.3806e-23.*296.659).*d)./(2.*kappa.*wavenr.^2))
% u2=((1.3806e-23.*296.65)/(2.*sigma))*((1./wavenr)-(1./(((sigma./kappa1)+(wavenr.^2)).^(0.5)))+((6.*sigma.*(rmean))./(K.*(d).*wavenr)))
u1=((1.3806e-23.*296.65)./(2.*sigma)).*((1./wavenr)-(1./(abs((sigma./kappa)+(wavenr.^2))).^0.5))
 %u=((1.3806e-23.*296.65)./2.*sigma).*((1./wavenr)-(1./(((sigma./kappa)+(wavenr.^2)).^(1./2))))
u=27875976884861368019686522917955130027505434715./113078212145816597093331040047546785012958969400039613319782796882727665664.*296.65./pi./integration_time.^2.*wavenr.^3./(4816437861622157./4503599627370496.*(sigma).*wavenr.^2+5151007104157705./4503599627370496.*(kappa1).*wavenr.^4).^3.*((602054732702769625./2328696403508554.*(sigma).*wavenr.^2+643875888019713125./2328696403508554.*(kappa1).*wavenr.^4).*integration_time./wavenr+exp((-602054732702769625./2328696403508554.*(sigma).*wavenr.^2-643875888019713125./2328696403508554.*(kappa1).*wavenr.^4).*integration_time./wavenr)-1)+29851504503965847925354055635351390910053567435./56539106072908298546665520023773392506479484700019806659891398441363832832.*296.65./pi./integration_time.^2.*wavenr.^3./(3375119391557767./1125899906842624.*(sigma).*wavenr.^2+5058811550670793./562949953421312.*(kappa1).*wavenr.^4).^3.*((675023878311553400./1559496659010233.*(sigma).*wavenr.^2+2023524620268317200./1559496659010233.*(kappa1).*wavenr.^4).*integration_time./wavenr+exp((-675023878311553400./1559496659010233.*(sigma).*wavenr.^2-2023524620268317200./1559496659010233.*(kappa1).*wavenr.^4).*integration_time./wavenr)-1)+13216177793986403278477768978236182487742188595./28269553036454149273332760011886696253239742350009903329945699220681916416.*296.65./pi./integration_time.^2.*wavenr.^3./(7844301334923487./562949953421312.*(sigma).*wavenr.^2+1707885594978209/8796093022208.*(kappa1).*wavenr.^4).^3.*((784430133492348700./840566387252587.*(sigma).*wavenr.^2+10930467807860537600./840566387252587.*(kappa1).*wavenr.^4).*integration_time./wavenr+exp((-784430133492348700./840566387252587.*(sigma).*wavenr.^2-10930467807860537600./840566387252587.*(kappa1 ).*wavenr.^4).*integration_time./wavenr)-1)+18479460224682247805707570423683430840847347905./226156424291633194186662080095093570025917938800079226639565593765455331328.*296.65./pi./integration_time.^2.*wavenr.^3./(7206984303956217./140737488355328.*(sigma).*wavenr.^2+720820941233925./274877906944.*(kappa1).*wavenr.^4).^3.*((2882793721582486800./1611393727821037.*(sigma).*wavenr.^2+147624128764707840000./1611393727821037.*(kappa1).*wavenr.^4).*integration_time./wavenr+exp((-2882793721582486800./1611393727821037.*(sigma).*wavenr.^2-147624128764707840000./1611393727821037.*(kappa1).*wavenr.^4).*integration_time./wavenr)-1)+187721319900814691551178886958946645927508125./113078212145816597093331040047546785012958969400039613319782796882727665664.*296.65./pi./integration_time.^2.*wavenr.^3./(5657289769229875./35184372088832.*(sigma).*wavenr.^2+1776630372431643./68719476736.*(kappa1).*wavenr.^4).^3.*((707161221153734375./223074084249452.*(sigma).*wavenr.^2+28426085958906288000./55768521062363.*(kappa1).*wavenr.^4).*integration_time./wavenr+exp((-707161221153734375./223074084249452.*(sigma).*wavenr.^2-28426085958906288000./55768521062363.*(kappa1).*wavenr.^4).*integration_time./wavenr)-1)%kappa gorrito
u7=27875976884861368019686522917955130027505434715./113078212145816597093331040047546785012958969400039613319782796882727665664.*296.65./pi./integration_time.^2.*wavenr.^3./(4816437861622157./4503599627370496.*(sigma).*wavenr.^2+5151007104157705./4503599627370496.*(kappa).*wavenr.^4).^3.*((602054732702769625./2328696403508554.*(sigma).*wavenr.^2+643875888019713125./2328696403508554.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-602054732702769625./2328696403508554.*(sigma).*wavenr.^2-643875888019713125./2328696403508554.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)+29851504503965847925354055635351390910053567435./56539106072908298546665520023773392506479484700019806659891398441363832832.*296.65./pi./integration_time.^2.*wavenr.^3./(3375119391557767./1125899906842624.*(sigma).*wavenr.^2+5058811550670793./562949953421312.*(kappa).*wavenr.^4).^3.*((675023878311553400./1559496659010233.*(sigma).*wavenr.^2+2023524620268317200./1559496659010233.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-675023878311553400./1559496659010233.*(sigma).*wavenr.^2-2023524620268317200./1559496659010233.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)+13216177793986403278477768978236182487742188595./28269553036454149273332760011886696253239742350009903329945699220681916416.*296.65./pi./integration_time.^2.*wavenr.^3./(7844301334923487./562949953421312.*(sigma).*wavenr.^2+1707885594978209/8796093022208.*(kappa).*wavenr.^4).^3.*((784430133492348700./840566387252587.*(sigma).*wavenr.^2+10930467807860537600./840566387252587.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-784430133492348700./840566387252587.*(sigma).*wavenr.^2-10930467807860537600./840566387252587.*(kappa ).*wavenr.^4).*integration_time./wavenr)-1)+18479460224682247805707570423683430840847347905./226156424291633194186662080095093570025917938800079226639565593765455331328.*296.65./pi./integration_time.^2.*wavenr.^3./(7206984303956217./140737488355328.*(sigma).*wavenr.^2+720820941233925./274877906944.*(kappa).*wavenr.^4).^3.*((2882793721582486800./1611393727821037.*(sigma).*wavenr.^2+147624128764707840000./1611393727821037.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-2882793721582486800./1611393727821037.*(sigma).*wavenr.^2-147624128764707840000./1611393727821037.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)+187721319900814691551178886958946645927508125./113078212145816597093331040047546785012958969400039613319782796882727665664.*296.65./pi./integration_time.^2.*wavenr.^3./(5657289769229875./35184372088832.*(sigma).*wavenr.^2+1776630372431643./68719476736.*(kappa).*wavenr.^4).^3.*((707161221153734375./223074084249452.*(sigma).*wavenr.^2+28426085958906288000./55768521062363.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-707161221153734375./223074084249452.*(sigma).*wavenr.^2-28426085958906288000./55768521062363.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)%sin kappa gorrito 
u4=31742826741287./578858699012588630232754658978552761769273106274331956450751627864434945448685027265310666769311083992223940018350009164352050912296960.*rmean.*296.65.*b.*(3026826037704147407303018546135974741819862953500710289188037925556404607266286669857476206978777309.*integration_time.*epsilon.*wavenr.^2+5154714760829599117273008160985944562431373952041484867990786180985185227381801355575050167883137024.*exp(-4816437861622157./9007199254740992.*integration_time./b.*epsilon.*wavenr.^2).*b-5333899822045905691015630443904295500907938309918988265360907807813432281696042397563832897827241984.*b+178845527224160682517497178933982915767927193088546156617181216316691951195003521115886500467179520.*exp(-3375119391557767./2251799813685248.*integration_time./b.*epsilon.*wavenr.^2).*b+339208894200059186783137002145249336834999553872482674596403712718014515518726313615641836257280.*exp(-7844301334923487./1125899906842624.*integration_time./b.*epsilon.*wavenr.^2).*b+325030006947268308093607453461886876548575587180561778824407328909735649412469680788031406080.*exp(-7206984303956217./281474976710656.*integration_time./b.*epsilon.*wavenr.^2).*b+67938884770033873374769311484925616659497577516565182391508178868069382089599799609262080.*exp(-5657289769229875./70368744177664.*integration_time./b.*epsilon.*wavenr.^2).*b)./pi./h./integration_time.^2./epsilon.^3./wavenr.^5
u5=31742826741287./1157717398025177260465509317957105523538546212548663912901503255728869890897370054530621333538622167984447880036700018328704101824593920.*rmean.*temperature.*c.*b.*(3026826037704147407303018546135974741819862953500710289188037925556404607266286669857476206978777309.*integration_time.*epsilon.*wavenr.^2+2577357380414799558636504080492972281215686976020742433995393090492592613690900677787525083941568512.*exp(-4816437861622157./4503599627370496.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b-2666949911022952845507815221952147750453969154959494132680453903906716140848021198781916448913620992.*c.*b+89422763612080341258748589466991457883963596544273078308590608158345975597501760557943250233589760.*exp(-3375119391557767./1125899906842624.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b+169604447100029593391568501072624668417499776936241337298201856359007257759363156807820918128640.*exp(-7844301334923487./562949953421312.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b+162515003473634154046803726730943438274287793590280889412203664454867824706234840394015703040.*exp(-7206984303956217./140737488355328.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b+33969442385016936687384655742462808329748788758282591195754089434034691044799899804631040.*exp(-5657289769229875./35184372088832.*integration_time./c./b.*epsilon.*wavenr.^2).*c.*b)./pi./h./integration_time.^2./epsilon.^3./wavenr.^5

 u1=u+u5; %kappa gorrito -+
 u2=u7+u5;%sin kappa gorrito -*
 
  
% save('D:/membrane_tracking_project/program/simulacion/fluct.txt','u','-ascii');
% save('D:/membrane_tracking_project/program/simulacion/fluct1.txt','u1','-ascii');
% save('D:/membrane_tracking_project/program/simulacion/fluct2.txt','u2','-ascii');
% save('D:/membrane_tracking_project/program/simulacion/wave.txt','wavenr','-ascii');
figure(8)
%semilogy(wavenr,u)
% semilogy(wavenr,fluct,'-o',wavenr,u1)%,'-+',wavenr,u2,'-*',wavenr,u7,'-k')
semilogy(wavenr,u1)


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
varian=((cc(j)-mean(cc))^2)/((length(savedcontours)-1));
varians=varian+temp;
temp=varians;
end
vari(m)=temp;



end

termino=hh.*pi*(mean(r0).^3)./2;

figure(8)
semilogy(wavenr,u2,wavenr,termino,'.')
