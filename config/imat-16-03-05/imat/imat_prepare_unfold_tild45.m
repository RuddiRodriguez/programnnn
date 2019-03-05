function X=imat_prepare_unfold_tild45(img)

[n m]=size(img);
X=[];
if n~=m
    disp('Warning: Spiral unfolding is not god since n~=m ...');
end
for i=-n:n
    X=[X diag(img i)'];
end
