
clear

h=0

contournr=1;
while exist(sprintf('D:/entropia/mediag1/media%i.txt',contournr)) == 2
    
  contournr=contournr+1;    
    
end

contournr=contournr-1;

variable = cell(contournr,1);
for h=1:contournr
    variable {h} =load(sprintf('D:/entropia/mediag1/media%i.txt',h));
end
areag=zeros(contournr,49)
mediamodos=zeros(100,49);
stdd=zeros(100,49);
i=0
for g=1:49
    
for j=1:contournr
    variable_temp=variable{j};
    k=size(variable_temp);
    
    t=0;
    
        for t=1:k(1)
        
    entromodo(t,j)=variable_temp(t,g);
        end
    
    
end

mediamodos(:,g)=mean(entromodo,2);
mediamodosaved=mediamodos(:,g);
stdd(:,g)=(std(entromodo,0,2)./2);
stddsaved=stdd(:,g);
areag(:,g)=trapz(entromodo)
areasavedg=areag(:,g);

save(sprintf('D:/entropia/mediag1/entrmodo%i.txt',g),'entromodo','-ascii');
save(sprintf('D:/entropia/mediag1/mediamodo%i.txt',g),'mediamodosaved','-ascii');
save(sprintf('D:/entropia/mediag1/stddmodo%i.txt',g),'stddsaved','-ascii');
save(sprintf('D:/entropia/mediag1/complexindex%i.txt',g),'areasavedg','-ascii');










end

save('D:/entropia/mediag1/mediamodos.txt','mediamodos','-ascii');
save('D:/entropia/mediag1/stdd.txt','stdd','-ascii');

k=0
k=size (mediamodos);

for l=[3 4 5 17 23 34 45]
    figure (24)
    %plot(mediamodos(1:(k(1)-60),l),'o')
    errorbar(mediamodos(1:(k(1)-10),l),(stdd(1:(k(1)-10),l))./4,'o')
    hold on;
end

% 
% contournr=1;
% while exist(sprintf('D:/entropia/media/media%i.txt',contournr)) == 2
%     
%     data = load(sprintf('D:/entropia/media/media%i.txt',contournr));
%     k=size(data);
%     
%     for j=1:k(2)
%     variable(:,contournr)=data(1:k(1),j)
%     end
%     contournr=contournr+1;
%     
% end