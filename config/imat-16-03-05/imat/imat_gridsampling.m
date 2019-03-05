function [Randv,Randx,Randy]=imat_gridsampling(imati,background,x,ux)
% x    2d image
% ux   1d unfolded
% background   2d background
METHOD=imati.analysis.method;
%%%%%%%%%%%
lowercutoff=imati.cutting.lowercutoff;
uppercutoff=imati.cutting.uppercutoff;
loweronhill=imati.cutting.loweronhill;
upperonhill=imati.cutting.upperonhill;
REMOVETRUEBG=imati.cutting.removebg;
POINTS=imati.analysis.points;
SMAX=imati.analysis.smax;
UNFOLDMETHOD=imati.analysis.unfold;
GBU=imati.grid.type.gbu;
GS_Kx=imati.grid.gridx;
GS_Ky=imati.grid.gridy;
GRIDRAND=imati.grid.type.stratified;    
Iter=imati.analysis.points;
if imati.grid.type.systematic==1 || imati.grid.type.keepgrid==1
   KEEPGRID=1; 
else
    KEEPGRID=0;
end

[N M]=size(x);
nm=N*M;


Randv=[];
Randx=[];
Randy=[];

if GS_Kx>M
    GS_Kx=M;
end
if GS_Ky>N
    GS_Ky=N;
end


grid0=zeros(N,M);
if GBU==1
    grid=grid0;
    grid2=grid0;
    indexx0=1:N/GS_Kx:N;
    indexy0=1:M/GS_Ky:M;   
    
%%    indexx2=indexx0+floor(N/GS_Kx/2);
%%    indexy2=indexy0+floor(M/GS_Ky/2);
    
    indexx0=floor(indexx0);
    indexy0=floor(indexy0);
%%    indexx2=round(indexx2);
%%    indexy2=round(indexy2);
    grid(indexx0,indexy0)=1;
    [indexx indexy]=find(grid>0);
    indexx=indexx';
    indexy=indexy';
    numrandx=size(indexx);
    numrandy=size(indexy);
    numrandx=numrandx(2);
    numrandy=numrandy(2);
%    grid2(indexx2,indexy2)=1;
%    grid=grid+grid2;        
    Randv=[];
    Randx=[];
    Randy=[];
    %    temppercent=0;
    %    while temppercent<ITERPERCENT
    grid2=grid0;
    if GRIDRAND==1
        indexx1=[];
        indexy1=[];
        for i=1:Iter
            randindexx=round(rand(1,numrandx)*(N/(GS_Kx)-1));
            randindexy=round(rand(1,numrandy)*(M/(GS_Ky)-1));
            indexx1=[indexx1 indexx+randindexx];
            indexy1=[indexy1 indexy+randindexy];
        end   
        %        grid2(indexx1,indexy1)=1;
        flatgrid2=reshape(grid2,1,N*M); 
        flatgrid2((indexx1-1)*M+indexy1)=1;
        grid2=reshape(flatgrid2,N,M);
        if KEEPGRID==1
            grid=grid+grid2; 
        elseif KEEPGRID==0
            grid=grid2;
        end
    end
    grid1d=imat_prepare_unfold(grid,UNFOLDMETHOD);        
    Randv=find(grid1d>0);
end

% GRID SAMPLING OF UNFOLDED IMAGE    
if GBU==0
    step=ceil(N*M/GS_Kx);
    dim1grid=1:step:(N*M);
    if KEEPGRID==1
        Randv=dim1grid;
    elseif KEEPGRID==0
        Randv=[];    
    end
    if GRIDRAND
        sd=size(dim1grid);
        sd=sd(2);
        for i=1:Iter
            randgrid1=ceil(rand(1,sd)*(step-1));
            Randv=[Randv dim1grid+randgrid1];
        end
    end
    grid1d=zeros(1,N*M);
    grid1d(1,Randv)=1;
    Randv=find(grid1d>0);
end


% if UNFOLDMETHOD~=1
%     background=double(background);
%     kp=~imat_prepare_unfold(background,UNFOLDMETHOD);        
%     kp2=zeros(1,N*M);
%     kp2(1,Randv)=5;
%     kp=(kp+kp2);
%     Rindex=(kp>5);
%     Randv=find(Rindex);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     pp=zeros(1,N*M);
% %     pp(Randv)=200;
% %     ww=xfolding(pp,N,M,'snake','hor');
% %     figure,imshow(ww);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end



if UNFOLDMETHOD==1
    % no unfolding
    Randx=indexx1;
    Randy=indexy1;
    %     ixy_lower=ones(1,GS_Kx*GS_Ky*Iter);
    %     ixy_upper=ones(1,GS_Kx*GS_Ky*Iter);
    uxtemp=reshape(x,1,N*M);
    if imati.cutting.type.onhill
        keepo=x>loweronhill;
        [ax ay]=find(keepo);
        complexaxy=complex(ax,ay);
        complexrandxy=complex(Randx,Randy);
        [ixy_lower]=ismember(complexrandxy,complexaxy);
        
        keepo=x<upperonhill;
        [ax ay]=find(keepo);
        complexaxy=complex(ax,ay);
        complexrandxy=complex(Randx,Randy);
        [ixy_upper]=ismember(complexrandxy,complexaxy);
        
        ixy=find(ixy_lower.*ixy_upper);
        Randx=Randx(ixy);
        Randy=Randy(ixy);
    end
end

if imati.cutting.type.onhill
    keep=find(ux(Randv)>loweronhill);
    Randv=Randv(keep);
    keep=find(ux(Randv)<upperonhill);
    Randv=Randv(keep);        
end






