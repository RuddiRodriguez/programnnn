function varargout = fitting_menu(varargin)
% FITTING_MENU M-file for fitting_menu.fig
%      FITTING_MENU, by itself, creates a new FITTING_MENU or raises the existing
%      singleton*.
%
%      H = FITTING_MENU returns the handle to a new FITTING_MENU or the handle to
%      the existing singleton*.
%
%      FITTING_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FITTING_MENU.M with the given input arguments.
%
%      FITTING_MENU('Property','Value',...) creates a new FITTING_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fitting_menu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fitting_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fitting_menu

% Last Modified by GUIDE v2.5 28-Sep-2007 13:33:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fitting_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @fitting_menu_OutputFcn, ...
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


% --- Executes just before fitting_menu is made visible.
function fitting_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fitting_menu (see VARARGIN)

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

set(handles.firstdatapoint_edit,'String',num2str(handles.parameterStruct.firstdatapoint));
set(handles.lastdatapoint_edit,'String',num2str(handles.parameterStruct.lastdatapoint));
set(handles.scalefactor_sigma_edit,'String',num2str(handles.parameterStruct.scalefactor_sigma));
set(handles.scalefactor_kappa_edit,'String',num2str(handles.parameterStruct.scalefactor_kappa));
set(handles.TolX_edit,'String',num2str(handles.parameterStruct.TolX));
set(handles.TolFun_edit,'String',num2str(handles.parameterStruct.TolFun));
set(handles.MaxFunEvals_edit,'String',num2str(handles.parameterStruct.MaxFunEvals));
set(handles.MaxIter_edit,'String',num2str(handles.parameterStruct.MaxIter));
set(handles.temperature_edit,'String',num2str(handles.parameterStruct.temperature));
set(handles.integration_time_edit,'String',num2str(handles.parameterStruct.integration_time));
set(handles.first_plot_point_edit,'String',num2str(handles.parameterStruct.first_plot_point));
set(handles.last_plot_point_edit,'String',num2str(handles.parameterStruct.last_plot_point));
set(handles.confidence_level_edit,'String',num2str(handles.parameterStruct.confidence_level*100)); % multiplied by 100 is conversion from value between 0 and 1 to percent



% Choose default command line output for testcontour_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes testcontour_menu wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fitting_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function firstdatapoint_edit_Callback(hObject, eventdata, handles)
% hObject    handle to firstdatapoint_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstdatapoint_edit as text
%        str2double(get(hObject,'String')) returns contents of firstdatapoint_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.firstdatapoint_edit,'String',num2str(handles.parameterStruct.firstdatapoint));
 return
else
 handles.parameterStruct.firstdatapoint = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function firstdatapoint_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstdatapoint_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lastdatapoint_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lastdatapoint_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lastdatapoint_edit as text
%        str2double(get(hObject,'String')) returns contents of lastdatapoint_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.lastdatapoint_edit,'String',num2str(handles.parameterStruct.lastdatapoint));
 return
else
 handles.parameterStruct.lastdatapoint = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lastdatapoint_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lastdatapoint_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fitting_parameters_ok_pushbutton.
function fitting_parameters_ok_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fitting_parameters_ok_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

savestructure(handles.parameterStruct,sprintf('%s/config/temp_config.ini',handles.program_directory_path));
close(handles.figure1);

% --- Executes on button press in fitting_parameters_cancel_pushbutton.
function fitting_parameters_cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fitting_parameters_cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1);



function TolX_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TolX_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TolX_edit as text
%        str2double(get(hObject,'String')) returns contents of TolX_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.TolX_edit,'String',num2str(handles.parameterStruct.TolX));
 return
else
 handles.parameterStruct.TolX = user_entry;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function TolX_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TolX_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TolFun_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TolFun_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TolFun_edit as text
%        str2double(get(hObject,'String')) returns contents of TolFun_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.TolFun_edit,'String',num2str(handles.parameterStruct.TolFun));
 return
else
 handles.parameterStruct.TolFun = user_entry;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function TolFun_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TolFun_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function scalefactor_sigma_edit_Callback(hObject, eventdata, handles)
% hObject    handle to scalefactor_sigma_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scalefactor_sigma_edit as text
%        str2double(get(hObject,'String')) returns contents of scalefactor_sigma_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.scalefactor_sigma_edit,'String',num2str(handles.parameterStruct.scalefactor_sigma));
 return
else
 handles.parameterStruct.scalefactor_sigma = user_entry;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function scalefactor_sigma_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scalefactor_sigma_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function scalefactor_kappa_edit_Callback(hObject, eventdata, handles)
% hObject    handle to scalefactor_kappa_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scalefactor_kappa_edit as text
%        str2double(get(hObject,'String')) returns contents of scalefactor_kappa_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.scalefactor_kappa_edit,'String',num2str(handles.parameterStruct.scalefactor_kappa));
 return
else
 handles.parameterStruct.scalefactor_kappa = user_entry;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function scalefactor_kappa_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scalefactor_kappa_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function integration_time_edit_Callback(hObject, eventdata, handles)
% hObject    handle to integration_time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of integration_time_edit as text
%        str2double(get(hObject,'String')) returns contents of integration_time_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.integration_time_edit,'String',num2str(handles.parameterStruct.integration_time));
 return
else
 handles.parameterStruct.integration_time = user_entry;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function integration_time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to integration_time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function temperature_edit_Callback(hObject, eventdata, handles)
% hObject    handle to temperature_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temperature_edit as text
%        str2double(get(hObject,'String')) returns contents of temperature_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.temperature_edit,'String',num2str(handles.parameterStruct.temperature));
 return
else
 handles.parameterStruct.temperature = user_entry;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function temperature_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temperature_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function first_plot_point_edit_Callback(hObject, eventdata, handles)
% hObject    handle to first_plot_point_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of first_plot_point_edit as text
%        str2double(get(hObject,'String')) returns contents of first_plot_point_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.first_plot_point_edit,'String',num2str(handles.parameterStruct.first_plot_point));
 return
else
 handles.parameterStruct.first_plot_point = user_entry;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function first_plot_point_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to first_plot_point_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function last_plot_point_edit_Callback(hObject, eventdata, handles)
% hObject    handle to last_plot_point_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of last_plot_point_edit as text
%        str2double(get(hObject,'String')) returns contents of last_plot_point_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.last_plot_point_edit,'String',num2str(handles.parameterStruct.last_plot_point));
 return
else
 handles.parameterStruct.last_plot_point = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function last_plot_point_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to last_plot_point_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function confidence_level_edit_Callback(hObject, eventdata, handles)
% hObject    handle to confidence_level_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of confidence_level_edit as text
%        str2double(get(hObject,'String')) returns contents of confidence_level_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.confidence_level_edit,'String',num2str(handles.parameterStruct.confidence_level));
 return
else
 handles.parameterStruct.confidence_level = (user_entry/100); % divided by 100 is conversion from percent to value between 0 and 1
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function confidence_level_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to confidence_level_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MaxIter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to MaxIter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxIter_edit as text
%        str2double(get(hObject,'String')) returns contents of MaxIter_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.MaxIter_edit,'String',num2str(handles.parameterStruct.MaxIter));
 return
else
 handles.parameterStruct.MaxIter = user_entry;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MaxIter_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxIter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MaxFunEvals_edit_Callback(hObject, eventdata, handles)
% hObject    handle to MaxFunEvals_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxFunEvals_edit as text
%        str2double(get(hObject,'String')) returns contents of MaxFunEvals_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.MaxFunEvals_edit,'String',num2str(handles.parameterStruct.MaxFunEvals));
 return
else
 handles.parameterStruct.MaxFunEvals = user_entry;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MaxFunEvals_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxFunEvals_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

