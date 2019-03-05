function varargout = load_raw_data(varargin)
% This function is associated with function load_raw_data.fig.
% It will open a window which user can load new raw data and set
% their units and consider a physical quantity to each column of 
% the data files.


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @load_raw_data_OpeningFcn, ...
    'gui_OutputFcn',  @load_raw_data_OutputFcn, ...
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


function load_raw_data_OpeningFcn(hObject, eventdata, handles, varargin)
% When the window open, first it shows a summary of data columns in related table.
% Writes some defaults for units of physical quantities
% then sets colors of the window items.
handles.output = hObject;
a = varargin(5);
b = varargin(6);
set(handles.Table_SampleData,'data',a{1});
if isstruct(b{1})
    set(handles.Table_ColumnNo,'data',b{1}.ColumnNo);
    set(handles.Table_Units,'data',cellstr(b{1}.Units)');
    handles.userdata.pathname = char(b{1}.PathName);
else
    set(handles.Table_ColumnNo,'data',zeros(1,5));
    set(handles.Table_Units,'data',{'S','mm','mm','mm','rad'});
end
color = .9;
set(hObject,'color',[color color color]);
set(handles.LoadDescription ,'backgroundcolor',[color color color]);
set(handles.pushbutton_Cancle ,'backgroundcolor',[color color color]);
set(handles.pushbutton_Finish ,'backgroundcolor',[color color color]);
set(handles.text3_SampleofDatas ,'backgroundcolor',[color color color]);
set(handles.text6 ,'backgroundcolor',[color color color]);
set(handles.text_ColumnsNumbers ,'backgroundcolor',[color color color]);
set(handles.text_Description ,'backgroundcolor',[color color color]);
set(handles.text_ProjectName ,'backgroundcolor',[color color color]);
% set(handles.Table_ColumnNo ,'backgroundcolor',[color color color]);
% set(handles.Table_SampleData ,'backgroundcolor',[color color color]);
% set(handles.Table_Units ,'backgroundcolor',[color color color]);
guidata(hObject, handles);


function varargout = load_raw_data_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;



function pushbutton_Cancle_Callback(hObject, eventdata, handles)
% If user clicks on "cancel" button, window visibility will be off.

set(handles.fig_LoadRawData,'userdata',nan);
set(handles.fig_LoadRawData,'visible','off');
guidata(hObject, handles);


function pushbutton_Finish_Callback(hObject, eventdata, handles)
% When user clicks on "Finish" button, the window will be closed
% and loaded data will be send to corresponding variables of 
% main window.

set(handles.fig_LoadRawData,'userdata',0);
guidata(hObject, handles);
a = get(handles.Table_ColumnNo,'data');
a(isnan(a)) = 0;
b = size(get(handles.Table_SampleData,'data'),2);
if sum(fix(a(a~=0))) ~= sum(a(a~=0))
    uiwait(errordlg('You should enter the columns nnumbers.'));
    return
end
if a(1) == 0
    uiwait(errordlg('Time should enter columns numbers.'));
    return
end
if sum(a~=0) < 2
    uiwait(errordlg('At least you should select two columns.'));
    return
end
if sum(a > b) > 0
    uiwait(errordlg('The columnts numbers should be less or equal of your data columns.'));
    return
end
for ii = 1:b
    if sum(a==ii) > 1
        uiwait(errordlg('A Column number shouldn''t repeat.'));
        return
    end
end
set(handles.fig_LoadRawData,'visible','off');
userdata.ColumnNo = a;
userdata.Description = get(handles.Edit_Description, 'String');
userdata.ProjectName = get(handles.Edit_ProjectName, 'String');
userdata.Units       = get(handles.Table_Units,'data');
set(handles.fig_LoadRawData,'userdata',userdata);
guidata(hObject, handles);


function fig_LoadRawData_CloseRequestFcn(hObject, eventdata, handles)
set(handles.fig_LoadRawData,'userdata',nan);
set(handles.fig_LoadRawData,'visible','off');
guidata(hObject, handles);


function Edit_ProjectName_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Edit_Description_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LoadDescription_Callback(hObject, eventdata, handles)
% User can load any saved description by "load description" button.
[FileName,PathName] = uigetfile({'*.txt';'*.*'}...
    ,'Load Description','MultiSelect','off',handles.userdata.pathname);
if FileName 
    Description = importdata([PathName,FileName]);
    set(handles.Edit_Description,'string',char(Description));
end


function Edit_Description_Callback(hObject, eventdata, handles)

function Edit_ProjectName_Callback(hObject, eventdata, handles)


function fig_LoadRawData_KeyPressFcn(hObject, eventdata, handles)
% If return key pressed it means that user finished loading new raw data!
if strcmpi(eventdata.Key,'return')
    pushbutton_Finish_Callback(hObject, eventdata, handles);
end


function fig_LoadRawData_WindowButtonDownFcn(hObject, eventdata, handles)

function fig_LoadRawData_ButtonDownFcn(hObject, eventdata, handles)
