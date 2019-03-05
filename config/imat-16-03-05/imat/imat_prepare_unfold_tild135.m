function X=imat_prepare_unfold_tild135(img)

img=img';
[n m]=size(img);
X=[];
if n~=m
    disp('Warning: Spiral unfolding is not god since n~=m ...');
end
for i=-n:n
    X=[X diag(img i)'];
end

