function F = xpolyxy(a,data)
x=data(1,:);
y=data(2,:);

F = a(1)*(x-a(4)).^2+a(2)*(y-a(5)).^2+a(3);

