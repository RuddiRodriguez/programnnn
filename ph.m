
function PH = ph(ph1,ph2,v1,v2)

c1=10^-ph1
c2=10^-ph2

n1=c1*(v1)
n2=c2*(v2)

nt=n1+n2
vt=v1+v2
ct=nt/vt

PH=-log10(ct)