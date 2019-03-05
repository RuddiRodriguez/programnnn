function varargout = testcontour_menu(varargin)
% TESTCONTOUR_MENU M-file for testcontour_menu.fig
%      TESTCONTOUR_MENU, by itself, creates a new TESTCONTOUR_MENU or raises the existing
%      singleton*.
%
%      H = TESTCONTOUR_MENU returns the handle to a new TESTCONTOUR_MENU or the handle to
%      the existing singleton*.
%
%      TESTCONTOUR_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTCONTOUR_MENU.M with the given input arguments.
%
%      TESTCONTOUR_MENU('Property','Value',...) creates a new TESTCONTOUR_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testcontour_menu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testcontour_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testcontour_menu

% Last Modified by GUIDE v2.5 15-Sep-2007 20:38:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testcontour_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @testcontour_menu_OutputFcn, ...
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


% --- Executes just before testcontour_menu is made visible.
function testcontour_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testcontour_menu (see VARARGIN)

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

set(handles.maxlengthdeviation_edit,'String',num2str(handles.parameterStruct.maxlengthdeviation));
set(handles.mincontourlength_edit,'String',num2str(handles.parameterStruct.mincontourlength));
set(handles.maxangle_edit,'String',num2str(handles.parameterStruct.maxangle));

% Choose default command line output for testcontour_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes testcontour_menu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testcontour_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function maxlengthdeviation_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxlengthdeviation_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxlengthdeviation_edit as text
%        str2double(get(hObject,'String')) returns contents of maxlengthdeviation_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.maxlengthdeviation_edit,'String',num2str(handles.parameterStruct.maxlengthdeviation));
 return
else
 handles.parameterStruct.maxlengthdeviation = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxlengthdeviation_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxlengthdeviation_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mincontourlength_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mincontourlength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mincontourlength_edit as text
%        str2double(get(hObject,'String')) returns contents of mincontourlength_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.mincontourlength_edit,'String',num2str(handles.parameterStruct.mincontourlength));
 return
else
 handles.parameterStruct.mincontourlength = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function mincontourlength_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mincontourlength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxangle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxangle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxangle_edit as text
%        str2double(get(hObject,'String')) returns contents of maxangle_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.maxangle_edit,'String',num2str(handles.parameterStruct.maxangle));
 return
else
 handles.parameterStruct.maxangle = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxangle_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxangle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in testcontour_parameters_ok_pushbutton.
function testcontour_parameters_ok_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to testcontour_parameters_ok_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

savestructure(handles.parameterStruct,sprintf('%s/config/temp_config.ini',handles.program_directory_path));
close(handles.figure1);

% --- Executes on button press in testcontour_parameters_cancel_pushbutton.
function testcontour_parameters_cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to testcontour_parameters_cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1);

