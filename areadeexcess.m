

kc=25e-20;
kbt=1.38e-23*298;
 excess=12
 rmean=4e-6
% l=2:10000;
temp=0
for l=2:10000
y=((2.*l+1)./((l.^2)+l+excess+(4.*(-2.41)))+((((-2.41)).^2)./2));

y=y+temp;
temp=y;
end
aeaexc=(rmean.^2).*y.*(kbt./(kc.*2))

% excess=2000
 l=2:10000;
y=((2.*l+1)./((l.^2)+l+excess));
suma=(sum(y)).*(kbt./(kc.*2))