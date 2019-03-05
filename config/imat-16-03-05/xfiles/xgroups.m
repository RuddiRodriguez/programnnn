function [groups,tgroups,NUMBERARRAY,STRINGARRAY,errortxt]=xgroups(syntax,sortid,pictures)
letters=[         'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'; 'l'; 'm'; 'n'; 'o'; 'p'; 'q'; 'r'; 's'; 't'; 'u'; 'v'; 'w'; 'x'; 'y'; 'z'];
letters=[letters; 'A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G'; 'H'; 'I'; 'J'; 'K'; 'L'; 'M'; 'N'; 'O'; 'P'; 'Q'; 'R'; 'S'; 'T'; 'U'; 'V'; 'W'; 'X'; 'Y'; 'Z'];
letters=[letters ; '-'; '+'; '='; '_'; '.'];
integers=['0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9';];

pictures=cellstr(pictures);
syntax=char(syntax);
sortid=char(sortid);
sortid=str2num(sortid);
[N M]=size(pictures);
res=0;


newpictures=[];
numberarray=[];
stringarray=[];
NUMBERARRAY=[];
STRINGARRAY=[];
groups=[];
tgroups=[];
size_syntax=size(syntax);

maxs=max(sortid);
if maxs>prod(size(syntax))    
    errortxt='Indicies must be seperated by commas and smaller than the length of the syntax.';    
else
    errortxt='';
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
    
    sorttype=syntax(sortid);
    sizesortid=size(sortid);
    groups=[];
    for ssi=1:sizesortid(2)
        if sorttype(ssi)=='s'
            groups=[groups STRINGARRAY(:,sortid(ssi))];
        end
        if sorttype(ssi)=='n'
            groups=[groups NUMBERARRAY(:,sortid(ssi))];
        end
    end
    
    tgroups=[];
    sortidd=[sortid sortid(sizesortid(2))];
    for row=1:N
        colgroups=[];
        for col=1:sizesortid(2)
            colgroups=[colgroups char(groups(row,col)) repmat('~',1,sortidd(col+1)-sortidd(col)-1)];
        end
        tgroups=[tgroups; cellstr(colgroups)];
    end
end
