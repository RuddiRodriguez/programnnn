function Diffusion_Par = Diffusion_Ensemble(t,D_Par,fraction,temp,DataSetIndex)
% Function to calculate diffusion coefficient form data of mean values of 
% displacements and square displacements.
% This function first calculates mean square displacement (MSD) then 
% fit a linear line to it.
% It uses fraction to fit data to some portion of data from beginning 
% corresponds to fraction value.

m = size(D_Par.dx,1);
MSDper2     = (mean(D_Par.dx2,1) - mean(D_Par.dx,1).^2)./2;
MD_Pardx    = mean(D_Par.dx,1);
ind = fix(size(MSDper2,2).*fraction);
if ind < 2 , ind = 2; end;
h = waitbar2(0.2,'Processing...');
D_Fit_Par = fit(t(1,1:ind)',MSDper2(1:ind)','poly1');
if ~ishandle(waitbar2(0.6))
    return
end
V_Fit_Par = fit(t(1,1:ind)',MD_Pardx(1:ind)','poly1');
if ~ishandle(waitbar2(1))
    return
end
Diffusion_Par.D           = D_Fit_Par.p1;
Diffusion_Par.D_Intercept = D_Fit_Par.p2;
Diffusion_Par.yFit        = D_Fit_Par.p1.*t(1,:)+D_Fit_Par.p2;
Diffusion_Par.Dt          = MSDper2;
Diffusion_Par.Dt_Err      = (D_Par.dx2_err + abs(2.*(mean(D_Par.dx))).*(D_Par.dx_err))./2;
Diffusion_Par.V           = V_Fit_Par.p1;
Diffusion_Par.V_Intercept = V_Fit_Par.p2;
Diffusion_Par.Vt          = D_Par.dx;
Diffusion_Par.Vt_Err      = D_Par.dx_err;
Diffusion_Par.fraction    = fraction;
Diffusion_Par.weight      = nan;
if size(D_Par.dx,1) == 1
    Diffusion_Par.Dt_Err = Diffusion_Par.Dt;
    Diffusion_Par.Vt_Err = Diffusion_Par.Vt;
end
if ishandle(h)
    close(h);
end
