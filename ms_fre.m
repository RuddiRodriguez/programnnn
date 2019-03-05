
n=[2:20]
sigmaexcess=12
ce=0
factor1=n.*(n+1)+sigmaexcess-(4.*ce)+(.2*(ce.^2));
factor2=((2.*n+1).*((2.*(n.^2))+(2.*n)-1))./(n.*(n+1).*(n+2).*(n-1));
%kappa=1.2e-19
epsilon=0.2
b=1e9;
% r0=7e-6
kappa=12e-19
r0=5e-6
ms=((kappa./((r0).^3))./(4.*0.001)).*((factor1)./(factor2));
ms1=((kappa./((r0).^3))./(4.*0.001)).*((factor1)./(factor2));
ms1=ms1'
ms2=(kappa.*((n./r0).^3))./(4.*0.001)
ms2=ms2'
loglog(n,ms1)