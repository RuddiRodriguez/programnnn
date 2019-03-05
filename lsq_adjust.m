function L =lsq_adjust(x0,lb,ub,point_fit,m,mode1,mode2,kappa)



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
q=((2:mode2)./r0);
q1=(2:mode2)
q1=q1';
q=q';
tiempo= load(sprintf('%s/correla/tiempo.txt',working_directory_path));
%gg=2;
length(correla)
variable=zeros((mode2-1),4)
for gg=mode1:(mode2-1)
    h = correla{gg};
gg
n=3:point_fit;
ydata=h(n,1);
xdata=tiempo(n,1);
x(5)=0;
%x(3)=0.667
options=optimset('TolFun',1e-12 ,'TolX',1e-11,'MaxFunEvals',50000000,'MaxIter',100000000000000000,'DiffMinChange',1e-54,'DiffMaxChange',8','TypicalX',[1 0.7 12 1]);
[x,resnorm,residual,exitflag,output] = lsqcurvefit(@myfun_lsq,x0,xdata,ydata,lb,ub,options)
teorica=(1-x(1)).*exp(-(x(2).*xdata).^x(3))+x(1).*exp(-x(4)*xdata)+0;
variable(gg,:)=x
figure(gg)  

     semilogx(xdata,teorica,'-r',xdata,ydata,'o','LineWidth',2,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
     %semilogx(xdata,ydata,'-o',xdata,teorica,'-k');
     title('Autocorrelation function (fourier)')
     xlabel('Time (s)')
     ylabel('G (u.a)')
     text(0.002,0.5,sprintf('Amplitud=%2.3e\n Frecuencia1=%2.3e\n Beta=%2.3e\n Frecuencia2=%2.3e',x(1),x(2),x(3),x(4)))
end

sigmaexcess=30;
ce=-2.4;
f=0

% for j=2:mode2
%     f=f+1;
%     d=0
%     for l=j:1000
%         d=d+1;
%         factor1(d)=l*(l+1)+sigmaexcess-(4*ce)+(2*(ce^2));
%         ZL(d)=((2*l+1)*((2*(l^2))+(2*l)-1))/(l*(l+1)*(l+2)*(l-1));
%        
%     end
%     prueba=sum(factor1);
%     prueba1=sum(ZL);
%      fre(f)=(kappa./(0.001.*(r0.^3))).*(sum(factor1)./sum(ZL))
% end
%    fre=fre'; 
l=q.*r0
factor1=l.*(l+1)+sigmaexcess-(4.*ce)+(.2*(ce.^2));
factor2=((2.*l+1).*((2.*(l.^2))+(2.*l)-1))./(l.*(l+1).*(l+2).*(l-1));
%kappa=1.2e-19
epsilon=0.2
b=2e9

assignin('base', 'results', variable);
ms=((kappa./((r0).^3))./(4.*0.001)).*((factor1)./(factor2));
fricc=(epsilon.*(q.^2))./(2*b);
diff=3e-12*(q.^2);
sss=variable(1:length(variable),1)
figure(500)
subplot(2,2,1)
plot(q,variable(1:length(variable),1),'o','MarkerEdgeColor','r', 'MarkerFaceColor','k')
hold on
subplot(2,2,2)
plot(q,variable(1:length(variable),3),'o','MarkerEdgeColor','r', 'MarkerFaceColor','k')
hold on
subplot(2,2,3)
loglog(l,variable(1:length(variable),2),'o',l,ms,'-b','MarkerEdgeColor','r', 'MarkerFaceColor','k')
hold on
subplot(2,2,4)
loglog(q,variable(1:length(variable),4),'o','MarkerEdgeColor','r', 'MarkerFaceColor','k')
hold on


figure(501)
subplot(2,2,1)
plot(q,variable(1:length(variable),1),'-k')
hold on
subplot(2,2,2)
plot(q,variable(1:length(variable),3),'-k')
hold on
subplot(2,2,3)
loglog(q,variable(1:length(variable),2),'-k',q,ms,'-b')
hold on
subplot(2,2,4)
loglog(q,variable(1:length(variable),4),'-k')
hold on
save(sprintf('%s/correla/results.txt',working_directory_path),'variable','-ascii')

 
