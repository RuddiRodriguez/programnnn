function [background] = xconnectedm(pic,bgvalue1,bgvalue2,init)
%====================================================
% Determination of a background surrounding a body.
% Structures inside the body will NOT be recognised as background,
% since this structure can not surround the body.
% Note: The value of <bgvalue> is crucial for a good determination.
%====================================================
% INPUT:
% pic           The picture in matrix form
% bgvalue   cutoff, values below this value is defined to be background.
% sgn          If 1 then background is above the cutoff value.
% init          initial point(s)... ex. [[1,1]; [256,256]].
%====================================================
% OUTPUT:
% background        The background in matrix form.
%                           Elements of value one denotes a background pixel,
%                           while pixel in the body take the value 0.
%====================================================
[P1 P2]=size(pic);
background=zeros(P1,P2);
initN=size(init);
for initn=1:initN
    chkpoints=[init(initn,:)];    
    [N M]=size(chkpoints);
    newchkpoints=[];
    while N~=0
        for n=1:N        
            for i=-1:1
                for j=-1:1
                    if chkpoints(n,1)+i>0 && chkpoints(n,2)+j>0 && chkpoints(n,1)+i<=P1 && chkpoints(n,2)+j<=P2
                            if pic(chkpoints(n,1)+i,chkpoints(n,2)+j)>bgvalue1  && pic(chkpoints(n,1)+i,chkpoints(n,2)+j)<=bgvalue2 && background(chkpoints(n,1)+i,chkpoints(n,2)+j)==0
                                newchkpoints=[newchkpoints;[chkpoints(n,1)+i chkpoints(n,2)+j]];
                                background(chkpoints(n,1)+i,chkpoints(n,2)+j)=1;
                            end                        

                    end            
                end
            end
        end
        chkpoints=newchkpoints;        
        [N M]=size(chkpoints);
        newchkpoints=[];
    end
end



