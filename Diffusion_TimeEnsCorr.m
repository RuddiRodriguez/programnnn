function Diffusion_Par = Diffusion_TimeEnsCorr(t,MD_Par,fraction,weight,DataSetIndex)
% Function to calculate diffusion coefficient form data of mean values of 
% displacements and square displacements.
% This function first calculates mean square displacement (MSD) then 
% fit a linear line to it.
% It uses fraction to fit data to some portion of data from beginning 
% corresponds to fraction value.

MSDper2 = (MD_Par.dx2 - (MD_Par.dx).^2)./2;
MSDper2_err = (MD_Par.dx2_err + abs(2.*(MD_Par.dx)).*(MD_Par.dx_err))./2;
ind = fix(size(MSDper2,2).*fraction);
if ind < 2 , ind = 2; end;
h = waitbar2(0.2,'Processing...');
if weight
    D_Fit_Par = fit(t(1,1:ind)', MSDper2(1:ind)','poly1',...
        'Weight',1./MSDper2_err(1:ind)');
    if ~ishandle(waitbar2(0.6))
        return
    end
    V_Fit_Par = fit(t(1,1:ind)', MD_Par.dx(1:ind)','poly1',...
        'Weight',1./MD_Par.dx_err(1:ind)');
    if ~ishandle(waitbar2(1))
        return
    end
else
    D_Fit_Par = fit(t(1,1:ind)', MSDper2(1:ind)','poly1');
    if ~ishandle(waitbar2(0.6))
        return
    end
    V_Fit_Par = fit(t(1,1:ind)', MD_Par.dx(1:ind)','poly1');
    if ~ishandle(waitbar2(1))
        return
    end
end
Diffusion_Par.D           = D_Fit_Par.p1;
Diffusion_Par.D_Intercept = D_Fit_Par.p2;
Diffusion_Par.yFit        = D_Fit_Par.p1.*t(1,:)+D_Fit_Par.p2;
Diffusion_Par.Dt          = MSDper2;
Diffusion_Par.Dt_Err      = MSDper2_err;
Diffusion_Par.V           = V_Fit_Par.p1;
Diffusion_Par.V_Intercept = V_Fit_Par.p2;
Diffusion_Par.Vt          = MD_Par.dx;
Diffusion_Par.Vt_Err      = MD_Par.dx_err;
Diffusion_Par.fraction    = fraction;
Diffusion_Par.weight      = weight;
if ishandle(h)
    close(h);
end
