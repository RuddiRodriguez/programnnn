function [Dt_par,Dt_per,Dr_par,Dr_per] = TLongCylinder(T,e,L,r)
% Function to calculate theoretical values of translational and 
% rotational diffusion for Long Cylinder using Einstein relation.
% --------------------- Input ---------------------------
% T: Temperature (K)
% e: viscosity (Pa.S)
% L: Length of cylinder
% r: Radius of cylinder
% -------------------- Output ---------------------------
% Dt_par: Translational diffusion parallel to cylinder axis
% Dt_per: Translational diffusion perpendicular to cylinder axis
% Dr_par: Translational diffusion about cylinder axis
% Dr_per: Translational diffusion about axis perpendicular to cylinder axis


KB = 1.3806E-23;
d = 2*r;
p = L/d;

dt_par = -0.207 + 0.980/p - 0.133/p^2;
dt_per =  0.839 + 0.185/p + 0.233/p^2;
dr_par =          0.677/p - 0.183/p^2;
dr_per = -0.662 + 0.917/p - 0.050/p^2;

Gt_par = (2*pi*e*L)/(log(p)+dt_par);
Gt_per = (4*pi*e*L)/(log(p)+dt_per);
Gr_par = (3.84*pi*e*L^3*(1+dr_par))/(p^2);
Gr_per = (pi*e*L^3)/(3*(log(p)+dr_per));

Dt_par = (KB*T)/Gt_par;
Dt_per = (KB*T)/Gt_per;
Dr_par = (KB*T)/Gr_par;
Dr_per = (KB*T)/Gr_per;
