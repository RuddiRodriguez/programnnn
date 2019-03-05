function F=fitting_easy(x)


wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path)); % 
fluct = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
sigmacn=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
fluct=(fluct-sigmacn);
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
% sym(q)
% factor=x(1)*((xdata.^2+q.^2).^2);
% factor1=x(2).*(xdata.^2+q.^2);
% factor3=1.3.*sqrt(x(3).*kbt).*((xdata.^2+q.^2).^(3/2));
% theo=int(kbt./(factor+factor1),q,0,8);

% theo=int(kbt)
theo=(kbt./(2.*x(1))).*((1./xdata)-(1./(sqrt(((x(1))./(x(2)))+(xdata.^2)))));
sigma=1e-7
factor=(((1./(((kbt.*ydata)./(2.*sigma))-(1./xdata)))-(1./(xdata.^2))).^2)./sigma
kappa=1./factor

figure(23)
semilogy(wavenr,fluct,'o','MarkerEdgeColor','r', 'MarkerFaceColor','r')
ylabel('Amplitud')
xlabel('modo')
h = legend('Fit_S_H','Experimental Amplitude',1);
set(h,'Interpreter','none')
text(3e6,1e-22,sprintf('kappa=%2.3e\n sigma=%2.3e',x(2),x(1)))
hold on
semilogy(xdata,theo,'-k','LineWidth',2)
hold off



 Res=ydata-theo
 figure (24)
 bar(xdata,Res)
x(1)
x(2)

F=0.5.*sum(Res.^2);



