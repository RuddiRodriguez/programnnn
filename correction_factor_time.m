function [alfa] = correction_factor_time(kappa,modo,radio,epsilon,b,fps,control)

if ((modo/radio)<1e-6)
    coeficiente=2
end

if ((modo/radio)>1e-6)
    coeficiente=8
end

q=modo/radio
if control==1
relaxation_time=(inv(kappa*(q^3)/(4*0.001)))+inv((epsilon.*(q.^2))./(coeficiente.*b));
end
if control==2
    relaxation_time=(inv(kappa*(q^3)/(4*0.001)));
end
    
integration_time=inv(fps);

cociente=relaxation_time/integration_time;

alfa=2*(cociente^2)*(exp(-inv(cociente))-(1-(inv(cociente))));