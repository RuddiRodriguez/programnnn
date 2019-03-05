function X=imat_prepare_unfold_snake_horizontal(img)
% snake horizontal
% m=reshape(1:9,3,3)
% m =
% 
%      1     4     7
%      2     5     8
%      3     6     9
% mu=amt_prepare_unfold_snake_horizontal(m)
% mu=[1 4 7 8 5 2 3 6 9]
%
[n m]=size(img);
X=[];
% Take all even rows
q1=img(2:2:n,:);
% Revert q1 and insert in in even rows of img.
img(2:2:n,:)=q1(:,m:-1:1);
% Unfold using chop1
X=imat_prepare_unfold_classic_horizontal(img);
