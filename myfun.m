function F = myfun(x)



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
parameterStruct;

% 
parameterStruct.firstdatapoint;
parameterStruct.lastdatapoint;
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
% load data of spectrum7
wavenr = load(sprintf('%s./results./wavenumbers.txt',working_directory_path)); % 
fluct = load(sprintf('%s./results./fluctuations.txt',working_directory_path));
sigma2u=load(sprintf('%s./results./errores.txt',working_directory_path));
sigmcn=load(sprintf('%s./results./sigmacnlinealpormodo.txt',working_directory_path));
temperature=parameterStruct.temperature;
integration_time=parameterStruct.integration_time;
% sigmcn=sigmcn';
fluct=(fluct-sigmcn');
r0 = load(sprintf('%s./results./r0.txt',working_directory_path));

  h=load(sprintf('%s/results/h.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
r0=r0(savedcontours);
rmean=mean(r0);
%luct=fluct-sigma2u;
%set region of xdata (predictor) and corresponding ydata (response)
xdata = wavenr(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
ydata = fluct(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
%F1=(2.4652e-028.*temperature./pi./integration_time.^2.*xdata.^3./(1.0695.*(x (1)).*xdata.^2+1.1438.*(x (2)).*xdata.^4).^3.*((258.5372.*(x (1)).*xdata.^2+276.4963.*(x (2)).*xdata.^4).*integration_time./xdata+exp((- 258.5372.*(x (1)).*xdata.^2-276.4963.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+5.2798e-028.*temperature./pi./integration_time.^2.*xdata.^3./(2.9977.*(x (1)).*xdata.^2+8.9863.*(x (2)).*xdata.^4).^3.*((432.8473.*(x (1)).*xdata.^2+1.2975e+003.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-432.8473.*(x (1)).*xdata.^2-1.2975e+003.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+4.6751e-028.*temperature./pi./integration_time.^2.*xdata.^3./(13.9343.*(x (1)).*xdata.^2+194.1641.*(x (2)).*xdata.^4).^3.*((933.2162.*(x (1)).*xdata.^2+1.3004e+004.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-933.2162.*(x (1)).*xdata.^2-1.3004e+004.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+ 8.1711e-029.*temperature./pi./integration_time.^2.*xdata.^3./(51.2087.*(x (1)).*xdata.^2+2.6223e+003.*(x (2)).*xdata.^4).^3.*((1.7890e+003.*(x (1)).*xdata.^2+ 9.1613e+004.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-1.7890e+003.*(x (1)).*xdata.^2-9.1613e+004.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+1.6601e-030.*temperature./pi./integration_time.^2.*xdata.^3./(160.7898.*(x (1)).*xdata.^2+2.5853e+004.*(x (2)).*xdata.^4).^3.*((3.1701e+003.*(x (1)).*xdata.^2+5.0972e+005.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-3.1701e+003.*(x (1)).*xdata.^2-5.0972e+005.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+( 2.7418e-122.*rmean.*temperature.*(x (5)).*(x (4)).*(3.0268e+099.*integration_time.*(x (3)).*xdata.^2+2.5774e+099.*exp(-1.0695.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))-2.6669e+099.*(x (5)).*(x (4))+8.9423e+097.*exp(-2.9977.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+1.6960e+095.*exp(-13.9343.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+1.6252e+092.*exp(-51.2087.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+3.3969e+088.*exp(-160.7898.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4)))./pi./x (6)./integration_time.^2./(x (3)).^3./xdata.^5));

x(6)=4e-9
%x(3)=5

F2=(27875976884861368019686522917955130027505434715./113078212145816597093331040047546785012958969400039613319782796882727665664.*temperature./pi./integration_time.^2.*xdata.^3./(4816437861622157./4503599627370496.*(x (1)).*xdata.^2+5151007104157705./4503599627370496.*(x (2)).*xdata.^4).^3.*((602054732702769625./2328696403508554.*(x (1)).*xdata.^2+643875888019713125./2328696403508554.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-602054732702769625./2328696403508554.*(x (1)).*xdata.^2-643875888019713125./2328696403508554.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+29851504503965847925354055635351390910053567435./56539106072908298546665520023773392506479484700019806659891398441363832832.*temperature./pi./integration_time.^2.*xdata.^3./(3375119391557767./1125899906842624.*(x (1)).*xdata.^2+5058811550670793./562949953421312.*(x (2)).*xdata.^4).^3.*((675023878311553400./1559496659010233.*(x (1)).*xdata.^2+2023524620268317200./1559496659010233.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-675023878311553400./1559496659010233.*(x (1)).*xdata.^2-2023524620268317200./1559496659010233.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+13216177793986403278477768978236182487742188595./28269553036454149273332760011886696253239742350009903329945699220681916416.*temperature./pi./integration_time.^2.*xdata.^3./(7844301334923487./562949953421312.*(x (1)).*xdata.^2+1707885594978209./8796093022208.*(x (2)).*xdata.^4).^3.*((784430133492348700./840566387252587.*(x (1)).*xdata.^2+10930467807860537600./840566387252587.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-784430133492348700./840566387252587.*(x (1)).*xdata.^2-10930467807860537600./840566387252587.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+18479460224682247805707570423683430840847347905./226156424291633194186662080095093570025917938800079226639565593765455331328.*temperature./pi./integration_time.^2.*xdata.^3./(7206984303956217./140737488355328.*(x (1)).*xdata.^2+720820941233925./274877906944.*(x (2)).*xdata.^4).^3.*((2882793721582486800./1611393727821037.*(x (1)).*xdata.^2+147624128764707840000./1611393727821037.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-2882793721582486800./1611393727821037.*(x (1)).*xdata.^2-147624128764707840000./1611393727821037.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+187721319900814691551178886958946645927508125./113078212145816597093331040047546785012958969400039613319782796882727665664.*temperature./pi./integration_time.^2.*xdata.^3./(5657289769229875./35184372088832.*(x (1)).*xdata.^2+1776630372431643./68719476736.*(x (2)).*xdata.^4).^3.*((707161221153734375./223074084249452.*(x (1)).*xdata.^2+28426085958906288000./55768521062363.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-707161221153734375./223074084249452.*(x (1)).*xdata.^2-28426085958906288000./55768521062363.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+(31742826741287./1157717398025177260465509317957105523538546212548663912901503255728869890897370054530621333538622167984447880036700018328704101824593920.*rmean.*temperature.*(x (3)).*(x (4)).*(3026826037704147407303018546135974741819862953500710289188037925556404607266286669857476206978777309.*integration_time.*(x (5)).*xdata.^2+2577357380414799558636504080492972281215686976020742433995393090492592613690900677787525083941568512.*exp(-4816437861622157./4503599627370496.*integration_time./(x (3))./(x (4)).*(x (5)).*xdata.^2).*(x (3)).*(x (4))-2666949911022952845507815221952147750453969154959494132680453903906716140848021198781916448913620992.*(x (3)).*(x (4))+89422763612080341258748589466991457883963596544273078308590608158345975597501760557943250233589760.*exp(-3375119391557767./1125899906842624.*integration_time./(x (3))./(x (4)).*(x (5)).*xdata.^2).*(x (3)).*(x (4))+169604447100029593391568501072624668417499776936241337298201856359007257759363156807820918128640.*exp(-7844301334923487./562949953421312.*integration_time./(x (3))./(x (4)).*(x (5)).*xdata.^2).*(x (3)).*(x (4))+162515003473634154046803726730943438274287793590280889412203664454867824706234840394015703040.*exp(-7206984303956217./140737488355328.*integration_time./(x (3))./(x (4)).*(x (5)).*xdata.^2).*(x (3)).*(x (4))+33969442385016936687384655742462808329748788758282591195754089434034691044799899804631040.*exp(-5657289769229875./35184372088832.*integration_time./(x (3))./(x (4)).*(x (5)).*xdata.^2).*(x (3)).*(x (4)))./pi./x(6)./integration_time.^2./(x (5)).^3./xdata.^5));

% myfun1(x(1),x(2),x(3),x(4),x(5),x(6));
figure(11)
semilogy(xdata,F2,wavenr,fluct,'o');
ylabel('Amplitud')
xlabel('modo')
h = legend('Fit_S_H','Experimental Amplitude',1);
set(h,'Interpreter','none')
text(1e6,1e-23,sprintf('sigma=%2.3e\n kappa=%2.3e\n c=%2.3e\n b=%2.3e\n epsilon=%2.3e\n h=%2.3e',x(1),x(2),x(3),x(4),x(5),x(6)))


Res=ydata-F2;
%Res =ydata-(2.4652e-028.*temperature./pi./integration_time.^2.*xdata.^3./(1.0695.*(x (1)).*xdata.^2+1.1438.*(x (2)).*xdata.^4).^3.*((258.5372.*(x (1)).*xdata.^2+276.4963.*(x (2)).*xdata.^4).*integration_time./xdata+exp((- 258.5372.*(x (1)).*xdata.^2-276.4963.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+5.2798e-028.*temperature./pi./integration_time.^2.*xdata.^3./(2.9977.*(x (1)).*xdata.^2+8.9863.*(x (2)).*xdata.^4).^3.*((432.8473.*(x (1)).*xdata.^2+1.2975e+003.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-432.8473.*(x (1)).*xdata.^2-1.2975e+003.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+4.6751e-028.*temperature./pi./integration_time.^2.*xdata.^3./(13.9343.*(x (1)).*xdata.^2+194.1641.*(x (2)).*xdata.^4).^3.*((933.2162.*(x (1)).*xdata.^2+1.3004e+004.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-933.2162.*(x (1)).*xdata.^2-1.3004e+004.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+ 8.1711e-029.*temperature./pi./integration_time.^2.*xdata.^3./(51.2087.*(x (1)).*xdata.^2+2.6223e+003.*(x (2)).*xdata.^4).^3.*((1.7890e+003.*(x (1)).*xdata.^2+ 9.1613e+004.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-1.7890e+003.*(x (1)).*xdata.^2-9.1613e+004.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+1.6601e-030.*temperature./pi./integration_time.^2.*xdata.^3./(160.7898.*(x (1)).*xdata.^2+2.5853e+004.*(x (2)).*xdata.^4).^3.*((3.1701e+003.*(x (1)).*xdata.^2+5.0972e+005.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-3.1701e+003.*(x (1)).*xdata.^2-5.0972e+005.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+( 2.7418e-122.*rmean.*temperature.*(x (5)).*(x (4)).*(3.0268e+099.*integration_time.*(x (3)).*xdata.^2+2.5774e+099.*exp(-1.0695.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))-2.6669e+099.*(x (5)).*(x (4))+8.9423e+097.*exp(-2.9977.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+1.6960e+095.*exp(-13.9343.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+1.6252e+092.*exp(-51.2087.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+3.3969e+088.*exp(-160.7898.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4)))./pi./x (6)./integration_time.^2./(x (3)).^3./xdata.^5));
%F=(2.4652e-028.*temperature./pi./integration_time.^2.*xdata.^3./(1.0695.*(x (1)).*xdata.^2+1.1438.*(x (2)).*xdata.^4).^3.*((258.5372.*(x (1)).*xdata.^2+276.4963.*(x (2)).*xdata.^4).*integration_time./xdata+exp((- 258.5372.*(x (1)).*xdata.^2-276.4963.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+5.2798e-028.*temperature./pi./integration_time.^2.*xdata.^3./(2.9977.*(x (1)).*xdata.^2+8.9863.*(x (2)).*xdata.^4).^3.*((432.8473.*(x (1)).*xdata.^2+1.2975e+003.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-432.8473.*(x (1)).*xdata.^2-1.2975e+003.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+4.6751e-028.*temperature./pi./integration_time.^2.*xdata.^3./(13.9343.*(x (1)).*xdata.^2+194.1641.*(x (2)).*xdata.^4).^3.*((933.2162.*(x (1)).*xdata.^2+1.3004e+004.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-933.2162.*(x (1)).*xdata.^2-1.3004e+004.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+ 8.1711e-029.*temperature./pi./integration_time.^2.*xdata.^3./(51.2087.*(x (1)).*xdata.^2+2.6223e+003.*(x (2)).*xdata.^4).^3.*((1.7890e+003.*(x (1)).*xdata.^2+ 9.1613e+004.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-1.7890e+003.*(x (1)).*xdata.^2-9.1613e+004.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+1.6601e-030.*temperature./pi./integration_time.^2.*xdata.^3./(160.7898.*(x (1)).*xdata.^2+2.5853e+004.*(x (2)).*xdata.^4).^3.*((3.1701e+003.*(x (1)).*xdata.^2+5.0972e+005.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-3.1701e+003.*(x (1)).*xdata.^2-5.0972e+005.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+( 2.7418e-122.*rmean.*temperature.*(x (5)).*(x (4)).*(3.0268e+099.*integration_time.*(x (3)).*xdata.^2+2.5774e+099.*exp(-1.0695.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))-2.6669e+099.*(x (5)).*(x (4))+8.9423e+097.*exp(-2.9977.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+1.6960e+095.*exp(-13.9343.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+1.6252e+092.*exp(-51.2087.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+3.3969e+088.*exp(-160.7898.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4)))./pi./x (6)./integration_time.^2./(x (3)).^3./xdata.^5));

%F=0.5.*sum(Res.^2);
F=F2;