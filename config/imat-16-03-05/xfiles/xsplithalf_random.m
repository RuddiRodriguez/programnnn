function ssplitx_random(x,ns,t)
%
%
%
[N,M,K]=size(x);
ix=ceil(rand(t)*ns);
rep=(1:N/ns)*ns-1;
ix=rep+ix;



