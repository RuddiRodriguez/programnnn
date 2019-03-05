% function main()

outside=1;

% this program uses the more advanced method for tracking the vesicle

clear all; %clear all variables

% sets filename of the files being analyzed
% for windows
% fid = fopen('D:/membrane_tracking_project/medidas/filename.txt','rt');
% for linux
fid = fopen('/media/NDAS400/membrane_tracking_project/medidas/filename.txt','rt');
filename = fscanf(fid,'%s')
fclose('all');

% sets the rootpath of the files being analyzed; ie: the directory
% containing the image directory
% for windows
% fid = fopen('D:/membrane_tracking_project/medidas/workingdirectory.txt','rt');
% for linux
fid = fopen('/media/NDAS400/membrane_tracking_project/medidas/workingdirectory.txt','rt');
path = fscanf(fid,'%s')
fclose('all');

% make corresponding contours directory
mkdir(sprintf('%s/contours',path));

% check numeration of image files (i.e.: if three or four digits are used in the numeration)
% check if there are three digits
if exist(sprintf('%s/images/%s001.tif',path,filename)) == 2
    filenumberdigits = 3;
elseif exist(sprintf('%s/images/%s0001.tif',path,filename)) == 2
    filenumberdigits = 4;
end

% check number image files in image directory; the if-query is to select
% the adequate formatting of the file numeration
if filenumberdigits == 3
contournr=1;
while exist(sprintf('%s/images/%s%03d.tif',path,filename,contournr)) == 2
   contournr=contournr+1; 
end
contournr=contournr-1;
elseif filenumberdigits == 4
    contournr=1;
while exist(sprintf('%s/images/%s%04d.tif',path,filename,contournr)) == 2
   contournr=contournr+1; 
end
contournr=contournr-1;
end


% save the number of images that will be analyzed for later use in the
% other programs
save(sprintf('%s/contours/contournr.txt',path),'contournr','-ascii');

%parameters:
linfitparameter = 3 % number of points to each side of a given point for the linear fit 
meanparameter = 6 % number of points to each side of a given point for which the mean grey value will be calculated

diaglinfitparameter = ceil(linfitparameter/1.4142)
diagmeanparameter = ceil(meanparameter/1.4142)

% diaglinfitparameter=linfitparameter
% diagmeanparameter=meanparameter


pixeltestparameter = 1.221730477; % parameter for the angle in the second pixelpositiontest; see the pixelpositiontest function

directioncondition = 0.5; % parameter that represents the minimal change of the mean of the 10 last membranepositions in 
                          % x- and y-direction for which tracking will
                          % continue in the given direction; default=0.05
lastpositions = 10; % number of last pixels/membrainpositions over which the algorithm will calculate the mean change 
                    % in x- and y-direction
                  
directiondetectionstart = 10; % gives the number of starting points for which xdirection=1 and ydirection=1 are set; default=10
directionchange = 80; % parameter that determines after what amount of iterations a new direction change can occur

slopediff = 30; % this parameter determines for the function 'newpixposmethod2' the minimum value that a slope 
                % has to be bigger than the other three
              
methode4parameter = 0.25; % parameter that determines what length the x-/y-abcisses in the function newpixposmethod4 must have
                          % in order for the newpixpos to be chosen in that
                          % direction; see file newpixposmethod4.m for details
comparepixel = 20;  % this is the index i of the pixel at which the algorithm will start 
                    % to check against to see whether the contour is closed;
                    % it will do this against the number of following
                    % points given by the parameter "closingpoints"; this
                    % means that the algorithm will check from i=comparepixel
                    % to i=comparepixel to i=comparepixel+numberofcomparepixel
                    % to see if the contour is closed.
                    % i.e.: the pixel position comparepixel also determines how many pixels of
                    % "run-in-time" the algorithm will receive to find the
                    % membrane position correctly
nrofcomparepixel = 50;  % this parameter gives the number of pixels with
                        % with which the algorithm will compare the
                        % current pixel i to see if the contour is
                        % closed
maxwanderof = 30;         % this parameter serves a break off condition of the detection algorithm
                        % if it wanders away from the membrane more than "maxwanderof"


maxnrofpoints = 800;  % this parameter determines the maximum number of membrane 
                      % points to be detected; literature: 700-2000
surroundings = 70;    % this parameter set the number of pixels to be selected around the vesicle
newcentersteps = 20;  % this paramater determines after how many steps the center 
                      % of the contours will be newly calculated; it is only 
                      % relevant if the vesicle is moving on the images
            

displaystart = 1000; % parameter to control when the first image of the already tracked points will be shown; only for control purposes
displaystartcounter = displaystart;
displayincrement = 1; % paramter to control after how many iterations the next image will be shown


%variables:
%pixpos: pixel position coordinates; matrix 2 x n
%xymempos: membrane position coordinates; matrix 2 x n
xymeanmemchange = ones(maxnrofpoints,2); % vector containing the mean change in x-/y-direction of the
                            % last number of membrane points given by lastpositions
vwmeanmemchange = ones(maxnrofpoints,2); 

meanpixchange = ones(maxnrofpoints,2); % vector containing the mean change in x-/y-direction of the
                            % last number of pixel points given by lastpositions
                            
center = zeros(1,2);        % this is the value of the center of the membrane;
                            % to be selected by the user at program
                            % initiation (apporximatly)
furthestmembranepos = zeros(1,2); % this is the value of the membrane position furthest from the center;
                            % to be selected by the user at program
                            % initiation (approximatly)
firstdetect = 0;            % this variable is set to one once the algorithm 
                            % has detected the contour correctly for the
                            % first time
contourclosed = 0;          % this variable will be used below to check 
                            % whether the contour was closed for the
                            % algorithm to calculate the new center
                            
                            
% Control variables
method=zeros(maxnrofpoints,1); %variable to check what method was used at what iteration
methodinternaldirection=zeros(maxnrofpoints,1); % control variable to see which direction was used inside a direction methods
deltaSxy=ones(maxnrofpoints,1);
deltaSxw=ones(maxnrofpoints,1);
deltaSxv=ones(maxnrofpoints,1);
detectedpoints=zeros(contournr,1); % array that will contain the detected points per contour

%xbar,ybar,vbar,wbar: postions of membrane for calculation of next membrane point (xtild,ytild)
%Sx1,Sx2,Sxbar,Sy1,Sy2,Sybar: slopes of membranes

%Counter/Index Variables:
%i: index for primary loop
xdirectionchangecounter = 0; % these are counter so that a new direction-change can only occur after a certain amount of iterations
ydirectionchangecounter = 0; % given by the parameter 'directiondetectionstart'
vdirectionchangecounter = 0;
wdirectionchangecounter = 0;

centercounter=0;    % this is a counter to be able to calculate a new contour
                        % center after the number of steps given by the parameter 
                        % newcentersteps

%allocation of the matrices that will membrane and pixel position
pixpos = zeros(maxnrofpoints,2);
xymempos = zeros(maxnrofpoints,2);
vwmempos = zeros(maxnrofpoints,2);

%IMPORTANT: The coordinate-system will chosen so that the x-direction
%corresponds to the row-index of the image-matrix and the y-direction to
%the column-index of the coordinate-system; i.e.: the normal
%right-coordinate-system is turned 90 degrees clockwise


for j = 1:contournr % loop to go through the contours

% open image for tracking
    if filenumberdigits == 3
    image = imread(sprintf('%s/images/%s%03d.tif',path,filename,j)); % creates nxn-matrix of grayscale-image with intensity values
    elseif filenumberdigits == 4
    image = imread(sprintf('%s/images/%s%04d.tif',path,filename,j)); % creates nxn-matrix of grayscale-image with intensity values
    end
        
% image=imread('D:/medidas/old_pics/images/M3.tif');

% calculate and select region of interest
% image=image(center(1)-round(sizeofvesicle)-surroundings:center(1)+round(sizeofvesicle)+surroundings,center(2)-round(sizeofvesicle)-surroundings:center(2)+round(sizeofvesicle)+surroundings);

image = double(image); % converts the image in to an array of doubles for further processing

displayimage = mat2gray(image); %creates a gray scale image with 8bit so it can be displayed

% center=[277.5,323.5];
% furthestmembranepos=[195.5,325.5];


if j==1
    a=('Select the center of the vesicle (approximatly)')
    figure(1), imshow(displayimage); %, axis square;
	[center(2), center(1)] = ginput(1);
    a=('Select the position of the membrane furthest from the center (approximatly)')
    figure(1), imshow(displayimage); %, axis square;
	[furthestmembranepos(2), furthestmembranepos(1)] = ginput(1);
end




% distance between center and furthes membrane position
sizeofvesicle=sqrt((furthestmembranepos(1)-center(1))^2+(furthestmembranepos(2)-center(2))^2);

% displayimage(round(center)) = 255;
% displayimage(round(furthestmembranepos)) = 255;
% figure(2), imshow(displayimage), axis square;
% pause;



%determine the size of the image to later determine the middle line of the
%image on which to find the membrane (see below)
[imagexmax imageymax]=size(image); % max coordinates in the x- and y-directions

%find starting point for membrane recognition

% OLD AND CORRECT VERSION FOR FINDING STARTING POINT

% this sets the variable firstdetect to 1 once the contour was tracked
% correctly for the first time
if j < 10 && contourclosed == 1
    firstdetect = 1;
end

if j < 10 && firstdetect == 0
pixpos(1,2)=round(center(2)); %chosen y-pixelpostion for finding membrane
pixpos(1,1)=pixelposition(image(:,round(center(2))),round(center(1)-sizeofvesicle-30),...
                              round(center(1)),linfitparameter); %determine the x-postion of starting pixel in x-direction for chosen y-position
else
   pixpos(1,:) = newstartingpixpos; 
end

%  pixpos(1,2)=round(center(2)); %chosen y-pixelpostion for finding membrane
%     pixpos(1,1)=pixelposition(image(:,round(center(2))),round(furthestmembranepos(1)),...
%                               round(center(1)),linfitparameter); % determine the x-postion of starting pixel in x-direction for chosen y-position

                           
% pixpos(1,2)=round(furthestmembranepos(2)); %chosen y-pixelpostion for finding membrane
% pixpos(1,1)=pixelposition(image(:,round(furthestmembranepos(2))),round(furthestmembranepos(1)-20),...
%                               round(furthestmembranepos(1)+20),linfitparameter); %determine the x-postion of starting pixel in x-direction for chosen y-position
                          
                          
                          
% if j==1
%     pixpos(1,2)=round(furthestmembranepos(2)); 
%     pixpos(1,1)=round(furthestmembranepos(1)); 
% end

% for first point set y membrane position to pixel position, since not better known
xymempos(1,1) = pixpos(1,1);
xymempos(1,2) = pixpos(1,2);

% coordinate transformation to the vw-coordinate system
vwmempos(1,1) = xymempos(1,1) * 0.70710678 + xymempos(1,2) * 0.70710678; % trafo to v-axis
vwmempos(1,2) = xymempos(1,2) * 0.70710678 - xymempos(1,1) * 0.70710678; % trafo to w-axis


% the new x- and y-directions to the direction of the last breakofpoint

xdirection = 1;
ydirection = 1;
vdirection = 1;
wdirection = 1;

% start of detection loop
for i = 1:maxnrofpoints

xdirectionchangecounter = xdirectionchangecounter + 1; % this serves to count the
ydirectionchangecounter = ydirectionchangecounter + 1; % number of detection iterations after the last directionchange

if i>directiondetectionstart % after the first number of points given by the variable directiondetectionstart 
                             % these conditions decide over a possible direction change in x- and y-direction
                            
xymeanmemchange(i,:)=[(mean(xymempos(i-lastpositions:i,1)-xymempos(i-lastpositions,1))),(mean(xymempos(i-lastpositions:i,2)-xymempos(i-lastpositions,2)))];
meanpixchange(i,:)=[(mean(pixpos(i-lastpositions:i,1)-pixpos(i-lastpositions,1))),(mean(pixpos(i-lastpositions:i,2)-pixpos(i-lastpositions,2)))];


% set new x-direction
if xdirectionchangecounter > directionchange
if abs(xymeanmemchange(i,1)) < directioncondition
    xdirection = - xdirection;
    xdirectionchangecounter = 0;
end
end

% set new y-direction
if ydirectionchangecounter > directionchange
if abs(xymeanmemchange(i,2)) < directioncondition
    ydirection = - ydirection;
    ydirectionchangecounter = 0;
end
end

end



% determine new points
% this function uses the old algorithm to determine the next pixpoint and
% membranepoint; see 'newpixposmethodold.m' function for details
[pixpos(i+1,:),internalmethod,xymempos(i+1,:),Sx,Sy,xbar,ybar]=newpixposmethodold(pixpos(i,:),image,xdirection,ydirection,meanparameter,linfitparameter);

% Version de Ivan

xtilde = ((pixpos(i,1)+xbar)*abs(Sx) + (pixpos(i,1)+xdirection)*abs(Sy))/(abs(Sx)+abs(Sy));
ytilde = ((ybar+pixpos(i,2))*abs(Sy) + (pixpos(i,2)+ydirection)*abs(Sx))/(abs(Sx)+abs(Sy));

xymempos(i+1,1) = xtilde;
xymempos(i+1,2) = ytilde;

pixtemp = pixpos(i+1,:);

pixpos(i+1,:) = round(xymempos(i+1,:));

if pixpos(i+1,:) == pixpos(i,:)
   pixpos(i+1,:) = pixtemp;
end


% test pixel found and if it shows in the wrong direction
% break
if pixelpositiontest(pixpos,pixeltestparameter,i)==0 % checks next pixel; if incorrect skip to next image
    break;
end

% % check if the pixel is wandering away from the vesicle or towards the
% % center
% if norm(pixpos(i,:)-center)>sizeofvesicle+maxwanderof || norm(pixpos(i,:)-center)<sizeofvesicle-maxwanderof
%     break; % break off condition if the tracking algorithm wanders of
% end


% this checks that the next pixel and the surrounding area for the calculations is still inside the image
if pixpos(i+1,1) - meanparameter - 1 < 0 || pixpos(i+1,1) + meanparameter + 1 > imagexmax || ...
   pixpos(i+1,2) - meanparameter - 1 < 0 || pixpos(i+1,1) + meanparameter + 1 > imageymax
    display('pixelposition or surrounding area for calculations is out-of-bounds (too large or to small)');
    outsidecounter = outsidecounter + 1;
    break;
end


% break-off condition of the algorithm. This compares the last calculated
% pixelposition with the pixel position (x_i,y_i) at i=comparepixel up to
% i=comparepixel+nrofcomparepixel. If one of them conincides the vesicle 
% tracing is complete.

breakofpixel=1; % the variable  "breakofpixel" will be used below to eliminate 
                % the first certain number membrane positions that were traced twice
                        
finished=0;     % variable of the finish condition; if it is turned to one,
                % the finish algorithm has found that the contour is closed
                
contourclosed=0; % this variable will be used below to check whether the contour was closed for the algorithm to calculate the new center

if i>comparepixel+nrofcomparepixel
for breakofpixel=comparepixel:comparepixel+nrofcomparepixel 

    if pixpos(breakofpixel,:)==pixpos(i+1,:)
    a=xymempos(10,:)-xymempos(1,:);
    b=xymempos(i,:)-xymempos(i-9,:);
    % calculate angle:
    if norm(a) ~= 0 && norm(b) ~= 0
    alpha=acos((a*transpose(b))/(norm(a)*norm(b)));
        maxangle = 0.7;
        if alpha<maxangle
        finished=1;
        contourclosed=1;
        break;
        end
    end
    end
end
if finished==1;
    finished=0;
    break; % this 'break' exits the detection loop
end
end

% mark membrane and pixel position in the image to white
displayimage(pixpos(i,1),pixpos(i,2))=255; % pixel positions are white
displayimage(round(xymempos(i,1)),round(xymempos(i,2)))=0; % membrane positions are black

% CONTROL DISPLAYS


if i==displaystartcounter
    displayimage(round(pixpos(i,1)),round(pixpos(i,2)))=0;
    displayimage(round(xymempos(i,1)),round(xymempos(i,2)))=255;
    
    displaystartcounter=i+displayincrement;
    zoomeddisplayimage=displayimage(round(center(1))-round(sizeofvesicle)-surroundings:round(center(1))+round(sizeofvesicle)+surroundings,...
        round(center(2))-round(sizeofvesicle)-surroundings:round(center(2))+round(sizeofvesicle)+surroundings);
    figure(1), imshow(zoomeddisplayimage);
    
    disp('ITERATION')
    disp(i)

    disp('direction change counters (x and y)')
    disp([xdirectionchangecounter,ydirectionchangecounter])
    
    if i>1          
    disp(xymempos(i,:))
    disp(pixpos(i,:))
    end
        
    disp('Internal Method')
    disp(internalmethod)
    
    disp('Sx    Sy')
    disp([Sx,Sy])
    
    disp('x-direction y-direction')
    disp([xdirection, ydirection])
    
    pause;
end

end % end detection loop

% save membrane positions for further analysis

xymempos = xymempos(breakofpixel:i-1,:);

% save the 10th last pixel of the contour to be the starting point 'newstartingpixpos' for the
% tracking in the following image

if contourclosed == 1
newstartingpixpos = round(xymempos(length(xymempos) - breakofpixel + 3,:));
displayimage(newstartingpixpos(1),newstartingpixpos(2))=255;
end


% save files in ascii text format
save(sprintf('%s/contours/contour%i.txt',path,j),'xymempos','-ascii'); % save the contour

% save files in MATLAB binary format
% save(sprintf('/home/micha/praktikum_complutense/program/contours/contour%i.mat',j),'xymempos');


% Calculate new center position of vesicle
% the following lines up to the clear command calculate the new contour
% center in case the vesicle is moving; this is done after the number of
% detection iteration steps given by the parameter "newcentersteps"

centercounter = centercounter + 1;
if centercounter >= newcentersteps && contourclosed == 1 % contourclosed=1 <=> contour is closed; contourclosed=0 <=> contour is NOT closed
centercounter = 0;
contourclosed = 0;
% Variables:
L=0; % length of circumference
xymemposlength=length(xymempos); % length of the vector xymempos
ds=zeros(xymemposlength,1); % vector containing the distances between neighbooring membrane positions
sumds=zeros(xymemposlength,1); % vector containing sum between ds(i) and ds(i+1)
center=zeros(1,2); % center of the vesicle

% calculate length of circumference
for i=1:xymemposlength-1
   ds(i+1)=sqrt((xymempos(i+1,1)-xymempos(i,1))^2+(xymempos(i+1,2)-xymempos(i,2))^2);
   L=L+ds(i);
   if i==xymemposlength-1
       ds(1)=sqrt((xymempos(1,1)-xymempos(i+1,1))^2+(xymempos(i,2)-xymempos(i+1,2))^2); 
       % to get the last part between the end and starting point of tracked contour
       L=L+ds(1);
   end
end

for i=1:xymemposlength-1
sumds(i)=ds(i)+ds(i+1);
if i==xymemposlength-1
    sumds(i+1)=ds(i+1)+ds(1);
end
end
center(1)=(1/(2*L))*xymempos(:,1)'*sumds;

for i=1:xymemposlength-1
sumds(i)=ds(i)+ds(i+1);
if i==xymemposlength-1
    sumds(i+1)=ds(i+1)+ds(1);
end
end
center(2)=(1/(2*L))*xymempos(:,2)'*sumds;

end

% show center in displayimage
displayimage(round(center(1)),round(center(2)))=255;



% CONTROL OUTPUT

% show zoomed image of selected vesicle
zoomeddisplayimage=displayimage(round(center(1))-round(sizeofvesicle)-surroundings:round(center(1))+round(sizeofvesicle)+surroundings,round(center(2))-round(sizeofvesicle)-surroundings:round(center(2))+round(sizeofvesicle)+surroundings);
figure(1), imshow(zoomeddisplayimage);
% figure(2), imshow(displayimage);
% pause;


% give out number of detected points to vector
detectedpoints(j)=length(xymempos);
[j,length(xymempos),xdirection,ydirection]

disp(['contour closed = ',int2str(contourclosed)])
disp(breakofpixel)
if contourclosed == 1
disp(newstartingpixpos)
end

pause(0.1);

clear xymempos pixpos image;
end