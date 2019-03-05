function FCS_resutl=FCS(first,last,k,d,c,m)
% clear
% clc
prompt = {'Set the path:'};
dlg_title = 'PATH';
num_lines = 1;
def = {sprintf('D:/membrane_tracking_project/medidas/FCS_data/r6g-calibration%i%i%i.txt',k,d,c)};
answer = inputdlg(prompt,dlg_title,num_lines,def);
% p=100


% prompt={'Enter the path:'};
% num_lines = 1;
% 
% def = {sprintf('%s','H:/DLS_DOPC/DOPC_028.dat')};
% answer=inputdlg(prompt,num_lines,def);

fid=fopen(answer{1});

%grades = textscan(fid, '%f %f %f %f',50,'CollectOutput', 1,'headerlines', 11,'delimiter','');
grades = (cell2mat(textscan(fid, '%f %f','headerlines', 16,'delimiter',',')));

 union=zeros(length(grades),1);
 q=zeros(1,1);
 n=1:length(grades)
 tiempo = grades(n,1)*1e-3;
 ACF=grades(n,2)
 figure (1)
 semilogx(tiempo,ACF,'o')
 
 h=first:last; 
if m==2 

s = fitoptions('Method','NonlinearLeastSquares',...
               'Startpoint',[1,0.1,1],'TolFun',10e-90,...
               'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
               'Levenberg-Marquardt','MaxFunEvals',...
               10000,'MaxIter',10000);
                     
    
  
  
ftype= fittype('y0+(1/N*((1+(x*11.2e-10/(w^2)))^(-1)))');
end

if m==3
    
    s = fitoptions('Method','NonlinearLeastSquares',...
               'Startpoint',[1,1e-7],'TolFun',10e-90,...
               'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
               'Levenberg-Marquardt','MaxFunEvals',...
               90000000,'MaxIter',900000000);
ftype = fittype('1+(1/N)*((1+(x*11.2e-10/(w^2)))^(-1))*(1/sqrt(1+(11.2e-10*x)))')
end

if m==21
    s = fitoptions('Method','NonlinearLeastSquares',...
               'Startpoint',[1,0.6,7e-7,1e-7],'TolFun',10e-100,...
               'Tolx',1e-100,'DiffMinChange',10e-100,'Algorithm',...
               'Levenberg-Marquardt','MaxFunEvals',...
               9000000000,'MaxIter',9000000000);
ftype = fittype('y0+(1/N)*(1/(1+(x*11.2e-10/(w^2))))*(1/sqrt(1+(11.2e-10*x/(z0^2))))')
end

if m==23
    s = fitoptions('Method','NonlinearLeastSquares',...
               'Startpoint',[0.1,1,1e-12],'TolFun',10e-90,...
               'Tolx',1e-90,'DiffMinChange',10e-56,'Algorithm',...
               'Levenberg-Marquardt','MaxFunEvals',...
               90000000,'MaxIter',90000000);
end
    
% % ftype= fittype('amplitud*exp(-frecuencia*x)+(1-amplitud)*exp(-fre*x)+y0');
% % 
% % 
 [fresult,gof,output] =fit(tiempo(h,1),ACF(h,1),ftype,s)
     f=feval(fresult,tiempo(h,1));
% 
% 

% 
  subplot (2,1,1)
%  
 semilogx(tiempo(h,1),f,'k','LineWidth',2)
hold on
semilogx(tiempo(h,1),ACF(h,1),'o')
% % 
subplot(2,1,2)
plot(output.residuals)

% % cc
% % 
% % 
% % 
td=(fresult.w)^2/(4*2.8e-10)*1000
