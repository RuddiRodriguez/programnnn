function F = myfun_lsq_expo(x,xdata,ydata)
 %x(1)=1;
%x(3)=1;
x(4)=0;
% F=(x(1)).*exp(-(x(2).*xdata).^x(3))+x(4);
 %F=(x(1)).*exp(-x(2).*xdata)+x(3);
 %F=(1-x(1)).*exp(-x(2).*xdata)+x(1).*exp(-x(3)*xdata)+0;
 %F = (1-x(1)).*exp(-(x(2).*xdata).^x(3))+x(1).*exp(-x(4)*xdata)+0;
 F=F;
%  Res=ydata-F;
%  options=optimset('Display','iter','TolFun',1e-15,'TolX',1e-15,'MaxFunEvals',50000000,'DiffMinChange',1,'DiffMaxChange',1,'MaxIter',100000000000000000);
%  F1=@(x)0.5.*sum((ydata-(x(1)).*exp(-(x(2).*xdata).^x(3))+x(4)).^2);
%  [x,fval] = fminsearch(F1,x0,options);
%  teorica=(x(1)).*exp(-(x(2).*xdata).^x(3))+x(4);
 
%F = (x(1)).*exp(-x(2).*xdata)+x(3);
%F = (1-x(1)).*exp(-x(2).*xdata)+x(1).*exp(-x(3)*xdata)+0;
%  semilogx(xdata,F,'-k',xdata,ydata,'o','LineWidth',2,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
%      %semilogx(xdata,ydata,'-o',xdata,teorica,'-k');
%      title('Autocorrelation function (fourier)')
%      xlabel('Time (s)')
%      ylabel('G (u.a)')