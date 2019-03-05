function X=imat_prepare_unfold_spiral(img)

[n m]=size(img);
X=[];
nm2=min([n m])/2;
if n~=m
    disp('Warning: Spiral unfolding is not god since n~=m ...');
end
j=1;
for i=0:1:nm2-1
    X=[X img(i+1,1+i:n-i-1)];
    X=[X img(1+i:m-i-1,n-i)'];    
    X=[X img(m-i,n-i:-1:i+2)];
    X=[X img(m-i:-1:2+i,i+1)'];    
end
