%laguerre
% fluct=load('C:/MATLAB7/work/Modulodatos/fluctuations.txt');
% wave=load('C:/MATLAB7/work/Modulodatos/wavenumbers.txt');
% a=size(wave);
n=6:16;

%f=exp(-qy^2)+a dqy
t=sym('t')
sigma_scalefactor_sigma=sym('sigma * scalefactor_sigma')%tension
%kapa=sym('kapa')
kappa_scalefactor_kappa=sym('kappa * scalefactor_kappa')%kapa
qx=sym('qx')
x=sym('x')
integration_time=sym('integration_time')
temperature=sym('temperature')
chi=sym('chi')
 % qx=x
eta=0.001
% tiempo=1/15
KbT=1.3806e-23.*temperature
factor=KbT./(2.*pi.*eta.*(integration_time.^2))
% qp=((qx.^2)+(qy.^2))
%  tm=((4./eta.*qx).*((1+chi).^0.5)))./(((a.*(qx.^2))(1+(chi.^2)))+((b.*(qx.^4)).*((1+(chi.^2)).^4)))
 
 
C1=0.521755610583
C2=0.398666811083
C3=0.0759424496817
C4=0.00361175867992
C5=0.0000233699723858
x1=0.263560319718
x2=1.413403059107
x3=3.596425771041
x4=7.085810005859
x5=12.640800844276

% C=[0.3478548 0.6521452 0.6521452 0.3478548]
% x=[-0.86113631 -0.33998104 0.33998104 0.86113631]
% down=wave(1)
% up=wave(10)

down=0
up=1000000000000000000000000000000000000000

% h=up-down
% chi=1/2*((t*(h))+down+up)
% dchi=1/2*(h)
m=(1+chi^2)
m1=(1/(qx*(m^(1/2))))
tm=((4*eta*qx)*(m^(1/2)))/((a*(qx^2)*m)+(b*(qx^4)*(m^2)))
m2=integration_time/tm


f=factor*(tm^3)*m1*(m2+(exp(-m2))-1)*qx%*dchi
%F=simple(f)
chi=x1
[f1]=eval(f)
chi=x2
[f2]=eval(f)
chi=x3
[f3]=eval(f)
chi=x4
[f4]=eval(f)
chi=x5
[f5]=eval(f)

I=(C1*f1)+(C2*f2)+(C3*f3)+(C4*f4)+(C5*f5)
%II=int2str(I)
simple(I)


% fluct=load('C:/MATLAB7/work/Modulodatos/fluctuations.txt');
% wave=load('C:/MATLAB7/work/Modulodatos/wavenumbers.txt');
% a=size(wave)
% n=6:16
% fluct=fluct(n)
% qx=wave(n)
% eta=0.001
% 
%    ftype=fittype('(C1*f1)+(C2*f2)+(C3*f3)+(C4*f4)','ind','qx')