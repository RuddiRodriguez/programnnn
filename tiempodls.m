
 function intervalo=tiempodls(var,camino)
fid=fopen(camino)
tiempo = (textscan(fid, '%s',3,'CollectOutput', 1,'headerlines',9));
tiempo=str2num(cell2mat(tiempo{1}(3)))
intervalo=tiempo./(length(var));
