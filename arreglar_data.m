
contournr=1
while exist(sprintf('D:/DFA/coefpowerrbc%i.txt',contournr)) == 2
   
   ydata= load(sprintf('D:/DFA/coefpowerrbc%i.txt',contournr));
   ydata=ydata';
    save(sprintf('D:/DFA/coefpowerrbc%i.txt',contournr),'ydata','-ascii');
   
    contournr=contournr+1
end