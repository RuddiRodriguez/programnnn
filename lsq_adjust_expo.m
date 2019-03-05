function L =lsq_adjust_expo(x0,lb,ub,point_fit,m,modos)



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

% output of parameters


savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

% a = load(sprintf('%s/results/a.txt',working_directory_path));
% b = load(sprintf('%s/results/b.txt',working_directory_path));
c = load(sprintf('%s/results/c.txt',working_directory_path));
wavenr = load(sprintf('%s/results/wavenumbers.txt',working_directory_path));
% fluctuations = load(sprintf('%s/results/fluctuations.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
% sigmaR2=load(sprintf('%s/results/sigmar2.txt',working_directory_path));
r0=r0(savedcontours);
r0=mean(r0);
% j=0
% q=0
% mediafluct=zeros(1,length(savedcontours));
% tiempo=zeros(1,length(savedcontours));
% w = waitbar(0,'Please wait...');
% for j = savedcontours
%     q=q+1;
% mempospol = load(sprintf('%s/memposs/mempos%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates
% n=1:length(mempospol);
% fluctpura=mempospol(n,1);
% 
% mediafluct(q)=(sum((fluctpura).^2))/(length(fluctpura));%(mean(((fluctpura)).^2))-((mean((fluctpura))).^2);    %mean(fluctpura)%  (sum((fluctpura).^2))/(length(fluctpura))
% %savedcontours=[4 5 6 7 8];
% tiempo1(q)=(parameterStruct.integration_time.*j);
% waitbar (j/length(savedcontours))
% end
% close(w)
% mediafluct=mediafluct;
% mediafluct=smooth(mediafluct,'moving')

% tiempo1=tiempo1';
% save(sprintf('%s/results/mediafluct.txt',working_directory_path),'mediafluct','-ascii');
% save(sprintf('%s/results/tiempo.txt',working_directory_path),'tiempo1','-ascii');



%r0=r0(savedcontours);
modos1=modos;
modos=modos+1;
mkdir(sprintf('%s/correla',working_directory_path));
% m=12;
correla = cell(m,1);

parametrosfit=zeros(m,1);
parametrosfitc=zeros(m,1);
parametrosfita=zeros(m,1);
 parametrosfitexpo=zeros(m,1);
% q=zeros(g,1);
i=0;
f3=100;
%m=12;
for j = 2:m
    i=i+1;
    correla{i} = load(sprintf('%s/correla/correlation%i.txt',working_directory_path,j)); % load the membrane position in polar coordinates
end
q=(modos./r0);
q1=(modos);
q1=q1';
q=q';
tiempo= load(sprintf('%s/correla/tiempo.txt',working_directory_path));
%gg=2;
length(correla)
i=0;
variable=zeros(length(modos),4)
for gg=modos
    h = correla{gg};
    i=i+1;
gg
n=1:point_fit;
ydata=h(n,1);
xdata=tiempo(n,1);
%x(1)=1;
%x(3)=1
x(4)=0
%x(3)=0.667
options=optimset('TolFun',1e-20 ,'TolX',1e-20,'MaxFunEvals',50000000,'MaxIter',100000000000000000,'DiffMinChange',1e-54)%,'PlotFcns',{@optimplotx,@optimplotfunccount,@optimplotfval,@optimplotresnorm } );
[x,resnorm,residual,exitflag,output] = lsqcurvefit(@myfun_lsq_expo,x0,xdata,ydata,lb,ub,options);
%[x,fval,exitflag,output]=fminsearch(@myfun_lsq_expo,x0,options);
%x=myfun_lsq_expo(xdata,ydata,x0);
%teorica=(x(1)).*exp(-x(2).*xdata)+x(3);
teorica=(x(1)).*exp(-(x(2).*xdata).^x(3))+x(4);
%teorica = (1-x(1)).*exp(-x(2).*xdata)+x(1).*exp(-x(3)*xdata)+0;
%teorica=(1-x(1)).*exp(-(x(2).*xdata).^x(3))+x(1).*exp(-x(4)*xdata)+0
 variable(i,:)=x
 figure(gg)  
% 
     semilogx(xdata,teorica,'-r',xdata,ydata,'o','LineWidth',2,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
     %semilogx(xdata,ydata,'-o',xdata,teorica,'-k');
     title('Autocorrelation function (fourier)')
     xlabel('Time (s)')
     ylabel('G (u.a)')
     %text(0.002,0.5,sprintf('Amplitud=%2.3e\n Frecuencia1=%2.3e\n Beta=%2.3e\n Frecuencia2=%2.3e',x(1),x(2),x(3),x(4)))
end
b=5e8
epsilon=0.1
assignin('base', 'results', variable);
ms=(epsilon.*(q.^2))./(8*b);
dif=9e-11.*(q.^2);
figure(500)
subplot(2,2,1)
plot(q,variable(1:length(variable),1),'-o')
 subplot(2,2,2)
 plot(q,variable(1:length(variable),2),'-o')
subplot(2,2,3)
loglog(q,dif,'-b',q,ms,'-g',q,variable(1:length(variable),3),'-o')
subplot(2,2,4)
 plot(q,variable(1:length(variable),4),'-o')
 hold on
figure
save(sprintf('%s/correla/results.txt',working_directory_path),'variable','-ascii')

 

