

  index=zeros(41,1)
  q=0
for j=8:48
a = load(sprintf('D:/membrane_tracking_project/medidas/test%i/results/contourclosedindex.txt',j)); % load the membrane position in polar coordinates
q=q+1;
index(q)=a

end
save(sprintf('D:/membrane_tracking_project/medidas/contourclosedindex.txt'),'index','-ascii')