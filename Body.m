function [x_body y_body] = Body(x,y,tet)
% Function to calculate displacements and postion of particle in body frame.

m = size(x,1); % number of data sets, or movies, etc.
n = size(x,2); % the steps, frames, ... of each data set.

dx = diff(x,1,2);
dy = diff(y,1,2);

tet_m = (tet(:,1:end-1) + tet(:,2:end))/2;

dx_body = cos(tet_m).*dx + sin(tet_m).*dy;
dy_body = -sin(tet_m).*dx + cos(tet_m).*dy;

x_body = cumsum(dx_body,2);
y_body = cumsum(dy_body,2);

x_body = meshgrid(x(:,1),(1:n)')' + [zeros(m,1) x_body];
y_body = meshgrid(y(:,1),(1:n)')' + [zeros(m,1) y_body];



