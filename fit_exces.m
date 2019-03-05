function fi_min = fit_exces(x0)






%x0=[1.15e-19 500 -2];


options=optimset('Display','iter','TolFun',1e-1,'TolX',1e-1,'MaxFunEvals',50000000,'DiffMinChange',1e-1,'DiffMaxChange',0.1,'MaxIter',100000000000000000);
[x,fval,exitflag,output]=fminsearch(@myfunfinal1,x0,options);
fval;
fi_min=x
%myfun42(x(1),x(2));

%  fit_easy([1e-6 1e-19])