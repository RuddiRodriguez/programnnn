function b=friccion(K,pendiente,porcientocolesterol)
b=K./(2*pendiente)
i
save(sprintf('D:/membrane_tracking_project/coeficientefriccion%i.txt',porcientocolesterol),'b','-ascii');
% fid=fopen('D:/membrane_tracking_project/coeficientefriccion%porcientocolesterol.txt','a+');
% fprintf(fid,'%6.3e\n',b);
% fclose(fid)