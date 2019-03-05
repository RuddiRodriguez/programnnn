function fi_min = fit_easy_hibrid(x0)






%x0=[1.15e-19 500 -2];


options=optimset('Display','iter','TolFun',1e-19,'TolX',1e-19,'MaxFunEvals',5000);
[x,fval,exitflag,output]=fminsearch(@myfunhibrid,x0,options)
fval;
fi_min=x
%myfun42(x(1),x(2));

