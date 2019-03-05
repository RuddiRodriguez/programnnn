% This program checks if the tracked contours were detected correctly
% It uses two methods to do this:
% Method 1:
% This method checks, that the membrane was circularly closed by comparing
% the vector of the 10 (or so) points of the membrane agaisnt that between the
% first 10 points. If the angle between them is more than the value given
% by the parameter "maxangle" the membrane will be deleted.
% 
% Method 2:
% This method checks that the length of the circumferences of a detected
% contour is the same to a cetain percentage as the mean length of all the
% circumferences. If this is not the case, the contour will be deleted. The 
% maximum deviation from the mean value is given by the parameter "maxlengthdeviation". 

clear all;

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

% check number of tracked contour files in the contour directory
contournr = 1;
while exist(sprintf('%s/contours/contour%d.txt',working_directory_path,contournr)) == 2
   contournr = contournr + 1; 
end
contournr = contournr - 1;

% parameters:
% parameterStruct.maxlengthdeviation = 1; % parameter giving the maximum length in percent by which a contour is allowed to
                      % to deviate from the mean value of the measurement
                      % ensemble, before being eliminated
% parameterStruct.mincontourlength = 640; % parameter determining the minimum length the mempos vector must have in order not to be rejected
% parameterStruct.maxangle = 0.8;     % maximum angle permitted between the vector of the last and the first 10 points (in radiants)

% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}), c{1});

% output of parameters
parameterStruct;

% Variables
L = zeros(1,contournr); % vector containing the circumferences of the different contours
deletedcontours(1) = 0; % vector in which the number of the deleted contours is saved

% counter
deletedcontourscounter = 1; % counter to augment by 1 if counter is deleted;
                          % used together with "deletedcontours" to save
                          % the number of the deleted contour
                          
savedcontours(1) = 0;
savedcontourscounter = 1;

% load the index that contains which contours where closed during tracking
contourclosedindex = load(sprintf('%s/results/contourclosedindex.txt',working_directory_path));


% Precheck:
% this checks to see if the vector has at least
% [parameterStruct.mincontourlength] points inside it
for j = 1:contournr
    camino=sprintf('%s/contours/contour%i.txt',working_directory_path,j);
mempos = load(camino); % creates nxn-matrix of grayscale-image with intensity values

if length(mempos) < parameterStruct.mincontourlength
    deletedcontours(deletedcontourscounter) = j;
    method(deletedcontourscounter) = 1;
    deletedcontourscounter = deletedcontourscounter + 1;
    method(deletedcontourscounter) = 0;
else
    savedcontours(savedcontourscounter)= j;
    savedcontourscounter = savedcontourscounter + 1;
end
end

% check whether contour was not closed correctly by checking savedcontours
% against the 'contourclosedindex' saved by the tracking program
for j = savedcontours
if contourclosedindex(j) == 0
    [m,n] = find(savedcontours==j);
    savedcontours(n) = [];
    deletedcontours(end+1) = j;
end
end
deletedcontours(1) = [];

% Method 1:

for j = savedcontours
    camino=sprintf('%s/contours/contour%i.txt',working_directory_path,j);
    mempos = load(camino); % creates nxn-matrix of grayscale-image with intensity values
    
    a = mempos(10,:) - mempos(1,:);
    b = mempos(length(mempos),:) - mempos(length(mempos) - 9,:);

   % calculate angle:
   alpha(j) = acos((a*transpose(b))/(norm(a)*norm(b)));

if alpha(j) > parameterStruct.maxangle
    % delete contour-index from 'savecondtours' vector    
    [m,n] = find(savedcontours==j);
    savedcontours(n) = [];
    
    % write contour-index to 'deletedcontours' vector
    deletedcontours(deletedcontourscounter) = j;
    method(deletedcontourscounter) = 1;
    deletedcontourscounter = deletedcontourscounter + 1; 
end
end


% Method 2:
% calculate length of circumference

% NOTE: only the circumference of contours not rejected by method 1 will be
% calculated

% variables:
for j = savedcontours
    mempos = load(sprintf('%s/contours/contour%i.txt',working_directory_path,j)); % creates nxn-matrix of grayscale-image with intensity values
    
    memposlength = length(mempos); % length of the current mempos vector (i.e: number of contour points)
    ds = zeros(memposlength,1); % vector containing the distance between neighbooring membrane points

for i = 1:memposlength - 1
   ds(i + 1) = sqrt((mempos(i + 1,1) - mempos(i,1))^2 + (mempos(i + 1,2) - mempos(i,2))^2);
   L(j) = L(j) + ds(i);
   if i == memposlength - 1
       ds(1) = sqrt((mempos(1,1) - mempos(i + 1,1))^2 + (mempos(i,2) - mempos(i + 1,2))^2); 
       % to get the last part between the end and starting point of tracked contour
       L(j) = L(j) + ds(1);
   end
end
end



% check whether the vector 'savedcontours' is empty
if isempty(savedcontours)
    errordlg('All contours were deleted. To solve this try decreasing the value of the ''Contour Circumference'' or increasing ''Maximal Circumference Deviation'' in ''Contour Test Parameters'' ','All contours deleted')
    return;
end

% calculate mean value of the contourlengths
meancircumference = sum(L)/length(savedcontours); % mean length of all the circum ferences
onepercentofmeancircumference = meancircumference/100;

% check the differet contour lengths against the mean value. If the
% deviation in percent is greater than the deviation given by the parameter
% 'parameterStruct.maxlengthdeviation' the contour will be eliminated

tmp = savedcontours; % the temp is used, because were changing savedcontours inside the loop
for j = tmp
    if abs(L(j) - meancircumference)>onepercentofmeancircumference*parameterStruct.maxlengthdeviation
        % delete contour-index from 'savecondtours' vector    
        [m,n] = find(savedcontours == j);
        savedcontours(n) = [];
    
        % write contour-index to 'deletedcontours' vector        
        deletedcontours(deletedcontourscounter) = j;
        method(deletedcontourscounter) = 2;
        deletedcontourscounter = deletedcontourscounter + 1;
    end
end

% this saves the index of the deleted contours
% save('D:/medidas/POPC424ms30fps/contours/deletedcontours.txt','deletedcontours','-ascii')
save(sprintf('%s/results/deletedcontours.txt',working_directory_path),'deletedcontours','-ascii')

% this saves the index of the saved contours
save(sprintf('%s/results/savedcontours.txt',working_directory_path),'savedcontours','-ascii')

% save log-file from of 'testcontour' program
fid = fopen(sprintf('%s/results/log_testcontour.txt',working_directory_path),'w');
fprintf(fid,'Total Contours: %i \nSaved Contours: %i \nDeleted Contours: %i',contournr,length(find(savedcontours ~= 0)),length(find(deletedcontours ~= 0)));
fclose('all');

% this display a message box displaying the total number of contours and number of saved contours and
% deleted contours

msgbox(sprintf('Total Contours: %i \nSaved Contours: %i \nDeleted Contours: %i',contournr,length(find(savedcontours ~= 0)),length(find(deletedcontours ~= 0))),'Results','none','modal')
