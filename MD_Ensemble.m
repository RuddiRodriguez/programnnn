function [MD_Ensemble_Par] = MD_Ensemble(x,xlabel)
% Function to calculate mean values of displacements and 
% square displacemets, <dx> and <dx2>, and their errors using Ensemble Average Method.

m = size(x,1); % number of data sets, or movies, etc.
n = size(x,2); % the steps, frames, ... of each data set.
MD_Ensemble_Par.Complete = 0;
h = waitbar2(0.2,['Calculating...   for ',xlabel]);
dx = x(:,2:end) - meshgrid(x(:,1),1:n-1)';
dx2 = dx.^2;
MD_Ensemble_Par.dx = (dx);
MD_Ensemble_Par.dx2 = (dx2);
MD_Ensemble_Par.dx_err = std(dx)./sqrt(m);
MD_Ensemble_Par.dx2_err = std(dx2)./sqrt(m);
if size(x,1) == 1
    MD_Ensemble_Par.dx_err = MD_Ensemble_Par.dx;
    MD_Ensemble_Par.dx2_err = MD_Ensemble_Par.dx2;
end
waitbar2(1);
pause(.5)
close(h);
MD_Ensemble_Par.Complete = 1;
