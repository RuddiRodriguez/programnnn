function [imato]=imat_main(imati,handles,sigma)
% From batch :  imat_mai(imati,[])
%
warning off all;
set(handles.Run,'String','Running...');
set(handles.Run,'ForegroundColor','red');

sprepro=0;
userpar=[];
RESX=[];
RESY=[];
GEO1=[];
GEO2=[];
percent_loweronhill=[];
percent_upperonhill=[];
percent_lowerplus=[];
percent_upperplus=[];

pictures=[];
colordistwarnings=[];
piterwarnings=[];
background=[];


imatuserpre1=textread([ imat_instpath imat_userpath imati.analysis.preprofile '.m'],'%s','delimiter','\n','whitespace','');
imatuserpost1=textread([ imat_instpath imat_userpath imati.analysis.postprofile '.m'],'%s','delimiter','\n','whitespace','');



cutoff=0;
PICS=imat_file(imati);

picno=0;
no=size(PICS);
no=no(1);
exittest=0;
time_start=clock;
while picno<no
    picno=picno+1;
    filename=PICS(picno).name;
    if imati.source.single==0
        OpenFile = [imati.source.path xgetos filename];
    else
        OpenFile = [imati.source.path];
    end
    pictures=[pictures;cellstr(filename)];
    sfn=size(filename);
    EXTENSION=filename(1,sfn(2)-2:sfn(2));
    if all(EXTENSION~='dat')
        imgdat=feval('imread',OpenFile);
        IMBIT=isa(imgdat,'uint8');
        IMBIT=[IMBIT isa(imgdat,'uint16')];
        IMBIT=[IMBIT isa(imgdat,'uint32')];
        IMBIT=[IMBIT isa(imgdat,'uint64')];
        IMBIT=sum(IMBIT.*[8 16 32 64]);
        imgdat=imat_router_channal(imgdat,imati.source.channel);
    else
        x=load(OpenFile);        
        entry=fields(x);
        entry=char(entry(1));
        imgdat=eval(['x.' entry]);
        clear x;
    end
        if imati.source.resize~=1
            rsimg=imresize(imgdat,imati.source.resize);
        else
            rsimg=imgdat;
        end
        [N M]=size(rsimg);
        
        X=rsimg;
        [N M]=size(X);
        X=double(X);
        rsimg=double(rsimg);
        
        
        
        
        if imati.cutting.removebg==1
            border=[(1:N)' repmat(1,N,1); (1:N)' repmat(M,N,1); repmat(1,1,M)' (1:M)' ; repmat(N,1,M)' (1:M)'];
            background=imat_prepare_background(rsimg,imati.cutting.bgcutoff,0,border);
        else
            background=zeros(N,M);
        end
        
        if imati.analysis.prepro==1
            [X,background,userpar,N,M]=eval([imati.analysis.preprofile '(X,background);']);
            X=double(X);
            if imati.sys.softdelay~=0
                pause(imati.sys.softdelay);
            end
        end
        
        if imati.analysis.unfold==1 && imati.analysis.method==1
            sf=size(filename);
            [fn extension]=xstripfilename(filename);
            imwrite(uint8(X),[char(imati.source.path) xgetos char(fn) char(imati.output.index) '.' char(extension)]);        
            pause(imati.sys.softdelay);
            sprepro=1;
        end
    
    
    if sprepro==0
        % Cutoff
        % Only detect, no action (removal)
        [cfpoints_loweronhill,cfpoints_upperonhill,cfpoints_lowerplus,cfpoints_upperplus,cfpc_loweronhill,cfpc_upperonhill,cfpc_lowerplus,cfpc_upperplus]=imat_prepare_cutoff(imati,X);
        if imati.cutting.type.onhill==1
            percent_loweronhill=[percent_loweronhill ; cfpc_loweronhill];
            percent_upperonhill=[percent_upperonhill ; cfpc_upperonhill];
        end
        if imati.cutting.type.plus==1
            percent_lowerplus=[percent_lowerplus cfpc_lowerplus];
            percent_upperplus=[percent_upperplus cfpc_upperplus];
        end
        
        if imati.cutting.type.plus==1
            bg1=X<imati.cutting.lowercutoff;
            bg2=X>imati.cutting.uppercutoff;
            background=(background+bg1+bg2)>0;
        end
        
        if imati.analysis.unfold~=1
            X=imat_prepare_unfold(X,imati.analysis.unfold);
            bgunfolded=imat_prepare_unfold(background,imati.analysis.unfold);            
            X=X(find(~bgunfolded));
        else
            X=imat_prepare_unfold(X,imati.analysis.unfold);
            bgunfolded=imat_prepare_unfold(background,imati.analysis.unfold);                        
        end
        [resx,resy,Piter,time_analysis1,time_analysis2] = imat_router_method(imati,background,rsimg,X,picno,userpar);
        if imati.sys.softdelay~=0
            pause(imati.sys.softdelay);
        end
        if Piter<1
            piterwarnings=strvcat(piterwarnings , filename);
        end
        if imati.analysis.postpro==1
            [RESX,resx,RESY,resy]=eval([imati.analysis.postprofile '(RESX,resx,RESY,resy);']);
        end
        if picno>1
            [RESX,resx]=xexpandarray(RESX,resx,NaN);
            [RESY,resy]=xexpandarray(RESY,resy,NaN);
        end
        RESX=[RESX;resx];
        RESY=[RESY;resy];
        
    end
    time_end=clock;
    if ~isempty(handles)
        [tdiff,hours,minutes,seconds]=xtime(time_start,time_end);
        total_seconds=tdiff;
        total_seconds_all=tdiff/picno*no;
        progresstxt=[' <One im> = ' num2str(total_seconds_all/no) ' sec.'];
        [tdiff,hours,minutes,seconds]=xtime(time_start,time_end,total_seconds_all);
        progresstxt1=['Tot time = ' xlastcol(['0' num2str(hours)],2) ':' xlastcol(['0' num2str(minutes)],2) ':' xlastcol(['0' num2str(seconds)],2)];
        progresstxt2=[ filename '      ' num2str(picno) '.' num2str(no)];
        set(handles.progresstxt,'String',progresstxt);
        set(handles.progresstxt1,'String',progresstxt1);
        set(handles.progresstxt2,'String',progresstxt2);
    end
    
end % while  pic
if ~(imati.analysis.unfold==1 && imati.analysis.method==1)
    time_end=clock;
    imato=imat_save(imati,RESX,RESY,pictures,percent_loweronhill,percent_upperonhill,percent_lowerplus,percent_upperplus,time_start,time_end,imatuserpre1,imatuserpost1);
    set(handles.resholder,'UserData',imato);
end
set(handles.Run,'String','Run');
set(handles.Run,'ForegroundColor','black');

