function varargout = imat(varargin)
% imat M-file for imat.fig
%      imat, by itself, creates a new imat or raises the existing
%      singleton*.
%
%      H = imat returns the handle to a new imat or the handle to
%      the existing singleton*.
%
%      imat('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in imat.M with the given input arguments.
%
%      imat('Property','Value',...) creates a new imat or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imat_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  se "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help imat

% Last Modified by GUIDE v2.5 07-Nov-2004 16:40:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @imat_OpeningFcn, ...
    'gui_OutputFcn',  @imat_OutputFcn, ...
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


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function update_gui(handles,setupfile)
%
if isa(setupfile,'char')==1
    load([setupfile]);    
    PNAME=imati.source.path;
    if imati.source.single        
        pos=find(PNAME==DELI);
        [q1 q2]=size(pos);
        [qq1 qq2]=size(PNAME);
        PICS=dir(PNAME);
        PNAME=PNAME(1:pos(q2));
    end
    
    if imati.source.single==1
        pname=[PNAME PICS(1).name];
    else
        pname=PNAME;
        % SOM I   amt_file    
    end
    set(handles.Opened_data, 'String', imati.source.path);
    set(handles.Output, 'String', imati.output.index);
    set(handles.Smax, 'String', imati.analysis.smax);
    set(handles.GridX, 'String', imati.grid.gridx);
    set(handles.GridY, 'String', imati.grid.gridy);
    set(handles.Iter, 'String', imati.analysis.points);
    set(handles.Channel, 'String', imati.source.channel);
    set(handles.Resize, 'String', num2str(imati.source.resize));
    set(handles.imtype,'String',imati.source.imtype);
    set(handles.preprocessonoff, 'Value', imati.analysis.prepro);
    set(handles.preprofile, 'String', imati.analysis.preprofile);
    set(handles.postprocessonoff, 'Value', imati.analysis.postpro);
    set(handles.postprofile, 'String', imati.analysis.postprofile);    
    set(handles.method,'Value',imati.analysis.method);
    set(handles.Unfold, 'Value', imati.analysis.unfold);
    set(handles.single, 'Value', imati.source.single);
    set(handles.gbu,'Value',imati.grid.type.gbu);
    set(handles.Stratified, 'Value', imati.grid.type.stratified);
    set(handles.Systematic, 'Value', imati.grid.type.systematic);
    set(handles.Keepgrid,'Value',imati.grid.type.keepgrid);
    set(handles.AMTplus, 'Value',imati.cutting.type.plus);
    set(handles.Lowercutoff,'String',imati.cutting.lowercutoff);
    set(handles.Uppercutoff,'String',imati.cutting.uppercutoff);   
    set(handles.AMTon, 'Value', imati.cutting.type.onhill);    
    set(handles.Upperonhill,'String',imati.cutting.upperonhill);   
    set(handles.Loweronhill,'String',imati.cutting.loweronhill);       
    set(handles.Remove_bg,'Value',imati.cutting.removebg);
    set(handles.Bg_cutoff, 'String', imati.cutting.bgcutoff);
end    



% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isunix
    DELI='/';
else
    DELI='\';
end
[setupfile,setuppath] = uigetfile('*_imatsetup.mat','Select a GUI setup in the directory');
update_gui(handles,setupfile);



function preprocessonoff(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[setupfile,setuppath] = uiputfile('*_imatsetup.mat','Save the GUI setup in a directory');
[imati]=imat_create_setup(handles);
save([setuppath setupfile '_imatsetup.mat'],'imati');


function [handles]=open_run_button(handles)
pname=get(handles.Opened_data, 'String');
Output=get(handles.Output, 'String');
if ~isempty(pname) && (~isempty(Output))
    % hak on
    set(handles.Run, 'Enable', 'on');    
else
    set(handles.Run, 'Enable', 'off');    
end    


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Question;

% Get the current position of the GUI from the handles structure
% to pass to the modal dialog.
%pos_size=get(handles.imat, 'Exit');
% Call modaldlg with the argument 'Position'.
user_response=imat_modaldlg('Title', 'Confirm Exit');
switch user_response
    case {'No'}
        % take no action
    case 'Yes'
        %Prepare to close GUI application window
        %
        %
        delete(handles.figure1)
end



% --- Executes just before imat is made visible.
function imat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imat (see VARARGIN)
% Choose default command line output for imat
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
if strcmp(get(hObject,'Visible'),'off')
    initialize_gui(hObject, handles);
end
%set(handles.Unfold,'ForegroundColor','red');
%set(handles.method,'ForegroundColor','red');
% UIWAIT makes imat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function initialize_gui(fig_handle, handles)
data.Smax = 250;
data.GridX = 100;
data.GridY = 100;
data.Iter = 1;
data.Channel = 1;
data.Resize = 1;
setappdata(fig_handle, 'metricdata', data);
set(handles.Smax, 'String', data.Smax);
set(handles.GridX, 'String', data.GridX);
set(handles.GridY, 'String', data.GridY);
set(handles.Iter, 'String', data.Iter);
set(handles.Channel, 'String', data.Channel);
set(handles.Resize, 'String', data.Resize);
set(handles.imtype,'String','.tif');
set(handles.single, 'Value', 0);
set(handles.Stratified, 'Value', 1);
set(handles.Systematic, 'Value', 0);
set(handles.Keepgrid,'Enable','on');
set(handles.gbu,'Value',1);
set(handles.Uppercutoff,'Enable','off');
set(handles.Lowercutoff,'Enable','off');
set(handles.text_uppercutoff, 'Enable', 'off');
set(handles.text_lowercutoff, 'Enable', 'off');
set(handles.Upperonhill,'Enable','off');
set(handles.Loweronhill,'Enable','off');
set(handles.text_upperonhill, 'Enable', 'off');
set(handles.text_loweronhill, 'Enable', 'off');
set(handles.Bg_cutoff,'Enable','off');
set(handles.text_bg_cutoff, 'Enable', 'off');
set(handles.Run, 'Enable', 'off');
set(handles.Opened_data,'String',pwd);
set(handles.Unfold, 'String', {'None', 'snake(vertical)', 'snake(horizontal)', 'classic(vertical)*', 'classic(horizontal)', 'spiral', 'tilt_45_degrees', 'tilt_135_degrees'});
set(handles.method, 'String', {'None','AMTlinear','AMTcircle(Andrle)','AMTcirclePWL','AMT2d','Histogram','Starvolume','Geometer','Fourier power sp.','Polar Fourier power sp.','Geodesic distances','Fractal dimension 2D','Fractal dimension 3D'});



% --- Outputs from this function are returned to the command line.
function varargout = imat_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in IMAT.




% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[imati]=imat_create_setup(handles);
method=get(handles.method,'Value');
dev_answer='Yes';
if any(method==[5,13])
    [dev_answer]=imat_dev;   
end
if dev_answer(1:2)=='Ye'
    if imati.sys.queue==1
        [answer]=imat_warning('title','imatt','string','Program is in queue mode !! Proceed ?');        
        if prod(size(answer))==2 all(answer(1:2)=='No')
            open('imat_create_setup.m');    
        else
            setups=imat_queue_setups;
            [N,M]=size(setups);
            for n=1:N
                setupfile=setups(n,:);
                update_gui(handles,char(setupfile));
                [imati]=imat_create_setup(handles);
                imat_main(imati,handles);
            end
        end
    else
        if check_settings(handles)==1
            imat_main(imati,handles);
        end
    end
else
    if check_settings(handles)==1
        set(handles.Run,'String','Run');
        set(handles.Run,'ForegroundColor','black');    
    end
end


% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open([imat_instpath '\doc\' 'imat-16-03-05.pdf']);


% --- Executes during object creation, after setting all properties.
function Opened_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Opened_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Opened_data_Callback(hObject, eventdata, handles)
% hObject    handle to Opened_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Opened_data as text
%        str2double(get(hObject,'String')) returns contents of Opened_data as a double
handles=open_run_button(handles);



% --- Executes during object creation, after setting all properties.
function Output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Output_Callback(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Output as text
%        str2double(get(hObject,'String')) returns contents of Output as a
%        double
if isunix
    DELI='/';
else    
    DELI='\';
end
path=get(handles.Opened_data,'String');
output=get(handles.Output,'String');
already=dir([path DELI 'IMAT_' output '.mat']);
already=size(already);
if already(1)~=0
    set(handles.Output,'BackgroundColor','yellow');
else
    set(handles.Output,'BackgroundColor','white');
end
handles=open_run_button(handles);




% --- Executes on button press in Choose.
function Choose_Callback(hObject, eventdata, handles)
% hObject    handle to Choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SINGLE=get(handles.single, 'Value');
IMTYPE=get(handles.imtype,'String');
CNAME=pwd;
PNAME=get(handles.Choose,'UserData');
if isempty(PNAME) || isa(PNAME,'numeric')
    PNAME=pwd;    
end
cd(PNAME);
if SINGLE==1
    [PICS,PNAME] = uigetfile(IMTYPE,'Select any image file in your directory and they will all be processed');
    set(handles.Opened_data, 'String',[PNAME PICS]);
else
    [PNAME] = uigetdir;
    set(handles.Opened_data, 'String',PNAME);
end
cd(CNAME);
set(handles.Choose,'UserData',PNAME);
handles=open_run_button(handles);


% --- Executes during object creation, after setting all properties.
function Newdata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Newdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Newdata_Callback(hObject, eventdata, handles)
% hObject    handle to Newdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Newdata as text
%        str2double(get(hObject,'String')) returns contents of Newdata as a double
Newdata = str2double(get(hObject, 'String'));
if isnan(edit1)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes during object creation, after setting all properties.
function Channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Channel_Callback(hObject, eventdata, handles)
% hObject    handle to Channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Channel as text
%        str2double(get(hObject,'String')) returns contents of Channel as a double
channel=get(handles.Channel,'String');
if isempty(channel) || str2num(channel)<=0
    set(handles.Channel,'BackgroundColor','red');    
else
    set(handles.Channel,'BackgroundColor','white');    
end

% --- Executes during object creation, after setting all properties.
function Resize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Resize_Callback(hObject, eventdata, handles)
% hObject    handle to Resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Resize as text
%        str2double(get(hObject,'String')) returns contents of Resize as a double
resize=get(handles.Resize,'String');
if isempty(resize) || str2num(resize)<=0
    set(handles.Resize,'BackgroundColor','red');
else
    set(handles.Resize,'BackgroundColor','white');
end


% --- Executes on button press in AMTlinear.
function AMTlinear_Callback(hObject, eventdata, handles)
% hObject    handle to AMTlinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AMTlinear
if get(handles.Systematic,'Value') == 1
    set(handles.Systematic,'Enable','on');
    set(handles.Stratified,'Enable','on');
    set(handles.Keepgrid,'Enable','off');
    set(handles.Keepgrid,'Value',1);
end
if get(handles.Stratified,'Value') == 1
    set(handles.Systematic,'Enable','on');
    set(handles.Stratified,'Enable','on');
    set(handles.Keepgrid,'Enable','on');
    set(handles.Keepgrid,'Value',0);
end
set(handles.Iter,'Enable','on');
set(handles.Smax,'Enable','on');
set(handles.text_smax, 'Enable', 'on');
set(handles.GridX,'Enable','on');
set(handles.GridY,'Enable','on');

set(handles.Unfold, 'Enable', 'on');
set(handles.Systematic,'Enable', 'on');
set(handles.Stratified,'Enable', 'on');
set(handles.AMTplus,'Enable', 'on');
if get(handles.AMTplus, 'Value') == 0
    set(handles.Uppercutoff,'Enable','off');
    set(handles.Lowercutoff,'Enable','off');
    set(handles.text_uppercutoff, 'Enable', 'off');
    set(handles.text_lowercutoff, 'Enable', 'off');
else
    set(handles.Uppercutoff,'Enable','on');
    set(handles.Lowercutoff,'Enable','on');
    set(handles.text_uppercutoff, 'Enable', 'on');
    set(handles.text_lowercutoff, 'Enable', 'on');
end
set(handles.AMTon,'Enable','on');
if get(handles.AMTon, 'Value') == 0
    set(handles.Upperonhill,'Enable','off');
    set(handles.Loweronhill,'Enable','off');
    set(handles.text_upperonhill, 'Enable', 'off');
    set(handles.text_loweronhill, 'Enable', 'off');
else
    set(handles.Upperonhill,'Enable','on');
    set(handles.Loweronhill,'Enable','on');
    set(handles.text_upperonhill, 'Enable', 'on');
    set(handles.text_loweronhill, 'Enable', 'on');
end
set(handles.Remove_bg,'Enable', 'on');
if get(handles.Remove_bg, 'Value') == 0
    set(handles.Bg_cutoff,'Enable','off');
    set(handles.text_bg_cutoff, 'Enable', 'off');
else
    set(handles.Bg_cutoff,'Enable','on');
    set(handles.text_bg_cutoff, 'Enable', 'on');
end


% --- Executes on button press in Systematic.
function Systematic_Callback(hObject, eventdata, handles)
% hObject    handle to Systematic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Systematic
set(handles.Systematic, 'Value', 1);
set(handles.Stratified, 'Value', 0);
set(handles.Keepgrid,'Enable','off');
set(handles.Keepgrid,'Value',1);


% --- Executes on button press in Stratified.
function Stratified_Callback(hObject, eventdata, handles)
% hObject    handle to Stratified (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Stratified
set(handles.Systematic, 'Value', 0);
set(handles.Stratified, 'Value', 1);
set(handles.Keepgrid,'Enable','on');
set(handles.Keepgrid,'Value',0);


% --- Executes on button press in Keepgrid.
function Keepgrid_Callback(hObject, eventdata, handles)
% hObject    handle to Keepgrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Keepgrid
if (get(hObject, 'Value') == get(hObject, 'Max'))
    % then checkbox is checked-take approriate acction    
else
    % checkbox is not checked-take approriate action
end


% --- Executes during object creation, after setting all properties.
function Iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Iter_Callback(hObject, eventdata, handles)
% hObject    handle to Iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Iter as text
%        str2double(get(hObject,'String')) returns contents of Iter as a double
iter=get(handles.Iter,'String');
if isempty(str2num(iter))
    set(handles.Iter,'BackgroundColor','red');    
else
    set(handles.Iter,'BackgroundColor','white');    
end

% --- Executes during object creation, after setting all properties.
function Smax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Smax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Smax_Callback(hObject, eventdata, handles)
% hObject    handle to Smax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Smax as text
%        str2double(get(hObject,'String')) returns contents of Smax as a double
smax=get(handles.Smax,'String');
if isempty(str2num(smax))
    set(handles.Smax,'BackgroundColor','red');    
else
    set(handles.Smax,'BackgroundColor','white');    
end



% --- Executes during object creation, after setting all properties.
function GridX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GridX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function GridX_Callback(hObject, eventdata, handles)
% hObject    handle to GridX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GridX as text
%        str2double(get(hObject,'String')) returns contents of GridX as a double
gridx=get(handles.GridX,'String');
if isempty(str2num(gridx))
    set(handles.GridX,'BackgroundColor','red');    
else
    set(handles.GridX,'BackgroundColor','white');    
end


% --- Executes during object creation, after setting all properties.
function Unfold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Unfold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%% set(hObject, 'String', {'None', 'snake(vertical)', 'snake(horizontal)', 'classic(vertical)*', 'classic(horizontal)', 'spiral', 'tilt_45_degrees', 'tilt_135_degrees'});
%% See imat_OpenFcn


% --- Executes during object creation, after setting all properties.
function GridY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GridY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function GridY_Callback(hObject, eventdata, handles)
% hObject    handle to GridY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GridY as text
%        str2double(get(hObject,'String')) returns contents of GridY as a double
gridy=get(handles.GridY,'String');
if isempty(str2num(gridy))
    set(handles.GridY,'BackgroundColor','red');    
else
    set(handles.GridY,'BackgroundColor','white');    
end


% --- Executes on selection change in Unfold.
function Unfold_Callback(hObject, eventdata, handles)
% hObject    handle to Unfold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Unfold contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Unfold
% unfold=get(handles.Unfold,'Value');
% if unfold==1
%     set(handles.Unfold,'ForegroundColor','red');
% else
%     set(handles.Unfold,'ForegroundColor','black');
% end
ok=check_settings(handles);


% --- Executes on button press in AMTplus.
function AMTplus_Callback(hObject, eventdata, handles)
% hObject    handle to AMTplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AMTplus
if (get(hObject, 'Value') == get(hObject, 'Max'))
    set(handles.Uppercutoff,'Enable','on');
    set(handles.Lowercutoff,'Enable','on');    
    set(handles.text_uppercutoff, 'Enable', 'on');
    set(handles.text_lowercutoff, 'Enable', 'on');   
    lower=get(handles.Lowercutoff,'String');
    upper=get(handles.Uppercutoff,'String');
    if isempty(lower)
        set(handles.Lowercutoff,'BackgroundColor','red');
    else
        set(handles.Lowercutoff,'BackgroundColor','white');
    end
    if isempty(upper)
        set(handles.Uppercutoff,'BackgroundColor','red');
    else
        set(handles.Uppercutoff,'BackgroundColor','white');
    end               
else
    set(handles.Uppercutoff,'Enable','off');
    set(handles.Lowercutoff,'Enable','off');    
    set(handles.text_uppercutoff, 'Enable', 'off');
    set(handles.text_lowercutoff, 'Enable', 'off');   
    set(handles.Lowercutoff,'BackgroundColor','white');
    set(handles.Uppercutoff,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Lowercutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lowercutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Lowercutoff_Callback(hObject, eventdata, handles)
% hObject    handle to Lowercutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lowercutoff as text
%        str2double(get(hObject,'String')) returns contents of Lowercutoff as a double
lower=get(handles.Lowercutoff,'String');
amtplus=get(handles.AMTplus,'Value');
if isempty(str2num(lower)) && amtplus==1
    set(handles.Lowercutoff,'BackgroundColor','red');    
else
    set(handles.Lowercutoff,'BackgroundColor','white');    
end


% --- Executes during object creation, after setting all properties.
function Uppercutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Uppercutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Uppercutoff_Callback(hObject, eventdata, handles)
% hObject    handle to Uppercutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Uppercutoff as text
%        str2double(get(hObject,'String')) returns contents of Uppercutoff as a double
upper=get(handles.Uppercutoff,'String');
amtplus=get(handles.AMTplus,'Value');
if isempty(str2num(upper)) && amtplus==1
    set(handles.Uppercutoff,'BackgroundColor','red');    
else
    set(handles.Uppercutoff,'BackgroundColor','white');    
end


% --- Executes on button press in AMTon.
function AMTon_Callback(hObject, eventdata, handles)
% hObject    handle to AMTon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AMTon
if (get(hObject, 'Value') == get(hObject, 'Max'))    
    set(handles.Upperonhill,'Enable','on');
    set(handles.Loweronhill,'Enable','on');    
    set(handles.text_upperonhill, 'Enable', 'on');
    set(handles.text_loweronhill, 'Enable', 'on');    
    lower=get(handles.Loweronhill,'String');
    upper=get(handles.Upperonhill,'String');
    if isempty(lower)
        set(handles.Loweronhill,'BackgroundColor','red');
    else
        set(handles.Loweronhill,'BackgroundColor','white');
    end
    if isempty(upper)
        set(handles.Upperonhill,'BackgroundColor','red');
    else
        set(handles.Upperonhill,'BackgroundColor','white');
    end               
    
else
    set(handles.Upperonhill,'Enable','off');
    set(handles.Loweronhill,'Enable','off');
    set(handles.text_upperonhill, 'Enable', 'off');
    set(handles.text_loweronhill, 'Enable', 'off');
    set(handles.Loweronhill,'BackgroundColor','white');
    set(handles.Upperonhill,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Loweronhill_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Loweronhill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Loweronhill_Callback(hObject, eventdata, handles)
% hObject    handle to Loweronhill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Loweronhill as text
%        str2double(get(hObject,'String')) returns contents of Loweronhill as a double
lower=get(handles.Loweronhill,'String');
if isempty(str2num(lower))
    set(handles.Loweronhill,'BackgroundColor','red');    
else
    set(handles.Loweronhill,'BackgroundColor','white');    
end


% --- Executes during object creation, after setting all properties.
function Upperonhill_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Upperonhill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Upperonhill_Callback(hObject, eventdata, handles)
% hObject    handle to Upperonhill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Upperonhill as text
%        str2double(get(hObject,'String')) returns contents of Upperonhill as a double
upper=get(handles.Upperonhill,'String');
if isempty(str2num(upper))
    set(handles.Upperonhill,'BackgroundColor','red');    
else
    set(handles.Upperonhill,'BackgroundColor','white');    
end


% --- Executes on button press in Remove_bg.
function Remove_bg_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_bg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Remove_bg
if (get(hObject, 'Value') == get(hObject, 'Max'))
    set(handles.Bg_cutoff,'Enable','on');    
    set(handles.text_bg_cutoff, 'Enable', 'on');    
else
    set(handles.Bg_cutoff,'Enable','off');    
    set(handles.text_bg_cutoff, 'Enable', 'off');    
end

% --- Executes during object creation, after setting all properties.
function Bg_cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bg_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Bg_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to Bg_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bg_cutoff as text
%        str2double(get(hObject,'String')) returns contents of Bg_cutoff as a double
bg=get(handles.Bg_cutoff,'String');
if isempty(str2num(bg))
    set(handles.Bg_cutoff,'BackgroundColor','red');    
else
    set(handles.Bg_cutoff,'BackgroundColor','white');    
end


% --------------------------------------------------------------------
function imat_about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imat_about


% --- Executes on button press in plotamt.
function plotamt_Callback(hObject, eventdata, handles)
% hObject    handle to plotamt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imato=get(handles.resholder,'UserData');
if ~isempty(imato)
    xpluto(imato.resx,imato.resy,imato.pictures);
else
    xpluto
end

% --- Executes during object creation, after setting all properties.
function METHOD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to METHOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in METHOD.
function METHOD_Callback(hObject, eventdata, handles)
% hObject    handle to METHOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns METHOD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from METHOD


% --- Executes on button press in postprocessonoff.
function postprocessonoff_Callback(hObject, eventdata, handles)
% hObject    handle to postprocessonoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of postprocessonoff

% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in method.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method
method=get(handles.method,'Value');
if method==1
    set(handles.postprocessonoff,'Value',0);
    set(handles.postprocessonoff,'Enable','Off');
    %    set(handles.method,'ForegroundColor','red');
else
    set(handles.postprocessonoff,'Enable','On');
    %    set(handles.method,'ForegroundColor','black');
end
ok=check_settings(handles);




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in viewprepro.
function viewprepro_Callback(hObject, eventdata, handles)
% hObject    handle to viewprepro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path=get(handles.Opened_data,'String');
single=get(handles.single,'Value');
imtype=get(handles.imtype,'String');
channel=get(handles.Channel,'String');
preprofile=get(handles.preprofile,'String');
if single
    [path,image]=xpathfile(path);
else
    image=['*' imtype];
end
xprepro(1,path,image,preprofile,channel);



% --- Executes on button press in preprocessonoff.
function preprocessonoff_Callback(hObject, eventdata, handles)
% hObject    handle to preprocessonoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of preprocessonoff
set(handles.preprofile,'BackgroundColor','white');


% --- Executes on button press in single.
function single_Callback(hObject, eventdata, handles)
% hObject    handle to single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of single
set(handles.Opened_data, 'String', '');

% --- Executes on button press in gbu.
function gbu_Callback(hObject, eventdata, handles)
% hObject    handle to gbu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gbu
gbu=get(handles.gbu,'Value');
if gbu==0
    set(handles.GridY,'Enable','Off');
    set(handles.text_gridy,'Enable','Off');
else
    set(handles.GridY,'Enable','On');
    set(handles.text_gridy,'Enable','On');
end


% --- Executes during object creation, after setting all properties.
function imtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function imtype_Callback(hObject, eventdata, handles)
% hObject    handle to imtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imtype as text
%        str2double(get(hObject,'String')) returns contents of imtype as a double


% --- Executes during object creation, after setting all properties.
function preprofile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function preprofile_Callback(hObject, eventdata, handles)
% hObject    handle to preprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of preprofile as text
%        str2double(get(hObject,'String')) returns contents of preprofile as a double




% --- Executes during object creation, after setting all properties.
function postprofile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to postprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function postprofile_Callback(hObject, eventdata, handles)
% hObject    handle to postprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of postprofile as text
%        str2double(get(hObject,'String')) returns contents of postprofile as a double

% --- Executes on button press in selectprefile.
function selectprefile_Callback(hObject, eventdata, handles)
% hObject    handle to selectprefile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curpath=pwd;
cd([imat_instpath imat_userpath]);
[file,path] = uigetfile('*.m','Pre-process file');
if isstr(file)
    sf=size(file);
    set(handles.preprofile,'String',file(1,1:sf(2)-2));
end
cd(curpath);

% --- Executes on button press in selectpostfile.
function selectpostfile_Callback(hObject, eventdata, handles)
% hObject    handle to selectpostfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curpath=pwd;
cd([imat_instpath imat_userpath]);
[file,path] = uigetfile('*.m','Post-process file');
if isstr(file)
    sf=size(file);
    set(handles.postprofile,'String',file(1,1:sf(2)-2));
end
cd(curpath);


function ok=check_settings(handles)
defaultcolor=get(0,'defaultUicontrolBackgroundColor');
ok=1;
method=get(handles.method,'Value');
if method==1   % None
    
end
if any(method==[2,3,4])   % AMT 1d
    unfold=get(handles.Unfold,'Value');
    if unfold==1
        set(handles.Unfold,'BackgroundColor','red');
        ok=0;
    else
        set(handles.Unfold,'BackgroundColor','white');
        ok=1;
    end    
end
if any(method==[5,6,7,8,9,10,11,12,13])   % AMT 2d
    unfold=get(handles.Unfold,'Value');
    if unfold~=1
        set(handles.Unfold,'BackgroundColor','red');
        ok=0;
    else
        set(handles.Unfold,'BackgroundColor','white');
        ok=1;
    end        
end
if any(method==[8,11,12,13])   % AMT 2d + others
    preprocessonoff=get(handles.preprocessonoff,'Value');
    preprofile=get(handles.preprofile,'String');
    if preprocessonoff==0 || isempty(preprofile)
        set(handles.preprocessonoff,'BackgroundColor',defaultcolor);
        set(handles.preprofile,'BackgroundColor','red');
        ok=0;
    else
        set(handles.preprocessonoff,'BackgroundColor',defaultcolor);
        set(handles.preprofile,'BackgroundColor','white');
        ok=1;
    end        
end

if any(method==[5,6,7,8,9,10,11,12,13])   % clip image
    amtplus=get(handles.AMTplus,'Value');
    if amtplus==1
        set(handles.AMTplus,'BackgroundColor','red');
        ok=0;
    else
        set(handles.AMTplus,'BackgroundColor',defaultcolor);
        ok=1;
    end            
end
if any(method==[2,3,4])   % clip image
    amtplus=get(handles.AMTplus,'Value');
    lower=get(handles.Lowercutoff,'Value');
    upper=get(handles.Uppercutoff,'Value');    
    if amtplus==1 && (isempty(lower) || isempty(upper))
        set(handles.Lowercutoff,'BackgroundColor','red');
        set(handles.Uppercutoff,'BackgroundColor','red');
        ok=0;
    else
        set(handles.Lowercutoff,'BackgroundColor','white');
        set(handles.Uppercutoff,'BackgroundColor','white');
        ok=1;
    end            
end
amton=get(handles.AMTon,'Value');
lower=get(handles.Loweronhill,'Value');
upper=get(handles.Upperonhill,'Value');    
if any(method==[7])   % clip grid  must for starvol
    set(handles.preprocessonoff,'BackgroundColor',defaultcolor);
    set(handles.preprofile,'BackgroundColor','white');    
    if amton==0 || (isempty(lower) || isempty(upper))
        set(handles.Loweronhill,'BackgroundColor','red');
        set(handles.Upperonhill,'BackgroundColor','red');
        ok=0;
    else
        set(handles.Loweronhill,'BackgroundColor','white');
        set(handles.Upperonhill,'BackgroundColor','white');
        ok=1;
    end         
else
    if amton==1 || (isempty(lower) || isempty(upper))
        set(handles.Loweronhill,'BackgroundColor','red');
        set(handles.Upperonhill,'BackgroundColor','red');
        ok=0;
    else
        set(handles.Loweronhill,'BackgroundColor','white');
        set(handles.Upperonhill,'BackgroundColor','white');
        ok=1;
    end             
end

