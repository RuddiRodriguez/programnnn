% clc
% clear
%function f=correlationandfit(s1,s2)

s1=2
s2=2
%s1 y s2 son los modos entre los cuales queremos calcular las fluctuaciones
%







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
mkdir(sprintf('%s/modos',working_directory_path));
mkdir(sprintf('%s/modostiempo',working_directory_path));
% output of parameters
parameterStruct

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
%savedcontours=[1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63	64	65	66	67	68	69	70	71	72	73	74	75	76	77	78	79	80	81	82	83	84	85	86	87	88	89	90	91	92	93	94	95	96	97	98	99	100	101	102	103	104	105	106	107	108	109	110	111	112	113	114	115	116	117	118	119	120	121	122	123	124	125	126	127	128	129	130	131	132	133	134	135	136	137	138	139	140	141	142	143	144	145	146	156	157	158	159	160	161	162	163	164	165	166	167	173	174	175	176	177	178	180	181	233	244	245	246	268	302	310	311	312	316	322	323	324	325	326	328	375	379	384	385	387	391	392	397	398	401	402	403	405	406	410	412	418	419	422	426	427	437	444]
sigma0=(0.1*parameterStruct.resolution);%1e-007
a = load(sprintf('%s/results/a.txt',working_directory_path));
b = load(sprintf('%s/results/b.txt',working_directory_path));
c = load(sprintf('%s/results/c.txt',working_directory_path));
% errorcn=load(sprintf('%s/results/sigmacn1.txt',working_directory_path));

wavenumbers = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
%savedcontours=[4 5 6 7 8];
r0=r0(savedcontours);
% mkdir(sprintf('%s/modos',working_directory_path));
% c=(c(m,savedcontours))
% termino1=zeros(2,(length(c)-1))
% termino1=zeros(2,(length(c)-1))
% termino1=zeros(2,(length(c)-1))

for j=[7 8]
 n=s1:s2;
 ccc=c(n,j)
 aaa=a(n,j)
 bbb=b(n,j)
 sigma=(aaa-mean(aaa).^2)
%  error=sigmacn1(n,j)
 figure (3)
 hold on;
 plot(n,aaa)
 title('c_n por modos')
 save(sprintf('%s/modos/modo%i.txt',working_directory_path,j),'ccc','-ascii');
end
hold off;
q=0
tiempo=zeros(1,length(savedcontours))
for j = savedcontours
    q=q+1
   % tiempo(q)=24.816+(0.066*j);
 tiempo(q)=0.066*j;   
end
    
for m=[3  ]
vv=(c(m,savedcontours));
bb=(b(m,savedcontours));
aa=(b(m,savedcontours));
cc=vv';
hold on;
figure (4)
hold on;
sigma=((vv-mean(vv)).^2)./2
plot(tiempo,cc)
title('modos-funcion-tiempo')
save(sprintf('%s/modostiempo/modotiempo%i.txt',working_directory_path,m),'cc','-ascii');

figure(5)
hold on;
plot(tiempo,r0)
title ('radio/tiempo')
r0=r0';
save(sprintf('%s/results/r01.txt',working_directory_path),'r0','-ascii')
% hold off;
end

% n=1:50;
% wavenr=n/mean(r0)
% wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path)); % 
% %fluct = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
% fluct=((mean(r0))^3)*(vvv.^2)/3
% % set region of xdata (predictor) and corresponding ydata (response)
% xdata = wavenr(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
% ydata = fluct(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
% 
% xdata = wavenr(n);
% ydata = fluct(n);
% % xdata=xdata'
% % ydata=ydata'
% 
% % set fittyp of the function with the following variables:
% % coefficients: sigma, kappa
% % idependent/predictor: qx
% % problemdependent-constants: scalefactor_sigma, scalefactor_kappa
% 
% % ftype = fittype('86131723981357271686750207030917009197377559875/13803492693581127574869511724554050904902217944340773110325048447598592*qx^3/(4972140676145015/4503599627370496*(sigma * scalefactor_sigma)*qx^2+5489427335664445/4503599627370496*(kappa * scalefactor_kappa)*qx^4)^3*(112589990684262400/7098112038896037/qx*(4972140676145015/4503599627370496*(sigma * scalefactor_sigma)*qx^2+5489427335664445/4503599627370496*(kappa * scalefactor_kappa)*qx^4)+exp(-112589990684262400/7098112038896037/qx*(4972140676145015/4503599627370496*(sigma * scalefactor_sigma)*qx^2+5489427335664445/4503599627370496*(kappa * scalefactor_kappa)*qx^4))-1)+46781576841508965099649462798448872477313283375/3450873173395281893717377931138512726225554486085193277581262111899648*qx^3/(2278642293337305/562949953421312*(sigma * scalefactor_sigma)*qx^2+2305804747575687/140737488355328*(kappa * scalefactor_kappa)*qx^4)^3*(22517998136852480/2718217551980133/qx*(2278642293337305/562949953421312*(sigma * scalefactor_sigma)*qx^2+2305804747575687/140737488355328*(kappa * scalefactor_kappa)*qx^4)+exp(-22517998136852480/2718217551980133/qx*(2278642293337305/562949953421312*(sigma * scalefactor_sigma)*qx^2+2305804747575687/140737488355328*(kappa * scalefactor_kappa)*qx^4))-1)+54275750806007000319552341842596195131041023225/6901746346790563787434755862277025452451108972170386555162524223799296*qx^3/(6074490001041099/281474976710656*(sigma * scalefactor_sigma)*qx^2+8193319083804227/17592186044416*(kappa * scalefactor_kappa)*qx^4)^3*(28147497671065600/7845598099354671/qx*(6074490001041099/281474976710656*(sigma * scalefactor_sigma)*qx^2+8193319083804227/17592186044416*(kappa * scalefactor_kappa)*qx^4)+exp(-28147497671065600/7845598099354671/qx*(6074490001041099/281474976710656*(sigma * scalefactor_sigma)*qx^2+8193319083804227/17592186044416*(kappa * scalefactor_kappa)*qx^4))-1)+99629978708602951608745794609064503995670102725/220855883097298041197912187592864814478435487109452369765200775161577472*qx^3/(6281631839615597/70368744177664*(sigma * scalefactor_sigma)*qx^2+273801110731667/34359738368*(kappa * scalefactor_kappa)*qx^4)^3*(7036874417766400/3989122658160117/qx*(6281631839615597/70368744177664*(sigma * scalefactor_sigma)*qx^2+273801110731667/34359738368*(kappa * scalefactor_kappa)*qx^4)+exp(-7036874417766400/3989122658160117/qx*(6281631839615597/70368744177664*(sigma * scalefactor_sigma)*qx^2+273801110731667/34359738368*(kappa * scalefactor_kappa)*qx^4))-1)','independent','qx','coefficients',{'sigma','kappa'},'problem',{'scalefactor_sigma','scalefactor_kappa'},'Levenberg-Marquardt')
% ftype = fittype('27875976884861368019686522917955130027505434715/113078212145816597093331040047546785012958969400039613319782796882727665664*temperature/pi/integration_time^2*qx^3/(4816437861622157/4503599627370496*(sigma * scalefactor_sigma)*qx^2+5151007104157705/4503599627370496*(kappa * scalefactor_kappa)*qx^4)^3*((602054732702769625/2328696403508554*(sigma * scalefactor_sigma)*qx^2+643875888019713125/2328696403508554*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-602054732702769625/2328696403508554*(sigma * scalefactor_sigma)*qx^2-643875888019713125/2328696403508554*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+29851504503965847925354055635351390910053567435/56539106072908298546665520023773392506479484700019806659891398441363832832*temperature/pi/integration_time^2*qx^3/(3375119391557767/1125899906842624*(sigma * scalefactor_sigma)*qx^2+5058811550670793/562949953421312*(kappa * scalefactor_kappa)*qx^4)^3*((675023878311553400/1559496659010233*(sigma * scalefactor_sigma)*qx^2+2023524620268317200/1559496659010233*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-675023878311553400/1559496659010233*(sigma * scalefactor_sigma)*qx^2-2023524620268317200/1559496659010233*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+13216177793986403278477768978236182487742188595/28269553036454149273332760011886696253239742350009903329945699220681916416*temperature/pi/integration_time^2*qx^3/(7844301334923487/562949953421312*(sigma * scalefactor_sigma)*qx^2+1707885594978209/8796093022208*(kappa * scalefactor_kappa)*qx^4)^3*((784430133492348700/840566387252587*(sigma * scalefactor_sigma)*qx^2+10930467807860537600/840566387252587*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-784430133492348700/840566387252587*(sigma * scalefactor_sigma)*qx^2-10930467807860537600/840566387252587*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+18479460224682247805707570423683430840847347905/226156424291633194186662080095093570025917938800079226639565593765455331328*temperature/pi/integration_time^2*qx^3/(7206984303956217/140737488355328*(sigma * scalefactor_sigma)*qx^2+720820941233925/274877906944*(kappa * scalefactor_kappa)*qx^4)^3*((2882793721582486800/1611393727821037*(sigma * scalefactor_sigma)*qx^2+147624128764707840000/1611393727821037*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-2882793721582486800/1611393727821037*(sigma * scalefactor_sigma)*qx^2-147624128764707840000/1611393727821037*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)+187721319900814691551178886958946645927508125/113078212145816597093331040047546785012958969400039613319782796882727665664*temperature/pi/integration_time^2*qx^3/(5657289769229875/35184372088832*(sigma * scalefactor_sigma)*qx^2+1776630372431643/68719476736*(kappa * scalefactor_kappa)*qx^4)^3*((707161221153734375/223074084249452*(sigma * scalefactor_sigma)*qx^2+28426085958906288000/55768521062363*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx+exp((-707161221153734375/223074084249452*(sigma * scalefactor_sigma)*qx^2-28426085958906288000/55768521062363*(kappa * scalefactor_kappa)*qx^4)*integration_time/qx)-1)','independent','qx','coefficients',{'sigma','kappa'},'problem',{'scalefactor_sigma','scalefactor_kappa','temperature','integration_time'},'Levenberg-Marquardt')
% 
% [fresult,gof,output] = fit(xdata,ydata,ftype,'StartPoint',[1 1],'TolX',parameterStruct.TolX,'TolFun',parameterStruct.TolFun,'MaxFunEvals',parameterStruct.MaxFunEvals,'MaxIter',parameterStruct.MaxIter,'Algorithm','Levenberg-Marquardt','problem',{parameterStruct.scalefactor_sigma,parameterStruct.scalefactor_kappa,parameterStruct.temperature,parameterStruct.integration_time})
% %ftype = fittype('(1929224991978674363003690277165/11709243565246420258621027978548378526750882773788260302848/pi/integration_time^2/qx^9/kappa * scalefactor_kappa^3*(622614267147378125/2251799813685248*integration_time*qx^3*kappa * scalefactor_kappa+exp(-622614267147378125/2251799813685248*integration_time*qx^3*kappa * scalefactor_kappa)-1)+8844577344029319570196755195805/12156146893201841097880189035811737317092159392991225611026432/pi/integration_time^2/qx^9/kappa * scalefactor_kappa^3*(91306951841268125/70368744177664*integration_time*qx^3*kappa * scalefactor_kappa+exp(-91306951841268125/70368744177664*integration_time*qx^3*kappa * scalefactor_kappa)-1)+1684812608504325560256190800685/26379803694176068421434270777548747192511558300201568697009045504/pi/integration_time^2/qx^9/kappa * scalefactor_kappa^3*(457526796561280625/35184372088832*integration_time*qx^3*kappa * scalefactor_kappa+exp(-457526796561280625/35184372088832*integration_time*qx^3*kappa * scalefactor_kappa)-1)+2564104408349841188861613971465/565871775567660558500432646726062380095261968734256539539964619128832/pi/integration_time^2/qx^9/kappa * scalefactor_kappa^3*(402916911775703625/4398046511104*integration_time*qx^3*kappa * scalefactor_kappa+exp(-402916911775703625/4398046511104*integration_time*qx^3*kappa * scalefactor_kappa)-1)+33182199879849734696133156335/345399913544383699146450534952389574055052522447677139845929019904098304/pi/integration_time^2/qx^9/kappa * scalefactor_kappa^3*(35027390282847625/68719476736*integration_time*qx^3*kappa * scalefactor_kappa+exp(-35027390282847625/68719476736*integration_time*qx^3*kappa * scalefactor_kappa)-1))*temperature','independent','qx','coefficients',{'kappa'},'problem',{'scalefactor_kappa','temperature','integration_time'},'Levenberg-Marquardt')
% 
% 
% %[fresult,gof,output] = fit(xdata,ydata,ftype,'StartPoint',[1 1],'TolX',parameterStruct.TolX,'TolFun',parameterStruct.TolFun,'MaxFunEvals',parameterStruct.MaxFunEvals,'MaxIter',parameterStruct.MaxIter,'Algorithm','Levenberg-Marquardt','problem',{parameterStruct.scalefactor_kappa,parameterStruct.temperature,parameterStruct.integration_time})
% % [fresult,gof,output] = fit(xdata,ydata,ftype,'StartPoint',[1 1],'TolX',1e-50,'TolFun',1e-50,'MaxFunEvals',2000,'MaxIter',2000,'Lower',[0 0],'problem',{scalefactor_sigma scalefactor_kappa,temperature,integration_time})
% 
% %  waveruido=load(sprintf('%s/results1/wavenumbers.txt',working_directory_path));
% %  fluctuationruido=load(sprintf('%s/results1/fluctuations.txt',working_directory_path));
% %  g=1:50;
% %  waveruido=waveruido(g,1);
% %  fluctuationruido=fluctuationruido(g,1);
% 
% f=feval(fresult,xdata);
% 
% % sigma = fresult.sigma * parameterStruct.scalefactor_sigma
% kappa = fresult.kappa * parameterStruct.scalefactor_kappa
% kappa./(1.3806e-23.*305.15)
% % figure(10) 
% % semilogy(wavenr(parameterStruct.first_plot_point:parameterStruct.last_plot_point),fluct(parameterStruct.first_plot_point:parameterStruct.last_plot_point),'ro');
% % hold on;
% % semilogy(xdata,f,'b-',waveruido,fluctuationruido,'bo');
% % hold off;
% figure(11)
% % semilogy(wavenr(parameterStruct.first_plot_point:parameterStruct.last_plot_point),fluct(parameterStruct.first_plot_point:parameterStruct.last_plot_point),'ro');
% % hold on;
% semilogy(xdata,f,'-',wavenr,fluct);
% hold off;
% % figure(6)
% % plot(waveruido,fluctuationruido)
% % save log-file from of 'testcontour' program
% % fid = fopen(sprintf('%s/results/log_fitting.txt',working_directory_path),'w');
% % fprintf(fid,'Sigma = %g \nKappa = %g \nsse = %g \nrsquare = %g \nadjrsquare = %g',sigma,kappa,gof.sse,gof.rsquare,gof.adjrsquare);
% % fclose('all');
% 
% fid = fopen(sprintf('%s/results/xdata.txt',working_directory_path),'w');
% fprintf(fid,'%6.9e\n',xdata);
% fclose(fid);
% fid = fopen(sprintf('%s/results/f.txt',working_directory_path),'w');
% fprintf(fid,'%6.9e\n',f);
% fclose(fid);
% 
% msgbox(sprintf('Sigma = %g \nKappa = %g \nsse = %g \nrsquare = %g \nadjrsquare = %g',sigma,kappa,gof.sse,gof.rsquare,gof.adjrsquare),'Fitting Results','none','non-modal')
% 
% % fid = fopen(sprintf('%s/results/log_fitting1.txt',working_directory_path),'w');
% % fprintf(fid,'%4.2f',sigma);
% % fclose('all');
% 
% % this display a message box displaying information on the fitting process
% 
% %msgbox(sprintf('Sigma = %g \nKappa = %g \nsse = %g \nrsquare = %g \nadjrsquare = %g',sigma,kappa,gof.sse,gof.rsquare,gof.adjrsquare),'Fitting Results','none','non-modal')
% 
