clear
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
mkdir(sprintf('%s/results_puntos_kurtosis',working_directory_path));
%mkdir(sprintf('%s/results_puntos_response',working_directory_path));



fps=3800




    m=100;
   w=0
    for j=1:1
        
        for h=50:120
            
        if exist(sprintf('%s/results/hist%i_%i.txt',working_directory_path,j,h)) == 2;
          w=w+1;  
         p(w)=h;
        end
        end
    end
y=0;
    for g=p
        y=y+1;
        q=0
       for l=1:m
        q=q+1
    data=load(sprintf('%s/results/hist%i_%i.txt',working_directory_path,l,g))
    kurto(q,y)=kurtosis((data(:,2)./(max(data(:,2)))))
    end
    
    
    figure(3)
    plot(((1:m).*(1/fps)),kurto(:,y)./3)
    hold on
    end
    t=100
    xdata=(1:m).*(1/fps);
    xdata=xdata'
    ydata=(mean(kurto,2)./3)
    stdkur=(std(kurto,0,2))./3
    figure (4)
    errorbar(xdata(1:t),ydata(1:t),stdkur(1:t),'-o')
    hold on
 save(sprintf('%s/results_puntos_kurtosis/kurtosis.txt',working_directory_path),'ydata','-ascii');
save(sprintf('%s/results_puntos_kurtosis/tiempo.txt',working_directory_path),'xdata','-ascii');
save(sprintf('%s/results_puntos_kurtosis/stdkur.txt',working_directory_path),'stdkur','-ascii');

    
