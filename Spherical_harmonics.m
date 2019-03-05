

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


v=50;
exces=5;
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
flucta = load(sprintf('%s/results/fluctuationsa.txt',working_directory_path));
C0=20;
q=2:v;
flucta=flucta(q,1);
kappa=zeros(1,length(q));
amplitud=zeros(1,length(q));
factor1=zeros(1,length(q));
sigmcn=load(sprintf('%s/results/sigmacnlinealpormodo.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
r0=r0(savedcontours);
rmean=mean(r0);
sigmcn=(sigmcn.*2)./(pi*(rmean.^3));
sigmcn=sigmcn(1,q);
flucta=(flucta')-sigmcn;
h=0;
for q=2:v
h=h+1;
j=q:100; 
i=0;
P1=zeros(length(j),1);

for l=q:100
    i=i+1;
        
    i=i+1;
    N=sqrt((((2*l)+1)/2)*((factorial(l-q))/(factorial(l+q))));
    N1=((((2*l)+1)/(4*pi))*((factorial(l-q))/(factorial(l+q))));
    pp=legendre(l,0);
    ppp=(pp).*N;
    pppp=(pp.^2).*N1;
P= legendre(l,0,'norm');
P=(P.^2)./(2*pi);
p=P((q+1));
deno=((l-1)*(l+2)*((l*(l+1))-exces-(4*C0)+(2*(C0^2))));
P1(i)=p./deno;
end
 factor=sum(P1);
factor1(h)=sum(P1);
kappa(h)=((1.38e-23*296)/(flucta(h)))*factor;
amplitud(h) =((1.38e-23*298)/(2e-19))*factor;
end
q=2:v;
figure(11)

bar(q(1,1:11),kappa(1,1:11))
figure(1)
hold on
semilogy(q,flucta,'o',q(1,2:49),amplitud(1,2:49),'-')
figure(3)
plot(q,factor1,'o')
hold on
figure (4)
plot(q,(flucta.*(q.^3)),'o')
figure(5)
semilogy(q,flucta,q,sigmcn)

assignin('base', 'AM_expe', flucta);
assignin('base', 'fit', amplitud);
assignin('base', 'q', q);