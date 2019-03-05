
clear
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
sigma2u=load(sprintf('%s/results/errores.txt',working_directory_path));
wavenumbers = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
sigma2q=load(sprintf('%s/results/errores1.txt',working_directory_path))
fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
%savedcontours=[4 5 6];
r0=r0(savedcontours);
temperature=parameterStruct.temperature;
integration_time=parameterStruct.integration;
sigma * scalefactor_sigma=fresult.sigma;
kappa * scalefactor_kappa=fresult.kappa;

%sigma2u=zeros(parameterStruct.nmax,1);


% save(sprintf('%s/results/wavenumbers.txt',working_directory_path),'wavenumbers','-ascii')
% 
% save(sprintf('%s/results/a.txt',working_directory_path),'a','-ascii')
fo
 F=@(qx)27875976884861368019686522917955130027505434715/113078212145816597093331040047546785012958969400039613319782796882727665664*temperature/pi/integration_time^2*qx^3/(4816437861622157/4503599627370496*(sigma * scalefactor_sigma)*qx^2+5151007104157705/4503599627370496*(kappa * scalefactor_kappa)*qx^4)^3*((602054732702769625/2328696403508554*(sigma * scalefactor_sigma)*qx^2+643875888019713125/2328696403508554*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-602054732702769625/2328696403508554*(sigma * scalefactor_sigma)*qx^2-643875888019713125/2328696403508554*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+29851504503965847925354055635351390910053567435/56539106072908298546665520023773392506479484700019806659891398441363832832*temperature/pi/integration_time^2*qx^3/(3375119391557767/1125899906842624*(sigma * scalefactor_sigma)*qx^2+5058811550670793/562949953421312*(kappa * scalefactor_kappa)*qx^4)^3*((675023878311553400/1559496659010233*(sigma * scalefactor_sigma)*qx^2+2023524620268317200/1559496659010233*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-675023878311553400/1559496659010233*(sigma * scalefactor_sigma)*qx^2-2023524620268317200/1559496659010233*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+13216177793986403278477768978236182487742188595/28269553036454149273332760011886696253239742350009903329945699220681916416*temperature/pi/integration_time^2*qx^3/(7844301334923487/562949953421312*(sigma * scalefactor_sigma)*qx^2+1707885594978209/8796093022208*(kappa * scalefactor_kappa)*qx^4)^3*((784430133492348700/840566387252587*(sigma * scalefactor_sigma)*qx^2+10930467807860537600/840566387252587*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-784430133492348700/840566387252587*(sigma * scalefactor_sigma)*qx^2-10930467807860537600/840566387252587*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+18479460224682247805707570423683430840847347905/226156424291633194186662080095093570025917938800079226639565593765455331328*temperature/pi/integration_time^2*qx^3/(7206984303956217/140737488355328*(sigma * scalefactor_sigma)*qx^2+720820941233925/274877906944*(kappa * scalefactor_kappa)*qx^4)^3*((2882793721582486800/1611393727821037*(sigma * scalefactor_sigma)*qx^2+147624128764707840000/1611393727821037*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-2882793721582486800/1611393727821037*(sigma * scalefactor_sigma)*qx^2-147624128764707840000/1611393727821037*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+187721319900814691551178886958946645927508125/113078212145816597093331040047546785012958969400039613319782796882727665664*temperature/pi/integration_time^2*qx^3/(5657289769229875/35184372088832*(sigma * scalefactor_sigma)*qx^2+1776630372431643/68719476736*(kappa * scalefactor_kappa)*qx^4)^3*((707161221153734375/223074084249452*(sigma * scalefactor_sigma)*qx^2+28426085958906288000/55768521062363*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-707161221153734375/223074084249452*(sigma * scalefactor_sigma)*qx^2-28426085958906288000/55768521062363*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1);
 Q=qudl(F,-Inf,Inf);

 factorg(m)=sigma2u

save(sprintf('%s/results/errores.txt',working_directory_path),'sigma2u','-ascii')
