function [resy,resx]=imatm_boxcountingdimension(X,userpar)
cutofflowers=userpar.levels;
boxsizes=userpar.boxsizes;
sc=size(cutofflowers,2);
resx=1:sc;
[N,M]=size(X);
cs=[];
ccs=[];
for d=boxsizes
    c=0;
    cs=[];
    for cutofflower=cutofflowers
        for n=1:d:(N-d)
            subn=X(n:n+d-1,:);
            for m=1:d:(M-d)
                sub=subn(:,m:m+d-1);
                sub=sub>cutofflower;          
                if all(sub)
                    c=c+1;    
                end            
            end
        end
        cs=[cs; c];
    end
    ccs=[ccs cs];
end
% resxtemp = [ levels x boxsizes]
% resytemp = [ levels x boxsizes]  (rows x cols)
resxtemp=repmat((boxsizes/min([N,M])),sc,1);
resytemp=log(ccs)./log(1./resxtemp);
resy=reshape(resytemp',1,prod(size(resytemp)));
ix=abs(resy)==Inf;
resy(find(ix))=NaN;
resx=resxtemp;

