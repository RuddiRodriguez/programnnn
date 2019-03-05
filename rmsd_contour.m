 function [u]=rmsd_contour(mediafluct,mempos,savedcontours)
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
parameterStruct;
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
r0 = load(sprintf('%s/results/r0.txt',working_directory_path));
r0=r0(savedcontours);
rmean=mean(r0);

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

mempos = cell(length(savedcontours),1);
meanu=zeros(1,1);
% load data
for j = 1:length(savedcontours)
    mempos{j} = load(sprintf('%s/contours/contour%i.txt',working_directory_path,savedcontours(j))); % load the membrane position in polar coordinates
end

mempos_tmp = mempos{j};
        mempospollength = length(mempos_tmp);

        n=1:mempospollength;
        x=mempos_tmp(n,1);
        y=mempos_tmp(n,2);
        




% mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,2));
l=1:(length(mempos_tmp)-3);
x=mempos_tmp(l,1);
y=mempos_tmp(l,2);
u=zeros((length(mempos_tmp))-3,1);
i=1;
j=0;
for g=1:length(mempos_tmp)-3
    j=j+1;
gg=2:length(savedcontours);
am=mediafluct(g,gg);
% mediafluct(g,gg)=mediafluct(g,gg)-mean(mediafluct(g,gg));

%am=a(1,:)-mean(a(1,:));
am2=am.^2;
u2=mean(am2);

u2=(mean(mediafluct(g,gg).^2))-((mean(mediafluct(g,gg))).^2);
u(j)=sqrt(u2);


% figure(10)
% plot(x(g),u(g))
% text(x(g),y(g),u(g),num2str(g))
 hold on;
end

% for gg1=10:10
% g1=1:length(mempos_tmp);
% i=i+1;
% u2=mediafluct(g1,gg1);
% l=1:length(u2);
% 
%  u1=u2(l,1);
%  figure (600)
%  plot(x,u1)
% end





figure(10)
un=(u./u(1));
plot3(x,y,u)

% text(x,y,u./u(1))
 hold on;
 i=0;
 t=0;
 c=0;
l=1:length(u)
x=mempos_tmp(l,1);
y=mempos_tmp(l,2);
meanu(1,1)=mean(u)
meanu(1,2)=std(u)
%u=u./(rmean);

 u1=u(l,1)
 
 for i=1:(length(u1)-1)
     if (u1(i)== max(u1))
         i
         t=i
         u1(i)
    working_directory_path
    save(sprintf('%s/results/max.txt',working_directory_path),'i','-ascii');
     end
     
     if (u1(i)== min(u1))
         i
         c=i
         u1(i)
    
    save(sprintf('%s/results/min.txt',working_directory_path),'i','-ascii');
     end
 end
     save(sprintf('%s/results/rmsh.txt',working_directory_path),'meanu','-ascii');
     save(sprintf('%s/results/u.txt',working_directory_path),'u','-ascii');
%  figure(10)
% un=(u./u(1));
% plot3(x,y,u1)
% text(x(t),y(t),u1(t),num2str(t))
% text(x(c),y(c),u1(c),num2str(c))


% for m=1:length(u)
%     for k=1:length(u)
%     
%     if k~t
%         temp(k)=u(k);
%     end
% end
% 
% f=zeros(length(u),1);
% f(t:length(u),1)=u(t:end,:);
% 
% for j=1:(t-1)
%     f(j)=temp(j);
% end
% 
% for n=1:length (f)
% figure(40)
% plot3(x(n),y(n),f(n))
% text(x(n),y(n),u(n),num2str(n))
%  hold on;
% end
% 
% 
% end
