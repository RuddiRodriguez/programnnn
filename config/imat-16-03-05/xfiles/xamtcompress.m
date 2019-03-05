function [v]=xamtcompress(y,order)
[N,M]=size(y);
M=200;

x=1:M;
v=[];
for n=1:N
    [p]=lsqcurvefit(@amtlin,[1,1,1,1,-0.4,1],x,y(n,1:M))
    v=[v;p];
    f=amtlin(p,x);
    figure,hold on
    plot(f(1:100),'red');
    plot(y(n,1:100),'blue');
    pause
    close
end


function F=amtlin(p,x)
F=p(1)*x.^p(2)+p(3)./x.^p(4)).*exp(p(5).*x.^p(6));



function F=polynom0(p,x)
F=p(1)+p(2)*x+p(3)*x.^2+p(4)*x.^3+p(5)*x.^4+p(6)*x.^5+p(7)*x.^6+p(8)*x.^7;


function F=polynom1(p,x)
F=p(1)*x+p(2)*x.^2+p(3)*x.^3+p(4)*x.^4+p(5)*x.^5+p(6)*x.^6+p(7)*x.^7;

function F=polynom0exp(p,x)
F=(p(1)+p(2)*x+p(3)*x.^2+p(4)*x.^3+p(5)*x.^4+p(6)*x.^5+p(7)*x.^6+p(8)*x.^7).*exp(p(9).*x);


function F=polynom1exp(p,x)
F=(p(1)*x+p(2)*x.^2+p(3)*x.^3+p(4)*x.^4+p(5)*x.^5+p(6)*x.^6+p(7)*x.^7).*exp(p(8)*x);


