function [border]=xedge(X,mode)
%----------------------------------------------------
% function [border]=xedge(X,mode)
%----------------------------------------------------
% Determines the edge of an object in an image.
%----------------------------------------------------
% Input:
%   X:      Matrix / image
%   mode:   'inner' / 'outer'
% Output:
%   border: the edge
%----------------------------------------------------
% Example:
%
[n m]=size(X);
Xd1=diff(X);
Xd2=diff(X')';

if all(mode=='inner')
    shift_negXd1=Xd1<0;
    shift_posXd1=Xd1>0;
    shift_negXd2=Xd2<0;
    shift_posXd2=Xd2>0;    
end
if all(mode=='outer')
    shift_negXd1=Xd1>0;
    shift_posXd1=Xd1<0;
    shift_negXd2=Xd2>0;
    shift_posXd2=Xd2<0;
end

[sn1 sn2]=size(shift_negXd1);
[sp1 sp2]=size(shift_posXd1);
pos=[zeros(1,sp2); shift_posXd1(1:sp1,:)];
neg=[zeros(1,sp2);shift_negXd1(2:sn1,:) ; zeros(1,sp2)];
Xv=pos+neg;

[sn1 sn2]=size(shift_negXd2);
[sp1 sp2]=size(shift_posXd2);
pos=[zeros(sn1,1) shift_posXd2(:,1:sp2)];
neg=[zeros(sn1,1) shift_negXd2(:,2:sn2) zeros(sn1,1)];
Xh=pos+neg;
border=((Xv+Xh)>0);


