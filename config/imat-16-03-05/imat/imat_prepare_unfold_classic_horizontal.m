function X=imat_prepare_unfold_classic_horizontal(img)
% Classic horizontal
% m=reshape(1:9,3,3)
% m =
% 
%      1     4     7
%      2     5     8
%      3     6     9
% mu=amt_prepare_unfold_classic_horizontal(img)
% mu=[1 4 7 2 5 8 3 6 9]
[m,n]=size(img);
X=reshape(img',1,m*n);
