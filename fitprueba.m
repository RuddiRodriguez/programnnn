







options = optimset('TolFun',1e-20,'MaxFunEvals',1e30,'Tolx',1e-40,'MaxIter',1e80,'Diagnostics','on','LargeScale','off','Display','notify','LevenbergMarquardt','on','TolCon',1e-20');
x0=[0 0 0 0 0]
ul=[0 0]
ub=[1 1]


[x] =  fminsearch(@myfun1,x0,options)