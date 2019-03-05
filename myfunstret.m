function  myfunstret(x0)
%   x0=[0.2,30,1,3]  
options=optimset('TolFun',1e-2,'TolX',1e-2,'MaxFunEvals',50000000,'MaxIter',100000000000000000);

           
     [x,fval,exitflag,output]=fminsearch(@myfun_ajus_stret,x0,options);
    