function [resy,resx]=imatm_boxcountingdimension3d(X,userpar)
resx=userpar.box;
dacc=userpar.dacc;
%cutoffupper(3);
[N,M]=size(X);
counts=[];
ccs=[];
sresx=size(resx);
sresx=prod(sresx);
for d=1:sresx
    de=resx(d);
    de1=de-1;
    colors=zeros(1,256);
    for n=1:de:N-de1
        subn=X(n:n+de1,:);
        for m=1:de:M-de1
            sub=subn(:,m:m+de1);
            color=ceil(mean(mean(sub))+0.5);
            ok=all(all(abs(sub-color)<dacc));
            if ok
                colors(color)=colors(color)+1;
            end
        end
    end
    counts=[counts; colors];
end
[a,b]=size(counts);
resy=reshape(counts,1,a*b);


