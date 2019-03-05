function D = TSphere(T,e,r)
% Function to calculate theoretical value of translational diffusion
% for sphere using Einstein relation.
% --------------------- Input ---------------------------
% T: Temperature (K)
% e: viscosity (Pa.S)
% radius of sphere (m)
% -------------------- Output ---------------------------
% D : Diffusion coefficient for a sphere

KB = 1.3806E-23;	% Boltzmann constant
G = 6*pi*e*r;
D = (KB*T)/G;