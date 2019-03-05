function varargout = Theory(varargin)
% This function is associated with function theory.fig.
% This function (with theory.fig) made a theory window, which user has access to 
% it using icon with shape like "alpha" in icon bar. 
% User can use theory window to calculate theoretical values of translational 
% and rotational for three basic geometrical shapes; sphere, spheroid and cylinder.

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Theory_OpeningFcn, ...
    'gui_OutputFcn',  @Theory_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function figTheory_CreateFcn(hObject, eventdata, handles)


function Theory_OpeningFcn(hObject, eventdata, handles, varargin)
% Call this function when window theory opens.
% At the beginning we use sphere as a default and set the shape, colors and pop-up menues
% We set all colors of objects manually  --> The colors will be the same in all systems.

handles.output = hObject;
[x, y, z] = ellipsoid(0,0,0,10,10,10,30);
surfl(x, y, z)
colormap gray
axis equal
color = .9;
set(handles.axes1,'XTickLabel','');
set(handles.axes1,'XTick',[]);
set(handles.axes1,'YTickLabel','');
set(handles.axes1,'YTick',[]);
set(handles.axes1,'ZTickLabel','');
set(handles.axes1,'ZTick',[]);
set(handles.axes1,'box','off');
set(handles.TextAxis,'string','Sphere');
set(handles.TextMinAx,'string','Radius');
set(handles.TextMaxAx,'visible','off');
set(handles.U2,'visible','off');
set(handles.MaxAx,'visible','off');
uistack(handles.PopShape , 'up', 1);
uistack(handles.MinAx , 'up', 2);
uistack(handles.PopU , 'up', 3);
uistack(handles.MaxAx , 'up', 4);
uistack(handles.T , 'up', 5);
uistack(handles.Vis , 'up', 6);
set(handles.figTheory,'clipping','on');
set(hObject,'color',[color color color]);
set(handles.Calculate ,'backgroundcolor',[color color color]);
set(handles.Close ,'backgroundcolor',[color color color]);
% set(handles.MinAx ,'backgroundcolor',[color color color]);
% set(handles.MaxAx ,'backgroundcolor',[color color color]);
% set(handles.PopShape ,'backgroundcolor',[color color color]);
% set(handles.PopU ,'backgroundcolor',[color color color]);
% set(handles.T ,'backgroundcolor',[color color color]);
% set(handles.Vis ,'backgroundcolor',[color color color]);
set(handles.U2 ,'backgroundcolor',[color color color]);
set(handles.UC ,'backgroundcolor',[color color color]);
set(handles.UVis ,'backgroundcolor',[color color color]);
set(handles.SendToResults ,'backgroundcolor',[color color color]);
set(handles.text1 ,'backgroundcolor',[color color color]);
set(handles.text2 ,'backgroundcolor',[color color color]);
set(handles.text3 ,'backgroundcolor',[color color color]);
set(handles.text5 ,'backgroundcolor',[color color color]);
set(handles.TextAxis ,'backgroundcolor',[color color color]);
set(handles.TextMaxAx ,'backgroundcolor',[color color color]);
set(handles.TextMinAx ,'backgroundcolor',[color color color]);
set(handles.TextResult ,'backgroundcolor',[color color color]);
set(handles.uipanel1 ,'backgroundcolor',[color color color]);
set(handles.axes1,'color',color*[1 1 1]);
set(handles.axes1,'xcolor',color*[1 1 1]);
set(handles.axes1,'ycolor',color*[1 1 1]);
set(handles.axes1,'zcolor',color*[1 1 1]);
guidata(hObject, handles);


function varargout = Theory_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function UC_Callback(hObject, eventdata, handles)
% Callback function for unit of temperature
function UC_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function UVis_Callback(hObject, eventdata, handles)
% Callback function for unit of viscosity
function UVis_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function U2_Callback(hObject, eventdata, handles)
% Callback function for second unit of size.
function U2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TextResult_Callback(hObject, eventdata, handles)
% Callback function for the text area of results.
function TextResult_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function PopShape_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PopShape_Callback(hObject, eventdata, handles)
% Callback function for the shapes pop-up menu.
% user can select for shapes; sphere, prolate spheroid, oblate spheroid
% Whene ever user change the shape pop-up menu, the program change 
% the parameters and shape corresponding to pop-up item.
a = get(handles.PopShape,'value');
set(handles.TextMinAx,'string','Minor Axis:');
set(handles.TextMaxAx,'visible','on');
set(handles.U2,'visible','on');
set(handles.MaxAx,'visible','on');
set(handles.TextMaxAx,'string','Major Axis:');
% Switch between different shapes
switch a
    case 1
        [x, y, z] = ellipsoid(0,0,0,10,10,10,30);
        set(handles.TextAxis,'string','Sphere');
        set(handles.TextMinAx,'string','Radius:');
        set(handles.TextMaxAx,'visible','off');
        set(handles.U2,'visible','off');
        set(handles.MaxAx,'visible','off');
    case 2
        [x, y, z] = ellipsoid(0,0,0,5,5,10,30);
        set(handles.TextAxis,'string',{'Prolate Spheroid';'(Rotate Around Major Axis)'});
    case 3
        [x, y, z] = ellipsoid(0,0,0,10,10,5,30);
        set(handles.TextAxis,'string',{'Oblate Spheroid';'(Rotate Around Minor Axis)'});
    case 4
        [x, y, z] = cylinder(.1+0*(0:30));
        set(handles.TextAxis,'string','Cylinder');
        set(handles.TextMinAx,'string','Radius:');
        set(handles.TextMaxAx,'string','Length:');
end
surfl(x, y, z)
colormap gray
axis equal
color = .9;
set(handles.axes1,'color',color*[1 1 1]);
set(handles.axes1,'xcolor',color*[1 1 1]);
set(handles.axes1,'ycolor',color*[1 1 1]);
set(handles.axes1,'zcolor',color*[1 1 1]);
set(handles.axes1,'XTickLabel','');
set(handles.axes1,'XTick',[]);
set(handles.axes1,'YTickLabel','');
set(handles.axes1,'YTick',[]);
set(handles.axes1,'ZTickLabel','');
set(handles.axes1,'ZTick',[]);
set(handles.axes1,'box','off');


function PopU_Callback(hObject, eventdata, handles)
% Callback function for unit of size. It would change the 
% second unit (U2) automaticlly
st = get(hObject,'string');
set(handles.U2,'string',st(get(hObject,'value')));


function PopU_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MaxAx_Callback(hObject, eventdata, handles)
% Callback function for the length of major axis (longer axis in the shape)
% for sphere only minor axis is visible.
s = get(handles.MaxAx,'string');
if (str2double(s) <= 0)  || isnan(str2double(s))
    set(handles.MaxAx,'string','');
end
guidata(hObject,handles);


function MaxAx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MinAx_Callback(hObject, eventdata, handles)
% Callback function for the length of major axis (longer axis in the shape)
% for sphere only minor axis is visible.
s = get(handles.MinAx,'string');
if (str2double(s) <= 0)  || isnan(str2double(s))
    set(handles.MinAx,'string','');
end
guidata(hObject,handles);


function MinAx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Vis_Callback(hObject, eventdata, handles)
% Callback function for viscosity value.
s = get(handles.Vis,'string');
if (str2double(s) <= 0)  || isnan(str2double(s))
    set(handles.Vis,'string','');
end
guidata(hObject,handles);


function Vis_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function T_Callback(hObject, eventdata, handles)
% Callback function for Temperature value.
s = get(handles.T,'string');
if (str2double(s) <= -280)  || isnan(str2double(s))
    set(handles.T,'string','');
end
guidata(hObject,handles);


function T_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Calculate_Callback(hObject, eventdata, handles)
% Callback function for calculate button. According to the values of 
% pop menues and the shape selected in pop-up shape, it uses theoretical 
% functions (Tshpere, Tprolatespheroid, Toblatespheroid, Tlongcylinder) 
% to calculate translational and rotational diffusion coefficients
% and write them in text results area.

T = str2double(get(handles.T,'string'));
e = str2double(get(handles.Vis,'string'));
a = str2double(get(handles.MaxAx,'string'));
b = str2double(get(handles.MinAx,'string'));
Ut = ' (m^2/S)';
Ur = ' (rad^2/S)';
i = get(handles.PopU,'value');
U = get(handles.PopU,'string');
a = a*10^(-3*(i-1));
b = b*10^(-3*(i-1));
if ~isnan(T) && ~isnan(e) && ~isnan(b)
    T = T + 273.15;
    switch get(handles.PopShape,'value')
        case 1
            D = TSphere(T,e,b);
            s = {['Diffusion = ' num2str(D) Ut]};
            ss = {'--------------------';...
                '  -- Theory Calculation';...
                'Shape: Sphere';...
                ['Radius: ' num2str(b) ' (' char(U(i)) ')'];...
                ['Temperature: ' num2str(T-273.15) ' (C)'];...
                ['Viscosity: ' num2str(e) ' (Pa.S)']};
            str(1:6,1) = ss;
            str(7,1) = s;
        case 2
            if isnan(a)
                return
            end
            [Dt_a,Dt_b,Dr_a,Dr_b] = TProlateSpheroid(T,e,a,b);
            s0 = '  -- Translational Diffusion:';
            s1 = ['Parallel to Prolate Axis = ' num2str(Dt_a) Ut];
            s2 = ['Perpendicular to Prolate Axis = ' num2str(Dt_b) Ut];
            s2p = '  -- Rotational Diffusion:';
            s3 = ['Around the Prolate Axis = ' num2str(Dr_a) Ur];
            s4 = ['Around Axis Perpendicular to Prolate Axis = ' num2str(Dr_b) Ur];
            ss = {'--------------------';...
                '  -- Theory Calculation';...
                'Shape: Prolate Spheroid';...
                ['Major Axis: ' num2str(a) ' (' char(U(i)) ')'];...
                ['Minor Axis: ' num2str(b) ' (' char(U(i)) ')'];...
                ['Temperature: ' num2str(T-273.15) ' (C)'];...
                ['Viscosity: ' num2str(e) ' (Pa.S)']};
            s = {s0;s1;s2;s2p;s3;s4};
            str(1:7,1) = ss;
            str(8:13,1) = s;
        case 3
            if isnan(a)
                return
            end
            [Dt_a,Dt_b,Dr_a,Dr_b] = TOblateSpheroid(T,e,b,a);
            s0 = '  -- Translational Diffusion:';
            s1 = ['Parallel to Oblate Axis = ' num2str(Dt_a) Ut];
            s2 = ['Perpendicular to Oblate Axis = ' num2str(Dt_b) Ut];
            s2p = '  -- Rotational Diffusion:';
            s3 = ['Around the Oblate Axis = ' num2str(Dr_a) Ur];
            s4 = ['Around Axis Perpendicular to Oblate Axis = ' num2str(Dr_b) Ur];
            ss = {'--------------------';...
                '  -- Theory Calculation';...
                'Shape: Oblate Spheroid';...
                ['Major Axis: ' num2str(a) ' (' char(U(i)) ')'];...
                ['Minor Axis: ' num2str(b) ' (' char(U(i)) ')'];...
                ['Temperature: ' num2str(T-273.15) ' (C)'];...
                ['Viscosity: ' num2str(e) ' (Pa.S)']};
            s = {s0;s1;s2;s2p;s3;s4};
            str(1:7,1) = ss;
            str(8:13,1) = s;
        case 4
            if isnan(a)
                return
            end
            [Dt_a,Dt_b,Dr_a,Dr_b] = TLongCylinder(T,e,a,b);
            s0 = '  -- Translational Diffusion:';
            s1 = ['Parallel to Cylinder Axis = ' num2str(Dt_a) Ut];
            s2 = ['Perpendicular to Cylinder Axis = ' num2str(Dt_b) Ut];
            s2p = '  -- Rotational Diffusion:';
            s3 = ['Around the Cylinder Axis = ' num2str(Dr_a) Ur];
            s4 = ['Around Axis Perpendicular to Cylinder Axis = ' num2str(Dr_b) Ur];
            ss = {'--------------------';...
                '  -- Theory Calculation';...
                'Shape: Long Cylinder';...
                ['Radius: ' num2str(b) ' (' char(U(i)) ')'];...
                ['Length: ' num2str(a) ' (' char(U(i)) ')'];...
                ['Temperature: ' num2str(T-273.15) ' (C)'];...
                ['Viscosity: ' num2str(e) ' (Pa.S)']};
            s = {s0;s1;s2;s2p;s3;s4};
            str(1:7,1) = ss;
            str(8:13,1) = s;
    end
    set(handles.TextResult,'string',s);
    set(handles.figTheory,'userdata',str);
end


function SendToResults_Callback(hObject, eventdata, handles)
% Callback function for Send to results button. It sends the 
% text in results area of theory window to Results Window of 
% main program.

if ~isempty(get(handles.figTheory,'userdata'))
    h = findobj(allchild(0),'flat','Tag','EditLog');
    h = findobj(allchild(h),'flat','Tag','Editor');
    s1  = cellstr([datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Calculate Theory']);
    s = cellstr(get(h,'string'));
    set(h,'string',[s;s1]);
    h = findobj(allchild(0),'flat','Tag','EditResults');
    h = findobj(allchild(h),'flat','Tag','Editor');
    s1 = cellstr(get(handles.figTheory,'userdata'));
    s = cellstr(get(h,'string'));
    set(h,'string',[s;s1]);
end

function Close_Callback(hObject, eventdata, handles)
close;


% --- Executes when user attempts to close figTheory.
function figTheory_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figTheory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
