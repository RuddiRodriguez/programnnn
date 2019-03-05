function varargout = evalu_menu(varargin)
% EVALU_MENU M-file for evalu_menu.fig
%      EVALU_MENU, by itself, creates a new EVALU_MENU or raises the existing
%      singleton*.
%
%      H = EVALU_MENU returns the handle to a new EVALU_MENU or the handle to
%      the existing singleton*.
%
%      EVALU_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EVALU_MENU.M with the given input arguments.
%
%      EVALU_MENU('Property','Value',...) creates a new EVALU_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before evalu_menu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to evalu_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help evalu_menu

% Last Modified by GUIDE v2.5 16-Sep-2007 15:20:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @evalu_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @evalu_menu_OutputFcn, ...
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


% --- Executes just before evalu_menu is made visible.
function evalu_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to evalu_menu (see VARARGIN)

% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
fid = fopen('config/program_directory_path.ini','rt');
% fid = fopen('/media/daw/home/micha/membrane_tracking_project/medidas/filename.txt','rt');
handles.program_directory_path = fscanf(fid,'%s')
fclose('all');

% load the parameters of from the configuraion file
fid = fopen(sprintf('%s/config/temp_config.ini',handles.program_directory_path));
c = textscan(fid, '%s = %f %*[^\n]'); % loads config into the cell 'c'
fclose(fid);

% convert the cell 'c' to the structure 'parameterStruct'
handles.parameterStruct = cell2struct(num2cell(c{2}), c{1});

set(handles.nmax_edit,'String',num2str(handles.parameterStruct.nmax));
set(handles.maxc_edit,'String',num2str(handles.parameterStruct.maxc));
set(handles.resolution_edit,'String',num2str(handles.parameterStruct.resolution));

% Choose default command line output for testcontour_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes testcontour_menu wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = evalu_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function nmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nmax_edit as text
%        str2double(get(hObject,'String')) returns contents of nmax_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.nmax_edit,'String',num2str(handles.parameterStruct.nmax));
 return
else
 handles.parameterStruct.nmax = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function nmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxc_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxc_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxc_edit as text
%        str2double(get(hObject,'String')) returns contents of maxc_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.maxc_edit,'String',num2str(handles.parameterStruct.maxc));
 return
else
 handles.parameterStruct.maxc = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxc_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxc_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resolution_edit_Callback(hObject, eventdata, handles)
% hObject    handle to resolution_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resolution_edit as text
%        str2double(get(hObject,'String')) returns contents of resolution_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.resolution_edit,'String',num2str(handles.parameterStruct.resolution));
 return
else
 handles.parameterStruct.resolution = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function resolution_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolution_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in evalu_parameters_ok_pushbutton.
function evalu_parameters_ok_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to evalu_parameters_ok_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

savestructure(handles.parameterStruct,sprintf('%s/config/temp_config.ini',handles.program_directory_path));
close(handles.figure1);

% --- Executes on button press in evalu_parameters_cancel_pushbutton.
function evalu_parameters_cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to evalu_parameters_cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1);
