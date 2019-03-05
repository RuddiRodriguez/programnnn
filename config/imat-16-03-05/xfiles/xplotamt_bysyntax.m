function [eqn]=xplotamt_bysyntax(AMT,pictures,syntax,sortafter,what,difforder,colors,handles,parent)
% AMT      = matrix
% pictures = picture names
% syntax     = string
% sortafter  = string
% what       = string
% 
% EXAMPLE:
% plot all A and Ref grouped such that
% one group is all A with -2
% and all Ref is with -3
%
%     pictures is=
%                  '12Ref1-3_ch00.tif'
%                  '12Ref2-2_ch00.tif'
%                  '12Ref3-3_ch00.tif'
%                  '2A1-2_ch00.tif'
%                  '2A2-2_ch00.tif'
%                  '2A3-1_ch00.tif'
%                  '2C1-3_ch00.tif'
%                  '2C2-3_ch00.tif'
% whith syntax     'nsnsnsns'
%                    |  |   
% sortafter         12345678    -->  '25'

%  plotamt_bysyntax(AMT,pictures,'nsnsnsns','25','A2,Ref3')


if nargin==5
    difforder=0
end

letters=['a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'; 'l'; 'm'; 'n'; 'o'; 'p'; 'q'; 'r'; 's'; 't'; 'u'; 'w'; 'x'; 'y'; 'z'];
letters=[letters; 'A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G'; 'H'; 'I'; 'J'; 'K'; 'L'; 'M'; 'N'; 'O'; 'P'; 'Q'; 'R'; 'S'; 'R'; 'U'; 'W'; 'X'; 'Y'; 'Z'];
letters=[letters; '-'; '+'; '='; '_'; '.'];
integers=['0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9';];
[N M]=size(pictures);
colors=           [0 0 1; 0 1 0 ; 1 0 0; 0.985 0.737 0.370; 0.5 1 1; 0.5 0.5 0;1 0.5 1 ; 0.75 0.75 0.75; 1 1 0.5  ; 0 0.5 0      ;0.886 0.741 0.471; 0.62 0.416 0.137];
colorname=strvcat('blue','green','red' ,'orange'          , 'cyan' , 'bush'   ,'pink'  , 'gray'        , 'yellow' ,'dark green'  ,'shit'           ,   'brown');
newpictures=[];
numberarray=[];
stringarray=[];
NUMBERARRAY=[];
STRINGARRAY=[];
size_syntax=size(syntax);

for row=1:N
    newpictures=[]; 
    numberarray=[];
    stringarray=[];
    pos1=1;
    curpic=char(pictures(row));
    [n m]=size(curpic);    
    for k=1:size_syntax(2)
        if syntax(k)=='n'
            numbersix=ismember(curpic(1,pos1:m),integers);
            firstoccur=find(numbersix==0);
            if isempty(firstoccur)
                firstoccur=m+2-pos1;    
            end
            firstoccur=firstoccur(1);
            numbers=curpic(1,pos1:(pos1-1)+firstoccur-1);
            numberarray=[numberarray cellstr(numbers)];
        else
            numberarray=[numberarray cellstr([''])];
        end
        if syntax(k)=='s'
            stringix=ismember(curpic(1,pos1:m),letters);
            firstoccur=find(stringix==0);
            if isempty(firstoccur)
                firstoccur=m+2-pos1;    
            end
            firstoccur=firstoccur(1);
            string=curpic(1,pos1:(pos1-1)+firstoccur-1);
            stringarray=[stringarray cellstr(string)];
        else
            stringarray=[stringarray cellstr([''])];
        end        
        pos1=(pos1-1)+firstoccur;
    end
    NUMBERARRAY=[NUMBERARRAY;numberarray];
    STRINGARRAY=[STRINGARRAY;stringarray];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%3I3-1_ch00.tif   
%3J1-1_ch00.tif   
% 3J2-2_ch00.tif   
% 3J3-1_ch00.tif   
% 3K1-3_ch00.tif   
% 3K2-2_ch00.tif   
% 'nsnsnsns' syntax
% '12'       sortafter

pfig=figure;
clf
hold on
n=1;
pictures=char(pictures);
size_sortafter=size(sortafter);
size_sortafter=size_sortafter(2);



out=[];
for ii=1:size_sortafter
    if syntax(1,str2num(sortafter(ii)))=='s'
        outsn=STRINGARRAY(:,str2num(sortafter(ii)));
    end
    if syntax(1,str2num(sortafter(ii)))=='n'
        str2num(sortafter(ii))
        outsn=NUMBERARRAY(:,str2num(sortafter(ii)));
    end
    out=[out outsn];
end

ixc=find(what==',');
swhat=size(what);
swhat=swhat(2);
ixc=[ixc swhat+1];
ncomma=sum(what==',');
pos=1;

yt=max(max(AMT));
miny=min(min(AMT));
dyt=(yt-miny)/14;
yt=yt-dyt;
[dd maxx]=size(AMT);
donepictures=[];
for n=1:ncomma+1
    curwhat=what(1,pos:ixc(n)-1);
    pos=ixc(n)+1;
    ixp=[];
    for m=1:N
        curall=xcells2str_h(out(m,:));
        if all(size(curall)==size(curwhat))
            if all(curall==curwhat)
                ixp=[ixp m];            
            end
        end
    end      
    if difforder==0
        curve=AMT(ixp,:)';
    else
        curve=diff(AMT(ixp,:)',difforder);        
    end
    plot(curve,'Color',colors(n,:));
    text(maxx,yt,['## ' curwhat],'Color',colors(n,:));
    yt=yt-dyt;
%    disp(pictures(ixp,:));
    part1=cellstr('===========================');
    part2=cellstr(['Members of group ' curwhat]);
    part3=cellstr('--------------------------------------------');
    part4=cellstr(pictures(ixp,:));
    donepictures=[donepictures; part1;part2;part3;part4];
    set(0,'CurrentFigure',parent);
    set(handles.namesoutlist,'String',char(donepictures));
    set(0,'CurrentFigure',pfig);
    pause
end

