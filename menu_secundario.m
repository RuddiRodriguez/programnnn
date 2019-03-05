function varargout = menu_secundario(varargin)
% MENU_SECUNDARIO M-file for menu_secundario.fig
%      MENU_SECUNDARIO, by itself, creates a new MENU_SECUNDARIO or raises the existing
%      singleton*.
%
%      H = MENU_SECUNDARIO returns the handle to a new MENU_SECUNDARIO or the handle to
%      the existing singleton*.
%
%      MENU_SECUNDARIO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MENU_SECUNDARIO.M with the given input arguments.
%
%      MENU_SECUNDARIO('Property','Value',...) creates a new MENU_SECUNDARIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before menu_secundario_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to menu_secundario_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help menu_secundario

% Last Modified by GUIDE v2.5 02-Apr-2009 14:18:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @menu_secundario_OpeningFcn, ...
                   'gui_OutputFcn',  @menu_secundario_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before menu_secundario is made visible.
function menu_secundario_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to menu_secundario (see VARARGIN)

% Choose default command line output for menu_secundario
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes menu_secundario wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = menu_secundario_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Errores.
function Errores_Callback(hObject, eventdata, handles)
% hObject    handle to Errores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

errores_test;
%calculate_errors;


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
h = str2double(get(hObject,'string'));
if isnan(h)
    errordlg('You must enter a numeric value','Bad Input','modal')
return
else
 handles.edit1 = h;
 guidata(hObject,handles)
end

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid = fopen('config/program_directory_path.ini','rt');
handles.program_directory_path = fscanf(fid,'%s')
fclose('all');

% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
fid = fopen('config/working_directory_path.ini','rt');
handles.working_directory_path = fscanf(fid,'%s')
fclose('all');

% create temporary config_file at startup by copying the default settings
% in 'default_config.ini' to 'temp_config.ini'
%copyfile(sprintf('%s/config/default_config.ini',handles.program_directory_path),sprintf('%s/config/temp_config.ini',handles.program_directory_path));
guidata(hObject,handles)
handles
hh=handles.edit1
save(sprintf('%s/results/h.txt',handles.working_directory_path),'hh','-ascii')









% --- Executes on button press in Fit_1.
function Fit_1_Callback(hObject, eventdata, handles)
% hObject    handle to Fit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fitting1;

% --- Executes on button press in Fit_2.
function Fit_2_Callback(hObject, eventdata, handles)
% hObject    handle to Fit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fitting_complementario;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

s1 = str2double(get(hObject,'string'));
if isnan(s1)
    errordlg('You must enter a numeric value','Bad Input','modal')
return
else
 handles.edit2 = s1;
 guidata(hObject,handles)
end




% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

s2 = str2double(get(hObject,'string'));
if isnan(s2)
    errordlg('You must enter a numeric value','Bad Input','modal')
return
else
 handles.edit3 = s2;
 guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

s3 = str2double(get(hObject,'string'));
if isnan(s3)
    errordlg('You must enter a numeric value','Bad Input','modal')
return
else
 handles.edit4 = s3;
 guidata(hObject,handles)
end





% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


s1=handles.edit2;
s2=handles.edit3;
s3=handles.edit4;

correlationandfit(s1,s2,s3);




























