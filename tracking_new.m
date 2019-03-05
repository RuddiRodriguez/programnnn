% function tracking

% this program uses the more advanced method for tracking the vesicle

clear all; %clear all variables

% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
fid = fopen('/media/NDAS400/membrane_tracking_project/program/config/program_directory_path.ini','rt');
fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
program_directory_path = fscanf(fid,'%s')
fclose('all');

% sets filename of the files being analyzed
fid = fopen(sprintf('%s/config/file_name.ini',program_directory_path),'rt');
filename = fscanf(fid,'%s')
fclose('all');

% sets the rootpath of the files being analyzed; ie: the directory
% containing the image directory
fid = fopen(sprintf('%s/config/working_directory_path.ini',program_directory_path),'rt');
working_directory_path = fscanf(fid,'%s')
fclose('all');

% make corresponding contours directory
mkdir(sprintf('%s/contours',working_directory_path));

% check numeration of image files (i.e.: if three or four digits are used in the numeration)
% check if there are three digits
if exist(sprintf('%s/images/%s.tif',working_directory_path,filename)) == 2
    filenumberdigits = 3;
    filename = filename(1:end-3);
elseif exist(sprintf('%s/images/%s.tif',working_directory_path,filename)) == 2
    filenumberdigits = 4;
    filename = filename(1:end-4);
end

% check number image files in image directory; the if-query is to select
% the adequate formatting of the file numeration
if filenumberdigits == 3
contournr = 1;
while exist(sprintf('%s/images/%s%03d.tif',working_directory_path,filename,contournr)) == 2
   contournr = contournr + 1;
end
contournr = contournr-1;
elseif filenumberdigits == 4
    contournr = 1;
while exist(sprintf('%s/images/%s%04d.tif',working_directory_path,filename,contournr)) == 2
   contournr = contournr + 1;
end
contournr = contournr-1;
end


% save the number of images that will be analyzed for later use in the
% other programs
save(sprintf('%s/contours/contournr.txt',working_directory_path),'contournr','-ascii');


% load the parameters of from the configuration file
fid = fopen(sprintf('%s/config/temp_config.ini',program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
parameterStruct = cell2struct(num2cell(c{2}), c{1});

% output of parameters
parameterStruct



% dynamicaly adjusted parameters
% calculate the the corresponding parameters for the diagonal calculations
diaglinfitparameter = ceil(parameterStruct.linfitparameter/1.4142)
diagmeanparameter = ceil(parameterStruct.meanparameter/1.4142)

parameterStruct.displaystartcounter = parameterStruct.displaystart;

%variables:
%pixpos: pixel position coordinates; matrix 2 x n
%xymempos: membrane position coordinates; matrix 2 x n
xymeanmemchange = ones(parameterStruct.maxnrofpoints,2); % vector containing the mean change in x-/y-direction of the
                            % last number of membrane points given by parameterStruct.lastpositions
vwmeanmemchange = ones(parameterStruct.maxnrofpoints,2); 

meanpixchange = ones(parameterStruct.maxnrofpoints,2); % vector containing the mean change in x-/y-direction of the
                            % last number of pixel points given by parameterStruct.lastpositions
                            
center = zeros(1,2);        % this is the value of the center of the membrane;
                            % to be selected by the user at program
                            % initiation (apporximatly)
furthestmembranepos = zeros(1,2); % this is the value of the membrane position furthest from the center;
                            % to be selected by the user at program
                            % initiation (approximatly)
firstdetection = 0;         % this variable is set to one once the algorithm 
                            % has detected the contour correctly for the
                            % first time
contourclosed = 0;          % this variable will be used below to check 
                            % whether the contour was closed for the
                            % algorithm to calculate the new center
                            

outside = 1;                % this switch serves to check how many times the
                            % tracking algorithm wanderd out of bounds
                            
abort = false;              % this variable serves to break of the detection 
                            % loop if the user wishes to do so; it works together 
                            % with the cancel pushbutton of the status
                            % dialog
                            
                            
% Control variables
method = zeros(parameterStruct.maxnrofpoints,1); %variable to check what method was used at what iteration
methodinternaldirection = zeros(parameterStruct.maxnrofpoints,1); % control variable to see which direction was used inside a direction methods
deltaSxy = ones(parameterStruct.maxnrofpoints,1);
deltaSxw = ones(parameterStruct.maxnrofpoints,1);
deltaSxv = ones(parameterStruct.maxnrofpoints,1);
detectedpoints = zeros(contournr,1); % array that will contain the detected points per contour
outsidecounter = 0; % counter to count how many times the algorithm wandered out of
                    % the image and was stopped because of that
contourclosedcounter = 0; % counter to count the number of time the contour was closed

%xbar,ybar,vbar,wbar: postions of membrane for calculation of next membrane point (xtild,ytild)
%Sx1,Sx2,Sxbar,Sy1,Sy2,Sybar: slopes of membranes

%Counter/Index Variables:
%i: index for primary loop
xparameterStruct.directionchangecounter = 0; % these are counter so that a new direction-change can only occur after a certain amount of iterations
yparameterStruct.directionchangecounter = 0; % given by the parameter 'parameterStruct.directiondetectionstart'
vparameterStruct.directionchangecounter = 0;
wparameterStruct.directionchangecounter = 0;

centercounter = 0;  % this is a counter to be able to calculate a new contour
                    % center after the number of steps given by the parameter 
                    % 'parameterStruct.newcentersteps'

%allocation of the matrices that will membrane and pixel position
pixpos = zeros(parameterStruct.maxnrofpoints,2);
xymempos = zeros(parameterStruct.maxnrofpoints,2);
vwmempos = zeros(parameterStruct.maxnrofpoints,2);

% cells that will later contain the coordinates and other information of all the different
% contours
x = cell(contournr,1);
y = cell(contournr,1);
x_ext = cell(contournr,1);
y_ext = cell(contournr,1);
L = cell(contournr,1);
ds = cell(contournr,1);
sumds = cell(contournr,1);

% IMPORTANT: The coordinate-system in the following will be chosen so that the x-direction
% corresponds to the row-index of the image-matrix and the y-direction to
% the column-index of the coordinate-system; i.e.: the normal
% right-coordinate-system is turned 90 degrees clockwise


for j = 1:contournr % loop to go through the contours

% open image for tracking
    if filenumberdigits == 3
    image = imread(sprintf('%s/images/%s%03d.tif',working_directory_path,filename,j)); % creates nxn-matrix of grayscale-image with intensity values
    elseif filenumberdigits == 4
    image = imread(sprintf('%s/images/%s%04d.tif',working_directory_path,filename,j)); % creates nxn-matrix of grayscale-image with intensity values
    end
        
% image = imread('D:/medidas/old_pics/images/M3.tif');

% calculate and select region of interest
% image = image(center(1)-round(sizeofvesicle)-parameterStruct.surroundings:center(1)+round(sizeofvesicle)+parameterStruct.surroundings,center(2)-round(sizeofvesicle)-parameterStruct.surroundings:center(2)+round(sizeofvesicle)+parameterStruct.surroundings);

image = double(image); % converts the image in to an array of doubles for further processing

displayimage = mat2gray(image); %creates a gray scale image with 8bit so it can be displayed

% center = [277.5,323.5];
% furthestmembranepos = [195.5,325.5];


if j==1
    disp('Select the center of the vesicle (approximatly)')
    figure(1), imshow(displayimage); %, axis square;
	[center(2), center(1)] = ginput(1);
    disp('Select the position of the membrane furthest from the center (approximatly)')
    figure(1), imshow(displayimage); %, axis square;
	[furthestmembranepos(2), furthestmembranepos(1)] = ginput(1);
end


if firstdetection == 0
% this calculates the radius of the vesicle
sizeofvesicle = sqrt((furthestmembranepos(1)-center(1))^2+(furthestmembranepos(2)-center(2))^2);
end

% displayimage(round(center)) = 255;
% displayimage(round(furthestmembranepos)) = 255;
% figure(2), imshow(displayimage), axis square;
% pause;



%determine the size of the image to later determine the middle line of the
%image on which to find the membrane (see below)
[imagexmax imageymax] = size(image); % max coordinates in the x- and y-directions

%find starting point for membrane recognition

% OLD AND CORRECT VERSION FOR FINDING STARTING POINT

% this sets the variable firstdetection to 1 once the contour was tracked
% correctly for the first time

if contourclosed == 1 && firstdetection == 0
    
% open question dialog of recognition
user_response = questdlg('Was the contour correctly recognized?','Recognition Dialog','Yes','No','Cancel','No');
switch user_response
case {'No'}
    firstdetection = 0;
case {'Yes'}
    firstdetection = 1;
case {'Cancel'}
    abort = true;
end

% firstdetection = input('Was the contour correctly recognized? (0 = no , 1 = yes) ');
if firstdetection == 1
delta = newstartingpixpos - center; % this calculates the relative coordinates 
                                    % of the detection starting point to
                                    % the center that moves with the
                                    % vesicle; so that we get a moving starting
                                    % point
                                    
sizeofvesicle = sqrt((newstartingpixpos(1)-center(1))^2+(newstartingpixpos(2)-center(2))^2);
parameterStruct.surroundings = 5; % this sets the surrounding displayarea smaller so that it
                  % go easily out-of-bound of the image
                  
% display waitbar
% h = awaitbar(0,'Vesicle Tracking Progress');
% h = waitbar(0,'Vesicle Tracking Progress');
% h = waitbar(0,'Vesicle Tracking Progress','CreateCancelBtn','close(h)')
h = awaitbar(0,'Running Monte-Carlo, please wait...'); 

end
end

% if j < 10 && contourclosed == 1
%     firstdetection = 1;
% end


if j < 10 && firstdetection == 0
pixpos(1,2) = round(center(2)); % chosen y-pixelpostion for finding membrane
pixpos(1,1) = pixelposition(image(:,round(center(2))),round(center(1)-sizeofvesicle-30),...
                              round(center(1)),parameterStruct.linfitparameter); %determine the x-postion of starting pixel in x-direction for chosen y-position
else
    pixpos(1,:) = round(center + delta);
    newstartingpixpos = pixpos(1,:);
end


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

% start

contourclosed = 0; % this variable will be used below to check whether the contour was closed for the algorithm to calculate the new centerof detection loop

for i = 1:parameterStruct.maxnrofpoints

xparameterStruct.directionchangecounter = xparameterStruct.directionchangecounter+1; % this serves to count the number of detection iterations after the last parameterStruct.directionchange
yparameterStruct.directionchangecounter = yparameterStruct.directionchangecounter+1;
vparameterStruct.directionchangecounter = vparameterStruct.directionchangecounter+1;
wparameterStruct.directionchangecounter = wparameterStruct.directionchangecounter+1;

if i>parameterStruct.directiondetectionstart % after the first number of points given by the variable parameterStruct.directiondetectionstart 
                             % these conditions decide over a possible direction change in x- and y-direction
                            
xymeanmemchange(i,:) = [(mean(xymempos(i-parameterStruct.lastpositions:i,1)-xymempos(i-parameterStruct.lastpositions,1))),(mean(xymempos(i-parameterStruct.lastpositions:i,2)-xymempos(i-parameterStruct.lastpositions,2)))];
vwmeanmemchange(i,:) = [(mean(vwmempos(i-parameterStruct.lastpositions:i,1)-vwmempos(i-parameterStruct.lastpositions,1))),(mean(vwmempos(i-parameterStruct.lastpositions:i,2)-vwmempos(i-parameterStruct.lastpositions,2)))];
meanpixchange(i,:) = [(mean(pixpos(i-parameterStruct.lastpositions:i,1)-pixpos(i-parameterStruct.lastpositions,1))),(mean(pixpos(i-parameterStruct.lastpositions:i,2)-pixpos(i-parameterStruct.lastpositions,2)))];


% set new x-direction
if xparameterStruct.directionchangecounter > parameterStruct.directionchange
if abs(xymeanmemchange(i,1)) < parameterStruct.directioncondition
    xdirection = - xdirection;
    xparameterStruct.directionchangecounter = 0;
end
end

% set new y-direction
if yparameterStruct.directionchangecounter > parameterStruct.directionchange
if abs(xymeanmemchange(i,2)) < parameterStruct.directioncondition
    ydirection = - ydirection;
    yparameterStruct.directionchangecounter = 0;
end
end

% set new v-direction
if vparameterStruct.directionchangecounter > parameterStruct.directionchange
if abs(vwmeanmemchange(i,1)) < parameterStruct.directioncondition
    vdirection = - vdirection;
    vparameterStruct.directionchangecounter = 0;
end
end

%set new w-direction
if wparameterStruct.directionchangecounter > parameterStruct.directionchange
if abs(vwmeanmemchange(i,2)) < parameterStruct.directioncondition
    wdirection = - wdirection;
    wparameterStruct.directionchangecounter = 0;
end
end

end


% Calculation of next membrane point according to the tracing algorithm

% in the following the Slopes and positions of the membrane are calculated
% in the coordinate-systems. Later the exact position of the membrane is
% determined by calculation of the baryo center of these four points
% weighted by the slopes



% membrane position ybar in y-direction at x_i+1, ie: (x_i+1,ybar)

p = polyfit(pixpos(i,2)-parameterStruct.linfitparameter:pixpos(i,2)+parameterStruct.linfitparameter,...
            image(pixpos(i,1)+xdirection,pixpos(i,2)-parameterStruct.linfitparameter:pixpos(i,2)+parameterStruct.linfitparameter),1); %calculate linear fit straight

Sy = p(1);

if Sy ==0
   Sy = 0.00001; 
end

intercepty = p(2);
meanvaluey = mean(image(pixpos(i,1)+xdirection,pixpos(i,2)-parameterStruct.meanparameter:pixpos(i,2)+parameterStruct.meanparameter));
ybar = (meanvaluey-intercepty)/Sy;

% for old method
ybar2 = ybar - pixpos(i,2);


% if i==0 %parameterStruct.displaystart
% % plot intensity profile
% figure(2),plot(pixpos(i,2)-parameterStruct.meanparameter:pixpos(i,2)+parameterStruct.meanparameter,...
%                image(pixpos(i,1)+xdirection,pixpos(i,2)-parameterStruct.meanparameter:pixpos(i,2)+parameterStruct.meanparameter));
% 
% hold on;
% 
% % plot linear fit
% linfit = Sy*(pixpos(i,2)-parameterStruct.linfitparameter:pixpos(i,2)+parameterStruct.linfitparameter)+intercepty;
% figure(2),plot(pixpos(i,2)-parameterStruct.linfitparameter:pixpos(i,2)+parameterStruct.linfitparameter,linfit);
% 
% % plot mean value of intesities
% meany = meanvaluey*ones(size(pixpos(i,2)-parameterStruct.meanparameter:pixpos(i,2)+parameterStruct.meanparameter));
% figure(2),plot(pixpos(i,2)-parameterStruct.meanparameter:pixpos(i,2)+parameterStruct.meanparameter,meany);
% 
% figure(2),title(['ydirection; Sy=',num2str(Sy),', ybar=',num2str(ybar2)]);
% 
% hold off;
% end




% membrane position xbar in x-direction at y_i+1, ie: (xbar,y_i+1)

p = polyfit(pixpos(i,1)-parameterStruct.linfitparameter:pixpos(i,1)+parameterStruct.linfitparameter,...
    transpose(image(pixpos(i,1)-parameterStruct.linfitparameter:pixpos(i,1)+parameterStruct.linfitparameter,pixpos(i,2)+ydirection)),1); %calculate linear fit straight

Sx = p(1);

if Sx ==0
   Sx = 0.00001; 
end

interceptx = p(2);
meanvaluex = mean(image(pixpos(i,1)-parameterStruct.meanparameter:pixpos(i,1)+parameterStruct.meanparameter,pixpos(i,2)+ydirection));
xbar = (meanvaluex - interceptx)/Sx;

% for old method
xbar2 = xbar - pixpos(i,1);


% if i==0 %parameterStruct.displaystart
% % plot intensity profile
% figure(3),plot(pixpos(i,1)-parameterStruct.meanparameter:pixpos(i,1)+parameterStruct.meanparameter,image(pixpos(i,1)-parameterStruct.meanparameter:pixpos(i,1)+parameterStruct.meanparameter,pixpos(i,2)+ydirection))
% 
% hold on;
% 
% % plot linear fit
% linfit  = Sx*(pixpos(i,1)-parameterStruct.linfitparameter:pixpos(i,1)+parameterStruct.linfitparameter)+interceptx;
% figure(3),plot(pixpos(i,1)-parameterStruct.linfitparameter:pixpos(i,1)+parameterStruct.linfitparameter,linfit);
% 
% % plot mean value of intensities
% meanx = meanvaluex*ones(size(pixpos(i,1)-parameterStruct.meanparameter:pixpos(i,1)+parameterStruct.meanparameter));
% figure(3),plot(pixpos(i,1)-parameterStruct.meanparameter:pixpos(i,1)+parameterStruct.meanparameter,meanx);
% 
% figure(3),title(['xdirection; Sx=',num2str(Sx),', xbar=',num2str(xbar2)]);
% 
% hold off;
% end




% membrane position wbar in w-direction at v_i+1, ie: (v_i+1,wbar)

% set the diagonal to be analysed

xposition_at_v_i1 = pixpos(i,1)+vdirection; % analyse at the x-y-podition in direction of v
yposition_at_v_i1 = pixpos(i,2)+vdirection;

wmeancutout = image(xposition_at_v_i1-diagmeanparameter:xposition_at_v_i1+diagmeanparameter,...
                    yposition_at_v_i1-diagmeanparameter:yposition_at_v_i1+diagmeanparameter);
                
wlinfitcutout = image(xposition_at_v_i1-diaglinfitparameter:xposition_at_v_i1+diaglinfitparameter,...
                      yposition_at_v_i1-diaglinfitparameter:yposition_at_v_i1+diaglinfitparameter);

meanintensities = perpdiag(wmeancutout);
linfitintensities = perpdiag(wlinfitcutout);

% the distance needs to be corrected since the pixels in the diagonals are 1.4142
% pixels apart ???
linfitxvalues = (-diaglinfitparameter:diaglinfitparameter); 
meanfitxvalues = (-diagmeanparameter:diagmeanparameter);

p = polyfit(linfitxvalues,linfitintensities,1);

Sw = p(1);

if Sw ==0
   Sw = 0.00001;
end

interceptw = p(2);
meanvaluew = mean(meanintensities);
wbar = (meanvaluew - interceptw)/Sw;


% if i==0 %parameterStruct.displaystart
% % plot inensity profile
% figure(4),plot(meanfitxvalues,meanintensities);
% 
% hold on;
% 
% % plot linear fit
% linfit = Sw*linfitxvalues+interceptw;
% figure(4),plot(linfitxvalues,linfit);
% 
% % plot mean value of intensities
% meanw = meanvaluew*ones(size(meanfitxvalues));
% figure(4),plot(meanfitxvalues,meanw);
% 
% figure(4),title(['wdirection; Sw=',num2str(Sw),', wbar=',num2str(wbar)]);
% 
% hold off;
% end

% calculate coordinates of wbar in x-y-coordinate-system

x_wbar = pixpos(i,1)+xdirection*0.7071-wbar*0.7071;
y_wbar = pixpos(i,2)+ydirection*0.7071+wbar*0.7071;



% membrane position vbar in v-direction at w_i+1, ie: (vbar,w_i+1)

% set the diagonal to be analysed

xposition_at_w_i1 = pixpos(i,1)-wdirection; % analyse at the x-y-podition in direction of w
yposition_at_w_i1 = pixpos(i,2)+wdirection;

vmeancutout = image(xposition_at_w_i1-diagmeanparameter:xposition_at_w_i1+diagmeanparameter,...
                    yposition_at_w_i1-diagmeanparameter:yposition_at_w_i1+diagmeanparameter);
                
vlinfitcutout = image(xposition_at_w_i1-diaglinfitparameter:xposition_at_w_i1+diaglinfitparameter,...
                      yposition_at_w_i1-diaglinfitparameter:yposition_at_w_i1+diaglinfitparameter);

meanintensities = transpose(diag(vmeancutout));
linfitintensities = transpose(diag(vlinfitcutout));

% the distance needs to be corrected since the pixels in the diagonals are 1.4142
% pixels apart ???
linfitxvalues = (-diaglinfitparameter:diaglinfitparameter);
meanfitxvalues = (-diagmeanparameter:diagmeanparameter);

p = polyfit(linfitxvalues,linfitintensities,1);

Sv = p(1);

if Sv ==0
   Sv = 0.00001; 
end

interceptv = p(2);
meanvaluev = mean(meanintensities);
vbar = (meanvaluev - interceptv)/Sv;


% if i==0 %parameterStruct.displaystart
% % plot inensity profile
% figure(5),plot(meanfitxvalues,meanintensities);
% 
% hold on;
% 
% % plot linear fit
% linfit = Sv*linfitxvalues+interceptv;
% figure(5),plot(linfitxvalues,linfit);
% 
% % plot mean value of intensities
% meanv = meanvaluev*ones(size(meanfitxvalues));
% figure(5),plot(meanfitxvalues,meanv);
% 
% figure(5),title(['vdirection; Sv=',num2str(Sv),', vbar=',num2str(vbar)]);
% 
% hold off;
% end


% calculate coordinates of wbar in x-y-coordinate-system

x_vbar = pixpos(i,1)-xdirection*0.7071+vbar*0.7071;
y_vbar = pixpos(i,2)+ydirection*0.7071+vbar*0.7071;


%calculation of baryocenter of the calculated points

%!!!!Sw and Sv need to be corrected by sqrt(2) due to different spacing in the v-w-coordinate-system; what about wbar and vbar?
% Sw = Sw*1.4142;
% Sv = Sv*1.4142;

% Sw = Sw*0.7071; % GOTTA be this one!!!
% Sv = Sv*0.7071;



% !!!Maybe absolute values for the baryo center!!!!
Sx = abs(Sx);
Sy = abs(Sy);
Sv = abs(Sv);
Sw = abs(Sw);

% latest method
% xtild  =  (Sx*xdirection + Sy*xbar2 + Sv*(vdirection/1.4142 - wbar/1.4142) + Sw*(-wdirection/1.4142 + vbar/1.4142))/(Sx+Sy+Sv+Sw);
% ytild = (Sx*ybar2 + Sy*ydirection + Sv*(vdirection/1.4142 + wbar/1.4142) + Sw*(wdirection/1.4142 + vbar/1.4142))/(Sx+Sy+Sv+Sw);

% my method
xtild = (Sy*xdirection + Sx*xbar2 + Sw*(vdirection*0.707106781 - (wbar/1.414213562)) + Sv*((-wdirection)*0.707106781 + (vbar/1.414213562)))/(Sx+Sy+Sv+Sw);
ytild = (Sy*ybar2 + Sx*ydirection + Sw*(vdirection*0.707106781 + (wbar/1.414213562)) + Sv*(wdirection*0.707106781 + (vbar/1.414213562)))/(Sx+Sy+Sv+Sw);
 


xymempos(i+1,1) = pixpos(i,1)+xtild;
xymempos(i+1,2) = pixpos(i,2)+ytild;

% coordinate transformation to the vw-coordinate system
vwmempos(i+1,1) = xymempos(i,1) * 0.70710678 + xymempos(i,2) * 0.70710678; % trafo to v-axis
vwmempos(i+1,2) = xymempos(i,2) * 0.70710678 - xymempos(i,1) * 0.70710678; % trafo to w-axis

% xtild2 = abs(xtild);
% ytild2 = abs(ytild);
% 
% xymempos(i+1,1) = pixpos(i,1)+xdirection*xtild2;
% xymempos(i+1,2) = pixpos(i,2)+ydirection*ytild2;




% NEW VERSION

% method for new point like described in text
% xymempos(i+1,1) = (Sx*(pixpos(i,1)+xdirection)+Sy*xbar+Sv*x_wbar+Sw*x_vbar)/(Sx+Sy+Sv+Sw);
% xymempos(i+1,2) = (Sx*ybar+Sy*(pixpos(i,2)+ydirection)+Sv*y_wbar+Sw*y_vbar)/(Sx+Sy+Sv+Sw);


%determination of new position on pixelgrid (i.e.: determination of pixpos(i+1,:))

%for this there are 4 Methodes to be used to find a new pixel-position pixpos(i+1,:). These are tested
%successively

% Methode 1:
% round the coordinates of the membrane position to the next integer. If the
% resulting pixel-position pixpos(i+1,:) equals pixpos(i,:), the next
% condition is tested

pixpos(i+1,1) = round(xymempos(i+1,1));
pixpos(i+1,2) = round(xymempos(i+1,2));

% If the determination of the new pixelposition by rounding of the membran position fails try next determination method 


if pixelpositiontest(pixpos,parameterStruct.pixeltestparameter,i)==1 % this checks if method 1 was used
    method(i) = 1;
    methodinternaldirection(i) = 0;
end


% check the other methods by heirarchie

if pixelpositiontest(pixpos,parameterStruct.pixeltestparameter,i)==0 % use method 2 to find next pixel position
    
    [pixpos(i+1,:),methodinternaldirection(i)] = newpixposmethod2(pixpos,i,Sx,Sy,Sv,Sw,xdirection,ydirection,parameterStruct.slopediff);
    method(i) = 2;


if pixelpositiontest(pixpos,parameterStruct.pixeltestparameter,i)==0 % use method 3 to find next pixel position
    
    [pixpos(i+1,:),methodinternaldirection(i)] = newpixposmethod3(xymempos,pixpos,i);
    method(i) = 3;


if pixelpositiontest(pixpos,parameterStruct.pixeltestparameter,i)==0 % use method 4 to find next pixel position
    
    [pixpos(i+1,:),methodinternaldirection(i)] = newpixposmethod4(xymempos,pixpos,i,parameterStruct.methode4parameter);
    method(i) = 4;


if pixelpositiontest(pixpos,parameterStruct.pixeltestparameter,i)==0 % use methode 5 to find next pixel position;
        % this is the old, simpler method for finding the next pixelposition
    [pixpos(i+1,:),methodinternaldirection(i),returnblank] = newpixposmethodold(pixpos(i,:),image,xdirection,ydirection,parameterStruct.meanparameter,parameterStruct.linfitparameter);
    method(i) = 5;
end
end
end
end



% this checks that the next pixel and the surrounding area for the calculations is still inside the image
if pixpos(i+1,1) - parameterStruct.meanparameter - 1 < 0 || pixpos(i+1,1) + parameterStruct.meanparameter + 1 > imagexmax || ...
   pixpos(i+1,2) - parameterStruct.meanparameter - 1 < 0 || pixpos(i+1,1) + parameterStruct.meanparameter + 1 > imageymax
    display('pixelposition or surrounding area for calculations is out-of-bounds (too large or to small)');
    outsidecounter = outsidecounter + 1;
    break;
end


% break-off condition of the algorithm. This compares the last calculated
% pixelposition with the pixel position (x_10,y_10) at i = parameterStruct.comparepixel up to
% i = parameterStruct.comparepixel+parameterStruct.nrofcomparepixel. If one of the conincides the vesicle 
% tracing is complete.

breakofpixel = 1; % the variable  "breakofpixel" will be used below to eliminate 
                % the first certain number membrane positions that were traced twice
                
finished = 0;     % variable of the finish condition; if it is turned to one,
                % the finish algorithm has found that the contour is closed

if i>parameterStruct.comparepixel+parameterStruct.nrofcomparepixel
for breakofpixel = parameterStruct.comparepixel:parameterStruct.comparepixel+parameterStruct.nrofcomparepixel 

    if pixpos(breakofpixel,:)==pixpos(i+1,:)
    a = xymempos(10,:)-xymempos(1,:);
    b = xymempos(i,:)-xymempos(i-9,:);
    % calculate angle:
    if norm(a) ~= 0 && norm(b) ~= 0
    alpha = acos((a*transpose(b))/(norm(a)*norm(b)));
        maxangle = 0.7;
        if alpha<maxangle
        finished = 1;
        contourclosed = 1;
        break;
        end
    end
    end
end
if finished==1;
    finished = 0;
    break; % this 'break' exits the detection loop
end
end

% mark membrane and pixel position in the image to white
displayimage(pixpos(i,1),pixpos(i,2)) = 255; % pixel positions are white
displayimage(round(xymempos(i,1)),round(xymempos(i,2))) = 0; % membrane positions are black


% section for controlling the algorithm


% Control variables for comparing the slopes
% deltaSxy(i) = abs(Sx-Sy);
% deltaSxw(i) = abs(Sx-Sw);
% deltaSxv(i) = abs(Sx-Sv);


% xymeanmemchange(i,:)
% [xdirection,ydirection]
% if i==parameterStruct.displaystart
%     parameterStruct.displaystart = i+parameterStruct.displayincrement;
%     
%     disp('ITERATION')
%     disp(i)
%     
%     disp('x-pixpos(i)     y-pixpos(i)')
%     disp(pixpos(i,:))
%     
%     disp(['x-xymempos(i+1)    y-xymempos(i+1)'])
%     disp([xymempos(i+1,1),xymempos(i+1,2)])
%     
%     
%     disp('x-pixpos(i+1)     y-pixpos(i+1)')
%     disp(pixpos(i+1,:))
%     
%     
%     disp(['method    internal method'])
%     disp([method(i),methodinternaldirection(i)])
% %     
%     disp('Sx        Sy          Sv           Sw')
%     disp([Sx,Sy,Sv,Sw])
%     
%     disp('Sx*xdir   Sy*xbar     Sv*x_wbar   Sw*x_vbar   /(Sx+Sy+Sv+Sw)')
%     disp([Sx*xdirection,Sy*xbar2,Sv*(xdirection*0.707106781-(wbar/1.414213562)),Sw*((-xdirection)*0.707106781+(vbar/1.414213562))]/(Sx+Sy+Sv+Sw));
%     
%     disp('Sx*ybar   Sy*ydir     Sv*y_wbar   Sw*y_vbar   /(Sx+Sy+Sv+Sw)')
%     disp([Sx*ybar2,Sy*ydirection,Sv*(ydirection*0.707106781+(wbar/1.414213562)),Sw*(ydirection*0.707106781+(vbar/1.414213562))]/(Sx+Sy+Sv+Sw));
% 
%     disp('x-tild    y-tild')
%     disp([xtild,ytild])
    
%     disp(['x-xymempos(i)    y-xymempos(i)'])
%     disp([xymempos(i,1),xymempos(i,2)])
%     
%     disp(['v-vwmempos(i)    w-vwmempos(i)'])
%     disp([vwmempos(i,1),vwmempos(i,2)])
%     
%     disp(['mean x-change    mean y-change'])
%     disp(xymeanmemchange(i,:))
%     
%     disp(['mean v-change    mean w-change'])
%     disp(vwmeanmemchange(i,:))

%     disp('	Sx   Sy  Sv   Sw')
%     disp([Sx,Sy,Sv,Sw])
%     
%     disp('	xbar      ybar        vbar        wbar')
%     disp([xbar ybar vbar wbar])
    
%     disp(['x-direction    y-direction'])
%     disp([xdirection,ydirection])
%     
%     disp(['v-direction    w-direction'])
%     disp([vdirection,wdirection])
    
        
%     imshow(displayimage);

%     zoomeddisplayimage = displayimage(round(center(1))-round(sizeofvesicle)-parameterStruct.surroundings:round(center(1))+round(sizeofvesicle)+parameterStruct.surroundings,round(center(2))-round(sizeofvesicle)-parameterStruct.surroundings:round(center(2))+round(sizeofvesicle)+parameterStruct.surroundings);
%     figure(1), imshow(zoomeddisplayimage);
%     pixpos(i,:)
    
    
%     if i>1
%     disp('xymempos(i+1) - xymempos(i)')
%     disp(xymempos(i+1,:)-xymempos(i,:))
%     end
    
%     %defines the center of the plot
%     xchange = pixpos(i,1);
%     ychange = pixpos(i,2);
%     
%     figure(6),plot(xymempos(i,2)-ychange,-xymempos(i,1)+xchange,'go');
%     hold on;
%     figure(6),plot(xymempos(i+1,2)-ychange,-xymempos(i+1,1)+xchange,'bo');
%     figure(6),plot(pixpos(i,2)-ychange,-pixpos(i,1)+xchange,'g+');
%     figure(6),plot(pixpos(i+1,2)-ychange,-pixpos(i+1,1)+xchange,'b+');
%     
%     % weighte direction positions
%     figure(6),plot(-pixpos(i,2)+ydirection+ychange,xbar-xchange,'r+');
%     figure(6),plot(-ybar+ychange,pixpos(i,1)+xdirection-xchange,'c+');
%     figure(6),plot(-y_vbar+ychange,x_vbar-xchange,'m+');
%     figure(6),plot(-y_wbar+ychange,x_wbar-xchange,'y+');
%     legend('xymempos(i)','xymempos(i+1)','pixpos(i)','pixpos(i+1)','xbar','ybar','vbar','wbar');
%     axis([-3,3,-3,3]);
%     hold off;



%     % defines the center of the plot
%     xchange = pixpos(i,1);
%     ychange = pixpos(i,2);
    
%     figure(6),plot(xymempos(i,2)-ychange,-xymempos(i,1)+xchange,'go');
%     hold on;
%     figure(6),plot(xymempos(i+1,2)-ychange,-xymempos(i+1,1)+xchange,'bo');
%     figure(6),plot(pixpos(i,2)-ychange,-pixpos(i,1)+xchange,'g+');
%     figure(6),plot(pixpos(i+1,2)-ychange,-pixpos(i+1,1)+xchange,'b+');
%     
%     % weighte direction positions
%     figure(6),plot((pixpos(i,2)+ydirection-ychange)*Sy/(Sx+Sy+Sv+Sw),(xbar-xchange)*Sy/(Sx+Sy+Sv+Sw),'r+');
%     figure(6),plot((ybar-ychange)*Sx/(Sx+Sy+Sv+Sw),(pixpos(i,1)+xdirection-xchange)*Sx/(Sx+Sy+Sv+Sw),'c+');
%     figure(6),plot((y_vbar-ychange)*Sw/(Sx+Sy+Sv+Sw),(x_vbar-xchange)*Sw/(Sx+Sy+Sv+Sw),'m+');
%     figure(6),plot((y_wbar-ychange)*Sv/(Sx+Sy+Sv+Sw),(x_wbar-xchange)*Sv/(Sx+Sy+Sv+Sw),'y+');
%     legend('xymempos(i)','xymempos(i+1)','pixpos(i)','pixpos(i+1)','xbar','ybar','vbar','wbar');
%     axis([-5,5,-5,5]);
%     hold off;


    
%     method(i)
%     deltaSxy(i)
%     deltaSxw(i)
%     deltaSxv(i)
%     xymempos(i,:)
%     xymeanmemchange(i,:)
%     [abs(mean(pixpos(i-parameterStruct.lastpositions:i,1)-pixpos(i-parameterStruct.lastpositions,1))),abs(mean(pixpos(i-parameterStruct.lastpositions:i,2)-pixpos(i-parameterStruct.lastpositions,2)))]
%     pause
% end


end % end detection loop

% save membrane positions for further analysis

xymempos = xymempos(breakofpixel:i-1,:);
pixpos = pixpos(breakofpixel:i-1,:);


% save the 10th last pixel of the contour to be the starting point 'newstartingpixpos' for the
% tracking in the following image

if firstdetection == 0
% if contourclosed == 1 
newstartingpixpos = round(pixpos(length(pixpos) - breakofpixel + 3,:));
end

if firstdetection == 1
    displayimage(newstartingpixpos(1),newstartingpixpos(2)) = 255;
end

% 

% save files in ascii text format
save(sprintf('%s/contours/contour%i.txt',working_directory_path,j),'xymempos','-ascii'); % save the contour

% save files in MATLAB binary format
% save(sprintf('/home/micha/praktikum_complutense/program/contours/contour%i.mat',j),'xymempos');


% Calculate new center position of vesicle
% the following lines up to the clear command calculate the new contour
% center in case the vesicle is moving; this is done after the number of
% detection iteration steps given by the parameter "parameterStruct.newcentersteps"

centercounter = centercounter + 1;
if centercounter >= parameterStruct.newcentersteps && contourclosed == 1 % contourclosed=1 <=> contour is closed; contourclosed=0 <=> contour is NOT closed
centercounter = 0;
x{j} = xymempos(:,1);
y{j} = xymempos(:,2);

x_ext{j} = zeros(length(x{j}) + 2,1);
y_ext{j} = zeros(length(y{j}) + 2,1);
x_ext{j}(2:end-1) = x{j};
x_ext{j}(1) = x{j}(end);
x_ext{j}(end) = x{j}(1);
y_ext{j}(2:end-1) = y{j};
y_ext{j}(1) = y{j}(end);
y_ext{j}(end) = y{j}(1);

% Variables:
% L = 0; % length of circumference
% xymemposlength = length(xymempos); % length of the vector xymempos
% ds = zeros(xymemposlength,1); % vector containing the distances between neighbooring membrane positions
% sumds = zeros(xymemposlength,1); % vector containing sum between ds(i) and ds(i+1)

% calculate length of circumferences
ds{j} = sqrt( (x_ext{j}(2:end) - x_ext{j}(1:end-1)) .^2 + (y_ext{j}(2:end) - y_ext{j}(1:end-1)) .^2 );
L{j} = sum( ds{j}(1:end-1) ); % sum up to end-1 because ds(end) = ds(1)

% calculate the center position of the contour

% calculate the center positions of the contours
sumds{j} = ds{j}(1:end-1) + ds{j}(2:end); % help variable representing the sum of the coordinate differences

center(1) = (1/(2*L{j})) * sum(x{j} .* sumds{j});
center(2) = (1/(2*L{j})) * sum(y{j} .* sumds{j});

end

% show center in displayimage
displayimage(round(center(1)),round(center(2))) = 255;



% CONTROL OUTPUT

% show zoomed image of selected vesicle
if j < parameterStruct.firstdisplayedcontours
zoomeddisplayimage = displayimage(round(center(1))-round(sizeofvesicle)-parameterStruct.surroundings:round(center(1))+round(sizeofvesicle)+parameterStruct.surroundings,round(center(2))-round(sizeofvesicle)-parameterStruct.surroundings:round(center(2))+round(sizeofvesicle)+parameterStruct.surroundings);
figure(1), imshow(zoomeddisplayimage);
% figure(2), imshow(displayimage);
% pause;
pause(0.1);
end

% give out number of detected points to vector
detectedpoints(j) = length(xymempos);
[j,length(xymempos),xdirection,ydirection]

disp(['contour closed = ',int2str(contourclosed)])
disp(breakofpixel)
if contourclosed == 1
disp(newstartingpixpos)
end

if contourclosed == 1
    contourclosedcounter = contourclosedcounter + 1;
end

clear xymempos vwmempos pixpos image;

if firstdetection == 1

hh=awaitbar(j/contournr,h,'Running the process','Progress');
if abort; close(h);return; end   % Abort the process by clicking abort button
if isempty(hh);return; end      % Break the process when closing the figure
end

end % this ends the loop for going through the different images

save(sprintf('%s/contours/tracking_variables.mat',working_directory_path,j),'x','x_ext','y','y_ext');