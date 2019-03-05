function [p] = polylinear(x,y)

x = x(:);
y = y(:);

% Construct Vandermonde matrix.
% V(:,2) = ones(length(x),1,class(x));
V(:,2) = ones(length(x),1);
% for j = n:-1:1
%    V(:,j) = x.*V(:,j+1);
% end

V(:,1) = x.*V(:,2);


% Solve least squares problem.
% [Q,R] = qr(V,0);

%p = R\(Q'*y);    
 p = V\y;