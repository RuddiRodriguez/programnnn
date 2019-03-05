clear
%fid1=fopen('resultsdesv.txt','w+');
m=1
% hbar = waitbar (0,'Please wait...');
% for f=1:m
% 
%     f;
%     [def def1]=set_path_polar(f);
fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s');
fclose('all')


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s');
fclose('all');

%avedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}),c{1});

%output of parameters
parameterStruct;

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

mempospol = cell(length(savedcontours),1);

% load data
for j = 1:length(savedcontours)
    mempospol{j} = load(sprintf('%s/contours/polarcontour%i.txt',working_directory_path,savedcontours(j))); % load the membrane position in polar coordinates
end

mempospol_tmp = mempospol{j};
        mempospollength = length(mempospol_tmp);

        n=1:mempospollength;
        rho=mempospol_tmp(n,1);
        theta=mempospol_tmp(n,2);
        thetar=zeros(length(theta),1);

% n=1:mempospollength;
% rho=mempospol(n,1);
% theta=mempospol(n,2);
% thetar=zeros(length(theta),1);

for b1=1:length(theta)
    if (theta(b1)>2*pi)&& (theta(b1)>0)
        thetar(b1)=theta(b1)-(2*pi);
    end
    
    if (theta(b1)>2*pi)&& (theta(b1)<0)
        thetar(b1)=abs(theta(b1))-(2*pi);
    end
    
    if (theta(b1)<2*pi)&& (theta(b1)>0)
        thetar(b1)=(theta(b1));
    end
    
    if (theta(b1)<2*pi)&& (theta(b1)<0)
        thetar(b1)=abs(theta(b1));
    end
end
% rmsd1;
medifluctimport;
[u]=rmsd_contour(mediafluct,mempos,savedcontours);
l=1:length(u);
variable=zeros(length(u),3);

theta=theta(l,1);
rho=rho(l,1);
%u=u(l,1);
media=zeros(size(u));
media(:)=mean(u);
figure(61)
polar(theta,u);
hold on;
polar(theta,media,'r');
figure(70)
plot(theta,u)


variable(:,1)= ((theta.*180)./pi);
variable(:,2)= u;
variable(:,3)= media;

save(sprintf('%s/results/polar.txt',working_directory_path),'variable','-ascii');
% waitbar(f/m)
% 
% end
% close(hbar)
