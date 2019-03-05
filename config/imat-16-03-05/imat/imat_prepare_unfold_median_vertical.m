function X=imat_prepare_unfold_median_vertical(img)
[n,m]=size(img);
left=img(:,1:round(m/2));
right=img(:,round(m/2)+1:m);

[nn,mm]=size(left);
reverted_left=left(:,mm:-1:1);
cat=[right reverted_left];

X=amt_prepare_unfold_chop1(cat);
