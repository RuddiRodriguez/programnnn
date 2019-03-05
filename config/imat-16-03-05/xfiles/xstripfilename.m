function [new,ext]=xstripfilename(filenames)
%--------------------------------------------------------------
% function [new,ext]=xstripfilename(filenames)
%--------------------------------------------------------------
% Divides filenames into name and extension
%--------------------------------------------------------------
% Input:
%   filenames:  string array with filenames in the rows
% Output:
%   new:        the filename (without extension)
%   ext:        the extension
%--------------------------------------------------------------
% Example:
%   filenames=  
%           [ '3P2-2_ch00.tif' ;
%             '3P3-3_ch...tif' ;
%             '3Q1-3_ch00.tif']
%   new=                            ext=  
%        [ '3P2-2_ch00' ;              [ 'tif' ;
%          '3P3-3_ch..' ;                'tif' ;
%          '3Q1-3_ch00']                 'tif' ]
%
names=''; sn=0;
ext=''; se=0;
filenames=char(filenames);
[N M]=size(filenames);
x=filenames=='.';
[i,j]=xgetix(x,1);
new=[];
ext=[];
for n=1:N
    sf=size(char(filenames(n,:)));
    [a b]=max(j((find(i==n)),:));
    new=[new;cellstr(filenames(n,1:a-1))];
    ext=[ext;cellstr(filenames(n,a+1:sf(2)))];
end



