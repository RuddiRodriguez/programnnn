function [imato1]=xmergeimatos(imato1,imato2)
%----------------------------------------------------
% function [imato1]=xmergeimatos(imato1,imato2)
%----------------------------------------------------
% Merges to imat output files into one file
%----------------------------------------------------
% Input:
%   imato1:
%   imato2:
% Output:
%   imato1:
%----------------------------------------------------
% Example:
%
imato1.pictures=[imato1.pictures;imato2.pictures];
imato1.resx=[imato1.resx;imato2.resx];
imato1.resy=[imato1.resy;imato2.resy];
clear imato2;



