clear all;

fluct=load('C:/MATLAB7/work/Modulodatos/fluctuations.txt');
wave=load('C:/MATLAB7/work/Modulodatos/wavenumbers.txt');

n = 6:26;
m = 6:26;

ydata=(fluct(n));
xdata=(wave(n));

p0 = [1, 1]; % starting values for parameter fit
% lb = [1e-08, 1e-21]; % lower bound for parameter values
% ub = [1e-06, 1e-19]; % upper bound for parameter values

% options = optimset('LevenbergMarquardt','on','TolFun',1e-90,'MaxFunEvals',2000,'MaxIter',2000,'DiffMaxChange',1e-20,'DiffMinChange',1e-20,'LargeScale','off','Diagnostics','On','LineSearchType','cubicpoly');
% [p,resnorm,residual,exitflag,output] = lsqcurvefit(@fluct_integ_fun,p0,xdata,ydata,[],[],options)

options = optimset('LevenbergMarquardt','on','LargeScale','off','TolX',1e-200,'TolFun',1e-50,'Display','iter');
[p,resnorm,residual,exitflag,output] = lsqcurvefit(@fluct_integ_fun,p0,xdata,ydata,[],[],options)

y = fluct_integ_fun(p,wave);


semilogy(wave(m),fluct(m),'ro');
hold on
semilogy(wave(m),y(m)),'b:-';
hold off