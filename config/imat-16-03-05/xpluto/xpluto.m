function varargout = xpluto(varargin)
% xpluto(imato.resx,imato.resy,imato.pictures)
% XPLUTO M-file for xpluto.fig
%      XPLUTO, by itself, creates a new XPLUTO or raises the existing
%      singleton*.
%
%      H = XPLUTO returns the handle to a new XPLUTO or the handle to
%      the existing singleton*.
%
%      XPLUTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XPLUTO.M with the given input arguments.
%
%      XPLUTO('Property','Value',...) creates a new XPLUTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xpluto_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xpluto_OpeningFcn via varargin.
%
%      *See GUI Options on REMGR's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: REMGR, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xpluto

% Last Modified by REMGR v2.5 20-Oct-2004 00:59:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @xpluto_OpeningFcn, ...
    'gui_OutputFcn',  @xpluto_OutputFcn, ...
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


function showinfo(handles,txt)
set(handles.information,'ForegroundColor',[190 44 44]/255);
set(handles.information,'String',txt);    



function [newa,newb]=listalter(fromdata,todata,pos)
object=fromdata(pos,:);
sizefd=size(fromdata,1);
newa=fromdata(find((1:sizefd)~=pos),:);
newb=[todata;object];


% --- Executes just before xpluto is made visible.
function xpluto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no done args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xpluto (see VARARGIN)
%options=[cellstr('0') cellstr('1') cellstr('0') cellstr('0') cellstr('1') cellstr('0') cellstr('0.5') cellstr('black') cellstr('')];
options=[cellstr('0') cellstr('1') cellstr('0') cellstr('0') cellstr('1') cellstr('0') cellstr('0.5') cellstr('black') cellstr('') cellstr('0') cellstr('0') cellstr('1') cellstr('0') cellstr('')];
set(handles.options,'UserData',options);

% Choose default command line done for xpluto
handles.done = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xpluto wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.definegroup,'Enable','On');
set(handles.definegroup,'UserData',[]);
if prod(size(varargin))==3
    loadx=varargin{1};
    if isempty(loadx)
        sy=size(loady);
        temp=1:sy(2);
        loadx=repmat(sy(1),1,temp);
    end
    loady=varargin{2};
    loadn=varargin{3};
    [guidetxt,loadx,loady,loadn]=xcheckxyn(loadx,loady,loadn);
    if prod(size(guidetxt))~=0
        showinfo(handles,guidetxt);       
    end    
    if ~isstruct(loadx)
        %        field=fieldnames(loady);
        eval(['loadx.AMT=loadx;']);
        set(handles.loadx,'UserData',loadx);
    end

    if ~isstruct(loady)
        %        field=fieldnames(loady);
        eval(['loady.AMT=loady;']);
        set(handles.loady,'UserData',loady);
    end
    if ~isstruct(loadn)       
        %        field=fieldnames(loadn);
        eval(['loadn.AMT=loadn;']);
        set(handles.loadn,'UserData',loadn);
    end
end
colors=xhardcolor(1);
scolors=size(colors);
colors1=colors(1:6,:);
colors2=colors(7:scolors(1),:);
set(handles.colors,'Value',1);
set(handles.colors,'String',num2str(colors2));
set(handles.colororder,'Value',1);
set(handles.colororder,'String',num2str(colors1));





% --- Outputs from this function are returned to the command line.
function varargout = xpluto_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning done args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line done from handles structure
varargout{1} = handles.done;


% --- Executes on button press in loadx.
function loadx_Callback(hObject, eventdata, handles)
% hObject    handle to loadx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);
errormessage=0;
lastpath=get(handles.pathstorage,'UserData');
curpath=pwd;
if ~isempty(lastpath)
    cd(lastpath);
end
[loadxs,xpath] = uigetfile('*.dat;*.mat','');
cd(curpath);
if xpath~=0
    set(handles.pathstorage,'UserData',xpath);
end
if loadxs~=0
    loadx=load([xpath loadxs]);
    set(handles.loadx,'TooltipString',[xpath loadxs]);    
    field=fieldnames(loadx);
    xstructbrowse(loadx,'loadx',handles);
end

% --- Executes on button press in loady.
function loady_Callback(hObject, eventdata, handles)
% hObject    handle to loady (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);
errormessage=0;
lastpath=get(handles.pathstorage,'UserData');
curpath=pwd;
if ~isempty(lastpath)
    cd(lastpath);
end
[loadys,ypath] = uigetfile('*.dat;*.mat','');
cd(curpath);
if ypath~=0
    set(handles.pathstorage,'UserData',ypath);
end
if loadys~=0
    loady=load([ypath loadys]);
    set(handles.loady,'TooltipString',[ypath loadys]);    
    field=fieldnames(loady);
    xstructbrowse(loady,'loady',handles);
end


% --- Executes on button press in loadn.
function loadn_Callback(hObject, eventdata, handles)
% hObject    handle to loadn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);
errormessage=0;
lastpath=get(handles.pathstorage,'UserData');
curpath=pwd;
if ~isempty(lastpath)
    cd(lastpath);
end
[loadns,npath] = uigetfile('*.dat;*.mat','');
cd(curpath);
if npath~=0
    set(handles.pathstorage,'UserData',npath);
end
if loadns~=0
    loadn=load([npath loadns]);
    set(handles.loadn,'TooltipString',[npath loadns])
    fieldn=fieldnames(loadn);
    xstructbrowse(loadn,'loadn',handles);
end

% --- Executes on button press in options.
function options_Callback(hObject, eventdata, handles)
% hObject    handle to options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);
xplutooptions(handles,gcf);




% --- Executes on button press in soft.
function undogr_Callback(hObject, eventdata, handles)
% hObject    handle to soft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);
undos=get(handles.undogr,'UserData');
if ~isempty(undos)
    pos=size(undos);
    recreate=undos(pos(1));
    undos=undos(1:pos(1)-1);
    set(handles.loadn,'UserData',recreate);
    shownames_Callback(hObject, eventdata, handles);
end




% --- Executes on button press in definegroup.
function definegroup_Callback(hObject, eventdata, handles)
% hObject    handle to definegroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newnames=[];
container1=[];
groupix=get(handles.groupix,'UserData');
set(handles.information,'String','');
acton=get(handles.acton,'String');
val=get(handles.acton,'Value');
groupprefix=get(handles.groupprefix,'String');
names=get(handles.loadn,'UserData');
syntax=char(get(handles.syntax,'String'));
plotby=char(get(handles.plotby,'String'));
groups=char(get(handles.groupstoplot,'String'));
if ~isempty(groupprefix) && ~isempty(names) && ~isempty(syntax) && ~isempty(plotby) && ~isempty(groups)
    undos=get(handles.undogr,'UserData');
    undos=[undos;names];
    if size(undos)>5
        undos=undos(2:6);
    end
    set(handles.undogr,'UserData',undos);
    if all(size(char(acton(val,:)))==size('Names in output'))
        if all(char(acton(val,:))=='Names in output')
            fieldn=fieldnames(names);
            pos12=get(handles.definegroup,'UserData');
            ix=min([pos12]):max([pos12]);
            newnames=eval(['names.' char(fieldn)]);
            for g=ix
                newnames(g,:)=cellstr([groupprefix char(newnames(g,:))]);    
            end
            set(handles.possiblegroups,'String','');
            set(handles.groupstoplot,'String','');
            eval(['names.' char(fieldn) '=(newnames);']);
            set(handles.loadn,'UserData',names);
            set(handles.definegroup,'UserData',[]);
            set(handles.definegroup,'Enable','Off');
            shownames_Callback(hObject, eventdata, handles);
            container1=groups;
        end
    end 
    if all(size(char(acton(val,:)))==size('Groups to plot'))    
        if all(char(acton(val,:))=='Groups to plot')
            allnames=names;
            fieldn=fieldnames(allnames);
            allnames=eval(['allnames.' char(fieldn)]);
            sall=size(allnames);
            [dummy,dummy,NUMBERARRAY,STRINGARRAY]=xgroups(syntax,plotby,allnames);
            out=xdecomposegroups(STRINGARRAY,NUMBERARRAY,plotby,syntax);       
            sgtp=size(groups);
            newnames=allnames;
            for n=1:sgtp(1)
                ixnames=xnamesofgroup(groups(n,:),out,allnames,1,groupix);
                sallnames=size(allnames);           
                newnames(ixnames,:)=cellstr([repmat(groupprefix,size(ixnames'),1) char(newnames(ixnames,:))]);
                groupix=[groupix ixnames];
            end
            set(handles.groupix,'UserData',groupix);
        end
        eval(['newnames.' char(fieldn) '=(newnames);']);
        set(handles.loadn,'UserData',newnames);
        set(handles.definegroup,'UserData',[]);
        shownames_Callback(hObject, eventdata, handles);
        container1=groups;
    end
else
    showinfo(handles,'Incomplete specifications');
end
if ~isempty(container1)    
    container=char(get(handles.container,'UserData'));
    if ~isempty(container)    
        container=[cellstr(container); cellstr(char(container1))];
        container=unique(container);
    else
        container=cellstr(container1);    
    end
    set(handles.container,'UserData',container);
end
if ~isempty(newnames)
    [syntax,errormessage]=xgetsyntax(eval(['newnames.' char(fieldn)]));
    if ~isnumeric(errormessage)
        showinfo(handles,[ 'Grouping not complete. ' errormessage]);
        set(handles.syntax,'Enable','Off');
        set(handles.probesyntax,'Enable','Off');
        set(handles.plotby,'Enable','Off');
    else
        showinfo(handles,'Do probe the new syntax !!');
        set(handles.syntax,'Enable','On');
        set(handles.probesyntax,'Enable','On');
        set(handles.plotby,'Enable','On');        
        set(handles.container,'UserData','');
        set(handles.groupix,'UserData',[]);
    end
end



% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);
A=get(handles.loady,'UserData');
B=get(handles.loadn,'UserData');
if (~isempty(A)) && (~isempty(B))
    X=get(handles.loadx,'UserData');
    if isempty(X)
        af=char(fieldnames(A));
        [temp1 temp2]=size(eval(['A.' af]));
        X.scale=repmat(1:temp2,temp1,1);
    end    
    syntax=get(handles.syntax);
    plotby=get(handles.plotby);
    what=get(handles.groupstoplot);
    colors=get(handles.colororder);
    plottype=isempty(syntax.String) || isempty(plotby.String) || isempty(colors.String);
    switch plottype
        case 1
            errormessage='Incomplete specifications for grouped plotting. Plotted with arbitrary colors.';
            af=char(fieldnames(A));
            figure,plot(eval(['A.' af])');
            showinfo(handles,errormessage);
        case 0
            if (~isempty(what.String))
                sw=size(what.String);
                wwhat=[''];
                for n=1:sw(1)-1
                    wwhat=[wwhat char(what.String(n,:)) ','];
                end
                wwhat=[wwhat char(what.String(sw(1),:))];
            else
                errormessage='Incomplete specifications. Select some groups.';                
                showinfo(handles,errormessage);
                return;
            end
            xf=char(fieldnames(X));
            af=char(fieldnames(A));
            bf=char(fieldnames(B));
            options=get(handles.options,'UserData');
            xpluto_plotter(eval(['X.' xf]),eval(['A.' af]),eval(['B.' bf]),char(syntax.String),char(plotby.String),wwhat,str2num(char(colors.String)),handles,gcf,options);            
    end
else
    showinfo(handles,'No data to plot.');
end

% --- Executes on button press in remgr.
function remgr_Callback(hObject, eventdata, handles)
% hObject    handle to remgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
container=get(handles.container,'UserData');
pgroups=get(handles.possiblegroups,'String');
ix=find(~ismember(pgroups,container));
set(handles.possiblegroups,'String',pgroups(ix,:));
set(handles.groupstoplot,'String',container);

% --- Executes on button press in probesyntax.
function probesyntax_Callback(hObject, eventdata, handles)
% hObject    handle to probesyntax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);
names=get(handles.loadn);
if ~isempty(names.UserData)
    field=fieldnames(names.UserData);
    thenames=eval(['names.UserData.' char(field)]);
    if ~isempty(thenames)
        [syntax,errormessage]=xgetsyntax(thenames);
        if errormessage==0
            set(handles.syntax, 'String', syntax);
            set(handles.syntax,'BackgroundColor',[206 215 215]/255)
        else
            showinfo(handles,errormessage);
        end
    else
        showinfo(handles,'Incomplete specifications');
    end
else
        showinfo(handles,'First, you must load data.');
end


% --- Executes on button press in probeithink.
function probeithink_Callback(hObject, eventdata, handles)
% hObject    handle to probeithink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);
syntax=get(handles.syntax,'String');
t=size(char(syntax),2)-2;
ithink=[];
for j=1:t-1
  ithink=[ithink num2str(j) ','];
end
  ithink=[ithink num2str(t)];
set(handles.plotby,'String',ithink);
plotby_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function possiblegroups_CreateFcn(hObject, eventdata, handles)
% hObject    handle to possiblegroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in possiblegroups.
function possiblegroups_Callback(hObject, eventdata, handles)
% hObject    handle to possiblegroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns possiblegroups contents as cell array
%        contents{get(hObject,'Value')} returns selected item from possiblegroups
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);
%keycontrol_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function colors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in colors.
function colors_Callback(hObject, eventdata, handles)
% hObject    handle to colors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns colors contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colors
set(handles.definegroup,'UserData',[]);
fromdata=get(handles.colors);
ac=str2num(fromdata.String);
if ~isempty(ac)
    set(handles.colors1,'BackgroundColor',ac(fromdata.Value,:)/255);
end


% --- Executes during object creation, after setting all properties.
function groupstoplot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupstoplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in groupstoplot.
function groupstoplot_Callback(hObject, eventdata, handles)
% hObject    handle to groupstoplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns groupstoplot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        groupstoplot
set(handles.information,'String','');
set(handles.definegroup,'UserData',[]);


% --- Executes during object creation, after setting all properties.
function colororder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colororder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in colororder.
function colororder_Callback(hObject, eventdata, handles)
% hObject    handle to colororder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.definegroup,'UserData',[]);
fromdata=get(handles.colororder);
ac=str2num(fromdata.String);
if ~isempty(ac)
    set(handles.colors2,'BackgroundColor',ac(fromdata.Value,:)/255)
end



% --- Executes during object creation, after setting all properties.
function done_CreateFcn(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns done contents as cell array
%        contents{get(hObject,'Value')} returns selected item from done


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function plotby_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotby (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function plotby_Callback(hObject, eventdata, handles)
% hObject    handle to plotby (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotby as text
%        str2double(get(hObject,'String')) returns contents of plotby as a
%        double
plotby=get(handles.plotby,'String');
if all(ismember(plotby,'1234567890,'))
    set(handles.information,'String','');
    set(handles.definegroup,'UserData',[]);
    syntax=get(handles.syntax,'String');
    userdata=get(handles.loadn);
    field=fieldnames(userdata.UserData);
    names=eval(['userdata.UserData.' char(field)]);
    [groups,tgroups,dd,dd,errortxt]=xgroups(syntax,plotby,names);
    showinfo(handles,errortxt);
    set(handles.possiblegroups,'Value',1);
    set(handles.possiblegroups,'String',char(unique(tgroups)));
    set(handles.groupstoplot,'Value',1);
    set(handles.groupstoplot,'String','');
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(handles.plotby,'BackgroundColor','red');
    showinfo(handles,'Plot by must be numbers seperated by commas.');
end


% --- Executes during object creation, after setting all properties.
function syntax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to syntax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function syntax_Callback(hObject, eventdata, handles)
% hObject    handle to syntax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of syntax as text
%        str2double(get(hObject,'String')) returns contents of syntax as a double
syntax=get(handles.syntax,'String');
csyntax=char(syntax);
if all(ismember(char(syntax),'sn')) && ((~sum(diff(csyntax=='s')==0)) || (~sum(diff(csyntax=='n')==0)))
    set(handles.information,'String','');
    set(handles.definegroup,'UserData',[]);
    set(hObject,'BackgroundColor',[206 215 215]/255);
    
else
    set(handles.syntax,'BackgroundColor','red');
    showinfo(handles,'Syntax must be sequence of alternating s and n.');
end


% --- Executes during object creation, after setting all properties.
function information_CreateFcn(hObject, eventdata, handles)
% hObject    handle to information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function information_Callback(hObject, eventdata, handles)
% hObject    handle to information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of information as text
%        str2double(get(hObject,'String')) returns contents of information as a double



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to information (see GCBO)
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
% hObject    handle to information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of information as text
%        str2double(get(hObject,'String')) returns contents of information as a double

% --- Executes during object creation, after setting all properties.
function namesoutlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to namesoutlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in namesoutlist.
function namesoutlist_Callback(hObject, eventdata, handles)
% hObject    handle to namesoutlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns namesoutlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from namesoutlist



function mousecontrol_possiblegroups_Callback(hObject, eventdata, handles)
defaultcolor=[175,190,184];
fromdata=get(handles.possiblegroups);
if ~isempty(fromdata.String)
    todata=get(handles.groupstoplot);
    [newa,newb]=listalter(fromdata.String,todata.String,fromdata.Value);    
    snewa=size(newa,1);
    snewb=size(newb,1);
    set(handles.possiblegroups,'String',newa);
    set(handles.groupstoplot,'String',newb);    
    if snewa==0
        set(handles.possiblegroups,'Value',1);
    elseif snewa<fromdata.Value
        set(handles.possiblegroups,'Value',snewa);
    end        
end






function mousecontrol_groupstoplot_Callback(hObject, eventdata, handles)
defaultcolor=[175,190,184];
fromdata=get(handles.groupstoplot);
if ~isempty(fromdata.String)
    todata=get(handles.possiblegroups);
    [newa,newb]=listalter(fromdata.String,todata.String,fromdata.Value);
    snewa=size(newa,1);
    snewb=size(newb,1);
    set(handles.groupstoplot,'String',newa);
    set(handles.possiblegroups,'String',newb);
    % Update color bar
    if snewa==0
        set(handles.groupstoplot,'Value',1);
    elseif snewa<fromdata.Value
        set(handles.groupstoplot,'Value',snewa);
    end            
end








function mousecontrol_namesoutlist_Callback(hObject, eventdata, handles)
currentselection=get(handles.definegroup,'UserData');
sc=size(currentselection);
if sc==0
    pos1=get(handles.namesoutlist,'Value');
    set(handles.definegroup,'UserData',[pos1]);
end
if sc==1
    pos1=currentselection;
    pos2=get(handles.namesoutlist,'Value');
    set(handles.definegroup,'UserData',[pos1 pos2]);
    set(handles.definegroup,'Enable','On');
end

% colors1        colors2
% colors  -->>  color order
function mousecontrol_colors_Callback(hObject, eventdata, handles)
defaultcolor=[175,190,184];
fromdata=get(handles.colors);
ac=str2num(fromdata.String);
if ~isempty(ac)
    todata=get(handles.colororder);
    [newa,newb]=listalter(fromdata.String,todata.String,fromdata.Value);    
    snewa=size(newa,1);
    snewb=size(newb,1);
    set(handles.colors,'String',newa);
    set(handles.colororder,'String',newb);    
    % Update color bar
    if snewa==0
        set(handles.colors1,'BackgroundColor',defaultcolor/255);        
        set(handles.colors,'Value',1);
    elseif snewa<fromdata.Value
        set(handles.colors,'Value',snewa);
        set(handles.colors1,'BackgroundColor',str2num(newa(snewa,:))/255);
    else
        set(handles.colors1,'BackgroundColor',str2num(newa(fromdata.Value,:))/255);
    end        
end

% colors  <<--  color order
function mousecontrol_colororder_Callback(hObject, eventdata, handles)
defaultcolor=[175,190,184];
fromdata=get(handles.colororder);
ac=str2num(fromdata.String);
if ~isempty(ac)
    todata=get(handles.colors);
    [newa,newb]=listalter(fromdata.String,todata.String,fromdata.Value);
    snewa=size(newa,1);
    snewb=size(newb,1);
    set(handles.colororder,'String',newa);
    set(handles.colors,'String',newb);
    % Update color bar
    if snewa==0
        set(handles.colors2,'BackgroundColor',defaultcolor/255);        
        set(handles.colororder,'Value',1);
    elseif snewa<fromdata.Value
        set(handles.colororder,'Value',snewa);
        set(handles.colors2,'BackgroundColor',str2num(newa(snewa,:))/255);
    else
        set(handles.colors2,'BackgroundColor',str2num(newa(fromdata.Value,:))/255);
    end            
end



function keycontrol_Callback(hObject, eventdata, handles)
ckey=get(gcf,'CurrentCharacter');
set(gcf,'CurrentCharacter',' ')
if ckey=='p'
    plot_Callback(hObject, eventdata, handles)
end
if ckey=='x'
    loadx_Callback(hObject, eventdata, handles)
end
if ckey=='y'
    loady_Callback(hObject, eventdata, handles)
end
if ckey=='n'
    loadn_Callback(hObject, eventdata, handles)
end
if ckey=='s'
    probesyntax_Callback(hObject, eventdata, handles)
end
if ckey=='.'
  mousecontrol_possiblegroups_Callback(hObject, eventdata, handles)
end




% --- Executes during object creation, after setting all properties.
function groupprefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupprefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function groupprefix_Callback(hObject, eventdata, handles)
% hObject    handle to groupprefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of groupprefix as text
%        str2double(get(hObject,'String')) returns contents of groupprefix as a double


% --- Executes on button press in shownames.
function shownames_Callback(hObject, eventdata, handles)
% hObject    handle to shownames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.definegroup,'UserData',[]);
names=get(handles.loadn,'UserData');
if ~isempty(names)
    fieldn=fieldnames(names);
    set(handles.namesoutlist,'String',eval(['names.' char(fieldn)]));
    set(handles.namesoutlist,'Value',1);
end

% --- Executes during object creation, after setting all properties.
function acton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu1.
function acton_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
acton=get(handles.acton,'String');
val=get(handles.acton,'Value');
if all(size(char(acton(val,:)))==size('Groups to plot'))
    if all(char(acton(val,:))=='Groups to plot')
        set(handles.definegroup,'Enable','On');
    end
end
if all(size(char(acton(val,:)))==size('Names in output'))
    if all(char(acton(val,:))=='Names in output')
        set(handles.definegroup,'Enable','Off');
    end
end


function swaplit_Callback(hObject, eventdata, handles)
possible=get(handles.possiblegroups,'String');
groups=get(handles.groupstoplot,'String');
set(handles.possiblegroups,'String',groups);
set(handles.groupstoplot,'String',possible);
set(handles.possiblegroups,'Value',1);
set(handles.groupstoplot,'Value',1);


% --- Executes on button press in mgr.
function mgr_Callback(hObject, eventdata, handles)
% hObject    handle to mgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.groupstoplot,'String');
b=get(handles.possiblegroups,'String');
if isempty(b) && ~isempty(a)
    aa=unique(cellstr(a));
elseif isempty(a) && ~isempty(b)
    aa=unique(cellstr(b));
elseif ~isempty(a) && ~isempty(b)
    aa=unique([cellstr(a); cellstr(b)]);
end
set(handles.possiblegroups,'String',aa);
set(handles.groupstoplot,'String','');
set(handles.possiblegroups,'Value',1);
set(handles.groupstoplot,'Value',1);




function groupix_Callback(hObject, eventdata, handles)
% hObject    handle to mgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
