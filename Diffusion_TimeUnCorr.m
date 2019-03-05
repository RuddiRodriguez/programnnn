function Diffusion_Par = Diffusion_TimeUnCorr(t,MD_Par,fraction,weight,DataSetIndex)
% Function to calculate diffusion coefficient form data of mean values of 
% displacements and square displacements.
% This function first calculates mean square displacement (MSD) then 
% fit a linear line to it.
% It uses fraction to fit data to some portion of data from beginning 
% corresponds to fraction value.

MSDper2 = (MD_Par.dx2 - (MD_Par.dx).^2)./2;
MSDper2_err = (MD_Par.dx2_err + abs(2.*(MD_Par.dx)).*(MD_Par.dx_err))./2;
m = size(MSDper2,1);
% -----------------------------------------------------------------------
% Pre-Allocation
D_S = zeros(1,m);
D_S_Intercept = zeros(1,m);
V_S = zeros(1,m);
V_S_Intercept = zeros(1,m);
% -----------------------------------------------------------------------
ind = fix(size(MSDper2,2).*fraction);
if ind < 2 , ind = 2; end;
h = waitbar2(0.02,'Processing...');
if weight
    for i = 1:m
        D_Fit_Par = fit(t(i,1:ind)', MSDper2(i,1:ind)','poly1',...
            'Weight',1./MSDper2_err(i,1:ind)');
        D_S(i) = D_Fit_Par.p1;
        D_S_Intercept(i) = D_Fit_Par.p2;
        
        V_Fit_Par = fit(t(i,1:ind)', MD_Par.dx(i,1:ind)','poly1',...
            'Weight',1./MD_Par.dx_err(i,1:ind)');
        V_S(i) = V_Fit_Par.p1;
        V_S_Intercept(i) = V_Fit_Par.p2;
        if ~ishandle(waitbar2(i/m))
            break
        end
    end
else
    for i = 1:m
        D_Fit_Par = fit(t(i,1:ind)', MSDper2(i,1:ind)','poly1');
        D_S(i) = D_Fit_Par.p1;
        D_S_Intercept(i) = D_Fit_Par.p2;
        
        V_Fit_Par = fit(t(i,1:ind)', MD_Par.dx(i,1:ind)','poly1');
        V_S(i) = V_Fit_Par.p1;
        V_S_Intercept(i) = V_Fit_Par.p2;
        if ~ishandle(waitbar2(i/m))
            break
        end
    end
end
D           = mean(D_S);
D_Intercept = mean(D_S_Intercept);
D_Err       = std(D_S);
Dt          = mean(MSDper2,1);
Dt_Err      = std(MSDper2);
V           = mean(V_S);
V_Intercept = mean(V_S_Intercept);
V_Err       = std(V_S);
Vt          = mean(MD_Par.dx,1);
Vt_Err      = std(MD_Par.dx);
if size(MSDper2,1)==1
    D_Err  = D_S;
    Dt_Err = MSDper2;
    V_Err  = V_S;
    Vt_Err = MD_Par.dx;
end
if ishandle(h)
    close(h);
end
Diffusion_Par.D             = D;
Diffusion_Par.D_Intercept   = D_Intercept;
Diffusion_Par.yFit          = D.*t(1,:)+D_Intercept;
Diffusion_Par.D_Err         = D_Err./sqrt(m);
Diffusion_Par.Dt            = Dt;
Diffusion_Par.Dt_Err        = Dt_Err./sqrt(m);
Diffusion_Par.D_Fit_Par     = D_Fit_Par;
Diffusion_Par.V             = V;
Diffusion_Par.V_Intercept   = V_Intercept;
Diffusion_Par.V_Err         = V_Err./sqrt(m);
Diffusion_Par.Vt            = Vt;
Diffusion_Par.Vt_Err        = Vt_Err./sqrt(m);
Diffusion_Par.V_Fit_Par     = V_Fit_Par;
Diffusion_Par.D_S           = D_S;
Diffusion_Par.D_S_Intercept = D_S_Intercept;
if DataSetIndex > 0
    Diffusion_Par.yFit          = D_S(DataSetIndex).*t(DataSetIndex,:)+D_S_Intercept(DataSetIndex);
end
Diffusion_Par.Dt_S          = MSDper2;
Diffusion_Par.Dt_S_Err      = MSDper2_err;
Diffusion_Par.V_S           = V_S;
Diffusion_Par.V_S_Intercept = V_S_Intercept;
Diffusion_Par.Vt_S          = MD_Par.dx;
Diffusion_Par.Vt_S_Err      = MD_Par.dx_err;
Diffusion_Par.fraction      = fraction;
Diffusion_Par.weight        = weight;