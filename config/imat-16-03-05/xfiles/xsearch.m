function xsearch(files,searchfor,path)
%-----------------------------------------------------------------
% function xsearch(files,searchfor,path)
%-----------------------------------------------------------------
% Serach after content in the files in a folder
%-----------------------------------------------------------------
% Input:
%   files:      filenames or part of filename group, ex. *.m
%   searchfor:  string to look for.
%   path:       path to search in.
% Output:
%   No outout
% Example:  xsearch('*.m','percent')
%
comment=1;
if nargin==2
    path=pwd;
end
if ~isunix
    if path(end)~='\';
        path=[path '\'];
    end
else
    if path(end)~='/';
        path=[path '/'];
    end    
end

files2=dir([path files]);
[sf a]=size(files2);
collect=[];
for i=1:sf
    filecontent=char(textread([ path files2(i).name],'%s','delimiter','\n','whitespace',''));
    if comment==0
        notcom=~(filecontent(:,1)=='%');
        filecontent=filecontent(notcom,:);
    end
    [f1 f2]=size(filecontent);
    filecontent=reshape(filecontent',1,f1*f2);
    found=findstr(searchfor,filecontent);
    if ~isempty(found)
        disp(files2(i).name);
        collect=strvcat(collect,files2(i).name);
    end
end
sc=size(collect);
sc=sc(1);
if ~isempty(collect)
    yes=input('Open them (y/n)  ','s');
    if sum(yes==['y' 'Y'])
        for i=1:sc            
            collecti=char(collect(i,:));
            notsp=~isspace(collecti);
            collecti=collecti(find(notsp));
            open(collecti);
        end
    end
end

