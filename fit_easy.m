function fi_result = fit_easy(x0)






%x0=[1.15e-19 500 -2];


options=optimset('Display','iter','TolFun',1e-12,'TolX',1e-12,'MaxFunEvals',5000);
[x,fval,exitflag,output]=fminsearch(@fitting_easy,x0,options)
fval;
fi_result=x
%myfun42(x(1),x(2));