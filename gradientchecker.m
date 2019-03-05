% program to check the slopes and fits of the membrane gradients

% NEW VERSION OF METHOD TO CALCULATE NEXT MEMBRANE POSITION

% membrane position ybar in y-direction at x_i+1, ie: (x_i+1,ybar)

clear all; %clear all variables


xdirection=1;
ydirection=1;


% sets filename of the files being analyzed
fid = fopen('/membrane_tracking_project/medidas/filename.txt','rt'); 
filename = fscanf(fid,'%s')
fclose('all');

% sets the rootpath of the files being analyzed; ie: the directory
% containing the image directory
fid = fopen('/membrane_tracking_project/medidas/workingdirectory.txt','rt'); 
path = fscanf(fid,'%s')
fclose('all');


% check number image files in image directory
contournr=1;
while exist(sprintf('%s/images/%s%03d.tif',path,filename,contournr)) == 2
   contournr=contournr+1; 
end
contournr=contournr-1;
% save the number of images that will be analyzed for later use in the
% other programs
save(sprintf('%s/contours/contournr.txt',path),'contournr','-ascii');

%parameters:
linfitparameter=4; % number of points to each side of a given point for the linear fit 
meanparameter=14; % number of points to each side of a given point for which the mean grey value will be calculated

diaglinfitparameter=3;
diagmeanparameter=10;

j=1;

image=imread(sprintf('%s/images/%s%03d.tif',path,filename,j)); % creates nxn-matrix of grayscale-image with intensity values
% image=imread('D:/medidas/old_pics/images/M3.tif');

image=double(image); % converts the image in to an array of doubles for further processing

displayimage=mat2gray(image); %creates a gray scale image with 8bit so it can be displayed

t=1;
i=1;

while t==1
    
    disp('Select the center of the vesicle (approximatly)')
    figure(1), imshow(displayimage); %, axis square;
	[pixpos(i,2), pixpos(i,1)] = ginput(1);
    
    pixpos = round(pixpos)

p = polyfit([pixpos(i,2)-linfitparameter:pixpos(i,2)+linfitparameter],image(pixpos(i,1)+xdirection,pixpos(i,2)-linfitparameter:pixpos(i,2)+linfitparameter),1); %calculate linear fit straight

Sy = p(1);
intercepty = p(2);
meanvaluey = mean(image(pixpos(i,1)+xdirection,pixpos(i,2)-meanparameter:pixpos(i,2)+meanparameter));
ybar = (meanvaluey-intercepty)/Sy;

% for old method
ybar2 = ybar - pixpos(i,2);


% plot intensity profile
figure(2),plot([pixpos(i,2)-meanparameter:pixpos(i,2)+meanparameter],image(pixpos(i,1)+xdirection,pixpos(i,2)-meanparameter:pixpos(i,2)+meanparameter));

hold on;

% plot linear fit
linfit = Sy*[pixpos(i,2)-linfitparameter:pixpos(i,2)+linfitparameter]+intercepty;
figure(2),plot([pixpos(i,2)-linfitparameter:pixpos(i,2)+linfitparameter],linfit);

% plot mean value of intesities
meany = meanvaluey*ones(size([pixpos(i,2)-meanparameter:pixpos(i,2)+meanparameter]));
figure(2),plot([pixpos(i,2)-meanparameter:pixpos(i,2)+meanparameter],meany);

figure(2),title(['ydirection; Sy=',num2str(Sy),', ybar=',num2str(ybar2)]);

hold off;



% membrane position xbar in x-direction at y_i+1, ie: (xbar,y_i+1)

p=polyfit([pixpos(i,1)-linfitparameter:pixpos(i,1)+linfitparameter],...
    transpose(image(pixpos(i,1)-linfitparameter:pixpos(i,1)+linfitparameter,pixpos(i,2)+ydirection)),1); %calculate linear fit straight

Sx = p(1);
interceptx = p(2);
meanvaluex = mean(image(pixpos(i,1)-meanparameter:pixpos(i,1)+meanparameter,pixpos(i,2)+ydirection));
xbar = (meanvaluex - interceptx)/Sx;

% for old method
xbar2 = xbar - pixpos(i,1);

% plot intensity profile
figure(3),plot([pixpos(i,1)-meanparameter:pixpos(i,1)+meanparameter],image(pixpos(i,1)-meanparameter:pixpos(i,1)+meanparameter,pixpos(i,2)+ydirection))

hold on;

% plot linear fit
linfit  = Sx*[pixpos(i,1)-linfitparameter:pixpos(i,1)+linfitparameter]+interceptx;
figure(3),plot([pixpos(i,1)-linfitparameter:pixpos(i,1)+linfitparameter],linfit);

% plot mean value of intensities
meanx = meanvaluex*ones(size([pixpos(i,1)-meanparameter:pixpos(i,1)+meanparameter]));
figure(3),plot([pixpos(i,1)-meanparameter:pixpos(i,1)+meanparameter],meanx);

figure(3),title(['xdirection; Sx=',num2str(Sx),', xbar=',num2str(xbar2)]);

hold off;



% membrane position wbar in w-direction at v_i+1, ie: (v_i+1,wbar)

% set the diagonal to be analysed

wmeancutout = image(pixpos(i,1)-diagmeanparameter:pixpos(i,1)+diagmeanparameter,pixpos(i,2)-diagmeanparameter:pixpos(i,2)+diagmeanparameter);
wlinfitcutout = image(pixpos(i,1)-diaglinfitparameter:pixpos(i,1)+diaglinfitparameter,pixpos(i,2)-diaglinfitparameter:pixpos(i,2)+diaglinfitparameter);

meanintensities = perpdiag(wmeancutout);
linfitintensities = perpdiag(wlinfitcutout);

linfitxvalues = [-diaglinfitparameter:diaglinfitparameter]*1.4142;
meanfitxvalues = [-diagmeanparameter:diagmeanparameter]*1.4142;

p = polyfit(linfitxvalues,linfitintensities,1);

Sw = p(1);
interceptw = p(2);
meanvaluew = mean(meanintensities);
wbar = (meanvaluew - interceptw)/Sw;

% plot inensity profile
figure(4),plot(meanfitxvalues,meanintensities);

hold on;

% plot linear fit
linfit = Sw*linfitxvalues+interceptw;
figure(4),plot(linfitxvalues,linfit);

% plot mean value of intensities
meanw = meanvaluew*ones(size(meanfitxvalues));
figure(4),plot(meanfitxvalues,meanw);

figure(4),title(['wdirection; Sw=',num2str(Sw),', wbar=',num2str(wbar)]);

hold off;


% calculate coordinates of wbar in x-y-coordinate-system

x_wbar = pixpos(i,1)+xdirection*0.7071-wbar*0.7071;
y_wbar = pixpos(i,2)+ydirection*0.7071+wbar*0.7071;



% membrane position vbar in v-direction at w_i+1, ie: (vbar,w_i+1)

% set the diagonal to be analysed

vmeancutout = image(pixpos(i,1)-diagmeanparameter:pixpos(i,1)+diagmeanparameter,pixpos(i,2)-diagmeanparameter:pixpos(i,2)+diagmeanparameter);
vlinfitcutout = image(pixpos(i,1)-diaglinfitparameter:pixpos(i,1)+diaglinfitparameter,pixpos(i,2)-diaglinfitparameter:pixpos(i,2)+diaglinfitparameter);

meanintensities = transpose(diag(vmeancutout));
linfitintensities = transpose(diag(vlinfitcutout));

linfitxvalues = [-diaglinfitparameter:diaglinfitparameter]*1.4142;
meanfitxvalues = [-diagmeanparameter:diagmeanparameter]*1.4142;

p = polyfit(linfitxvalues,linfitintensities,1);

Sv = p(1);
interceptv = p(2);
meanvaluev = mean(meanintensities);
vbar = (meanvaluev - interceptv)/Sv;

% plot inensity profile
figure(5),plot(meanfitxvalues,meanintensities);

hold on;

% plot linear fit
linfit = Sv*linfitxvalues+interceptv;
figure(5),plot(linfitxvalues,linfit);

% plot mean value of intensities
meanv = meanvaluev*ones(size(meanfitxvalues));
figure(5),plot(meanfitxvalues,meanv);

figure(5),title(['vdirection; Sv=',num2str(Sv),', vbar=',num2str(vbar)]);

hold off;

% calculate coordinates of wbar in x-y-coordinate-system

x_vbar = pixpos(i,1)-xdirection*0.7071+vbar*0.7071;
y_vbar = pixpos(i,2)+ydirection*0.7071+vbar*0.7071;

end