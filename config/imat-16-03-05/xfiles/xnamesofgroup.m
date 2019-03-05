function [ixp,names,curwhat]=xnamesofgroup(what,out,pictures,n,exclude)
[N,dd]=size(pictures);
what=[',' what ','];
ixc=find(what==',');
swhat=size(what);
swhat=swhat(2);
%ixc=[ixc swhat+1];
%ncomma=sum(what==',');
curwhat=what(1,ixc(n)+1:ixc(n+1)-1);
%curwhat=what(1,ixc(n)-1:ixc(n)-1);
pos=ixc(n)+1;
ixp=[];
items=xchardelimiter(curwhat,'~');
sitems=size(items);
sitems=sitems(2);
cand=1:N;
cand=find(~ismember(cand,exclude));
for m=1:N
    ok=[];
    if ismember(m,cand)
        for t=1:sitems
            curall=xcells2str_h(out(m,:));
            curallitems=xchardelimiter(curall,'~');
            if all(size(char(curallitems(t)))==size(char(items(t))))
                curall=xchardelimiter(xcells2str_h(out(m,:)),'~');
                if all(char(curallitems(t))==char(items(t)))
                    ok=[ok 1];
                else
                    ok=[ok 0];
                end
            else
                ok=[ok 0];
            end
        end
    else
        ok=[ok 0];    
    end
    if all(ok)
        ixp=[ixp m];
    end
end
names=pictures(ixp,:);





