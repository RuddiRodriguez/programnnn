
clear

h=0

contournr=1;
while exist(sprintf('D:/entropia/media1/media%i.txt',contournr)) == 2
    
  contournr=contournr+1;    
    
end

contournr=contournr-1;

variable = cell(contournr,1);
for h=1:contournr
    variable {h} =load(sprintf('D:/entropia/media1/media%i.txt',h));
end
area=zeros(contournr,49);
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
area(:,g)=trapz(entromodo)
areasaved=area(:,g);


save(sprintf('D:/entropia/media1/entrmodo%i.txt',g),'entromodo','-ascii');
save(sprintf('D:/entropia/media1/mediamodo%i.txt',g),'mediamodosaved','-ascii');
save(sprintf('D:/entropia/media1/stddmodo%i.txt',g),'stddsaved','-ascii');
save(sprintf('D:/entropia/media1/complexindex%i.txt',g),'areasaved','-ascii');











end

save('D:/entropia/media/mediamodos.txt','mediamodos','-ascii');
save('D:/entropia/media/stdd.txt','stdd','-ascii');

k=0
k=size (mediamodos);

for l=[2 3 4 5 14 34 45 48]
    figure (56)
    %plot(mediamodos(1:(k(1)-60),l),'o')
    errorbar(mediamodos(1:(k(1)-10),l),(stdd(1:(k(1)-10),l))./2,'o')
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