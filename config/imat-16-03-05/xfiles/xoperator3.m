function [newMATRIX,newpictures,res]=xoperator3(MATRIX,pictures,syntax,sortid,operator,lie)
% MATRIX
% pictures
% syntax = of the filename  'nsn'
% sortsyntax = part of the filename syntax after which sorting must be done
%               in order to do the operator task
% sortsequence = 'ABCDEFGHIJKLMNOPQR'
%q=load('GIA_lins1.mat');
%AMT=q.giao.resy;
%pictures=q.giao.pictures;
% [a b c]=xoperator3(AMT,pictures,'nsnsns', '12', 'analf' ,0); MAKROyoghurt
%
% [a b c]=xoperator3(AMT,pictures,'nsnsns', '12', 'mikro' ,0); MIKROyoghurt
%
% [a b c]=xoperator3(AMT,pictures,'nsnsns', '12', 'mikra' ,0); MIKROyoghurt all

if ~isa(pictures,'cell')
    pictures=cellstr(pictures);
end

resize=char(strvcat(syntax,sortid));
synstax=resize(1,:);
sortid=resize(2,:);
res=0;



letters=[         'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'; 'l'; 'm'; 'n'; 'o'; 'p'; 'q'; 'r'; 's'; 't'; 'u'; 'v';'w'; 'x'; 'y'; 'z'];
letters=[letters; 'A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G'; 'H'; 'I'; 'J'; 'K'; 'L'; 'M'; 'N'; 'O'; 'P'; 'Q'; 'R'; 'S'; 'T'; 'U'; 'V';'W'; 'X'; 'Y'; 'Z'];
letters=[letters ; '-'; '+'; '='; '_'; '.'];
integers=['0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9';];
[N M]=size(pictures);


if lie==1 
    % remove extension !! They must have the same!!
    for i=1:N
        picturesi=char(pictures(i,:));
        posend=max(find(char(picturesi)=='.'));
        pictures(i)=cellstr(picturesi(1,1:posend-1));        
    end
end

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

NUMBERARRAY;
STRINGARRAY;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
size_sortid=size(sortid);
truncfilenames=[];
uniquepart=[];
inversesortid=1;
for k=1:size_sortid(2)
    truncfilenames_number=[];
    truncfilenames_string=[];
    uniqueparti=[];
    id=str2num(sortid(1,k));
    if syntax(1,id)=='n'
        truncfilenames_number=NUMBERARRAY(:,id);
    end
    if syntax(1,id)=='s'
        truncfilenames_string=STRINGARRAY(:,id);
    end
    truncfilenames=[truncfilenames truncfilenames_number truncfilenames_string];    
    if isempty(str2num(sortid(k))) || inversesortid~=str2num(sortid(k))
        uniqueparti=[uniqueparti NUMBERARRAY(:,inversesortid) STRINGARRAY(:,inversesortid)];
        uniquepart=[uniquepart uniqueparti];
    end
    inversesortid=inversesortid+1;
end

newtruncfilenames=[];
st=size(truncfilenames);
for k=1:st(1)
    newj=[];
    for j=1:st(2)
        newj=[newj char(truncfilenames(k,j))];
    end
    newtruncfilenames=[newtruncfilenames; cellstr(newj)];
end


if all(operator=='sorte')
    [sortf ix]=sort(newtruncfilenames);
    newpictures=pictures(ix(:,1),:);
    newMATRIX=MATRIX(ix(:,1),:);
else
    newpictures=pictures;
    newMATRIX=MATRIX;
end



if all(operator=='analf')
    % MAKRO
    ix=[cellstr('1A');cellstr('2A');cellstr('3A');cellstr('1B');cellstr('2B');cellstr('3B');cellstr('1C');cellstr('2C');cellstr('3C');cellstr('1D');cellstr('2D');cellstr('3D');cellstr('1E');cellstr('2E');cellstr('3E')];
    ix=[ix;cellstr('1F');cellstr('2F');cellstr('3F');cellstr('1G');cellstr('2G');cellstr('3G');cellstr('1H');cellstr('2H');cellstr('3H');cellstr('1I');cellstr('2I');cellstr('3I');cellstr('1J');cellstr('2J');cellstr('3J')];
    ix=[ix;cellstr('1K');cellstr('2K');cellstr('3K');cellstr('1L');cellstr('2L');cellstr('3L');cellstr('1M');cellstr('2M');cellstr('3M');cellstr('1N');cellstr('2N');cellstr('3N');cellstr('1O');cellstr('2O');cellstr('3O')];
    ix=[ix;cellstr('1P');cellstr('2P');cellstr('3P');cellstr('1Q');cellstr('2Q');cellstr('3Q');cellstr('1R');cellstr('2R');cellstr('3R')];    
    ix=[ix;cellstr('1REF'); cellstr('5REF'); cellstr('9REF'); cellstr('2REF'); cellstr('6REF'); cellstr('10REF'); cellstr('3REF'); cellstr('7REF'); cellstr('11REF'); cellstr('4REF'); cellstr('8REF'); cellstr('12REF')];
    ix=[ix;cellstr('1S');cellstr('2S');cellstr('3S');cellstr('1T');cellstr('2T');cellstr('3T');cellstr('1U');cellstr('2U');cellstr('3U')];
    ix=[ix;cellstr('1V');cellstr('2V');cellstr('3V');cellstr('1X');cellstr('2X');cellstr('3X')];
    ix=[ix;cellstr('1Y');cellstr('2Y');cellstr('3Y')];
    sizeex=size(ix);
    ixstr=strcat(truncfilenames(:,1),truncfilenames(:,2));
    [aa,bb]=ismember(ixstr,ix);
%    bb=unique(bb);
    grppic=xgroup_isos(pictures,9);
    grpMATRIX=xgroup_isos(MATRIX,9);
%    nnnp=grppic(1,bb);
%    nnnm=grpMATRIX(1,bb);
newpictures=[]; 
newMATRIX=[];
for s=1:sizeex(1)
        [aa bb]=ismember(ixstr,ix{s});
        newpictures=[newpictures;pictures(find(aa),:)];
        newMATRIX=[newMATRIX;MATRIX(find(aa),:)];
    end
end

if all(operator=='mikro')
    % MIKRO
    ix=[cellstr('2A');cellstr('3A');cellstr('3B');cellstr('2C');cellstr('3C');cellstr('3D');cellstr('3E')];
    ix=[ix;cellstr('2F');cellstr('3F');cellstr('2G');cellstr('3G');cellstr('3H');cellstr('2I');cellstr('3I');cellstr('3J')];
    ix=[ix;cellstr('2K');cellstr('3K');cellstr('2L');cellstr('3L');cellstr('2M');cellstr('3M');cellstr('3N');cellstr('2O');cellstr('3O')];
    ix=[ix;cellstr('2P');cellstr('3P');cellstr('3Q');cellstr('3R')];    
    ix=[ix;cellstr('9Ref');cellstr('6Ref');cellstr('10Ref');cellstr('11Ref');cellstr('8Ref');cellstr('12Ref')];
    ix=[ix;cellstr('3S');cellstr('3T');cellstr('2U');cellstr('3U')];
    ix=[ix;cellstr('3V');cellstr('2X');cellstr('3X')];
    ix=[ix;cellstr('3Y')];
    sizeex=size(ix);
    ixstr=strcat(truncfilenames(:,1),truncfilenames(:,2));
    [aa,bb]=ismember(ixstr,ix);
    %    bb=unique(bb);
    grppic=xgroup_isos(pictures,3);
    grpMATRIX=xgroup_isos(MATRIX,3);
    %    nnnp=grppic(1,bb);
    %    nnnm=grpMATRIX(1,bb);
    newpictures=[]; 
    newMATRIX=[];
    for s=1:sizeex(1)
        [aa bb]=ismember(ixstr,ix{s});
        newpictures=[newpictures;pictures(find(aa),:)];
        newMATRIX=[newMATRIX;MATRIX(find(aa),:)];
    end
end

if all(operator=='mikra')
    % MIKRO  all
    
    ix=[cellstr('1A');cellstr('2A');cellstr('3A');cellstr('1B'); cellstr('2B');cellstr('3B');cellstr('1C');cellstr('2C');cellstr('3C');cellstr('1D');cellstr('2D');cellstr('3D');cellstr('1E');cellstr('2E');cellstr('3E')];
    ix=[ix;cellstr('1F');cellstr('2F');cellstr('3F');cellstr('1G');cellstr('2G');cellstr('3G');cellstr('1H');cellstr('2H');cellstr('3H');cellstr('1I');cellstr('2I');cellstr('3I');cellstr('1J');cellstr('2J');cellstr('3J')];
    ix=[ix;cellstr('1K');cellstr('2K');cellstr('3K');cellstr('1L');cellstr('2L');cellstr('3L');cellstr('1M');cellstr('2M');cellstr('3M');cellstr('1N');cellstr('2N');cellstr('3N');cellstr('1O');cellstr('2O');cellstr('3O')];
    ix=[ix;cellstr('1P');cellstr('2P');cellstr('3P');cellstr('1Q');cellstr('2Q');cellstr('3Q');cellstr('1R');cellstr('2R');cellstr('3R')];    
    ix=[ix;cellstr('1Ref');cellstr('5Ref')];
    ix=[ix;cellstr('9Ref');cellstr('2Ref');cellstr('6Ref');cellstr('10Ref');cellstr('3Ref');cellstr('7Ref');cellstr('11Ref');cellstr('4Ref');cellstr('8Ref');cellstr('12Ref')];
    ix=[ix;cellstr('1S');cellstr('2S');cellstr('3S');cellstr('1T');cellstr('2T');cellstr('3T');cellstr('1U');cellstr('2U');cellstr('3U')];
    ix=[ix;cellstr('1V');cellstr('2V');cellstr('3V');cellstr('1X');cellstr('2X');cellstr('3X')];
    ix=[ix;cellstr('1Y');cellstr('2Y');cellstr('3Y')];
    sizeex=size(ix);
    ixstr=strcat(truncfilenames(:,1),truncfilenames(:,2));
    [aa,bb]=ismember(ixstr,ix);
    %    bb=unique(bb);
    grppic=xgroup_isos(pictures,3);
    grpMATRIX=xgroup_isos(MATRIX,3);
    %    nnnp=grppic(1,bb);
    %    nnnm=grpMATRIX(1,bb);
    newpictures=[]; 
    newMATRIX=[];
    for s=1:sizeex(1)
        [aa bb]=ismember(ixstr,ix{s});
        newpictures=[newpictures;pictures(find(aa),:)];
        newMATRIX=[newMATRIX;MATRIX(find(aa),:)];
    end
end



if all(operator=='nulet')
    s1=size(newpictures);
    uniquenames=char(unique(cellstr(newtruncfilenames)));
    s2=size(uniquenames);
    grp=s1(1)/s2(1);
    nulet=[];
    for k=1:s2(1)
        onevector=[];
        for j=1:s1(1)
            scalar=all(newtruncfilenames(j,:)==uniquenames(k,:));
            onevector=[onevector scalar];
        end        
        nulet=[nulet; onevector];
    end
    res=nulet';      
end


if all(operator=='picat')
    uniqued=unique(newtruncfilenames)
    st=size(uniqued);
    s1=size(newtruncfilenames);
    for ii=1:st(1)
        ix=[];
        newgrpname=num2str(dec2hex(ii,3));                
        onevector=[];
        for j=1:s1(1)
            if all(size(char(newtruncfilenames(j)))==size(char(uniqued(ii))))
                scalar=all(char(newtruncfilenames(j))==char(uniqued(ii)));
                ix=[ix; scalar];                       
            else
                ix=[ix; 0];                       
            end
        end       
        newpictures(find(ix))=cellstr(xcells2str_h(newgrpname,uniquepart(find(ix),:)));        
    end        
end


