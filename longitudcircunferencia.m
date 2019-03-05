fid = fopen('config/program_directory_path.ini','rt')
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all')


fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');

savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);
parameterStruct = cell2struct(num2cell(c{2}),c{1});
q=0
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));
Lo =zeros(1,length(savedcontours))%
for j = savedcontours
    q=q+1;
mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j));


% VARIABLES:
L = 0; % length of circumference
memposlength = length(mempos); % length of the vector mempos
mempospol = zeros(memposlength,2); % vector containing the membrane position in polar coordinates
ds = zeros(memposlength,1); % vector containing the distances between neighbooring membrane positions
sumds = zeros(memposlength,1); % vector containing sum between ds(i) and ds(i + 1)
center = zeros(1,2); % center of the vesicle


% calculate length of circumference
for i = 1:memposlength - 1
   ds(i + 1) = sqrt((mempos(i + 1,1) - mempos(i,1))^2 + (mempos(i + 1,2) - mempos(i,2))^2);
   L = L + ds(i);
end
% to get the last part between the end and starting point of tracked
% contour
ds(1) = sqrt((mempos(1,1) - mempos(i + 1,1))^2 + (mempos(1,2) - mempos(i + 1,2))^2); 
L = L + ds(1);
   

Lo(q)=(L*parameterStruct.resolution);
exceso=(Lo-Lo(1))/Lo(1)
 save(sprintf('%s/results/longitud.txt',working_directory_path),'Lo','-ascii'); % save the contour
 save(sprintf('%s/results/exceso.txt',working_directory_path),'exceso','-ascii'); % save the contour
end
hold on;
tiempo=(0.066*savedcontours);
figure(7)
%plot(Lo)
 plot(tiempo,abs(exceso))