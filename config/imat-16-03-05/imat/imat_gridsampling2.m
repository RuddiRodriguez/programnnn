function [Randv,Randx,Randy]=imat_gridsampling(imati,background,orgimg,x)
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

[N M]=size(orgimg);
nm=N*M;

orgimg=imat_prepare_unfold(orgimg,UNFOLDMETHOD);

Randv=[];
Randx=[];
Randy=[];

if METHOD==99
    % fold back
    unforgimg=orgimg;
    orgimg=reshape(orgimg,N,M);
end

if GBU==0
    orgimg=imat_prepare_unfold(orgimg,UNFOLDMETHOD);
    N=N*M;
    M=1;
    GS_Ky=1;
end
grid=zeros(N,M);
indexx0=round(1:(N/GS_Kx):N);
indexy0=round(1:M/GS_Ky:M);   
grid(indexx0,indexy0)=1;
if GBU
    [indexx indexy]=find(grid>0);
else
    [indexx ]=find(grid>0);
    indexy=1;
end

indexx=indexx';
indexy=indexy';
[numrandx dd]=size(indexx);
[numrandy dd]=size(indexy);

Randv=[];
Randx=[];
Randy=[];


grid2=zeros(N,M);
indexx1=[];
indexy1=[];
for i=1:Iter
    randindexx=round(rand(1,numrandx)*(N/(GS_Kx)-1));
    indexx1=[indexx1 indexx+randindexx];
    randindexy=round(rand(1,numrandy)*(M/(GS_Ky)-1));
    indexy1=[indexy1 indexy+randindexy];      
end   
indexx1=unique(indexx1);
indexy1=unique(indexy1);
grid2(indexx1,indexy1)=1;
%flatgrid2=reshape(grid2,1,N*M); 
%flatgrid2((indexx1-1)*M+indexy1)=1;
%grid2=reshape(flatgrid2,N,M);
if KEEPGRID==1
    grid=grid+grid2; 
elseif KEEPGRID==0
    grid=grid2;
end
%Randx=indexx1;
%Randy=indexy1;    


backgroundu=ones(N,M);
if REMOVETRUEBG
    backgroundu=imat_prepare_unfold(background,UNFOLDMETHOD);        
end
lowergroundindex=ones(N,M);
uppergroundindex=ones(N,M);
if imati.cutting.type.plus==1
    lowergroundindex=orgimg>lowercutoff;       
    uppergroundindex=orgimg<uppercutoff;    
end
index_plus=lowergroundindex.*uppergroundindex;
lowergroundindex=ones(N,M);
uppergroundindex=ones(N,M);
if imati.cutting.type.onhill
    lowergroundindex=orgimg>loweronhill;       
    uppergroundindex=orgimg<upperonhill;        
end
index_onhill=lowergroundindex.*uppergroundindex;
grid=grid.*((index_plus.*index_onhill).*(backgroundu));
Randx=unique(Randx);
Randy=unique(Randy);
[Randx Randy]=find(grid);
Randv=find(imat_prepare_unfold(grid,UNFOLDMETHOD));        


% Test 1 (plain and onhill)
orgimg(Randx,Randy)=0;
figure,imshow(uint8(orgimg))

% Test 2 (plus)
orgimg(Randx,Randy)=0;
qq=imat_prepare_unfold(orgimg,UNFOLDMETHOD);
figure,plot(qq(Randv))





