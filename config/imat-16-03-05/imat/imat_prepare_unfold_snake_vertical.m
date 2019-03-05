function X=imat_prepare_unfold_snake_vertical(img)
% snake vertical
% m=reshape(1:9,3,3)
% m =
% 
%      1     4     7
%      2     5     8
%      3     6     9
% mu=amt_prepare_unfold_snake_vertical(m)
% mu=[1 2 3 6 5 4 7 8 9]

[n m]=size(img);
X=[];
% Take all even rows
q1=img(:,2:2:m);
% Revert q1 and insert in in even rows of img.
img(:,2:2:m)=q1(n:-1:1,:);
% Unfold using chop1
X=imat_prepare_unfold_classic_vertical(img);
