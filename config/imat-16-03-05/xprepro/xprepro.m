function varargout = xprepro(varargin)
% XPREPRO M-file for xprepro.fig
%      XPREPRO, by itself, creates a new XPREPRO or raises the existing
%      singleton*.
%
%      H = XPREPRO returns the handle to a new XPREPRO or the handle to
%      the existing singleton*.
%
%      XPREPRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XPREPRO.M with the given input arguments.
%
%      XPREPRO('Property','Value',...) creates a new XPREPRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xprepro_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xprepro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xprepro

% Last Modified by GUIDE v2.5 17-Nov-2004 01:25:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xprepro_OpeningFcn, ...
                   'gui_OutputFcn',  @xprepro_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%%%% COLOR DEFINITIONS color
%  Grå              [192 192 192]/256
%  Grøn+grå+mørk    [173 175 175]/256
%  MS borring       [236 233 216]/256
%
% A: [173 175 175]/256
% B: [173 175 180]/256
% C: [173 180 185]/256
%

function [xlim,ylim]=truncateaxes(xlim,ylim,n,m)
if xlim(2)>n xlim=[xlim(1) n]; end
if ylim(2)>m ylim=[ylim(1) m]; end
if xlim(1)<1 xlim=[1 xlim(2)]; end
if ylim(1)<1 ylim=[1 ylim(2)]; end



function [image]=xprepro_evalpreproc(handles,image)
set(handles.preproc,'Enable','Off');
set(handles.imagelist,'Enable','Off');
set(handles.histogram,'Enable','Off');
mfile=get(handles.usermfile,'String');
evalarg=['image=uint8(' mfile '(image,[]));'];
eval(evalarg);
eval(['clear ' mfile]);
set(handles.preproc,'Enable','On');
set(handles.imagelist,'Enable','On');
set(handles.histogram,'Enable','On');        



function xprepro_showhist(handles,image,filename,preprocessed)
h1=get(gcf,'CurrentAxes');
himage=get(h1);
channel=str2num(get(handles.channel,'String')');
if size(channel,1)==1
    if size(size(image),2)==3
        image=image(:,:,channel);    
    end
    xlim=round(himage.XLim);
    ylim=round(himage.YLim);
    [n m]=size(image);
    [xlim,ylim]=truncateaxes(xlim,ylim,n,m);
    txt='';
    if ~ischar(preprocessed)
        preprocessed=num2str(preprocessed);
    end
    if char(preprocessed)=='1'
        txt='Preprocessed.';    
    end
    figure;
    image=image';
    [bit,type]=xnumtype(image);
    image=double(image(ylim(1):ylim(2),xlim(1):xlim(2)));
    [N,M]=size(image);
    image=reshape(image,1,N*M);
    histo=hist(image,2^bit);
    bar(histo);
    title([txt strrep(char(filename),'_','\_')]);
end


function xprepro_showimage(image,filename,preprocessed,dump,keepz)
if keepz==1
    h1=get(gcf,'CurrentAxes');
    himage=get(h1);
    xlim=himage.XLim;
    ylim=himage.YLim;
end
txt='';
if ~ischar(preprocessed)
    preprocessed=num2str(preprocessed);
end
if char(preprocessed)=='1'
    txt='Preprocessed    ';
end
txt=[txt strrep(char(filename),'_','\_')];
if dump==1
    figure;
    imshow(image);
    title(txt);
else
    imshow(image);
end
if keepz==1
    h1=get(gcf,'CurrentAxes');
    set(h1,'XLim',xlim);
    set(h1,'YLim',ylim);
end



function [image]=xprepro_loadim(handles,filename)
varargin=get(handles.argframe,'UserData');
path=char(varargin{2});
extension=char(varargin{3});
image=imread([path xgetos filename]);
%if prod(size(size(image)))==3
%  image=image(:,:,3);
%  disp('Several channels. Taking channel 3.');
%end



function [ix]=xprepro_add2buffer(handles,image,filename,stoas)
buffer1=get(handles.bufferfield1,'UserData');
buffer2=get(handles.bufferfield2,'UserData');
[io1,io2,ix1,ix2,bufferimage]=xprepro_isinbuffer(handles,filename,stoas);
[N entries]=size(buffer2);
ix=N;
if io2==0
    buffer1(N+1).images=image;
    buffer2=[buffer2; cellstr(filename) cellstr(num2str(stoas))];
    set(handles.bufferfield1,'UserData',buffer1);
    set(handles.bufferfield2,'UserData',buffer2);
    ix=N+1;
end
if ix>20
   buffer1(1)=[];
   buffer2(1,:)=[];
   ix=ix-1;
end

function [io1,io2,ix1,ix2,image]=xprepro_isinbuffer(handles,filename,preprocessed)
% io1 = is filename present
% io2 = is filename present AND is it the good one.
io1=0;
ix1=0;
io2=0;
ix2=0;
buffer2=get(handles.bufferfield2,'UserData');
if ~isempty(buffer2)
    ix1=strcmp(filename,buffer2(:,1));
    io1=sum(ix1)>0;
end
image=0;
if io1==1
%    [io2]=ismember(num2str(preprocessed),char(buffer2(:,2)))
    ix2=num2str(preprocessed)==char(buffer2(:,2));
    ix2=ix2.*ix1;
    io2=(sum(ix2)>0);
    buffer1=get(handles.bufferfield1,'UserData');
    if  io2==1
        % image is in and is GOOD.
        image=buffer1(find(ix2)).images;
    else
        % image is present but Not the good one.
        image=buffer1(find(ix1)).images;
    end
end




% --- Executes just before xprepro is made visible.
function xprepro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xprepro (see VARARGIN)

% Choose default command line output for xprepro
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xprepro wait for user response (see UIRESUME)
% uiwait(handles.figure1);
nargs=size(varargin);
nargs=nargs(2);
set(handles.figure1,'Color',[173 175 175]/256);
set(handles.argframe,'UserData',varargin);
if nargs>1 path=varargin{2}; else 
    path=pwd;
    if varargin{1}==1
        installdir=get(gcf,'FileName');
        sep=installdir==xgetos;
        ix=find(sep);
        [dd six]=size(ix);
        ix=ix(six);
        path=installdir(1,1:ix);
    end
end
if nargs>2 extension=varargin{3}; else extension='*.tif'; end
if nargs>3 usermfile=varargin{4}; else usermfile='usermfile'; end
if nargs>4 channel=varargin{5}; else channel=1; end
varargin{2}=path;
varargin{3}=extension;
varargin{4}=usermfile;
varargin{5}=channel;
set(handles.argframe,'UserData',varargin);
set(handles.sourcedir,'String',path);
set(handles.usermfile,'String',usermfile);
set(handles.channel,'String',num2str(channel));
files=xdir([path xgetos extension]);
%sf=size(files);
%if sf(2)==0
%    path=pwd;
%    files='ueda.tif';
%end
set(handles.imagelist,'String',files);
if ~isempty(files)
    filename=char(files(1,:));
    image=imread([path xgetos filename]);
    channel=str2num(channel');
    xprepro_showimage(image(:,:,channel),filename,'0',0,0);
    [ix]=xprepro_add2buffer(handles,image,filename,0);
    set(handles.curimage,'UserData',ix);
    h1=get(gcf,'CurrentAxes');
    himage=get(h1);
    xlim=himage.XLim;
    ylim=himage.YLim;
    set(handles.resetaxes,'UserData',[xlim;ylim]);    
end

% --- Outputs from this function are returned to the command line.
function varargout = xprepro_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function imagelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[192 192 192]/256);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in imagelist.
function imagelist_Callback(hObject, eventdata, handles)
% hObject    handle to imagelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns imagelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imagelist
varargin=get(handles.argframe,'UserData');
path=varargin{2};
extension=varargin{3};
preprocessed=get(handles.preproc,'Value');
histogram=get(handles.histogram,'Value');
val=get(handles.imagelist,'Value');
images=get(handles.imagelist,'String');
showlower=get(handles.showlower,'Value');
showupper=get(handles.showupper,'Value');
filename=char(images(val,:));
[io1,io2,ix1,ix2,image]=xprepro_isinbuffer(handles,filename,preprocessed);
ix=find(ix2);
if io1==0
    image=imread([path xgetos filename]);
    ix=xprepro_add2buffer(handles,image,filename,0);
end
if io2==0 && preprocessed==1
    image=xprepro_evalpreproc(handles,image);
    ix=xprepro_add2buffer(handles,image,filename,1);
end
channel=get(handles.channel,'String');   
channel=str2num(channel');
image=image(:,:,channel);
xprepro_showimage(image(:,:,channel),filename,preprocessed,0,1);    
set(handles.curimage,'UserData',ix);
if showlower
  showlower_Callback(hObject, eventdata, handles)
end
if showupper
  showupper_Callback(hObject, eventdata, handles)
end
if histogram==1
    xprepro_showhist(handles,image,filename,preprocessed);
end


% --- Executes on button press in dumpm.
function dumpm_Callback(hObject, eventdata, handles)
% hObject    handle to dumpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xans;
h1=get(gcf,'CurrentAxes');
himage=get(h1);
xlim=round(himage.XLim);
ylim=round(himage.YLim);
curix=get(handles.curimage,'UserData');
buffer2=get(handles.bufferfield2,'UserData');
channels=str2num(get(handles.channel,'String')');
if ~isempty(buffer2)
    filename=char(buffer2(curix,1));
    preprocessed=get(handles.preproc,'Value');
    [io1,io2,ix1,ix2,image]=xprepro_isinbuffer(handles,filename,preprocessed);
    if ~io2 && preprocessed==1
        image=xprepro_evalpreproc(handles,image);
    end
    [n,m,c]=size(image);
    image=image(:,:,channels);
    [xlim,ylim]=truncateaxes(xlim,ylim,n,m);
    eval(['xans= image(' num2str(ylim(1))  ':' num2str(ylim(2)) ',' num2str(xlim(1)) ':' num2str(xlim(2)), ',:' ')']);
end




% --- Executes on button press in preproc.
function preproc_Callback(hObject, eventdata, handles)
% hObject    handle to preproc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargin=get(handles.argframe,'UserData');
path=varargin(2);
preprocessed=get(handles.preproc,'Value');
curix=get(handles.curimage,'UserData');
buffer2=get(handles.bufferfield2,'UserData');
if ~isempty(buffer2)
    filename=char(buffer2(curix,1));
    channel=get(handles.channel,'String');   
    channel=str2num(channel');
    [io1,io2,ix1,ix2,image]=xprepro_isinbuffer(handles,filename,preprocessed);
    if io1==0
        image=xprepro_loadim(handles,filename);
        ix=xprepro_add2buffer(handles,image,filename,0);
    end    
    if io2==0
        image=xprepro_evalpreproc(handles,image);
        ix=xprepro_add2buffer(handles,image,filename,1);
    end
if size(size(image),2)==3
    image=image(:,:,channel);
end
    showlower=get(handles.showlower,'Value');
    if showlower==1
        image=double(image);
        lower=get(handles.lowercutoff,'String');
        if ~isempty(lower)
            ok=image>str2num(lower);
            image=uint8(image.*ok);        
            xprepro_showimage(image,filename,preprocessed,0,1);
        end
    end
    showupper=get(handles.showupper,'Value');
    if showupper==1
        image=double(image);
        upper=get(handles.uppercutoff,'String');
        if ~isempty(upper)
            ok=image<str2num(upper);
            image=uint8(image.*ok);
            xprepro_showimage(image,filename,preprocessed,0,1);
        end
    end
    xprepro_showimage(image,filename,preprocessed,0,1);    
end


% --- Executes during object creation, after setting all properties.
function lowercutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowercutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[173 175 180]/256);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function lowercutoff_Callback(hObject, eventdata, handles)
% hObject    handle to lowercutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowercutoff as text
%        str2double(get(hObject,'String')) returns contents of lowercutoff as a double
value=get(handles.lowercutoff,'String');
sv=size(value);
nvalue=str2num(value);
if sv(2)>0 && isempty(nvalue)
    set(handles.lowercutoff,'BackgroundColor','red');
else
    set(handles.lowercutoff,'BackgroundColor',[173 175 180]/256);
    showlower_Callback(hObject, eventdata, handles)
end






% --- Executes during object creation, after setting all properties.
function uppercutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uppercutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[173 175 180]/256);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function uppercutoff_Callback(hObject, eventdata, handles)
% hObject    handle to uppercutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uppercutoff as text
%        str2double(get(hObject,'String')) returns contents of uppercutoff as a double
value=get(handles.uppercutoff,'String');
sv=size(value);
nvalue=str2num(value);
if sv(2)>0 && isempty(nvalue)
    set(handles.uppercutoff,'BackgroundColor','red');
else
    set(handles.uppercutoff,'BackgroundColor',[173 175 180]/256);
    showupper_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in dump.
function dump_Callback(hObject, eventdata, handles)
% hObject    handle to dump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curix=get(handles.curimage,'UserData');
buffer2=get(handles.bufferfield2,'UserData');
if ~isempty(buffer2)
    filename=char(buffer2(curix,1));
    preprocessed=get(handles.preproc,'Value');
    [io1,io2,ix1,ix2,image]=xprepro_isinbuffer(handles,filename,preprocessed);
    if ~io2 && preprocessed==1
        image=xprepro_evalpreproc(handles,image);
    end    
    channel=get(handles.channel,'String');   
    channel=str2num(channel');
    xprepro_showimage(image(:,:,channel),filename,preprocessed,1,1);
end







% --- Executes on button press in analyse.
function analyse_Callback(hObject, eventdata, handles)
% hObject    handle to analyse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in openm.
function openm_Callback(hObject, eventdata, handles)
% hObject    handle to openm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
usermfile=get(handles.usermfile,'String');
path=get(handles.sourcedir,'String');
su=size(usermfile);
if all(usermfile(su(2)-1:su(2))=='.m')
  extension='';
else
    extension='.m';
end
files=dir([ imat_instpath imat_userpath  usermfile extension]);
[f1 f2]=size(files);
if f1==1
  open(usermfile);
else
  fp=fopen([ imat_instpath imat_userpath usermfile extension],'w');
  txt1=['function [X,background,userpar,N,M]=' usermfile '(X,background)'];
  txt2='% Image (X) must be of type uint8';
  txt3='% Output N and M are the new dimensions of the image';
  txt4='% --- If you know what you are doing, then change ...';
  txt5='userpar=[];';
  txt6='X=double(X);';
  txt7='[N,M]=size(X);';
  txt8='% --- Type Your Matlab code here ...';
  fprintf(fp,'%s\n',txt1);
  fprintf(fp,'%s\n',txt2);
  fprintf(fp,'%s\n',txt3);
  fprintf(fp,'%s\n',txt4);
  fprintf(fp,'%s\n',txt5);
  fprintf(fp,'%s\n',txt6);
  fprintf(fp,'%s\n',txt7);
  fprintf(fp,'%s\n',txt8);
  fclose(fp);
  open([ imat_instpath imat_userpath usermfile extension]);
end
set(handles.usermfile,'BackgroundColor',[173 180 185]/256);


% --- Executes on button press in histogram.
function histogram_Callback(hObject, eventdata, handles)
% hObject    handle to histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
histogram=get(handles.histogram,'Value');
if histogram==1
    curix=get(handles.curimage,'UserData');
    buffer2=get(handles.bufferfield2,'UserData');
    if ~isempty(buffer2)
        filename=char(buffer2(curix,1));
        preprocessed=get(handles.preproc,'Value');
        [io1,io2,ix1,ix2,image]=xprepro_isinbuffer(handles,filename,preprocessed);
        if io2 && preprocessed==1
            image=xprepro_evalpreproc(handles,image);
        end    
        xprepro_showhist(handles,image,filename,preprocessed);    
    end
end


% --- Executes on button press in clearplain.
function clearprepro_Callback(hObject, eventdata, handles)
% hObject    handle to clearplain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% buffer2=[filename preprocessed];
buffer1=get(handles.bufferfield1,'UserData');
buffer2=get(handles.bufferfield2,'UserData');
preprocessed=str2num(char(buffer2(:,2)));
ix=find(preprocessed==1);
buffer2(ix,:)=[];
buffer1(ix)=[];
set(handles.bufferfield1,'UserData',buffer1);
set(handles.bufferfield2,'UserData',buffer2);
mfile=get(handles.usermfile,'String');
eval(['clear ' mfile]);
set(handles.histogram,'Enable','On');
set(handles.preproc,'Enable','On');
set(handles.imagelist,'Enable','On');
set(handles.histogram,'Value',0);
set(handles.preproc,'Value',0);


% --- Executes on button press in clearprepro.
function clearplain_Callback(hObject, eventdata, handles)
% hObject    handle to clearprepro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% buffer2=[filename preprocessed];
buffer1=get(handles.bufferfield1,'UserData');
buffer2=get(handles.bufferfield2,'UserData');
preprocessed=str2num(char(buffer2(:,2)));
ix=find(preprocessed==0);
buffer2(ix,:)=[];
buffer1(ix)=[];
set(handles.bufferfield1,'UserData',buffer1);
set(handles.bufferfield2,'UserData',buffer2);


% --- Executes on button press in showlower.
function showlower_Callback(hObject, eventdata, handles)
% hObject    handle to showlower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargin=get(handles.argframe,'UserData');
path=varargin{2};
extension=varargin{3};
showlower=get(handles.showlower,'Value');
preprocessed=get(handles.preproc,'Value');
val=get(handles.imagelist,'Value');
images=get(handles.imagelist,'String');
if ~isempty(images)
    filename=char(images(val,:));
    channel=get(handles.channel,'String');   
    channel=str2num(channel');
    [io1,io2,ix1,ix2,image]=xprepro_isinbuffer(handles,filename,preprocessed);
    ix=find(ix2);
    if io1==0
        image=imread([path xgetos filename]);
        %    if prod(size(size(image)))==3
        %  image=image(:,:,3);
        %  disp('Several channels. Taking channel 3.');
        %end
        
        ix=xprepro_add2buffer(handles,image,filename,0);
    end
    if io2==0 && preprocessed==1
        image=xprepro_evalpreproc(handles,image);
        ix=xprepro_add2buffer(handles,image,filename,1);
    end
    if size(image,3)>=channel
            image=image(:,:,channel);
        set(handles.channel,'BackgroundColor',[173 180 185]/256)
        if showlower==1
            image=double(image);
            lower=get(handles.lowercutoff,'String');
            if ~isempty(lower)
                ok=image>str2num(lower);
                image=uint8(image.*ok);
                xprepro_showimage(image,filename,preprocessed,0,1);
            end
        else
            xprepro_showimage(image,filename,preprocessed,0,1);
        end
    else
        set(handles.channel,'BackgroundColor','red');
    end
end
    

% --- Executes on button press in showupper.
function showupper_Callback(hObject, eventdata, handles)
% hObject    handle to showupper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargin=get(handles.argframe,'UserData');
path=varargin{2};
extension=varargin{3};
showupper=get(handles.showupper,'Value');
preprocessed=get(handles.preproc,'Value');
val=get(handles.imagelist,'Value');
images=get(handles.imagelist,'String');
if ~isempty(images)
    filename=char(images(val,:));
    channel=get(handles.channel,'String');   
    channel=str2num(channel');
    [io1,io2,ix1,ix2,image]=xprepro_isinbuffer(handles,filename,preprocessed);
    ix=find(ix2);
    if io1==0
        image=imread([path xgetos filename]);
        %if prod(size(size(image)))==3
        %  image=image(:,:,3);
        %  disp('Several channels. Taking channel 3.');
        %end
        
        ix=xprepro_add2buffer(handles,image,filename,0);
    end
    if io2==0 && preprocessed==1
        image=xprepro_evalpreproc(handles,image);
        ix=xprepro_add2buffer(handles,image,filename,1);
    end
    if size(image,3)>=channel
        image=image(:,:,channel);
        set(handles.channel,'BackgroundColor',[173 180 185]/256);
        if showupper==1
            image=double(image);
            upper=get(handles.uppercutoff,'String');
            if ~isempty(upper)
                ok=image<str2num(upper);
                image=uint8(image.*ok);
                xprepro_showimage(image,filename,preprocessed,0,1);
            end
        else
            xprepro_showimage(image,filename,preprocessed,0,1);
        end
        
    else
        set(handles.channel,'BackgroundColor','red');       
    end
end


% --- Executes during object creation, after setting all properties.
function usermfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to usermfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[173 180 185]/256);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function usermfile_Callback(hObject, eventdata, handles)
% hObject    handle to usermfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of usermfile as text
%        str2double(get(hObject,'String')) returns contents of usermfile as a double
usermfile=get(handles.usermfile,'String');
files=dir([ imat_instpath imat_userpath usermfile '.m']);
[f1 f2]=size(files);
if f1==1
    set(hObject,'BackgroundColor',[173 180 185]/256);
    clearprepro_Callback(hObject, eventdata, handles)
else
    set(hObject,'BackgroundColor','yellow');
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function sourcedir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sourcedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[173 180 185]/256);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function sourcedir_Callback(hObject, eventdata, handles)
% hObject    handle to sourcedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sourcedir as text
%        str2double(get(hObject,'String')) returns contents of sourcedir as a double
source=get(handles.sourcedir,'String');
clearprepro_Callback(hObject, eventdata, handles)
clearplain_Callback(hObject, eventdata, handles)
xprepro(1,source,'*.tif');


% --- Executes on button press in resetaxes.
function resetaxes_Callback(hObject, eventdata, handles)
% hObject    handle to resetaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%axes=get(handles.resetaxes,'UserData');
h1=get(gcf,'CurrentAxes');
% himage=get(h1);
% set(h1,'XLim',axes(1,:));
% set(h1,'YLim',axes(2,:));
preprocessed=get(handles.preproc,'Value');
val=get(handles.imagelist,'Value');
images=get(handles.imagelist,'String');
filename=char(images(val,:));
[io1,io2,ix1,ix2,image]=xprepro_isinbuffer(handles,filename,preprocessed);
[N,M,C]=size(image);
set(h1,'XLim',[1 M]);
set(h1,'YLim',[1 N]);



% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in increasecutoff.
function increasecutoff_Callback(hObject, eventdata, handles)
% hObject    handle to increasecutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
upper=get(handles.showupper,'Value');
lower=get(handles.showlower,'Value');
if upper==1 && lower==0
    uppercutoff=get(handles.uppercutoff,'String');
    uppercutoff=num2str(str2num(uppercutoff)+1);
    set(handles.uppercutoff,'String',uppercutoff);
    uppercutoff_Callback(hObject, eventdata, handles);
end
if upper==0 && lower==1
    lowercutoff=get(handles.lowercutoff,'String');
    lowercutoff=num2str(str2num(lowercutoff)+1);
    set(handles.lowercutoff,'String',lowercutoff);
    lowercutoff_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in decreasecutoff.
function decreasecutoff_Callback(hObject, eventdata, handles)
% hObject    handle to decreasecutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
upper=get(handles.showupper,'Value');
lower=get(handles.showlower,'Value');
if upper==1 && lower==0
    uppercutoff=get(handles.uppercutoff,'String');
    uppercutoff=num2str(str2num(uppercutoff)-1);
    set(handles.uppercutoff,'String',uppercutoff);
    uppercutoff_Callback(hObject, eventdata, handles);
end
if upper==0 && lower==1
    lowercutoff=get(handles.lowercutoff,'String');
    lowercutoff=num2str(str2num(lowercutoff)-1);
    set(handles.lowercutoff,'String',lowercutoff);
    lowercutoff_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[173 180 185]/256);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function channel_Callback(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channel as text
%        str2double(get(hObject,'String')) returns contents of channel as a double
channel=get(handles.channel,'String');
channel=str2num(channel');
if (size(channel,1)==1 && any(channel==[1,2,3])) || size(channel,1)==3 && any(channel==[1,2,3]')
    set(hObject,'BackgroundColor',[173 180 185]/256);
    upper=get(handles.showupper,'Value');
    lower=get(handles.showlower,'Value');
    uppercutoff=get(handles.uppercutoff,'String');
    uppercutoff_Callback(hObject, eventdata, handles);
    lowercutoff=get(handles.lowercutoff,'String');
    lowercutoff_Callback(hObject, eventdata, handles);
    
else
    set(handles.channel,'BackgroundColor','red');    
end



