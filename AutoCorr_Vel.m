function AutoCorr_Vel_Par = AutoCorr_Vel(x,t,fraction)
% Function to calculate velocity autocorrelation function.
% x could be a matrice, t is time and fraction is the amount 
% of the portion of datapoints from beginning which program 
% should fit exponential fit to it. 

m = size(x,1); % number of data sets, or movies, etc.
n = size(x,2); % the steps, frames, ... of each data set.
dx = diff(x,1,2);
dt = diff(t,1,2);
v = dx./(dt);
nv = size(v,2);
AutoCorr = zeros(m,nv);
h = waitbar2(0.02,'Processing...');
for i = 0:(nv-1)
    g_temp = zeros(m,nv-i);
    for  j = 1:(nv - i)
        g_temp(:,j) = v(:,j+i).*v(:,j);
    end
    AutoCorr(:,i+1) = mean(g_temp,2);
    if ~ishandle(waitbar2(i/(nv-i)))
        break
    end
end
% AutoCorr_Vel_Par.fun_S = AutoCorr(:,1:fix(nv*fraction));
% AutoCorr_Vel_Par.t_S = t(:,1:fix(nv*fraction))-t(1,1);
% AutoCorr_Vel_Par.fun = mean(AutoCorr(:,1:fix(nv*fraction)),1);
% AutoCorr_Vel_Par.err = std(AutoCorr(:,1:fix(nv*fraction)));
% if m == 1
%     AutoCorr_Vel_Par.err = AutoCorr_Vel_Par.fun;
% end
% AutoCorr_Vel_Par.t = t(1,1:fix(nv*fraction))-t(1,1);
if ishandle(h)
    close(h);
end
AutoCorr_Vel_Par=smooth(AutoCorr,3,'moving');
figure(34)
plot(t(1:fraction),AutoCorr_Vel_Par(1:fraction),'-o');