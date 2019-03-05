function [ center ] = length_center( xymempos )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
L = 0; % length of circumference
xymemposlength = length(xymempos); % length of the vector xymempos
ds = zeros(xymemposlength,1); % vector containing the distances between neighbooring membrane positions
sumds = zeros(xymemposlength,1); % vector containing sum between ds(i) and ds(i+1)

% calculate length of circumference
for i = 1:xymemposlength-1
   ds(i+1) = sqrt((xymempos(i+1,1)-xymempos(i,1))^2+(xymempos(i+1,2)-xymempos(i,2))^2);
   L = L+ds(i);
   if i==xymemposlength-1
       ds(1) = sqrt((xymempos(1,1)-xymempos(i+1,1))^2+(xymempos(i,2)-xymempos(i+1,2))^2); 
       % to get the last part between the end and starting point of tracked contour
       L = L+ds(1);
   end
end

for i = 1:xymemposlength-1
    sumds(i) = ds(i)+ds(i+1);
    if i==xymemposlength-1
        sumds(i+1) = ds(i+1)+ds(1);
    end
end

for i = 1:xymemposlength-1
    sumds(i) = ds(i)+ds(i+1);
    if i==xymemposlength-1
        sumds(i+1) = ds(i+1)+ds(1);
    end
end



    center(1) = (1/(2*L))*xymempos(:,1)'*sumds;
    center(2) = (1/(2*L))*xymempos(:,2)'*sumds;
    newcenter(1) = (1/(2*L))*xymempos(:,1)'*sumds;
    newcenter(2) = (1/(2*L))*xymempos(:,2)'*sumds;
    
   




% show center in displayimage


end

