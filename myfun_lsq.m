function F = myfun_lsq(x,xdata)
%x(3)=0.667;
% x(4)=0;
F = (1-x(1)).*exp(-(x(2).*xdata).^x(3))+x(1).*exp(-x(4)*xdata)+0;