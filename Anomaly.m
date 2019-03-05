function Anomaly_Par = Anomaly(y,x,fraction,weight)
% Function to calculate the amount of anomaly of diffusion.
% It gets x values (vector) and y values (vector) as an inputs
% plot their logs and fit a linea line to it, the amount of slope
% is the anomaly. 
% It use the fraction and weight as fitting parameters.

log_x = log(x);
log_y = log(y);
ind = fix(length(y).*fraction);
if ind < 2 , ind = 2; end;
Polynomial = fit(log_x(1:ind)', log_y(1:ind)','poly1','Weight',1./weight(1:ind)');
Anomaly_Par.Value = Polynomial.p1;
Anomaly_Par.Intercept = Polynomial.p2;
Anomaly_Par.x = log_x;
Anomaly_Par.y = log_y;
range = confint(Polynomial);
a_range = [range(1,1) range(2,1)];
da = (max(a_range) - min(a_range))/2;
Anomaly_Par.da = da;
Anomaly_Par.a_range = a_range;
Anomaly_Par.yFit = Polynomial.p1.*log_x + Polynomial.p2;
% According to amount of anomaly it decides that the how kind of the 
% motion; normal, sub, super or ballestic diffusion.
if (Anomaly_Par.Value > 1 - da) && (Anomaly_Par.Value < 1 + da)
    Anomaly_Par.String = 'Normal Diffusion';
elseif (Anomaly_Par.Value > 0) && (Anomaly_Par.Value <= 1 - da)
    Anomaly_Par.String = 'Sub-Diffusion';
elseif (Anomaly_Par.Value > 1 + da) && (Anomaly_Par.Value <= 2 - da)
    Anomaly_Par.String = 'Super-Diffusion';
elseif (Anomaly_Par.Value > 2 - da) && (Anomaly_Par.Value <= 2 + da)
    Anomaly_Par.String = 'Ballestic-Diffusion';
end


