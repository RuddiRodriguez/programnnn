function [eAMTX,eAMTY,epictures]=xpluto_plotter(AMTX,AMTY,pictures,syntax,sortafter,what,colors,handles,parent,options)
% AMT      = matrix
% pictures = picture names
% syntax     = string
% sortafter  = string
% what       = string
% 
% EXAMPLE:
% plot all A and Ref grouped such that
% one group is all A with -2
% and all Ref is with -3
%
%     pictures is=
%                  '12Ref1-3_ch00.tif'
%                  '12Ref2-2_ch00.tif'
%                  '12Ref3-3_ch00.tif'
%                  '2A1-2_ch00.tif'
%                  '2A2-2_ch00.tif'
%                  '2A3-1_ch00.tif'
%                  '2C1-3_ch00.tif'
%                  '2C2-3_ch00.tif'
% whith syntax     'nsnsnsns'
%                    |  |   
% sortafter         12345678    -->  '25'
%
%

difforder=str2num(char(options(1)));
movav =str2num(char(options(2)));
transx=str2num(char(options(3)));
transy=str2num(char(options(4)));
interruptbg =str2num(char(options(5)));
exportnoplot=str2num(char(options(6)));
linew=str2num(char(options(7)));
bgcolor=char(options(8));
xrange=char(options(9));
averagegrps=str2num(char(options(10)));
stdmax=str2num(char(options(11)));
transparency=str2num(char(options(12)));
filter=str2num(char(options(13)));
filterval=str2num(char(options(14)));

if transx==1
  AMTX=AMTX';    
end
if transy==1
  AMTY=AMTY';    
end

if size(AMTX,1)~=size(AMTY,1)
  AMTX=repmat(AMTX(1,:),size(AMTY,1),1);
end

if filter==1
    averagegrps=1;
    exportnoplot=1;
end
labelcont.pos=[];
labelcont.text=[];
labelcont.color=[];
labelcont.hand=[];
if ~isempty(xrange)
    xrange=eval(xrange);
    AMTY=AMTY(:,xrange);
    [q1,q2]=size(AMTX);
    if q2>1
        AMTX=AMTX(:,xrange);
    end
end
%======================================================================================
% Moving average and differentiation
%======================================================================================
if movav>1
    AMTY=xmovaverage(AMTY,movav);
end
if difforder>0
    AMTY=diff(AMTY',difforder)';
    sax=size(AMTX);
    AMTX=AMTX(:,1:sax(2)-difforder);
end
%======================================================================================
% Initialization of figure
%======================================================================================
[N,M]=size(pictures);
figure
pfig=gcf;
clf
hold on
n=1;
maxy=max(max(AMTY));
miny=min(min(AMTY));
if filter==0
    set(get(gcf,'Children'),'YLimMode','Manual');
    set(get(gcf,'Children'),'YLim',[miny maxy]);
end
%======================================================================================
% Set the background color
%======================================================================================
set(get(gcf,'Children'),'Color',bgcolor);
if all(bgcolor=='black')
    set(gcf,'Color',[0.2 0.2 0.2]);
    set(get(gcf,'Children'),'XColor','white');
    set(get(gcf,'Children'),'YColor','white');
else
    set(gcf,'Color',[0.8 0.8 0.8]);
    set(get(gcf,'Children'),'XColor','black');
    set(get(gcf,'Children'),'YColor','black');
end

%======================================================================================
% Initializations of matrices
%======================================================================================
global export;
export.resx=[];
export.resy=[];
export.pictures=[];
export.averagegrps.resx=[];
export.averagegrps.mean=[];
export.averagegrps.std=[];
export.averagegrps.max=[];
export.averagegrps.pictures=[];
export.filter.sep=[];
export.filter.seplabel=[];
export.filter.pictures=[];
export.filter.spectray=[];
export.filter.spectrax=[];
export.filter.spectraix=[];
export.filter.sep2D=[];

[dd maxx]=size(AMTY);
eAMTY=[];
eAMTX=[];
eAMTYmean=[];
eAMTYstd=[];
eAMTYmax=[];
listpictures=[];
ecurwhat=[];
[groups,tgroups,NUMBERARRAY,STRINGARRAY]=xgroups(syntax,sortafter,pictures);
[out]=xdecomposegroups(STRINGARRAY,NUMBERARRAY,sortafter,syntax);
ixc=find(what==',');
ncomma=sum(what==',')+1;
[ncolors,dummy]=size(colors);
nc=0;
%======================================================================================
% Loop over length of "Plot by"
%======================================================================================
for n=1:ncomma
    nc=nc+1;
    [ixp,names,curwhat]=xnamesofgroup(what,out,pictures,n,[]);
    curvey=AMTY(ixp,:);
    curvex=AMTX(ixp,:);
    if nc>ncolors
        nc=1;
    end
    %======================================================================================
    % "Normal" groupped plot
    %======================================================================================
    if averagegrps==0
        [q1,q2]=size(curvey);
        if ~all(size(curvex)==size(curvey))
            curvex=(1:q1)';
        end
        if filter==0
            if all(size(curvex)==size(curvey))
            plot(curvex',curvey','Color',colors(nc,:)/255,'LineWidth',linew);
        else
                plot(curvex,curvey,'Color',colors(nc,:)/255,'LineWidth',linew);
        end
        end
    end
    %======================================================================================
    % Store averagegrps matrices, and make the plot
    % If filter is on >>> then ONLY variables are made
    %======================================================================================
    if averagegrps==1
        mAMTY=xmean(curvey,1);
        if stdmax==0 && size(ixp,2)>1
            sAMTY=0.5*xstd(curvey,1);
        else
            sAMTY=curvey*0;
        end
        if stdmax~=0
            si=size(ixp);
            mamty=repmat(mAMTY,prod(si),1);
            sAMTY=max(abs(curvey-mamty),[],1);
        end
        len=prod(size(mAMTY));
        upper=mAMTY+sAMTY;
        lower=mAMTY-sAMTY;
        lower(1,len)=upper(1,len);
        lower(1,1)=upper(1,1);
        avcurvey=[upper fliplr(lower)];
        avcurvex=[1:len fliplr(1:len)];
        eAMTYmean=[eAMTYmean; xmean(curvey,1)];
        if stdmax==0
            eAMTYstd=[eAMTYstd; xstd(curvey,1)];
        else
            eAMTYmax=[eAMTYmax; max(curvey,[],1)];
        end
        if filter==0
            fill(avcurvex,avcurvey,colors(nc,:)/255,'EdgeColor',colors(nc,:)/255,'FaceAlpha',transparency);
        end
    end
    %======================================================================================
    % Set labels
    %======================================================================================
    if filter==0
        labelcont=xsetlabels(labelcont,['## ' strrep(curwhat,'_','\_')],colors(nc,:)/255,maxy);
    end
    %======================================================================================
    % Update Output list
    %======================================================================================
    part1=cellstr('=================================');
    part2=cellstr(['Members of group ' curwhat]);
    part3=cellstr('--------------------------------------------');
    grppictures=cellstr(pictures(ixp,:));
    ecurwhat=[ecurwhat; cellstr(curwhat)];
    listpictures=[listpictures; part1;part2;part3;grppictures];
    set(0,'CurrentFigure',parent);
    set(handles.namesoutlist,'String',char(listpictures));
    set(0,'CurrentFigure',pfig);
    %======================================================================================
    % Make a pause, unless it is an export
    %======================================================================================
    if interruptbg==1 && exportnoplot==0 && n<ncomma
        pause
        set(0,'CurrentFigure',pfig);
    end
    if exportnoplot==1
        export.resx=[export.resx; curvex];
        export.resy=[export.resy; curvey];
        export.pictures=[export.pictures; grppictures];
        export.averagegrps.resx=[export.averagegrps.resx; curvex];
        export.averagegrps.mean=[export.averagegrps.mean; eAMTYmean];
        export.averagegrps.std=[export.averagegrps.std; eAMTYstd];
        export.averagegrps.max=[export.averagegrps.max; eAMTYmax];
        export.averagegrps.pictures=[export.averagegrps.pictures; grppictures];
    end
end
%======================================================================================
% If filter then make filter matrices
%======================================================================================
if filter==1
    [N,M]=size(eAMTYmean);
    degree=[];
    degreec=[];
    for n1=1:N
        for n2=n1+1:N
            if stdmax==0
                degree=[degree; abs(eAMTYmean(n1,:)-eAMTYmean(n2,:))-abs((eAMTYstd(n1,:)+eAMTYstd(n2,:)))];
            else
                degree=[degree; abs(eAMTYmean(n1,:)-eAMTYmean(n2,:))-abs((eAMTYmax(n1,:)+eAMTYmax(n2,:)))];
            end
            degreec=[degreec;cellstr([char(ecurwhat(n1,:)) '-+-' char(ecurwhat(n2,:))])];
        end
    end
    if ~isempty(filterval)
        ix=any(degree>filterval,1);
        degree=degree(:,find(ix));
    else
        ix=1:size(degree,2);
    end
    maxy=max(max(degree));
    miny=min(min(degree));
    set(get(gcf,'Children'),'YLimMode','Manual');
    set(get(gcf,'Children'),'YLim',[miny maxy ]);
    nc=1;
    nn=1;
    %======================================================================================
    % Plot etc. of the filter
    %======================================================================================
    for n1=1:N
        for n2=n1+1:N
            plot(degree(nn,:),'Color',colors(nc,:)/255,'LineWidth',linew);
            labelcont=xsetlabels(labelcont,['## ' strrep(char(degreec(nn,:)),'_','\_')],colors(nc,:)/255,maxy);
            if interruptbg==1
                pause
            end
            nc=nc+1;
            if nc>size(colors,1) nc=1; end
            nn=nn+1;
        end
    end
    if all(bgcolor=='black')
        avcolor=[255 255 255];
    else
        avcolor=[0 0 0];
    end
    overall=xmean(degree,1);
    plot(overall,'Color',avcolor/255,'LineWidth',linew*8);
    maxy=max([max(overall) maxy]);
    labelcont=xsetlabels(labelcont,['mean'],avcolor/255,maxy);
    %======================================================================================
    % If spectra are 2D-square, then make a 2D overall seperation plot
    %======================================================================================
    overallhot=[];
    N=round(sqrt(size(degree,2)));
    if abs(N-sqrt(size(degree,2)))==0
        overallhot=zeros(N,N,3);
        overallhot(:,:,1)=xreyscale(reshape(overall,N,N),0,255);
        overallhot(:,:,3)=xreyscale(reshape(-overall,N,N),0,255);
        figure,imshow(uint8(overallhot));
        %figure,imshow(uint8(xreyscale(reshape(overall,N,N),0,255)));
        title('Overall separation regions in 2D');
    end
end
%======================================================================================
% Finally, put the filter matrices into into export
% Must be done even though its is not a filter plot
%======================================================================================
if exportnoplot==1
    export.filter.sep=degree;
    export.filter.seplabel=degreec;
    export.filter.pictures=export.pictures;
    export.filter.spectray=export.resy(:,find(ix));
    export.filter.spectrax=find(ix);
    export.filter.spectraix=1:size(find(ix),2);
    export.filter.sep2D=overallhot;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end





