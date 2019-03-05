function F=fitting_easy(x)


% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all');

% read working directory from config file 'working_directory_path.ini'
fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s');
fclose('all');

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}), c{1});

% output of parameters
parameterStruct;

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
r0=r0(savedcontours);
rmean=mean(r0);
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path)); % 
fluct = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
sigmacn=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
fluct=(fluct-sigmacn');
% set region of xdata (predictor) and corresponding ydata (response)
xdata = wavenr(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
ydata = fluct(parameterStruct.firstdatapoint:parameterStruct.lastdatapoint);
sigma2u=load(sprintf('%s/results/errores.txt',working_directory_path));

kbt=(1.3806e-23.*parameterStruct.temperature);
% ftype = fittype('(beta/2*(sigma * scalefactor_sigma))*((1/qx)-(1/(sqrt(((sigma * scalefactor_sigma)/(kappa * scalefactor_kappa))+(qx^2)))))','independent','qx','coefficients',{'sigma','kappa'}','problem',{'beta','scalefactor_sigma','scalefactor_kappa'});
% s = fitoptions('Method','NonlinearLeastSquares',...
%                'Startpoint',[1,1],'TolFun',10e-90,...
%                'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
%                'Levenberg-Marquardt','MaxFunEvals',...
%                1000000000,'MaxIter',10000000000);  
%            
%            [fresult,gof,output] = fit(xdata,ydata,ftype,s,'problem',{kbt,parameterStruct.scalefactor_sigma,parameterStruct.scalefactor_kappa})
%   

factor1=kbt/(2.*x(1));
factor2=1./xdata;
factor3=1./((x(1)./x(2))+(xdata.^2));
factor4=6.*x(1).*(rmean.^2);
factor5=(x(3)).*((x(4)).^2).*xdata;
theo=factor1.*(factor2-sqrt(factor3)+(factor4./factor5));



%theo=(kbt./(2.*x(1))).*((1./xdata)-(1./(sqrt(((x(1))./(x(2)))+(xdata.^2)))));


sigma=1e-7
factor=(((1./(((kbt.*ydata)./(2.*sigma))-(1./xdata)))-(1./(xdata.^2))).^2)./sigma
kappa=1./factor

figure(23)
semilogy(xdata,theo,'-k',xdata,ydata,'o','LineWidth',2,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
ylabel('Amplitud')
xlabel('modo')
h = legend('Fit_S_H','Experimental Amplitude',1);
set(h,'Interpreter','none')
text(3e6,1e-22,sprintf('kappa=%2.3e\n sigma=%2.3e\n epsilon=%2.3e\n h=%2.3e',x(2),x(1),x(3),x(4)))

figure (24)
bar(xdata,kappa)
Res=ydata-theo
x(1)
x(2)

F=0.5.*sum(Res.^2);



