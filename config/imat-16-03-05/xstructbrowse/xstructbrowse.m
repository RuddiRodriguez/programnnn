function varargout = xstructbrowse(varargin)
% Browse through structured arrays
% Usage:
%       First type  "q.giao=giao" in the command prompt
%       Then type   "xstructbrowse(q,'q')"

%      XSTRUCTBROWSE M-file for xstructbrowse.fig
%      XSTRUCTBROWSE, by itself, creates a new XSTRUCTBROWSE or raises the existing
%      singleton*.
%
%      H = XSTRUCTBROWSE returns the handle to a new XSTRUCTBROWSE or the handle to
%      the existing singleton*.
%
%      XSTRUCTBROWSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XSTRUCTBROWSE.M with the given input arguments.
%
%      XSTRUCTBROWSE('Property','Value',...) creates a new XSTRUCTBROWSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xstructbrowse_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xstructbrowse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xstructbrowse

% Last Modified by GUIDE v2.5 04-Nov-2004 15:02:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @xstructbrowse_OpeningFcn, ...
    'gui_OutputFcn',  @xstructbrowse_OutputFcn, ...
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


% --- Executes just before xstructbrowse is made visible.
function xstructbrowse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xstructbrowse (see VARARGIN)

% Choose default command line output for xstructbrowse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xstructbrowse wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.figure1,'Color',[175 190 184]/256);
set(handles.figure1,'UserData',varargin);
felt=varargin{2};
eval(['vin.' felt '=' 'varargin{1};']);
set(handles.structurename,'UserData',vin);
if ~isempty(varargin)
    vin=varargin{1};
    structurename=fieldnames(vin);
    set(handles.structurename,'String',structurename);
    set(handles.structurename,'Enable','Off');
    %set(handles.structurename,'String',);
    fields=fieldnames(eval(['vin.' char(structurename)]));
    set(handles.entries,'String',fields);
    sf=size(fields);
    helperfields=[repmat(['vin.' char(structurename) '.'],sf(1),1)  char(fields)];
    set(handles.helperlist,'String',helperfields);
    levels=repmat('1',sf(1),1);
    set(handles.levelist,'String',levels);
end



% --- Outputs from this function are returned to the command line.
function varargout = xstructbrowse_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function structurename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to structurename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[175 190 184]/256);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function structurename_Callback(hObject, eventdata, handles)
% hObject    handle to structurename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of structurename as text
%        str2double(get(hObject,'String')) returns contents of structurename as a double


% --- Executes during object creation, after setting all properties.
function entries_CreateFcn(hObject, eventdata, handles)
% hObject    handle to entries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[175 190 184]/256);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in entries.
function entries_Callback(hObject, eventdata, handles)
% hObject    handle to entries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns entries contents as cell array
%        contents{get(hObject,'Value')} returns selected item from entries
%--------------------------------
% Main list
set(handles.helperlist,'Value',1);
set(handles.levelist,'Value',1);
val=get(handles.entries,'Value');
entries=get(handles.entries,'String');
se=size(entries);
curentry=entries(val,:);
% Helper
helperentries=get(handles.helperlist,'String');
sh=size(helperentries);
helperentry=helperentries(val,:);
vin=get(handles.figure1,'UserData');
vin=vin{1};
addtolist=eval(char(helperentry));

if isstruct(addtolist)
    txt='Structure entry';
    levels=get(handles.levelist,'String');
    sl=size(levels);
    curlevel=str2num(char(levels(val,:)));    
    %addtolist=eval(helperentry);
    addfields=fieldnames(addtolist);
    sa=size(addfields);
    newentries=[cellstr(entries(1:val)) ; cellstr([repmat('---:',sa(1),curlevel) char(addfields)]); cellstr(entries(val+1:se(1)))];
    set(handles.entries,'String',newentries);
    newhelper=([deblank(repmat(char(helperentry),sa(1),1)) char(repmat('.',sa(1),1))  char(addfields) ]);
    %[ix pos]=xpoccur(char(levels(val+1:val+sl(1)-1)),'1',1);
    if  (val+sa(1))<=sl(1) && char(levels(val+1))>=num2str(curlevel+1);
        % Colabs tree  []
        [ix pos]=xpoccur(char(levels(val+1:sl(1))),num2str(curlevel),1);
        newentries=[cellstr(entries(1:val,:)); cellstr(entries(val+pos:se(1),:))];
        set(handles.entries,'String',newentries);
        % the helpers
        newhelpers=[cellstr(helperentries(1:val,:)); cellstr(helperentries(val+pos:se(1),:))];
        set(handles.helperlist,'String',newhelpers);
        % fix the level list        
        newlevel=num2str(curlevel-1);
        newlevels=[cellstr(levels(1:val)) ; cellstr(levels(val+pos:se(1)))];
        set(handles.levelist,'String',newlevels);        
    else
        % Expand tree
        newhelpers=[cellstr(helperentries(1:val,:)); cellstr(newhelper); cellstr(helperentries(val+1:sh(1),:))];
        set(handles.helperlist,'String',newhelpers);
        % fix the level list
        newlevels=repmat(num2str(curlevel+1),sa(1),1);
        newlevels=[cellstr(levels(1:val)) ; cellstr(newlevels); cellstr(levels(val+1:se(1)))];
        set(handles.levelist,'String',newlevels);
    end
else
    if isa(addtolist,'numeric');
        if prod(size(addtolist))==1
            txt=['Scalar = ' num2str(addtolist)];    
        else
            txt=['Numeric array'];    
        end
    end
    if isa(addtolist,'char');
        txt=['String = ' char(addtolist)];    
    end    
    if isa(addtolist,'cell');
        txt='Cell (of strings)';
        if prod(size(addtolist))==1
            txt=['String = ' char(addtolist)];    
        end
    end    
end
set(handles.entrytype,'String',txt);




% --- Executes during object creation, after setting all properties.
function helperlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to helperlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in helperlist.
function helperlist_Callback(hObject, eventdata, handles)
% hObject    handle to helperlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns helperlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from helperlist


% --- Executes during object creation, after setting all properties.
function levelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to levelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in levelist.
function levelist_Callback(hObject, eventdata, handles)
% hObject    handle to levelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns levelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from levelist

function fetch_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor',[175 190 184]/256);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in fetch.
function fetch_Callback(hObject, eventdata, handles)
% hObject    handle to fetch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helperentries=get(handles.helperlist,'String');
val=get(handles.entries,'Value');
sh=size(helperentries);
helperentry=helperentries(val,:);
vin=get(handles.figure1,'UserData');
felt=vin{2};
if prod(size(vin))>=3
    phandles=vin{3};
    vin=vin{1};
    %addtolist=eval(char(helperentry));
    if all(felt=='loadx')
        %    eval(['addtolist.' felt '.AMT=' char(helperentry)]);
        eval([ felt '.scale=' char(helperentry)]);    
    end
    if all(felt=='loady')
        %    eval(['addtolist.' felt '.AMT=' char(helperentry)]);
        eval([ felt '.AMT=' char(helperentry)]);
        
    end
    if all(felt=='loadn')
        %eval([ 'addtolist.' felt '.names=' char(helperentry)]);
        eval([ felt '.names=' char(helperentry)]);
    end
    set(eval(['phandles.' felt]),'UserData',eval(felt));
    close(gcf);
end



% --- Executes on button press in entrytype.
function entrytype_Callback(hObject, eventdata, handles)
% hObject    handle to entrytype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helperentries=get(handles.helperlist,'String');
val=get(handles.entries,'Value');
sh=size(helperentries);
helperentry=helperentries(val,:);
vin=get(handles.figure1,'UserData');
felt=vin{2};
%phandles=vin{3};
vin=vin{1};
eval('global xans;');
eval(['xans=' char(helperentry)]);


