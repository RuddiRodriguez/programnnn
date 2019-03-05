function F = myfun411(x)

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
 C0=-0.76
exces=60;
flucta = load(sprintf('%s/results/fluctuationsa.txt',working_directory_path));
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
q=v1:v;
flucta=flucta(q,1);
kappa=zeros(1,length(q));
amplitud=zeros(1,length(q));
factor1=zeros(1,length(q));
Res=zeros(1,length(q));
sigmcn=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
r0=r0(savedcontours);
rmean=mean(r0);
sigmcn=(sigmcn.*2)./(pi*(rmean.^3));
sigmcn=sigmcn(1,q);
flucta=(flucta')-sigmcn;
h=0;
for q=v1:v
h=h+1;
j=q:100; 
i=0;
P1=zeros(length(j),1);
p1=zeros(length(j),1);
for l=q:100
    i=i+1;
        
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
deno=((l-1).*(l+2).*((l.*(l+1))+x(2)-(4.*x(3))+(2.*((x(3)).^2))));
P1(i)=p./deno;
% a=((1.38e-23*298)/(x(1)))*symsum(P/((l-1)*(l+2)*((l*(l+1))+x(2))),l,q,15)

end
% x(1)=kappa, x(3)=CE, x(2)=excessarea, x(4)=gamma  
% x(5)=h, x(6)=epsilon
x(5)=4e-9
kbt=1.38e-23*298;
% alfap=(9.*x(1).*kbt)/(16.*pi.*x(2));
kappab=x(1)+(x(7).*(q.^(-2)))+(x(4).*(q.^(-4)))
keff=(3.*kappab./q)./(1+(6.*(((rmean.^2)./((x(5))^2)).*(kappab.*(q.^1)./x(6)))))         
factor=sum(P1);
poli=sum(p1);
factor1(h)=sum(P1);
kappa(h)=((1.38e-23*298)./(flucta(h))).*factor;
amplitud(h) =((1.38e-23.*298)./(1.43e-19)).*factor;
Res(h) =flucta(h)-((1.38e-23.*298)./(keff)).*factor;


end
sigma =x(2)*x(1)/(rmean^2);
q=v1:v;


figure(1)

semilogy(q,amplitud,'-k',q,flucta,'o','LineWidth',2,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
ylabel('Amplitud')
xlabel('modo')
h = legend('Fit_S_H','Experimental Amplitude',1);
set(h,'Interpreter','none')
text(10,1e-8,sprintf('kappa=%2.3e\n sigmaR=%2.3e\n CE=%2.3e\n sigma=%2.3e\n alfap=%2.3e\n ga=%2.3e\n  h=%2.3e\n epsilon=%2.3e',x(1),x(2),x(3),sigma,x(4),x(7),x(5),x(6)))
%hold on

figure (2)
bar(q,kappa)
% hold on


axis square
% if (x(1)>= 2.4e-19 ) ||(x(2)<0)
%    keyboard
% end
F=0.5.*sum(Res.^2);

 assignin('base', 'AM_expe', flucta);
assignin('base', 'fit', amplitud);
assignin('base', 'q', q);



