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

% output of parameters
parameterStruct
integration_time=parameterStruct.integration_time

parameterStruct.firstdatapoint=1
parameterStruct.lastdatapoint=30

% load data of spectrum
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path)); % 
fluct = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
% sigma2u=load(sprintf('%s/results/errores.txt',working_directory_path));
%  fluct=fluct-sigma2u
% set region of xdata (predictor) and corresponding ydata (response)
wavenr = wavenr(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
fluct= fluct(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);


savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
 r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
 r0=r0(savedcontours);
 rmean=mean(r0)';
 
%  ftype = fittype('27875976884861368019686522917955130027505434715/113078212145816597093331040047546785012958969400039613319782796882727665664*temperature/pi/integration_time^2*qx^3/(4816437861622157/4503599627370496*(sigma * scalefactor_sigma)*qx^2+5151007104157705/4503599627370496*(kappa * scalefactor_kappa)*qx^4)^3*((602054732702769625/2328696403508554*(sigma * scalefactor_sigma)*qx^2+643875888019713125/2328696403508554*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-602054732702769625/2328696403508554*(sigma * scalefactor_sigma)*qx^2-643875888019713125/2328696403508554*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+29851504503965847925354055635351390910053567435/56539106072908298546665520023773392506479484700019806659891398441363832832*temperature/pi/integration_time^2*qx^3/(3375119391557767/1125899906842624*(sigma * scalefactor_sigma)*qx^2+5058811550670793/562949953421312*(kappa * scalefactor_kappa)*qx^4)^3*((675023878311553400/1559496659010233*(sigma * scalefactor_sigma)*qx^2+2023524620268317200/1559496659010233*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-675023878311553400/1559496659010233*(sigma * scalefactor_sigma)*qx^2-2023524620268317200/1559496659010233*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+13216177793986403278477768978236182487742188595/28269553036454149273332760011886696253239742350009903329945699220681916416*temperature/pi/integration_time^2*qx^3/(7844301334923487/562949953421312*(sigma * scalefactor_sigma)*qx^2+1707885594978209/8796093022208*(kappa * scalefactor_kappa)*qx^4)^3*((784430133492348700/840566387252587*(sigma * scalefactor_sigma)*qx^2+10930467807860537600/840566387252587*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-784430133492348700/840566387252587*(sigma * scalefactor_sigma)*qx^2-10930467807860537600/840566387252587*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+18479460224682247805707570423683430840847347905/226156424291633194186662080095093570025917938800079226639565593765455331328*temperature/pi/integration_time^2*qx^3/(7206984303956217/140737488355328*(sigma * scalefactor_sigma)*qx^2+720820941233925/274877906944*(kappa * scalefactor_kappa)*qx^4)^3*((2882793721582486800/1611393727821037*(sigma * scalefactor_sigma)*qx^2+147624128764707840000/1611393727821037*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-2882793721582486800/1611393727821037*(sigma * scalefactor_sigma)*qx^2-147624128764707840000/1611393727821037*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+187721319900814691551178886958946645927508125/113078212145816597093331040047546785012958969400039613319782796882727665664*temperature/pi/integration_time^2*qx^3/(5657289769229875/35184372088832*(sigma * scalefactor_sigma)*qx^2+1776630372431643/68719476736*(kappa * scalefactor_kappa)*qx^4)^3*((707161221153734375/223074084249452*(sigma * scalefactor_sigma)*qx^2+28426085958906288000/55768521062363*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-707161221153734375/223074084249452*(sigma * scalefactor_sigma)*qx^2-28426085958906288000/55768521062363*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)','independent','qx','coefficients',{'sigma','kappa'},'problem',{'scalefactor_sigma','scalefactor_kappa','temperature','integration_time'},'Levenberg-Marquardt')
% 
% 
% [fresult,gof,output] = fit(xdata,ydata,ftype,'StartPoint',[1 1],'TolX',parameterStruct.TolX,'TolFun',parameterStruct.TolFun,'MaxFunEvals',parameterStruct.MaxFunEvals,'MaxIter',parameterStruct.MaxIter,'Algorithm','Levenberg-Marquardt','problem',{parameterStruct.scalefactor_sigma,parameterStruct.scalefactor_kappa,parameterStruct.temperature,parameterStruct.integration_time})
%  
 
%  f=feval(fresult,xdata);

% sigma = fresult.sigma * parameterStruct.scalefactor_sigma
% kappa = fresult.kappa * parameterStruct.scalefactor_kappa
% kappa1=kappa./(1.3806e-23.*parameterStruct.temperature)
%  
 
 
 
 mkdir(sprintf('%s/simulacion',working_directory_path));
% integration_time=0.066
%  kappa1=kappa+(2*(d^2)*K)
  kappa=8.64e-020
  sigma=-1.27e-8
 
 u=27875976884861368019686522917955130027505434715./113078212145816597093331040047546785012958969400039613319782796882727665664.*296.65./pi./integration_time.^2.*wavenr.^3./(4816437861622157./4503599627370496.*(sigma).*wavenr.^2+5151007104157705./4503599627370496.*(kappa).*wavenr.^4).^3.*((602054732702769625./2328696403508554.*(sigma).*wavenr.^2+643875888019713125./2328696403508554.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-602054732702769625./2328696403508554.*(sigma).*wavenr.^2-643875888019713125./2328696403508554.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)+29851504503965847925354055635351390910053567435./56539106072908298546665520023773392506479484700019806659891398441363832832.*296.65./pi./integration_time.^2.*wavenr.^3./(3375119391557767./1125899906842624.*(sigma).*wavenr.^2+5058811550670793./562949953421312.*(kappa).*wavenr.^4).^3.*((675023878311553400./1559496659010233.*(sigma).*wavenr.^2+2023524620268317200./1559496659010233.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-675023878311553400./1559496659010233.*(sigma).*wavenr.^2-2023524620268317200./1559496659010233.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)+13216177793986403278477768978236182487742188595./28269553036454149273332760011886696253239742350009903329945699220681916416.*296.65./pi./integration_time.^2.*wavenr.^3./(7844301334923487./562949953421312.*(sigma).*wavenr.^2+1707885594978209/8796093022208.*(kappa).*wavenr.^4).^3.*((784430133492348700./840566387252587.*(sigma).*wavenr.^2+10930467807860537600./840566387252587.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-784430133492348700./840566387252587.*(sigma).*wavenr.^2-10930467807860537600./840566387252587.*(kappa ).*wavenr.^4).*integration_time./wavenr)-1)+18479460224682247805707570423683430840847347905./226156424291633194186662080095093570025917938800079226639565593765455331328.*296.65./pi./integration_time.^2.*wavenr.^3./(7206984303956217./140737488355328.*(sigma).*wavenr.^2+720820941233925./274877906944.*(kappa).*wavenr.^4).^3.*((2882793721582486800./1611393727821037.*(sigma).*wavenr.^2+147624128764707840000./1611393727821037.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-2882793721582486800./1611393727821037.*(sigma).*wavenr.^2-147624128764707840000./1611393727821037.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)+187721319900814691551178886958946645927508125./113078212145816597093331040047546785012958969400039613319782796882727665664.*296.65./pi./integration_time.^2.*wavenr.^3./(5657289769229875./35184372088832.*(sigma).*wavenr.^2+1776630372431643./68719476736.*(kappa).*wavenr.^4).^3.*((707161221153734375./223074084249452.*(sigma).*wavenr.^2+28426085958906288000./55768521062363.*(kappa).*wavenr.^4).*integration_time./wavenr+exp((-707161221153734375./223074084249452.*(sigma).*wavenr.^2-28426085958906288000./55768521062363.*(kappa).*wavenr.^4).*integration_time./wavenr)-1)
 u6=1231536352843655./19730272103967189395749745241669820765355089330176.*296.65.*(19364820035021121433718020813198589952000.*abs(1./wavenr./(5151007104157705.*kappa.*wavenr.^2+4816437861622157.*sigma)).^2.*integration_time+360758294161152609598523914988621805620237906963595264.*abs(1./wavenr./(5151007104157705.*kappa.*wavenr.^2+4816437861622157.*sigma)).^3.*exp(-125./2328696403508554.*integration_time./abs(1./wavenr./(5151007104157705.*kappa.*wavenr.^2+4816437861622157.*sigma)))-360758294161152609598523914988621805620237906963595264.*abs(1./wavenr./(5151007104157705.*kappa.*wavenr.^2+4816437861622157.*sigma)).^3+1548274717062872478789199858859627520000.*abs(1./wavenr./(10117623101341586.*kappa.*wavenr.^2+3375119391557767.*sigma)).^2.*integration_time+12072646242447817093972549596251552747900831242060800.*abs(1./wavenr./(10117623101341586.*kappa.*wavenr.^2+3375119391557767.*sigma)).^3.*exp(-200./1559496659010233.*integration_time./abs(1./wavenr./(10117623101341586.*kappa.*wavenr.^2+3375119391557767.*sigma)))-12072646242447817093972549596251552747900831242060800.*abs(1./wavenr./(10117623101341586.*kappa.*wavenr.^2+3375119391557767.*sigma)).^3+158968147184800791604617574008437760000.*abs(1./wavenr./(109304678078605376.*kappa.*wavenr.^2+7844301334923487.*sigma)).^2.*integration_time+1336232811673655101068006042500131746036423884851200.*abs(1./wavenr./(109304678078605376.*kappa.*wavenr.^2+7844301334923487.*sigma)).^3.*exp(-100./840566387252587.*integration_time./abs(1./wavenr./(109304678078605376.*kappa.*wavenr.^2+7844301334923487.*sigma)))-1336232811673655101068006042500131746036423884851200.*abs(1./wavenr./(109304678078605376.*kappa.*wavenr.^2+7844301334923487.*sigma)).^3+100649446966452796960070516154330000.*abs(1./wavenr./(123020107303923200.*kappa.*wavenr.^2+2402328101318739.*sigma)).^2.*integration_time+135154906291998447043381503555370785216427200175.*abs(1./wavenr./(123020107303923200.*kappa.*wavenr.^2+2402328101318739.*sigma)).^3.*exp(-1200./1611393727821037.*integration_time./abs(1./wavenr./(123020107303923200.*kappa.*wavenr.^2+2402328101318739.*sigma)))-135154906291998447043381503555370785216427200175.*abs(1./wavenr./(123020107303923200.*kappa.*wavenr.^2+2402328101318739.*sigma)).^3+649128703448108159968383716112000.*abs(1./wavenr./(909634750685001216.*kappa.*wavenr.^2+5657289769229875.*sigma)).^2.*integration_time+1158430328653766581203281145221069569276564992.*abs(1./wavenr./(909634750685001216.*kappa.*wavenr.^2+5657289769229875.*sigma)).^3.*exp(-125./223074084249452.*integration_time./abs(1./wavenr./(909634750685001216.*kappa.*wavenr.^2+5657289769229875.*sigma)))-1158430328653766581203281145221069569276564992.*abs(1./wavenr./(909634750685001216.*kappa.*wavenr.^2+5657289769229875.*sigma)).^3)./pi./integration_time.^2
 u6=u6*0.1;
 
save(sprintf('%s/simulacion/simulane.txt',working_directory_path),'u6','-ascii');
save(sprintf('%s/simulacion/wave.txt',working_directory_path),'wavenr','-ascii');
save(sprintf('%s/simulacion/fluct.txt',working_directory_path),'fluct','-ascii');
figure(8)
%hold on;
%semilogy(wavenr,u)
semilogy(wavenr,fluct,'-ok',wavenr,u6)
%axis square;
% figure(9)
% semilogy(wavenr.*rmean,fluct,'-ok')
 
 