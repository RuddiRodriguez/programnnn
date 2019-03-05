function [Dt_a,Dt_b,Dr_a,Dr_b] = TProlateSpheroid(T,e,a,b)
% Function to calculate theoretical values of translational and 
% rotational diffusion for Prolate Spheroid using Einstein relation.
% --------------------- Input ---------------------------
% T: Temperature (K)
% e: viscosity (Pa.S)
% a: Length of major axis of an ellipse which Prolate Spheroid made of it. (m)
% b: Length of minor axis of an ellipse which Prolate Spheroid made of it. (m)
% -------------------- Output ---------------------------
% Dt_a: Translational diffusion parallel to axis "a"
% Dt_b: Translational diffusion perpendicular to axis "b"
% Dr_a: Translational diffusion about axis "a"
% Dr_b: Translational diffusion about axis "b"

KB = 1.3806E-23;	% Boltzmann constant
S = (2*log((a+sqrt(a^2-b^2))/b))/sqrt(a^2-b^2);

Gt_a = (16*pi*e*(a^2-b^2))/((2*a^2-b^2)*S-2*a);
Gt_b = (32*pi*e*(a^2-b^2))/((2*a^2-3*b^2)*S+2*a);
Gr_a = ((32/3)*pi*e*(a^2-b^2)*b^2)/(2*a-b^2*S);
Gr_b = ((32/3)*pi*e*(a^4-b^4))/((2*a^2-b^2)*S-2*a);

Dt_a = (KB*T)/Gt_a;
Dt_b = (KB*T)/Gt_b;
Dr_a = (KB*T)/Gr_a;
Dr_b = (KB*T)/Gr_b;