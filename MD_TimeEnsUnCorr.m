function [MD_TimeEns_UnCorr_Par] = MD_TimeEnsUnCorr(x,xlabel)
% Function to calculate mean values of displacements and 
% square displacemets, <dx> and <dx2>, and their errors using Uncorrelated Time-Ensemble Average Method. 
% This function use MD_TimeUnCorr function (function which calculate these values using 
% Uncorrelated Time Average Method).

m = size(x,1);
par = MD_TimeUnCorr(x,xlabel);
MD_TimeEns_UnCorr_Par.dx = mean(par.dx,1);
MD_TimeEns_UnCorr_Par.dx_err = std(par.dx)./sqrt(m);
MD_TimeEns_UnCorr_Par.dx2 = mean(par.dx2,1);
MD_TimeEns_UnCorr_Par.dx2_err = std(par.dx2)./sqrt(m);
if size(x,1) == 1
    MD_TimeEns_UnCorr_Par.dx_err = MD_TimeEns_UnCorr_Par.dx;
    MD_TimeEns_UnCorr_Par.dx2_err = MD_TimeEns_UnCorr_Par.dx2;
end
MD_TimeEns_UnCorr_Par.Complete = par.Complete;