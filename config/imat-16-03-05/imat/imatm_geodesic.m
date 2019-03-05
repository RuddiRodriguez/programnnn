function [euclids]=imatm_geodesic(y,userpar)
loweronhill=userpar(1);
upperonhill=userpar(2);
[aa,bb,ic,jc]=imatm_geometer(y,userpar);        
si=size(ic,2);
euclids=[];
for i=1:si
    euclid=0;
    for j=1:si
        euclid=[euclid sqrt((ic(i)-ic(j))^2 + (jc(i)-jc(j))^2)]; %*(y(round(ic(i)),round(jc(i)))+ y(round(ic(j)),round(jc(j))));
    end
    euclids=[euclids euclid];
end

