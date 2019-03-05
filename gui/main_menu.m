function varargout = main_menu(varargin)
% MAIN_MENU M-file for main_menu.fig
%      MAIN_MENU, by itself, creates a new MAIN_MENU or raises the existing
%      singleton*.
%
%      H = MAIN_MENU returns the handle to a new MAIN_MENU or the handle to
%      the existing singleton*.
%
%      MAIN_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_MENU.M with the given input arguments.
%
%      MAIN_MENU('Property','Value',...) creates a new MAIN_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_menu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property
%      application
%      stop.  All inputs are passed to main_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_menu

% Last Modified by GUIDE v2.5 28-Sep-2007 14:05:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @main_menu_OutputFcn, ...
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


% --- Executes just before main_menu is made visible.
function main_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_menu (see VARARGIN)

% sets folder of the program file to have relative paths for the other *.ini
% files
% for linux
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
copyfile(sprintf('%s/config/default_config.ini',handles.program_directory_path),sprintf('%s/config/temp_config.ini',handles.program_directory_path));

% Choose default command line output for main_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_menu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tracking_parameters_pushbutton.
function tracking_parameters_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to tracking_parameters_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tracking_menu;

% --- Executes on button press in tracking_perform_pushbutton.
function tracking_perform_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to tracking_perform_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tracking;

% --- Executes on button press in test_parameter_pushbutton.
function test_parameter_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to test_parameter_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

testcontour_menu;

% --- Executes on button press in test_perform_pushbutton.
function test_perform_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to test_perform_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

testcontour;

% --- Executes on button press in evaluation_parameters_pushbutton.
function evaluation_parameters_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to evaluation_parameters_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalu_menu;

% --- Executes on button press in evaluation_perform_pushbutton.
function evaluation_perform_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to evaluation_perform_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalu;

% --- Executes on button press in fitting_parameters_pushbutton.
function fitting_parameters_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fitting_parameters_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fitting_menu;

% --- Executes on button press in fitting_perform_pushbutton.
function fitting_perform_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fitting_perform_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fitting;

% --- Executes during object creation, after setting all properties.
function tracking_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracking_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in perform_all_pushbutton.
function perform_all_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to perform_all_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

main;

% --- Executes on button press in perfrom_selected_pushbutton.
function perfrom_selected_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to perfrom_selected_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exit_pushbutton.
function exit_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exit_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

user_response = questdlg('Are you sure you want to exit?','Exit Dialog','Yes','No','No');
switch user_response
    case {'Yes'}
%     delete(sprintf('%s/config/temp_config.ini',handles.program_directory_path));
    delete(handles.figure1);
    case {'No'}
    return;
end
% uiresume(handles.figure1);


% --- Executes on button press in set_as_default_pushbutton.
function set_as_default_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to set_as_default_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% copy the temporary settings from 'temp_config.ini' to
% 'default_config.ini', from which the default values are loaded at startup
copyfile(sprintf('%s/config/temp_config.ini',handles.program_directory_path),sprintf('%s/config/default_config.ini',handles.program_directory_path));

% --- Executes on button press in save_settings_pushbutton.
function save_settings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_settings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fileextensions = {'*.ini','ini';'*.txt','txt';'*.conf','conf'};
[filename,pathname,filterindex] = uiputfile(fileextensions,'Save Settings',handles.working_directory_path);

if filename ~= 0 | pathname ~= 0 % check whether the load dialog was canceled or not

if length(filename) > 4  % check whether the fileextension was given in file name in case filename is longer than 4 letters
if strcmpi(filename(end-3:end),'.ini') | strcmpi(filename(end-3:end),'.txt') | strcmpi(filename(end-4:end),'.conf')
    copyfile(sprintf('%s/config/temp_config.ini',handles.program_directory_path),sprintf('%s%s',pathname,filename));
else % if not add file extension that was selected
    if exist(sprintf('%s%s.%s',pathname,filename,fileextensions{filterindex,2})) % check whether file exists after adding the extension
    user_entry = questdlg('The file already exists. Do you want to replace it?','File Exists','Yes','No','No') 
    switch user_entry
        case('Yes')
        copyfile(sprintf('%s/config/temp_config.ini',handles.program_directory_path),sprintf('%s%s.%s',pathname,filename,fileextensions{filterindex,2}));
        case('No')
        return;
    end
    else
    copyfile(sprintf('%s/config/temp_config.ini',handles.program_directory_path),sprintf('%s%s.%s',pathname,filename,fileextensions{filterindex,2}));
    end
end
end
% if exist(sprintf('%s%s.%s',pathname,filename,fileextensions{filterindex,2}))  % check whether file exists after adding the extension
%    user_entry = questdlg('The file already exists. Do you want to replace it?','File Exists','Yes','No','No') 
%     switch user_entry
%         case('Yes')
%         copyfile(sprintf('%s/config/temp_config.ini',handles.program_directory_path),sprintf('%s%s.%s',pathname,filename,fileextensions{filterindex,2}));
%         case('No')
%         return;
%     end
% end
end

% --- Executes on button press in load_settings_pushbutton.
function load_settings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_settings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fileextensions = {'*.ini','ini';'*.txt','txt';'*.conf','conf';'*.*','All Files'};
[filename,pathname,filterindex] = uigetfile(fileextensions,'Load Settings',handles.program_directory_path);

if filename ~= 0 | pathname ~=0 % check whether the load dialog was canceled or not
copyfile(sprintf('%s%s',pathname,filename),sprintf('%s/config/temp_config.ini',handles.program_directory_path));
end


% --- Executes on button press in select_image_pushbutton.
function select_image_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to select_image_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fileextensions = {'*.tif','tif';'*.*','All Files'};
[filename,pathname,filterindex] = uigetfile(fileextensions,'Open First Image File',handles.working_directory_path);

if filename ~= 0 | pathname ~=0 % check whether the load dialog was canceled or not
% remove the 'image\' part from pathname to get the working-folder
pathname = pathname(1:end - 7);
pathname = strrep(pathname, '\', '/');

%
if strcmp('',pathname) == 0
handles.working_directory_path = pathname;
end

% remove file extension from filename including dot
filename = filename(1:end - (length(fileextensions{filterindex,2}) + 1));

% save pathname to 'working_directory_paht.ini'
fid = fopen('config/working_directory_path.ini','w');
fprintf(fid,'%s',pathname);
fclose('all');

% save filename to 'file_name.ini'
fid = fopen('config/file_name.ini','w');
fprintf(fid,'%s',filename);
fclose('all');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in show_working_path_pushbutton.
function show_working_path_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to show_working_path_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox(sprintf('%s',handles.working_directory_path),'Working Directory Path','none','modal')


