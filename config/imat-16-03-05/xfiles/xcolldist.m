function [coll]=xcolldist(ids,radii,coll)
test=0;
err=0;
radiin=radii;
dd=[];
colloy=[];
collox=[];
names=[];
for id=ids
    if id<10
        qq='00';
    end
    if id<100 && id>9
        qq='0';    
    end
    if id==100
        qq='';
    end    
    
    sr=size(radiin,2);
    rt=[];
    for ss=1:sr
        rt=[rt num2str(radiin(ss)) '_'];
    end
    name=['fs_'  rt qq num2str(id)];   
    load([name '.mat'],'info');
    if size(info.dist(:,1)',2)==3
        ww=0;
    else
        ww=[];
    end
    
    colloy=[colloy; info.dist(:,1)' ww];
    collox=[collox; info.dist(:,2)' ww];    
    names=[names; cellstr(name)];
end
coll.disty=[coll.disty; colloy ];
coll.distx=[coll.distx; collox ]
coll.pics=[coll.pics;names];
