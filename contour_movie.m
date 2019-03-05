% This script plots the contours of the vesicles as a "movie"

% calculate length of circumference

clear all;
% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all');

% read working directory from config file 'working_directory_path.ini'
fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/workingdirectory.txt','rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');

% check number of tracked contour files in the contour directory
contournr=1;
while exist(sprintf('%s/contours/contour%d.txt',working_directory_path,contournr)) == 2
   contournr=contournr+1; 
end
contournr=contournr-1;

% parameters:
deletedcontours = load(sprintf('%s/results/deletedcontours.txt',working_directory_path));
savedcontours = load(sprintf('%s/results/savedcontours.txt',working_directory_path));

% Dialog to select what contours should be shown; contourselection will be
% set to the selected contours to be displayed; it is then called from the
% "playbackloop"
user_response = questdlg('Which contours are to be shown?','Contour Movie Option','Saved','Deleted','All','Saved');
switch user_response
    case {'Saved'}
        contourselection = savedcontours;
    case {'Deleted'}
        contourselection = deletedcontours;
    case {'All'}
        contourselection = (1:contournr);
end

% loop to playback the contours
for j = contourselection % shows the contours selected in the dialog above

% load mempos.txt
mempos=load(sprintf('%s/contours/contour%i.txt',working_directory_path,j)); % creates nxn-matrix of grayscale-image with intensity values
    
% Variables:
L=0; % length of circumference
memposlength=length(mempos); % length of the vector mempos
ds=zeros(memposlength,1); % vector containing the distances between neighbooring membrane positions
sumds=zeros(memposlength,1); % vector containing sum between ds(i) and ds(i+1)
center=zeros(1,2); % center of the vesicle

    
for i=1:memposlength-1
   ds(i+1)=sqrt((mempos(i+1,1)-mempos(i,1))^2+(mempos(i+1,2)-mempos(i,2))^2);
   L=L+ds(i);
   if i==memposlength-1
       ds(1)=sqrt((mempos(1,1)-mempos(i+1,1))^2+(mempos(i,2)-mempos(i+1,2))^2); 
       % to get the last part between the end and starting point of tracked contour
       L=L+ds(1);
   end
end

% calculate the center position of the contour

% center=newcenter(mempos);

for i=1:memposlength-1
sumds(i)=ds(i)+ds(i+1);
if i==memposlength-1
    sumds(i+1)=ds(i+1)+ds(1);
end
end
center(1)=(1/(2*L))*mempos(:,1)'*sumds;

for i=1:memposlength-1
sumds(i)=ds(i)+ds(i+1);
if i==memposlength-1
    sumds(i+1)=ds(i+1)+ds(1);
end
end
center(2)=(1/(2*L))*mempos(:,2)'*sumds;


% transformation of coordinate origin to center of vesicle

mempos(:,1)=mempos(:,1)-center(1);
mempos(:,2)=mempos(:,2)-center(2);


% hold on;
plot(mempos(:,2),mempos(:,1));
axis manual;
% xlim([-120 120]);
% ylim([-120 120]);
axis square;
% axis([-120,120,-120,120]);
axis([-550,550,-550,550]);
% axis(axis)
pause;
% pause(0.066); % realtime for 15 fps
% pause(0.033); % realtime for 30 fps

end