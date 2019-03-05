function [pic,dist,err,dd]=xgaussianspheres(ids,sigma,m,A,xmin,xmax,step,dd,options)
%----------------------------------------------------------------------------
% [pic,dist,err]=xgaussianspheres(sigma,m,A,ids,xmin,xmax,step,options)
%----------------------------------------------------------------------------
% Generate an image of Gaussian distributed spheres.
% The Gaussian distribution:
%  g(x) = 1/(sigma*sqrt(2*pi)) * exp[ -1/2 * ((x-m)/sigma)^2 ]
% The images is generated by first placing the larger (according
% to the distribution) spheres followed by the next largest etc.
%----------------------------------------------------------------------------
% Input:
%   ids:        Indices given to the file names
%   sigma:  
%   m:      
%   A:
%   xmin:       smallest sphere
%   xmax:       largest sphere
%   step:       step in size of spheres
%   options:    [image size (256), save image (0/1), it (1000)]
% Output:
%   dist:   The distribution (digitalized)
%   X:      The image
%   err:    if 1, then the distribution is impossible within it iterations
%----------------------------------------------------------------------------
% Example:
%   x=xgaussianspheres(1,15,35,200,1,0,100,5);
%
err=0;
warning off all
dist=[];
for id=ids
    dist=[];
    if id<10
        qq='00';
    end
    if id<100 && id>9
        qq='0';    
    end
    if id==100
        qq='';
    end
    
    if nargin==8
        N=256;    
        mattemps=100000
        saveim=0;
    else
        N=options(1);
        saveim=options(2);
        mattemps=options(3);
    end
    pic=zeros(N,N);    
    name=['gs_' int2str(sigma) '_' int2str(m) '_' int2str(A) '_' '0_' qq int2str(id)];
    dist1=[];
    for x=xmin:step:xmax
        dist1=[dist1; A/(sigma*sqrt(2*pi))*exp(-0.5*((x-m)/sigma)^2 ) x];
    end
    
%     figure,plot(dist1(:,2),dist1(:,1));
%     hold on
%     plot(dist1(:,2),dist1(:,1),'+');
%     plot(dist1(:,2),round(dist1(:,1)),'color','red');
%     plot(dist1(:,2),round(dist1(:,1)),'+','color','red');    
%     pause(1)
    [K]=size(dist1,1);
    attemps=0;
    for k=K:-1:1
        centers=[];
        number=round(dist1(k,1));
        R=round(dist1(k,2));
        attemps=0;
        h=0;
        while h<number
            attemps=attemps+1;
            if attemps>mattemps
                getout=1;
                err=1;
                disp('Distribution impossible!');
                pause(1)
                break;    
            end
            x=rand*N;
            y=rand*N;            
            collision=0;
            n=1;
            pic0=pic;
            colli=0;
            dphi=1/R;
            phi=0;
            xx=round(x+0.5);
            yy=round(y+0.5);
            if pic(xx,yy)==0
                gody=1;
            else
                gody=0;
            end
            if gody==1
                while phi<=2*pi && colli==0
                    xx=round(x+R*sin(phi));
                    yy=round(y+R*cos(phi));            
                    if xx>0 && yy>0 && xx<=N && yy<=N
                        if pic0(xx,yy)~=0
                            colli=1;    
                        end
                    else
                        colli=1;
                    end
                    phi=phi+dphi;
                end
                if colli==0            
                    theta=0;
                    centers=[centers; x y R];
                    while theta<=pi/2
                        phi=0;
                        while phi<=2*pi
                            xx=round(x+R*sin(phi)*sin(theta));
                            yy=round(y+R*cos(phi)*sin(theta));            
                            zz=round(255*cos(theta));
                            pic(xx,yy)=zz;
                            phi=phi+dphi;
                        end %phi
                        theta=theta+dphi;
                    end %theta            
                    h=h+1;
                end % if colli        
            end            
        end
        dist=[dist; h R ];
    end
    if err==0
        dd=[dd dist];
        
        info.centers=centers;
        info.dist=dist;
        pic=reshape(pic,N,N);
        pic=uint8(pic);
        if saveim==1
            imwrite(pic,[name '.tif'],'tif');
            name
            save([name '.mat'],'info');
        end
    end
end

