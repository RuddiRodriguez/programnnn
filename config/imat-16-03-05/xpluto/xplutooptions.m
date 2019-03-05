function varargout = xplutooptions(varargin)
% XPLUTOOPTIONS M-file for xplutooptions.fig
%      XPLUTOOPTIONS, by itself, creates a new XPLUTOOPTIONS or raises the existing
%      singleton*.
%
%      H = XPLUTOOPTIONS returns the handle to a new XPLUTOOPTIONS or the handle to
%      the existing singleton*.
%
%      XPLUTOOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XPLUTOOPTIONS.M with the given input arguments.
%
%      XPLUTOOPTIONS('Property','Value',...) creates a new XPLUTOOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xplutooptions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xplutooptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xplutooptions

% Last Modified by GUIDE v2.5 14-Mar-2005 13:34:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xplutooptions_OpeningFcn, ...
                   'gui_OutputFcn',  @xplutooptions_OutputFcn, ...
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


% --- Executes just before xplutooptions is made visible.
function xplutooptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xplutooptions (see VARARGIN)
% Choose default command line output for xplutooptions
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes xplutooptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);
phandles=varargin{1};
parent=varargin{2};
set(handles.frame,'UserData',varargin);
pfig=gcf;
set(0,'CurrentFigure',parent);
options=get(phandles.options,'UserData');
set(0,'CurrentFigure',pfig);
set(handles.difforder,'String',char(options(1)));
set(handles.movav,'String',char(options(2)));
set(handles.transx,'Value',str2num(char(options(3))));
set(handles.transy,'Value',str2num(char(options(4))));
set(handles.interruptbg,'Value',str2num(char(options(5))));
set(handles.exportnoplot,'Value',str2num(char(options(6))));
set(handles.linew,'String',char(options(7)));
set(handles.bgcolor,'String',char(options(8)));
set(handles.xrange,'String',char(options(9)));
set(handles.averagegrps,'Value',str2num(char(options(10))));
set(handles.stdmax,'Value',str2num(char(options(11))));
if char(options(11))=='0'
    set(handles.stdmaxout,'String','std');
else
    set(handles.stdmaxout,'String','max');    
end
set(handles.transparency,'String',char(options(12)));
set(handles.filter,'Value',str2num(char(options(13))));
set(handles.filterval,'String',char(options(14)));

% --- Outputs from this function are returned to the command line.
function varargout = xplutooptions_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = get(handles.output,'UserData');

% --- Executes on button press in closeoptions.
function closeoptions_Callback(hObject, eventdata, handles)
% hObject    handle to closeoptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
apply(hObject, eventdata, handles);
close(gcf);


% --- Executes on button press in defaultoptions.
function defaultoptions_Callback(hObject, eventdata, handles)
% hObject    handle to defaultoptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargin=get(handles.frame,'UserData');
phandles=varargin{1};
parent=varargin{2};
set(handles.difforder,'String','0');
set(handles.movav,'String','1');
set(handles.transx,'Value',0);
set(handles.transy,'Value',0);
set(handles.interruptbg,'Value',1);
set(handles.exportnoplot,'Value',0);
set(handles.linew,'String','0.5');
set(handles.bgcolor,'String','white');
set(handles.bgcolor,'String','');
set(handles.averagegrps,'Value',0);
set(handles.stdmax,'Value',0);
set(handles.stdmaxout,'String','std');
set(handles.transparency,'String','1');
set(handles.filter,'Value',0);
set(handles.filterval,'String','0');
options=[cellstr('0') cellstr('1') cellstr('0') cellstr('0') cellstr('1') cellstr('0') cellstr('0.5') cellstr('white') cellstr('') cellstr('0') cellstr('0') cellstr('1') cellstr('0') cellstr('0')];
pfig=gcf;
set(0,'CurrentFigure',parent);
set(phandles.options,'UserData',options);
set(0,'CurrentFigure',pfig);


% --- Executes on button press in Interruptbg.
function Interruptbg_Callback(hObject, eventdata, handles)
% hObject    handle to Interruptbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Interruptbg


% --- Executes on button press in exportnoplot.
function exportnoplot_Callback(hObject, eventdata, handles)
% hObject    handle to exportnoplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of exportnoplot


% --- Executes during object creation, after setting all properties.
function difforder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to difforder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function difforder_Callback(hObject, eventdata, handles)
% hObject    handle to difforder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of difforder as text
%        str2double(get(hObject,'String')) returns contents of difforder as a double
difforder=get(handles.difforder,'String');
if difforder<0
    errormessage='Must be at least 0';
end


% --- Executes on button press in transx.
function transx_Callback(hObject, eventdata, handles)
% hObject    handle to transx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of transx


% --- Executes on button press in transy.
function transy_Callback(hObject, eventdata, handles)
% hObject    handle to transy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of transy


% --- Executes during object creation, after setting all properties.
function movav_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc   
        set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function movav_Callback(hObject, eventdata, handles)
% hObject    handle to movav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movav as text
%        str2double(get(hObject,'String')) returns contents of movav as a
%        double
errormessage=0;
movav=get(handles.movav,'String');
if movav<1
    errormessage='Must be at least 1 (i.e. no averaging).';
end
    


% --- Executes on button press in interruptbg.
function interruptbg_Callback(hObject, eventdata, handles)
% hObject    handle to interruptbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of interruptbg


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


function apply(hObject, eventdata, handles)
varargin=get(handles.frame,'UserData');
phandles=varargin{1};
parent=varargin{2};
difforder=get(handles.difforder,'String');
movav=get(handles.movav,'String');
transx=get(handles.transx,'Value');
transy=get(handles.transy,'Value');
interruptbg=get(handles.interruptbg,'Value');
exportnoplot=get(handles.exportnoplot,'Value');
linew=get(handles.linew,'String');
bgcolor=get(handles.bgcolor,'String');
xrange=get(handles.xrange,'String');
averagegrps=num2str(get(handles.averagegrps,'Value'));
stdmax=num2str(get(handles.stdmax,'Value'));
transparency=num2str(get(handles.transparency,'String'));
filter=num2str(get(handles.filter,'Value'));
filterval=num2str(get(handles.filterval,'String'));
options=[cellstr(difforder) cellstr(movav) cellstr(num2str(transx)) cellstr(num2str(transy)) cellstr(num2str(interruptbg)) cellstr(num2str(exportnoplot)) cellstr(linew) cellstr(bgcolor) cellstr(xrange) cellstr(averagegrps) cellstr(stdmax) cellstr(transparency) cellstr(filter) cellstr(filterval)];
pfig=gcf;
set(0,'CurrentFigure',parent);
if exportnoplot==1 
    set(phandles.plot,'String','Export');
else
    set(phandles.plot,'String','Plot');
end
set(phandles.options,'UserData',options);
set(0,'CurrentFigure',pfig);









% --- Executes during object creation, after setting all properties.
function linew_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
        set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function linew_Callback(hObject, eventdata, handles)
% hObject    handle to linew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linew as text
%        str2double(get(hObject,'String')) returns contents of linew as a double


% --- Executes during object creation, after setting all properties.
function bgcolor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bgcolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
        set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function bgcolor_Callback(hObject, eventdata, handles)
% hObject    handle to bgcolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bgcolor as text
%        str2double(get(hObject,'String')) returns contents of bgcolor as a double


% --- Executes during object creation, after setting all properties.
function xrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
        set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xrange_Callback(hObject, eventdata, handles)
% hObject    handle to xrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xrange as text
%        str2double(get(hObject,'String')) returns contents of xrange as a double
allowed=['0123456789,:'];
xrange=get(handles.xrange,'String');
if ~all(ismember(xrange,allowed))
    set(handles.xrange,'String','invalid');
    set(handles.xrange,'BackgroundColor','red');
else
    set(handles.xrange,'BackgroundColor','white');
end


% --- Executes on button press in averagegrps.
function averagegrps_Callback(hObject, eventdata, handles)
% hObject    handle to averagegrps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of averagegrps


% --- Executes on button press in stdmax.
function stdmax_Callback(hObject, eventdata, handles)
% hObject    handle to stdmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stdmax
stdmax=get(handles.stdmax,'Value');
if stdmax==0
set(handles.stdmaxout,'String','std');
else
set(handles.stdmaxout,'String','max');    
end


% --- Executes during object creation, after setting all properties.
function stdmaxout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stdmaxout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
            set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stdmaxout_Callback(hObject, eventdata, handles)
% hObject    handle to stdmaxout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stdmaxout as text
%        str2double(get(hObject,'String')) returns contents of stdmaxout as a double


% --- Executes during object creation, after setting all properties.
function transparency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transparency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
            set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function transparency_Callback(hObject, eventdata, handles)
% hObject    handle to transparency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transparency as text
%        str2double(get(hObject,'String')) returns contents of transparency as a double


% --- Executes on button press in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filter


% --- Executes during object creation, after setting all properties.
function filterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[206 215 215]/255);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function filterval_Callback(hObject, eventdata, handles)
% hObject    handle to filterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filterval as text
%        str2double(get(hObject,'String')) returns contents of filterval as a double


