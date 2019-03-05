function ximat2unscr(resy,pictures,RES,filename,AYX,strip)
%-----------------------------------------------------------------------
% function ximat2unscr(resy,pictures,RES,filename,AYX,strip)
%-----------------------------------------------------------------------
% Convert resy matrix and pictures to a txt-format compatible
% with a format required by unscrambler
%-----------------------------------------------------------------------
% Input:
%   resy:       Y-data (e.x. AMT matrix)
%   pictures:   filenames of picture names
%   RES:        columns in resy   
%   filename:   save conversion in filename
%   AYX:        text string, specifies the y-data, that are
%               to be exported. Ex.: '110' only exports MA and MDY.
%   strip:      if 1, then extension is removed.
% Output:
%   No output, result saved in filename
%-----------------------------------------------------------------------
% Example:
%   load('IMAT_<name provided by you>.mat');
%   ximat2unscr(imato.resy,imato.pictures,251,'test.txt','110',1)
%   where imato.resy and imato.pictures are the result of AMT analysis
%   with SMAX=250. It will export MA and MDY without extension.
%
if nargin~=6
    disp('Usage:  ximat2unscr(resy,pictures,RES,filename,AYX,strip)')
    break;
end
if strip==1
    [pictures ext]=xstripfilename(pictures);
end

cols=[];
fp=fopen(filename,'w');
if AYX(1,1)=='1'
    for i=1:RES
        if i<=RES
            fprintf(fp,'Ma%d,',i);      
        end
    end    
    cols=[cols 1:RES];
end
if AYX(1,2)=='1'
    for i=1:RES
        if i<RES
            fprintf(fp,'Mdy%d,',i);              
        elseif i==RES
            fprintf(fp,'Mdy%d',i);      
        end        
    end
    cols=[cols (1:RES)+RES];
end
if AYX(1,3)=='1'
    for i=1:RES
        if i<RES
            fprintf(fp,'Mdx%d,',i);      
        elseif i==RES
            fprintf(fp,'Mdx%d',i);      
        end
    end
    cols=[cols (1:RES)+2*RES];
end

fprintf(fp,'\n');

np=size(resy);
np=np(1);
for i=1:np    
    fprintf(fp,'%s,',char(pictures(i,:)));
    sc=size(cols);
    for j=cols(1:sc(2)-1)
        fprintf(fp,'%e,',resy(i,j));
    end
    fprintf(fp,'%e',resy(i,sc(2)));
    fprintf(fp,'\n');
end
fclose(fp);

