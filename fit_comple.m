 function fi_min = fit_comple(x0)

%  function w=correlationandfit(s1,s2,s3)
% % this function plot the fluctuations
% function f=fitfriction(s1,s2,s3)
% clear all;
%fit_comple([1e-7 1e-19 8 1e8 0.1 4e-9])
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
parameterStruct;

% n = 6:26;
% sigma = 1e-07;
% kappa = 1e-20;

% PARAMETERS
% temperature = 304.15;
% integration_time = 1/15;
% scalefactor_sigma = 1e-07;
% scalefactor_kappa = 1e-20;
% TolX = 1e-50;
% TolFun =1e-50;
% first_plot_point = 1;
% last_plot_point = 25;
% MaxFunEvals = 2000;
% MaxIter = 2000;
parameterStruct.firstdatapoint;
parameterStruct.lastdatapoint;

% load data of spectrum7
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path)); % 
fluct = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
sigma2u=load(sprintf('%s/results/errores.txt',working_directory_path));
sigmcn=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
sigmcn=sigmcn';
temperature=parameterStruct.temperature
integration_time=parameterStruct.integration_time
fluct=(fluct-sigmcn');
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));


rmean=mean(r0)
r0=mean(r0);
%fluct=fluct-sigma2u;
% set region of xdata (predictor) and corresponding ydata (response)
xdata = wavenr(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
ydata = fluct(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
% s1=2
% s2=5


% % a * scalefactor_a
% parameterStruct.scalefactor_a=1e-1
% parameterStruct.scalefactor_b=1e-3
% % xdata=tiempo;
% % ydata=correlation;
% options = optimset('TolFun',1e-20);
% %options.MaxFunEvals = 10000;
% % options.TolFun = 1e-4;
% options.Tolx=1e-1000;
% options.TolFun=1e-99;
% options.MaxFunEvals=1e99;
% 
% 
%  options.LargeScale='on' ;
% options.MaxIter=1000000000000;
% options.Diagnostics='on'
% options.Display='notify';
% %  options.DiffMaxChange=1e-1
% %  options.DiffMinChange=1e-1
% %options.NonlEqnAlgorithm={'lm'}
% options.LevenbergMarquardt='off';
% options.TolCon=1e-60;
% x0=[0 0 0];
% 
%  x0=[1e-8 1.57e-19 0.04 1e8 1 4e-9];
 %x0=[1 1 1 1 1 4e-9];
%  A=[1 0 0]
%  b=[1]
%  Aeq=[]
% %  beq=[]
%  ul=[1e-9 1e-20 1e-5 1e5 1 1e-9]
%  ub=[1e-5 1e-19 1 1e11 10 6e-9]
 options=optimset('Display','iter','TolFun',1e-18,'TolX',1e-18,'MaxFunEvals',5000);

 %myfun=@(x)(-2.4652e-028.*temperature./pi./integration_time.^2.*xdata.^3./(1.0695.*(x (1)).*xdata.^2+1.1438.*(x (2)).*xdata.^4).^3.*((258.5372.*(x (1)).*xdata.^2+276.4963.*(x (2)).*xdata.^4).*integration_time./xdata+exp((- 258.5372.*(x (1)).*xdata.^2-276.4963.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+5.2798e-028.*temperature./pi./integration_time.^2.*xdata.^3./(2.9977.*(x (1)).*xdata.^2+8.9863.*(x (2)).*xdata.^4).^3.*((432.8473.*(x (1)).*xdata.^2+1.2975e+003.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-432.8473.*(x (1)).*xdata.^2-1.2975e+003.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+4.6751e-028.*temperature./pi./integration_time.^2.*xdata.^3./(13.9343.*(x (1)).*xdata.^2+194.1641.*(x (2)).*xdata.^4).^3.*((933.2162.*(x (1)).*xdata.^2+1.3004e+004.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-933.2162.*(x (1)).*xdata.^2-1.3004e+004.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+ 8.1711e-029.*temperature./pi./integration_time.^2.*xdata.^3./(51.2087.*(x (1)).*xdata.^2+2.6223e+003.*(x (2)).*xdata.^4).^3.*((1.7890e+003.*(x (1)).*xdata.^2+ 9.1613e+004.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-1.7890e+003.*(x (1)).*xdata.^2-9.1613e+004.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+1.6601e-030.*temperature./pi./integration_time.^2.*xdata.^3./(160.7898.*(x (1)).*xdata.^2+2.5853e+004.*(x (2)).*xdata.^4).^3.*((3.1701e+003.*(x (1)).*xdata.^2+5.0972e+005.*(x (2)).*xdata.^4).*integration_time./xdata+exp((-3.1701e+003.*(x (1)).*xdata.^2-5.0972e+005.*(x (2)).*xdata.^4).*integration_time./xdata)-1)+( 2.7418e-122.*rmean.*temperature.*(x (5)).*(x (4)).*(3.0268e+099.*integration_time.*(x (3)).*xdata.^2+2.5774e+099.*exp(-1.0695.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))-2.6669e+099.*(x (5)).*(x (4))+8.9423e+097.*exp(-2.9977.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+1.6960e+095.*exp(-13.9343.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+1.6252e+092.*exp(-51.2087.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4))+3.3969e+088.*exp(-160.7898.*integration_time./(x (5))./(x (4)).*(x (3)).*xdata.^2).*(x (5)).*(x (4)))./pi./x (6)./integration_time.^2./(x (3)).^3./xdata.^5));

 %[x,resnorm,residual,exitflag,output] = lsqcurvefit(@myfun,x0,xdata,ydata,ul,ub,options)
%  [x,fval,exitflag,output] =  fmincon(@myfun,x0,A,b,Aeq,beq,ul,ub)
  [x,fval,exitflag,output]=fminsearch(@myfun,x0,options);
%   %[x,resnorm,residual,exitflag,output]=lsqnonlin(@myfun,x0,[0 0 1e-9],[1 1 1],options)
% %[x,resnorm,residual,exitflag,output] =  lsqnonlin(@myfun,x0,[0 1e-9],[1 1],options);
% % y3 = myfun(x,xdata);
% % figure(1)
% % plot(xdata,y3,xdata,ydata,'o')
% myfun1(x(1),x(2),x(3),x(4),x(5),x(6));
%  msgbox(sprintf('Sigma = %g \nKappa = %g \nepsilon = %g \nb = %g \nc = %g \nh = %g ',x(1),x(2),x(3),x(4),x(5),x(6)),'Fitting Results','none','non-modal')
% hold off;
% ftype= fittype('exp(-2.6e-004*qx)*((a * scalefactor_a+(1-(a * scalefactor_a))*exp(-((b * scalefactor_b)*qx)^0.6667)))','independent','qx','coefficients',{'a','b'},'problem',{'scalefactor_a','scalefactor_b'},'Levenberg-Marquardt');
% 
% %ftype= fittype('exp(-7.86e-005*qx)*(a+(1-(a))*exp(-((b )*qx)^0.6667))','independent','qx','coefficients',{'a','b'},'Levenberg-Marquardt');
% 
% 
% 
% [fresult,gof,output] = fit(xdata,ydata,ftype,'Lower',[0 1e-9],'Upper',[1 1],'StartPoint',[0 0],'TolX',parameterStruct.TolX,'TolFun',parameterStruct.TolFun,'MaxFunEvals',parameterStruct.MaxFunEvals,'MaxIter',parameterStruct.MaxIter,'Algorithm','Levenberg-Marquardt','problem',{parameterStruct.scalefactor_a,parameterStruct.scalefactor_b})
% 
% %[fresult,gof,output] = fit(xdata,ydata,ftype,'Lower',[0 1e-6],'Upper',[1 1],'StartPoint',[1e-5 1],'TolX',parameterStruct.TolX,'TolFun',parameterStruct.TolFun,'MaxFunEvals',parameterStruct.MaxFunEvals,'MaxIter',parameterStruct.MaxIter,'Algorithm','Levenberg-Marquardt')
% 
     %f=feval(fresult,xdata);
%     figure(7)
%      plot(xdata,ydata,'.',xdata,f,'k');
%      hold on;
% a = fresult.a * parameterStruct.scalefactor_a
% b = fresult.b * parameterStruct.scalefactor_b
% % save(sprintf('%s/correla/parametrofit.txt',working_directory_path),'parametrosfit','-ascii');
% % % save(sprintf('%s/correla/parametrofitc.txt',working_directory_path),'parametrosfitc','-ascii');
% % save(sprintf('%s/correla/parametrofita.txt',working_directory_path),'parametrosfita','-ascii');
% % save(sprintf('%s/correla/tiempo.txt',working_directory_path),'tiempo','-ascii');
% % mean(r0)
% %  fresult
% % %  q = wavenumbers(n,1); % 
% % 
% %  q=wavenr((s1:s2),1)
% % %  q=(s1:s2)'
% %   xdata1=q.^3
% %  xdata2=q.^2
% %  ydata1=parametrosfit
% %  
% %  tiempos=1./parametrosfit
% %  parametrosfit
% %  ftype=fittype('a*x+b');
% %  [fresult,gof,output] =fit(xdata2,ydata1,ftype);
% % %  [fresult,gof,output] =fit(xdata1,ydata1,ftype);
% %  f=feval(fresult,xdata2);
% %   figure(3)
% %   plot(xdata2,ydata1,'.',xdata2,f,'k');
% %   kappa=fresult.a*4*0.001
% %   fresult
% %   gof
% %   w=fresult.a
% % %   fid=fopen('C:/membrane_tracking_project/pendambiente.txt','a+');
% % %   fprintf(fid,'%6.3e\n',w);
% % % fclose(fid)
% % tiempos=1./parametrosfit
% %  parametrosfit
% %    