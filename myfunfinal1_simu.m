function F = myfunfinal1_simu(x)

% myfunfinal1_simu([200 -2.41 1e-19 1e-15 1e4 1.2e-9 0.1])

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
% 
%x(1)=3e-6;x(2)=1e-19;
 v=parameterStruct.lastdatapoint;
 v1=parameterStruct.firstdatapoint;
 C0=-0.76;
 integration_time=parameterStruct.integration_time;
exces=60;
flucta = load(sprintf('%s/results/fluctuationsa.txt',working_directory_path));
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
q=v1:v;
q1=1:50;
flucta1=flucta;
flucta=flucta(q,1);
kappa=zeros(1,length(q));
keff=zeros(1,length(q));
amplitud=zeros(1,length(q));
amplitud1=zeros(1,length(q));
active1=zeros(1,length(q));
factor1=zeros(1,length(q));
Res=zeros(1,length(q));
sigmcn=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
r0=r0(savedcontours);
rmean=mean(r0);
sigmcn=(sigmcn.*2)./(pi*(rmean.^3));
flucta1=flucta1-sigmcn;
sigmcn=sigmcn(q,1);
flucta=(flucta)-sigmcn;

h=0;
% flucta=load('C:/ruddi/mean.txt');
% error=flucta(q,2);
% flucta=flucta(q,1);

for q=v1:v
    
    
    if ((q/rmean)<1e-6)
    coeficiente=2;
end

if ((q/rmean)>1e-6)
    coeficiente=8;
end
    
    
    
    
%    relaxation_time=(inv(x(3)*((q/rmean)^3)/(4*0.001)))+inv((x(7).*((q/rmean).^2))./(coeficiente.*x(8)));
%integration_time=inv(fps)

%cociente=relaxation_time/integration_time;
q;
%fcorr=2*(cociente^2)*(exp(-inv(cociente))-(1-(inv(cociente))));
fcorr=1;
h=h+1;
j=q:60; 
i=0;
P1=zeros(length(j),1);
p1=zeros(length(j),1);

for l=q:60
    i=i+1;
%q=modo/radio
        
    i=i+1;
%     N=sqrt((((2*l)+1)/2)*((factorial(l-q))/(factorial(l+q))));                           
%     N1=((((2*l)+1)/(4*pi))*((factorial(l-q))/(factorial(l+q))));
%     pp=legendre(l,0);
%     ppp=(pp).*N;                                                                        
%     pppp=(pp.^2).*N1;
P= legendre(l,0,'norm');
P=(P.^2)./(2.*pi);
p=P((q+1));
% p1(i)=P((q+1));
%x(4)=500
 %x(2)=-2.41;
deno=((l-1).*(l+2).*((l.*(l+1))+x(1)+(2.*x(2))+(((x(2)).^2)./2)));
P1(i)=p./deno;
% a=((1.38e-23*298)/(x(1)))*symsum(P/((l-1)*(l+2)*((l*(l+1))+x(2))),l,q,15)

end
% x(1)=area de exceso, x(2)=CE, x(3)=kappa, x(4)=alfap  
% x(5)=gamma, x(7)=epsilon
% x(6)=40e-9;
% x(1)=area de exceso, x(2)=CE, x(3)=kappa, x(4)=alfap  
% x(5)=gamma, x(7)=epsilon
% x(6)=40e-9;
%fit_exces([200 -2.41 1e-19 1e-15 1e8 4e-9 0.1])
% x(3)=2.5e-19;
% x(6)=40e-9;
%  x(4)=0;
%   x(5)=0;
%    x(2)=0;
   %x(1)=12;
%x(7)=0.2;

%fit_exces([200 -2.41 1e-19 1e-15 1e8 4e-9 0.1])
kbt=1.38e-23*296;
% alfap=(9.*x(1).*kbt)/(16.*pi.*x(2));
% keffb=(x(3)+(x(4).*(q.^(-2)))+(x(5).*(q.^(-4))));
%keff=(3.*(x(3)+(x(4).*(q.^(-2)))+(x(5).*(q.^(-4))))./q)./(1+(6.*(((rmean.^1)./((x(6))^1)).*(x(3).*(q.^1)./x(7)))))  
%x(5)=0
w=1+((x(4)./x(3)).*((q./rmean).^-2))+((x(5)./x(3)).*((q./rmean).^-4));%confinamiento
beta=12.*(rmean./x(6)).*((x(3).*((q./rmean).^2))./x(7));%hibrido

%beta=5;
%w=0.1;

keff(h)=(x(3).*w)./(1+(w.*beta));
keff1=(x(3).*w)./(1+(w.*beta));
%x(4)=1
keff2=1e-19;
factor=sum(P1);
factorprueba=fcorr.*sum(P1);
poli=sum(p1);
factor1(h)=sum(P1);
kappa(h)=((1.38e-23*298)./(flucta(h))).*factor;
modo=q./rmean;
active=x(8)./(modo^2);
active1(h)=x(8)./(modo^2);
amplitud(h) =((kbt)./(keff1)).*factor+active;
amplitud1(h) =((kbt)./(keff1)).*factor;
ratio(h)=amplitud(h)./active;
%amplitud(h) =((kbt)./(keff1)).*factor;
%amplitud1=((1.38e-23.*298)./(keff1)).*factor;
Res(h) =flucta(h)-amplitud(h);%(((1.38e-23.*298)./(keff)).*factor);
%Res(h)=flucta(h)-amplitud(h)


end
%sigma =(x(1)+(2.*x(2).*rmean)).*(x(3)./(rmean.^2));
sigma =(x(1))*(x(3)/(rmean^2));
mu=x(4)*16*pi*x(3)/(9*kbt);
q=v1:v;
q=q';
amplitud=amplitud';
% save('C:/ruddi/results/ampltudponf.txt','amplitud','-ascii')
% save('C:/ruddi/results/qpoinf.txt','q','-ascii')
% save('C:/ruddi/results/fluctsimulada1kappa60.txt','flucta','-ascii')
% save('C:/ruddi/results/fluctsimuladakappa60.txt','flucta','-ascii')

figure(400)
q1=1:50;
q1=q1';
semilogy(q,amplitud1,'-k',q,amplitud,'-r',q,flucta,'o','LineWidth',2,'MarkerEdgeColor','k', 'MarkerFaceColor','k')



% [h_m h_i]=inset(fig1,fig2);

%set(h_i,'xtick',2.35:.025:2.45,'xlim',[2.35,2.45])

ylabel('Amplitud')
xlabel('modo')
h = legend('Passive','Active','Experimental Amplitude',4);
set(h,'Interpreter','none')
%text(15,1e-6,sprintf('shear=%2.3e\n keffec=%2.3e\n kappa=%2.3e\n sigmaR=%2.3e\n CE=%2.3e\n sigma=%2.3e\n alfap=%2.3e\n gamma=%2.3e\n  h=%2.3e\n epsilon=%2.3e\n F=%2.3e\n etasu=%2.3e\n A=%2.3e ',mu,keff1,x(3),x(1),x(2),sigma,x(4),x(5),x(6),x(7),x(8),x(9),x(10)))
text(15,1e-6,sprintf('shear=%2.3e\n keffec=%2.3e\n kappa=%2.3e\n sigmaR=%2.3e\n CE=%2.3e\n sigma=%2.3e\n alfap=%2.3e\n gamma=%2.3e\n  h=%2.3e\n epsilon=%2.3e\n C=%2.3e',mu,keff1,x(3),x(1),x(2),sigma,x(4),x(5),x(6),x(7),x(8)))
hold on
%semilogy(q1,flucta1,'o','MarkerEdgeColor','r', 'MarkerFaceColor','r')
 %semilogy(q1,flucta1,'o','MarkerEdgeColor','k', 'MarkerFaceColor','k')
% semilogy(q,flucta,'o','MarkerEdgeColor','k', 'MarkerFaceColor','k')
% errorbar(q,flucta,error.*0.9)
hold off
% figure (2)
% bar(q,kappa)
% % hold on
figure(500)
plot(q,active1);

axis square
% if (x(1)>= 2.4e-19 ) ||(x(2)<0)
%    keyboard
% end
F=0.5.*sum(Res.^2);

 assignin('base', 'AM_expe', flucta);
assignin('base', 'fit', amplitud);
assignin('base', 'q', q);
assignin('base', 'kappaefectiva', keff);


