
function D = resumen_dynamics_eritrocitos_fucntion(m,kappa,sigmaexcess,ce)










for f=1:m

    f;
    [def def1]=set_path_dynamics(f);

% if (f == 1)
% % prompt = {'Set the path:'};
% % dlg_title = 'PATH';
% % num_lines = 1;
% def = {'C:/ruddi/eirtrocito_save/clasificacion1/S0001/results/DynamicsOrigin.txt'};
% % answer = inputdlg(prompt,dlg_title,num_lines,def);
% 
% % prompt = {'Set the path:save'};
% % dlg_title = 'PATH';
% % num_lines = 1;
% def1 = {'C:/ruddi/eirtrocito_save/clasificacion1/S0001/results'};
% % answersave = inputdlg(prompt,dlg_title,num_lines,def1);
% 
% def=char(def)
% def1=char(def1)
% end
savedcontours = load(sprintf('%s/savedcontours.txt',def1));
r0 = load(sprintf('%s/r0.txt',def1));
% sigmaR2=load(sprintf('%s/results/sigmar2.txt',working_directory_path));
r0=r0(savedcontours);
r0=mean(r0);
 fid=fopen(def);
% path = fscanf(fid,'%s')
% fclose(fid)
% grades = (cell2mat(textscan(fid, '%f %f %f %f %f %f %f %f %f %f','delimiter','\t')));


data=cell2mat(textscan(fid,'%f32 %f32 %f32 %f32 %f32 %f32 %f32 %f32 %f32 %f32'));
fclose('all')

%data1 = load(sprintf('%s/DynamicsOrigin.txt',def))
k=size(data);
kk(f)=length(data);
% wave=zeros(length(data),1);

for i=1:k(1)
   
    wave(:,i)=data(i,1);
    mode(:,i)=data(i,2);
    amplitud(:,i)=data(i,3);
    erroram=data(i,4);
    beta(:,i)=data(i,5);
    errorbeta(:,i)=data(i,6);
    frestret(:,i)=data(i,7);
    errorfrestret(:,i)=data(i,8);
    freactiv(:,i)=data(i,9);
    errorfreactiv(:,i)=data(i,10);
    
   
end
g=0;
%amplitudtotal=zeros(1:k(1),1)
for g=1:k(1)
    
amplitudtotal(g,f)=amplitud(g);
frestrettotal(g,f)=frestret(g);
freactivtotal(g,f)=freactiv(g);
betatotal(g,f)=beta(g);
end
amplitudtotal=double(amplitudtotal);
frestrettotal=double(frestrettotal);
freactivtotal=double(freactivtotal);
betatotal=double(betatotal);




% kappa=1.2e-19
% sigmaexcess=20
% ce=-2.4
l=wave.*r0;
factor1=l.*(l+1)+sigmaexcess-(4.*ce)+(.2*(ce.^2));
factor2=((2.*l+1).*((2.*(l.^2))+(2.*l)-1))./(l.*(l+1).*(l+2).*(l-1));
%kappa=1.2e-19
epsilon=0.2;
ms=((kappa./((r0).^3))./(4.*0.001)).*((factor1)./(factor2));
b=1e9;
figure(500)
subplot(2,2,1)
plot(wave,(1-amplitud),'r-',wave,amplitud,'k-')
hold on
subplot(2,2,2)
plot(wave,beta,'-o','MarkerEdgeColor','r', 'MarkerFaceColor','k')
hold on
subplot(2,2,3)
loglog(l,frestret,'o',l,ms,'-b','MarkerEdgeColor','r', 'MarkerFaceColor','k')
hold on
subplot(2,2,4)
loglog(wave,freactiv,'-o','MarkerEdgeColor','r', 'MarkerFaceColor','k')
hold on
end






% l=wave.*r0;

amplitudtotal=double(amplitudtotal);
frestrettotal=double(frestrettotal);
freactivtotal=double(freactivtotal);
betatotal=double(betatotal);


    save('C:/ruddi/eirtrocito_save/clasificacion1/amplitudtotal.txt','amplitudtotal','-ascii');
    save('C:/ruddi/eirtrocito_save/clasificacion1/frestrettotal.txt','frestrettotal','-ascii');
    save('C:/ruddi/eirtrocito_save/clasificacion1/freactivtotal.txt','freactivtotal','-ascii');
    save('C:/ruddi/eirtrocito_save/clasificacion1/betatotal.txt','betatotal','-ascii');



k=size(amplitudtotal);

for t=1:k(1)
    meditemp=0;
    j=0;
for g=1:k(2)
    
    if ~(amplitudtotal(t,g)==0)
        j=j+1;
       meditemp(j)=amplitudtotal(t,g);
    end
end
meditemp1(t)=mean(meditemp);
errortemp(t)=std(meditemp,0);
end
amplitudmedia=meditemp1';
errorampli=errortemp';

k=size(frestrettotal);

for t=1:k(1)
    meditemp=0;
    j=0;
for g=1:k(2)
    
    if ~(frestrettotal(t,g)==0)
        j=j+1;
       meditemp(j)=frestrettotal(t,g);
    end
end
meditemp1(t)=mean(meditemp);
errortemp(t)=std(meditemp,0);
end
freben=meditemp1';
errorben=errortemp';

k=size(freactivtotal);

for t=1:k(1)
    meditemp=0;
    j=0;
for g=1:k(2)
    
    if ~(freactivtotal(t,g)==0)
        j=j+1;
       meditemp(j)=freactivtotal(t,g);
    end
end
meditemp1(t)=mean(meditemp);
errortemp(t)=std(meditemp,0);
end
freactividad=meditemp1';
errorfreactividad=errortemp';


k=size(betatotal);

for t=1:k(1)
    meditemp=0;
    j=0;
for g=1:k(2)
    
    if ~(betatotal(t,g)==0)
        j=j+1;
       meditemp(j)=betatotal(t,g);
    end
end
meditemp1(t)=mean(meditemp);
errortemp(t)=std(meditemp,0);
end
betamedia=meditemp1';
errorbetamedia=errortemp';

var=zeros(length(amplitudmedia),8)
var(:,1)=amplitudmedia
var(:,2)=errorampli
var(:,3)=freben
var(:,4)=errorben
var(:,5)=freactividad
var(:,6)=errorfreactividad
var(:,7)=betamedia
var(:,8)=errorbetamedia




    save('C:/ruddi/eirtrocito_save/clasificacion1/media.txt','var','-ascii');
%     save('C:/ruddi/eirtrocito_save/clasificacion1/frestrettotal.txt','frestrettotal','-ascii');
%     save('C:/ruddi/eirtrocito_save/clasificacion1/freactivtotal.txt','freactivtotal','-ascii');
%     save('C:/ruddi/eirtrocito_save/clasificacion1/betatotal.txt','betatotal','-ascii');







% %freben=mean(frestrettotal,2)
% errorben=std(frestrettotal,0,2);
% %freactividad=mean(freactivtotal,2)
% errorfreactividad=std(freactivtotal,0,2);
% %betamedia=mean(betatotal,2)
% errorbetamedia=std(betatotal,0,2);

%  kappa=1.2e-19
%  sigmaexcess=40
%  ce=-2.4
l=2:(length(amplitudtotal)+1);
l=l';
factor1=l.*(l+1)+sigmaexcess-(4.*ce)+(.2*(ce.^2));
factor2=((2.*l+1).*((2.*(l.^2))+(2.*l)-1))./(l.*(l+1).*(l+2).*(l-1));
%kappa=1.2e-19
epsilon=0.2
b=1e9;


ms=((kappa./((r0).^3))./(4.*0.001)).*((factor1)./(factor2));
ms1=((kappa./((r0).^3))./(4.*0.001)).*((factor1)./(factor2));
save('C:/ruddi/eirtrocito_save/clasificacion1/ms1.txt','ms','-ascii');

epsilon=0.2;
b=1e9;
%ms=(kappa.*(wave.^3))./(4*0.001);
% fricc=(epsilon.*(q.^2))./(2*b);
% diff=1e-12*(q.^2);

figure(501)
subplot(2,2,1)
plot(l,(1-amplitudmedia),'r-',l,amplitudmedia,'k-')
hold on
errorbar(l,(1-amplitudmedia),(errorampli),'r-')
errorbar(l,(amplitudmedia),(errorampli),'k-')

hold on
subplot(2,2,2)
plot(l,betamedia,'-o','MarkerEdgeColor','k', 'MarkerFaceColor','w')
hold on
errorbar(l,betamedia,(errorbetamedia),'-o','MarkerEdgeColor','k', 'MarkerFaceColor','w')

subplot(2,2,3)
loglog(l,freben,'o',l,ms,'-r','MarkerEdgeColor','k', 'MarkerFaceColor','w')
hold on
errorbar(l,freben,errorben,'-o','MarkerEdgeColor','k', 'MarkerFaceColor','w')



subplot(2,2,4)
loglog(l,freactividad,'-o','MarkerEdgeColor','r', 'MarkerFaceColor','w')
hold on
errorbar(l,freactividad,errorfreactividad,'-o','MarkerEdgeColor','k', 'MarkerFaceColor','w')