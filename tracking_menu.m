function varargout = tracking_menu(varargin)
% TRACKING_MENU M-file for tracking_menu.fig
%      TRACKING_MENU, by itself, creates a new TRACKING_MENU or raises the existing
%      singleton*.
%
%      H = TRACKING_MENU returns the handle to a new TRACKING_MENU or the handle to
%      the existing singleton*.
%
%      TRACKING_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKING_MENU.M with the given input
%      arguments.
%
%      TRACKING_MENU('Property','Value',...) creates a new TRACKING_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tracking_menu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tracking_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tracking_menu

% Last Modified by GUIDE v2.5 18-Sep-2007 13:58:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tracking_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @tracking_menu_OutputFcn, ...
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


% --- Executes just before tracking_menu is made visible.
function tracking_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tracking_menu (see VARARGIN)

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

set(handles.linfitparameter_edit,'String',num2str(handles.parameterStruct.linfitparameter));
set(handles.meanparameter_edit,'String',num2str(handles.parameterStruct.meanparameter));
set(handles.pixeltestparameter_edit,'String',num2str(handles.parameterStruct.pixeltestparameter));
set(handles.directioncondition_edit,'String',num2str(handles.parameterStruct.directioncondition));
set(handles.lastpositions_edit,'String',num2str(handles.parameterStruct.lastpositions));
set(handles.directiondetectionstart_edit,'String',num2str(handles.parameterStruct.directiondetectionstart));
set(handles.directionchange_edit,'String',num2str(handles.parameterStruct.directionchange));
set(handles.slopediff_edit,'String',num2str(handles.parameterStruct.slopediff));
set(handles.methode4parameter_edit,'String',num2str(handles.parameterStruct.methode4parameter));
set(handles.comparepixel_edit,'String',num2str(handles.parameterStruct.comparepixel));
set(handles.nrofcomparepixel_edit,'String',num2str(handles.parameterStruct.nrofcomparepixel));
% set(handles.maxwanderof_edit,'String',num2str(handles.parameterStruct.maxwanderof));
set(handles.maxnrofpoints_edit,'String',num2str(handles.parameterStruct.maxnrofpoints));
set(handles.surroundings_edit,'String',num2str(handles.parameterStruct.surroundings));
% set(handles.displaystart_edit,'String',num2str(handles.parameterStruct.displaystart));
% set(handles.displayincrement_edit,'String',num2str(handles.parameterStruct.displayincrement));
set(handles.firstdisplayedcontours_edit,'String',num2str(handles.parameterStruct.firstdisplayedcontours));
set(handles.maxcenterchange_edit,'String',num2str(handles.parameterStruct.maxcenterchange));


% Choose default command line output for tracking_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes tracking_menu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tracking_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function linfitparameter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to linfitparameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linfitparameter_edit as text
%        str2double(get(hObject,'String')) returns contents of linfitparameter_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.linfitparameter_edit,'String',num2str(handles.parameterStruct.linfitparameter));
 return
else
 handles.parameterStruct.linfitparameter = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function linfitparameter_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linfitparameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meanparameter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to meanparameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meanparameter_edit as text
%        str2double(get(hObject,'String')) returns contents of meanparameter_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.meanparameter_edit,'String',num2str(handles.parameterStruct.meanparameter));
 return
else
 handles.parameterStruct.meanparameter = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function meanparameter_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanparameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function directioncondition_edit_Callback(hObject, eventdata, handles)
% hObject    handle to directioncondition_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directioncondition_edit as text
%        str2double(get(hObject,'String')) returns contents of directioncondition_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.directioncondition_edit,'String',num2str(handles.parameterStruct.directioncondition));
 return
else
 handles.parameterStruct.directioncondition = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function directioncondition_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directioncondition_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function directiondetectionstart_edit_Callback(hObject, eventdata, handles)
% hObject    handle to directiondetectionstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directiondetectionstart_edit as text
%        str2double(get(hObject,'String')) returns contents of directiondetectionstart_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.directiondetectionstart_edit,'String',num2str(handles.parameterStruct.directiondetectionstart));
 return
else
 handles.parameterStruct.directiondetectionstart = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function directiondetectionstart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directiondetectionstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function directionchange_edit_Callback(hObject, eventdata, handles)
% hObject    handle to directionchange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directionchange_edit as text
%        str2double(get(hObject,'String')) returns contents of directionchange_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.directionchange_edit,'String',num2str(handles.parameterStruct.directionchange));
 return
else
 handles.parameterStruct.directionchange = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function directionchange_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directionchange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lastpositions_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lastpositions_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lastpositions_edit as text
%        str2double(get(hObject,'String')) returns contents of lastpositions_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.lastpositions_edit,'String',num2str(handles.parameterStruct.lastpositions));
 return
else
 handles.parameterStruct.lastpositions = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lastpositions_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lastpositions_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxnrofpoints_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxnrofpoints_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxnrofpoints_edit as text
%        str2double(get(hObject,'String')) returns contents of maxnrofpoints_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.maxnrofpoints_edit,'String',num2str(handles.parameterStruct.maxnrofpoints));
 return
else
 handles.parameterStruct.maxnrofpoints = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxnrofpoints_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxnrofpoints_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixeltestparameter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pixeltestparameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixeltestparameter_edit as text
%        str2double(get(hObject,'String')) returns contents of pixeltestparameter_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.pixeltestparameter_edit,'String',num2str(handles.parameterStruct.pixeltestparameter));
 return
else
 handles.parameterStruct.pixeltestparameter = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pixeltestparameter_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixeltestparameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slopediff_edit_Callback(hObject, eventdata, handles)
% hObject    handle to slopediff_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slopediff_edit as text
%        str2double(get(hObject,'String')) returns contents of slopediff_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.slopediff_edit,'String',num2str(handles.parameterStruct.slopediff));
 return
else
 handles.parameterStruct.slopediff = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slopediff_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slopediff_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function methode4parameter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to methode4parameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of methode4parameter_edit as text
%        str2double(get(hObject,'String')) returns contents of methode4parameter_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.methode4parameter_edit,'String',num2str(handles.parameterStruct.methode4parameter));
 return
else
 handles.parameterStruct.methode4parameter = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function methode4parameter_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methode4parameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function comparepixel_edit_Callback(hObject, eventdata, handles)
% hObject    handle to comparepixel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comparepixel_edit as text
%        str2double(get(hObject,'String')) returns contents of comparepixel_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.comparepixel_edit,'String',num2str(handles.parameterStruct.comparepixel));
 return
else
 handles.parameterStruct.comparepixel = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function comparepixel_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comparepixel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nrofcomparepixel_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nrofcomparepixel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nrofcomparepixel_edit as text
%        str2double(get(hObject,'String')) returns contents of nrofcomparepixel_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.nrofcomparepixel_edit,'String',num2str(handles.parameterStruct.nrofcomparepixel));
 return
else
 handles.parameterStruct.nrofcomparepixel = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function nrofcomparepixel_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nrofcomparepixel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function surroundings_edit_Callback(hObject, eventdata, handles)
% hObject    handle to surroundings_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of surroundings_edit as text
%        str2double(get(hObject,'String')) returns contents of surroundings_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.surroundings_edit,'String',num2str(handles.parameterStruct.surroundings));
 return
else
 handles.parameterStruct.surroundings = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function surroundings_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to surroundings_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tracking_parameters_ok_pushbutton.
function tracking_parameters_ok_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to tracking_parameters_ok_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

savestructure(handles.parameterStruct,sprintf('%s/config/temp_config.ini',handles.program_directory_path));
close(handles.figure1);

% --- Executes on button press in tracking_parameters_cancel_pushbutton.
function tracking_parameters_cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to tracking_parameters_cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1);



function maxcenterchange_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxcenterchange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxcenterchange_edit as text
%        str2double(get(hObject,'String')) returns contents of maxcenterchange_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.maxcenterchange_edit,'String',num2str(handles.parameterStruct.maxcenterchange));
 return
else
 handles.parameterStruct.maxcenterchange = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxcenterchange_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxcenterchange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function firstdisplayedcontours_edit_Callback(hObject, eventdata, handles)
% hObject    handle to firstdisplayedcontours_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstdisplayedcontours_edit as text
%        str2double(get(hObject,'String')) returns contents of firstdisplayedcontours_edit as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
 errordlg('You must enter a numeric value','Bad Input','modal')
 set(handles.firstdisplayedcontours_edit,'String',num2str(handles.parameterStruct.firstdisplayedcontours));
 return
else
 handles.parameterStruct.firstdisplayedcontours = user_entry;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function firstdisplayedcontours_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstdisplayedcontours_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


