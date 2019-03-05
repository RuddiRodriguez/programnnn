function [MD_Time_UnCorr_Par] = MD_TimeUnCorr(x,xlabel)
% Function to calculate mean values of displacements and 
% square displacemets, <dx> and <dx2>, and their errors using Uncorellated Time Average Method. 
m = size(x,1); % number of data sets, or movies, etc.
n = size(x,2); % the steps, frames, ... of each data set.
MD_Time_UnCorr_Par.Complete = 0;
MD_Time_UnCorr_Par.dx(m,n-1) = 0;
MD_Time_UnCorr_Par.dx2(m,n-1) = 0;
MD_Time_UnCorr_Par.dx_err(m,n-1) = 0;
MD_Time_UnCorr_Par.dx2_err(m,n-1) = 0;
h = waitbar2(0.005,['Calculating... for ',xlabel]);
cnt = 1;
for step = 1:n-1
    clear dx_temp
    i = 0:fix(n/step);
    i = i(i*step+1<= n)*step+1;
    xx = x(:,i);
    dx_temp = xx(:,2:end) - xx(:,1:end-1);
    MD_Time_UnCorr_Par.dx(:,step) = mean(dx_temp,2);
    MD_Time_UnCorr_Par.dx_err(:,step) = std(dx_temp,0,2)./sqrt(size(dx_temp,2));
    dx_temp2 = dx_temp.^2;
    MD_Time_UnCorr_Par.dx2(:,step) = mean(dx_temp2,2);
    MD_Time_UnCorr_Par.dx2_err(:,step) = std(dx_temp2,0,2)./sqrt(size(dx_temp,2));
    if step >= cnt*((n-1)/100)
        if ~ishandle(waitbar2(step/(n-1)))
            break
        end
        cnt = cnt + 1;
    end
end
if ishandle(h)
    waitbar2(1);
    close(h);
    MD_Time_UnCorr_Par.Complete = 1;
end