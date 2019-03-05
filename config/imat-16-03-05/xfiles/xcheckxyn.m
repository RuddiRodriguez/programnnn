function [guidetxt,X,Y,N]=xcheckxyn(X,Y,N)
%--------------------------------------------------------------
% function [guidetxt,X,Y,N]=xcheckxyn(X,Y,N)
%--------------------------------------------------------------
% Check that X,Y and N matrix have equal row dimensions
% If not then they are truncated and a message is returned.
%--------------------------------------------------------------
% Input:
%   X:      X-data
%   Y:      Y-data
%   N:      Names
% Output:
%   guidetxt:   Information on the dimensions
%   X:          Evt. modified X-data
%   Y:          Evt. modified Y-data
%   N:          Evt. modified names
%--------------------------------------------------------------
% Example:
%
[x1 x2]=size(X);
[y1 y2]=size(Y);
[n1 n2]=size(N);
trunca=min([y1 n1]);
truncated=0;
if prod(size(unique([ y1 n1 trunca])))~=1
    Y=Y(1:trunca,:);
    N=N(1:trunca,:);
    truncated=1;
    trunctxt=' (Truncating!!)';
else
    trunctxt='';
end

guidetxt='';
if 1~=prod(size(unique([y1 n1]))) && all([y1 n1]~=0) || truncated==1
    txt=[cellstr(['Dimension are ill' trunctxt]); cellstr(['        Size(X)  = ' num2str(size(X))])];
    txt=[txt; cellstr(['        Size(Y)  = ' num2str(size(Y))])];
    txt=[txt; cellstr(['        Size(Nms)= ' num2str(size(N))])];
    guidetxt=txt;    
end
