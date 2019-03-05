function varargout = Edit_Log(varargin)
% This function is associated with function Edit_Log.fig.
% It will open a window which user can view and edit its 
% activity during working with program.
% User can save this information as a txt file.

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Edit_Log_OpeningFcn, ...
    'gui_OutputFcn',  @Edit_Log_OutputFcn, ...
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

function Edit_Log_OpeningFcn(hObject, eventdata, handles, varargin)
% When the window open, first it sets colors of the window items.
handles.output = hObject;
color = .9;
set(hObject,'color',[color color color]);
set(handles.Button_Clear ,'backgroundcolor',[color color color]);
set(handles.Button_Close ,'backgroundcolor',[color color color]);
set(handles.Button_Save ,'backgroundcolor',[color color color]);
set(handles.Text ,'backgroundcolor',[color color color]);
guidata(hObject, handles);

function varargout = Edit_Log_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function Editor_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Button_Save_Callback(hObject, eventdata, handles)
% When user click on "Save" button, user activities will be saved as a 
% txt file.
h  = findobj(allchild(0),'flat','Tag','KOJA');
h1 = findobj(allchild(h),'flat','Tag','projectname');
h2 = findobj(allchild(h),'flat','Tag','ProjectPathName');
Nnn = get(h1,'string');
if isempty(Nnn)
    Nnn = datestr(now,'yyyy-mmm-dd_HH-MM-SS');
else
    ind = regexpi(Nnn, '[ A-Z]');
    Nnn = Nnn(ind);
    Nnn(findstr(Nnn,' ')) = '_';
end
pathname = get(h2,'string');
filters = {'*.txt'};
experssion = {'Text File (*.txt)'};
[filename, pathname, filterindex] = uiputfile (...
    [filters;experssion]','Report Log', [pathname 'Log_' Nnn,'.txt']);
if filterindex
    [a,b] = fileparts(filename);
    log = char(get(handles.Editor,'string'));
    fid = fopen([pathname, b, '.txt'],'w+');
    set(h2,'string',pathname);
    for ii = 1:size(log,1)
        fprintf(fid,[log(ii,:),char(13),char(10)]);
    end
    fclose(fid);
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
        '  -- Export Log as a TXT file with name ',...
        filename,' to ',pathname];
    h = findobj(allchild(0),'flat','Tag','EditLog');
    h = findobj(allchild(h),'flat','Tag','Editor');
    s = get(h,'string');
    set(h,'string',[s;s1]);
end


function Button_Close_Callback(hObject, eventdata, handles)
% Close a log window
Close


function Button_Clear_Callback(hObject, eventdata, handles)
% Clear an editable text area of log window
set(handles.Editor,'string','');


function EditLog_CloseRequestFcn(hObject, eventdata, handles)
set(handles.EditLog,'visible','off');

function ss = ClearSpaces(s)
% To avoid any problem in the name of saved file, 
% spaces in the name of file would be clear.
a = find(~(s == ' '));
if numel(a)
    ss = s(1:a(end));
else
    ss = '';
end
