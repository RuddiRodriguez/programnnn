% this is a script that calls the actual programs of the entire measuring
% process in the following sequence:
% 1. pathset - program to set the path of the working directory
% 2. tacker - program that tracks the contours of the vesicula
% 3. testcontour - program to test the contours (i.e.: if closed, etc.)
% 4. evalu - contour evaluation program (extracts the spectrum)
% 5. fitting - program to fit the fitting-function against the spectrum
% 6. flot - program to plot the data and the fitted function

pathset;

oldmain_new;
% main_gui;

testcontour;

evalu;

fitting;

flot;

flot2;