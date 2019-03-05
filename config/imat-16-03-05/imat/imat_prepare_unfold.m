function [X]=imat_prepare_unfold(rsimg,unfoldmethod)
unfoldmethod=unfoldmethod-1;

if unfoldmethod==0     
    % nothing to do
    X=rsimg;
end    
if unfoldmethod==1
    X=imat_prepare_unfold_snake_vertical(rsimg);
end    
if unfoldmethod==2
    X=imat_prepare_unfold_snake_horizontal(rsimg);
end        
if unfoldmethod==3
    X=imat_prepare_unfold_classic_vertical(rsimg);        
end
if unfoldmethod==4
    X=imat_prepare_unfold_classic_horizontal(rsimg);        
end
if unfoldmethod==5
    X=imat_prepare_unfold_spiral(rsimg);        
end
if unfoldmethod==6
    X=imat_prepare_unfold_tild45(rsimg);        
end
if unfoldmethod==7
    X=imat_prepare_unfold_tild135(rsimg);        
end    
if unfoldmethod==8
    X=imat_prepare_unfold_median_vertical(rsimg);        
end    
