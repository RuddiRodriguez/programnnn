function spatial_autoco=spa_auto(mediafluct,mempos,lag)
i=0;
fid1=fopen('resultsdesv.txt','w+');
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

% paramters:
% nmax = 100; % maximal index of the coefficients of the fouriertransformation to be calculated
% maxc = 1; % maximum value permited for the coefficients c(n); if a contour give larger value, it will be deleted
% resolution = 14e-8; %0.0000001; % this parameter gives the resolution of the microscope (meters per pixel)

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
% output of parameters
parameterStruct;

% max = load(sprintf('%s/results/max.txt',working_directory_path));
% min = load(sprintf('%s/results/min.txt',working_directory_path));
% this sets the index of 'deletedcontourscounter' so that deleted contours
% will be add to the vector 'deletedcontours'
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
r0=r0(savedcontours);
rmean=mean(r0);
first=2;
last=2;
l=1:(length(mempos)-3);
x=mempos(l,1);
y=mempos(l,2);
for gg1=10:10
g1=1:length(mempos);
i=i+1;
u2=mediafluct(g1,gg1);
l=1:length(u2);

 u1=u2(l,1);
 for j=1:(length(u1)-1)
     if (u1(j)== max(u1))
         j
         t=j
         u1(j)
    
     end
 end
for k=1:length(u2)
    
    if k~t
        temp(k)=u2(k);
    end
end

f=zeros(length(u2),1);
f(1:length(t:end),1)=u2(t:end,:);

for j=t+1:length(f)
    f(j)=temp(j);
end




correlation=autocorr(f,lag);
n=0:lag;
% n=sort(n,'descend')
dis=(n.*2.*pi.*rmean)./lag;
figure (1)
plot(dis)
theta=(dis./rmean)-(pi./2);
figure (2)
plot(theta)

% for b=1:length(theta)
%       if (theta(b) > pi)
%           theta(b)=(2*pi)-theta(b)
%       end
%       if (theta(b) <= pi)
%           theta(b)=theta(b)
%           
%       end
%       
% end

disn=2.*rmean.*cos(theta)
figure (4)
plot(disn)
denon=1-(((disn./rmean).^2)./2);
figure (5)
plot(denon)
disna=acos(disn./(2.*rmean))
figure(20)
plot(disn,correlation,'o')
hold on
end
deno1=((dis./rmean).^2)./2;
for j=1:length(dis)
    
deno=((dis(j)./rmean).^2)./2;
% if (abs((1-denon)) < 1)
%   h=0
  for l=2:2
%  h=h+1
 x=[denon]; P=legendrep(l,'x'); Lp=eval(P);
%  integrando=correlation.*P;
%  Im(l)=quad(correlation.*P,-Inf,Inf)
%   end
 %pl(j)=(Lp);
%  Im=trapz(correlation(1:length(pl)).*pl)
end
% % % if (deno > 1)
% % %     h=0
% % %     for l=2:2
% % %   h=h+1
% % %  x=[1-(1./deno)]; P=legendrep(l,'x'); Lp(h)=eval(P);
% %  
% %   end
% %  pl(j)=Lp;
% 
% end

end 
% pl=pl'
% deno=deno'
% resta=1-deno

% for l=1:length(pl)
Im(l)=quad(correlation.*Lp',-Inf,Inf)
% end

figure (31)
plot(denon,Lp)
figure(30)
%plot(dis,(correlation./pl'),'-')

figure (12)
plot(u1,'o')
figure (13)
plot(f,'o')





