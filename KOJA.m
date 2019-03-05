function varargout = KOJA(varargin)
% This function is associated with function KOJA.fig.
% This is a main function of the package. Running this function cause 
% openning Main Window of the programs which give user access to 
% many physical and statistical functions to investigate brownian 
% motion of particles, using menus and icons in main window of the program.

gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @KOJA_OpeningFcn, ...
    'gui_OutputFcn',  @KOJA_OutputFcn, ...
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



% --------------------------------------------------------------------
% -------------------------  My Own Functions  -----------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------



% --------------------------------------------------------------------
function z = zz
% Creat random function for function logo
z=0;
while z==0
    z=rand(1)-0.5;
    z = sign(z);
end



% --------------------------------------------------------------------
function AP = Logo
% Function to plot a random walk motion at the left side of main window.
lw = 1;
dx=0.05;
L=1;
N = 5000;
ii=sqrt(-1);
AP =(1+ii)*ones(1, N);
P=0;
for i=1:N
    AP(i)=P;
    dP = (1+ii)*dx*(zz+ii*zz)/2;
    P = P+dP;
end



% --------------------------------------------------------------------
function handles = Clear_Vars(hObject, handles)
% Clear default values of some parameters 
handles.UserData.Project.Changed = 0;
handles.UserData.RawData.ColumnNo = [0 0 0 0 0];
handles.UserData.Fig.YLabel = '';
handles.UserData.Fig.Err = 0;
handles.UserData.Fig.Grid = 'GridNone';
handles.UserData.Fig.ShowErr = 'off';
handles.UserData.Fig.Method = 'PlotSimple';
handles.UserData.Project.ProjectName = '';
set(handles.projectname,'string','');
set(handles.ProjectPathName,'string','');
handles.UserData.Project.FileName = '';
handles.UserData.Project.PathName = '';
handles.UserData.LabFrame.ini = 0;
handles.UserData.BodyFrame.ini = 0;
handles.UserData.LastMethod = '';
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Clear Variables'];
Add_TextLog(hObject,handles,s1);



% --------------------------------------------------------------------
function handles = Clear_Texts(hObject, handles)
% Clear text area of Results and log windows.
h = findobj(allchild(handles.Results),'flat','Tag','Editor');
set(h,'string','');
h = findobj(allchild(handles.Log),'flat','Tag','Editor');
set(h,'string','');



% --------------------------------------------------------------------
function handles = Clear_Axes(hObject, eventdata, handles)
% Clear figure panel from any diagram.
figure(findobj(allchild(0),'flat','Tag','KOJA'));
axes(handles.axes1);
plot(1,'-w');
set(gca,'Unit','Pixel');
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(handles.EditAxes,'Enable','off');
handles.UserData.Fig.Err = 0;
handles.UserData.Fig.Grid = 'GridNone';
handles.UserData.Fig.Method = 'PlotSimple';
handles.UserData.Fig.x = 0;
handles.UserData.Fig.y = 0;
handles.UserData.Fig.yFit = 0;
handles.UserData.Fig.YLabel = '';
handles.UserData.Fig.XLabel = '';
handles.UserData.Fig.Title = '';
handles.UserData.Fig.Last = '';
cla
xlabel(handles.UserData.Fig.XLabel);
ylabel(handles.UserData.Fig.YLabel);
title(handles.UserData.Fig.Title);
guidata(hObject, handles);



% --------------------------------------------------------------------
function handles = Initialize(hObject, eventdata, handles)
% At the beginning of the program, program will clear axes,
% clear variables, and clear texts in results and log windows.

clc
warning off all
handles = Clear_Axes(hObject, eventdata, handles);
handles = Clear_Vars(hObject, handles);
handles = Clear_Texts(hObject, handles);
handles.UserData.Fig.Last = 'Trajectory';
set(handles.GridNoneIcon,'state','off');
set(handles.GridMajorIcon,'state','off');
set(handles.GridMinorIcon,'state','off');
set(handles.SimpleIcon,'state','off');
set(handles.SemilogxIcon,'state','off');
set(handles.SemilogyIcon,'state','off');
set(handles.LoglogIcon,'state','off');
set(handles.Fraction,'value',0.1);
set(handles.ShowFit,'Value',0);
set(handles.Weight,'Value',0);
set(handles.PopDataSet,'value',1);
set(handles.PopDimention,'value',1);
set(handles.LabFrame ,'value',1);
Disable_All(hObject, handles);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Initializing'];
Add_TextLog(hObject,handles,s1);
set(handles.GridNone,'checked','on');
set(handles.PlotSimple ,'checked','on');



% --------------------------------------------------------------------
function handles = Set_WindowItems(hObject,handles)
% set values of pop menus According to loaded data.
ColumnNumber = handles.UserData.RawData.ColumnNo;
ColumnName = handles.ColumnName;
cnt = 1;
clear empty
for i = 2:5
    if ColumnNumber(i)==0
        if i == 2
            set(handles.XY,'Enable','off');
            set(handles.XZ,'Enable','off');
        end
        if i == 3
            set(handles.XY,'Enable','off');
            set(handles.YZ,'Enable','off');
        end
        if i == 4
            set(handles.XZ,'Enable','off');
            set(handles.YZ,'Enable','off');
        end
        empty(cnt) = i;
        cnt = cnt + 1;
    end
end
try
    ColumnName(empty)=[];
end
if ColumnNumber(1)
    ColumnName(1) = [];
end
set(handles.PopDimention ,'String',ColumnName);
FileNumbers = handles.UserData.RawData.FileNumbers;
PopDataSetString = cell(1,FileNumbers+2);
PopDataSetString(1) = {'Final'};
PopDataSetString(2) = {'All'};
for i = 1:FileNumbers
    PopDataSetString(i+2) = {num2str(i)};
end
set(handles.PopDataSet,'String',PopDataSetString);
handles = Set_MenuTicks(hObject,handles);



% --------------------------------------------------------------------
function handles = Set_MenuTicks(hObject,handles)
% When open the project, it will check that which physical quantitis 
% are calculated and then put a Tick markas beside them.

BdLb     = char(handles.BdLb(get(handles.LabFrame,'value')+1));
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
var = whos('-file', filename);
set(handles.Ensemble,'checked','off');
set(handles.TimeCorr,'checked','off');
set(handles.TimeUncorr,'checked','off');
set(handles.TimeEnsCorr,'checked','off');
set(handles.TimeEnsUnCorr ,'checked','off');
for ii = 1:length(var)
    if sum(strfind(var(ii).name,[BdLb 'Ensemble']))
        set(handles.Ensemble,'checked','on');
    end
    if sum(strfind(var(ii).name,[BdLb 'TimeCorr']))
        set(handles.TimeCorr,'checked','on');
    end
    if sum(strfind(var(ii).name,[BdLb 'TimeUncorr']))
        set(handles.TimeUncorr,'checked','on');
    end
    if sum(strfind(var(ii).name,[BdLb 'TimeEnsCorr']))
        set(handles.TimeEnsCorr,'checked','on');
    end
    if sum(strfind(var(ii).name,[BdLb 'TimeEnsUnCorr']))
        set(handles.TimeEnsUnCorr ,'checked','on');
    end
end



% --------------------------------------------------------------------
function handles = Set_AxesData(hObject, eventdata, handles,tag)
% Set data of axes in plotting area (Figure Panel) according to last 
% calculated quantity or user action.

if nargin == 3
    tag = 'KOJA';
end
h = findobj(allchild(0),'flat','tag',tag);
figure(h(1));
h = findobj(allchild(h(1)),'flat','tag','');
axes(h(1));
set(gca,'XTickmode','auto');
set(gca,'YTickmode','auto');
set(gca,'XTicklabelmode','auto');
set(gca,'YTicklabelmode','auto');
fig = handles.UserData.Fig;
if ~isfield(fig,'PMy')
    fig.PMy = '';
end
if strcmpi(fig.Last, 'DiffusionStatistics')
    fig.PMy = '.-';
end
fig.PMyFit = ':r';
if strcmpi(get(handles.PlotSimple,'check'),'on')
    plot(fig.x, fig.y, fig.PMy);
    if get(handles.ShowFit,'value') && sum(fig.yFit(:))
        hold on
        plot(fig.x(1,:), fig.yFit,fig.PMyFit,'LineWidth',2);
        hold off
    end
end
if strcmpi(get(handles.SemilogX ,'check'),'on')
    semilogx(fig.x, fig.y, fig.PMy);
    if get(handles.ShowFit,'value') && sum(fig.yFit(:))
        hold on
        semilogx(fig.x(1,:), fig.yFit,fig.PMyFit,'LineWidth',2);
        hold off
    end
end
if strcmpi(get(handles.SemilogY ,'check'),'on')
    semilogy(fig.x, fig.y, fig.PMy);
    if get(handles.ShowFit,'value') && sum(fig.yFit(:))
        hold on
        semilogy(fig.x(1,:), fig.yFit,fig.PMyFit,'LineWidth',2);
        hold off
    end
end
if strcmpi(get(handles.Loglog ,'check'),'on')
    loglog(fig.x, fig.y);
    if get(handles.ShowFit,'value') && sum(fig.yFit(:))
        hold on
        loglog(fig.x(1,:), fig.yFit,fig.PMyFit,'LineWidth',2);
        hold off
    end
end
if strcmpi(get(handles.GridNone ,'check'),'on')
    grid off
end
if strcmpi(get(handles.GridMajor ,'check'),'on')
    grid off
    grid on
end
if strcmpi(get(handles.GridMinor ,'check'),'on')
    grid minor
end
if strcmpi(get(handles.ErrorBar ,'check'),'on') && ...
        sum(handles.UserData.Fig.Err(:))
    hold on
    plot(fig.x, fig.y);
    step = fix(size(fig.x,2)./30)+1;
    if size(fig.Err,1) == 1 && size(fig.y,1) == 1
        errorbar(fig.x(:,1:step:end), fig.y(:,1:step:end), ...
            fig.Err(:,1:step:end),'.k');
    end
    hold off
    if get(handles.ShowFit,'value') && sum(fig.yFit(:))
        hold on
        loglog(fig.x(1,:), fig.yFit,fig.PMyFit,'LineWidth',2);
        hold off
    end
end
mx = max(fig.y(abs(fig.y)~=inf));
mn = min(fig.y(abs(fig.y)~=inf));
A = mx - mn;
if A ~= 0
    ylim([mn - A/20 , mx + A/20]);
    xlim([min(fig.x(:)) max(fig.x(:))]);
else
    handles = Clear_Axes(hObject, eventdata, handles);
end
xlabel(fig.XLabel);
ylabel(fig.YLabel);
set(handles.EditAxes,'Enable','on');
title(fig.Title);
handles.UserData.Fig.PMy = '-';
handles.UserData.Project.Changed = true;



% --------------------------------------------------------------------
function Add_TextResult(hObject,handles,varargin)
% Add result of calculated quntity to result window.
ss = varargin';
h = findobj(allchild(handles.Results),'flat','Tag','Editor');
s = get(h,'string');
set(h,'string',[s;ss]);



% --------------------------------------------------------------------
function Add_TextLog(hObject,handles,varargin)
% Add user activity to log window
ss = varargin';
h = findobj(allchild(handles.Log),'flat','Tag','Editor');
s = get(h,'string');
set(h,'string',[s;ss]);



% --------------------------------------------------------------------
function ini = Load_iniFile
% load inifile of the program, if available.
% It has information about user settings in the program.
iniName = [mfilename,'.ini'];
ini = 0;
if exist(iniName,'file')
    load(iniName,'-mat');
    ini = a;
end



% --------------------------------------------------------------------
function Save_iniFile(handles)
% Save user selected settings in the ini file.
a = handles.UserData.RawData;
handles.UserData.Project.PathName = get(handles.ProjectPathName,'string');
a.Project_PathName = handles.UserData.Project.PathName;
a.RawData_PathName = handles.UserData.RawData.PathName;
a.Units = handles.UserData.Project.Units;
save([mfilename,'.ini'],'a');



% --------------------------------------------------------------------
function handles = Save_RawDatatoAllDatas(hObject,eventdata,handles)
% Save the values of raw data file to an external file with the name of AllDatas.mat
% It helps user to free memory from any extra data. It helps user to work with large 
% data files.

a = handles.UserData.RawData;
Theta = handles.UserData.Project.Units(5);
PathName = handles.UserData.RawData.PathName;
name = handles.ColumnName;
for ii = 1:a.FileNumbers
    if a.FileNumbers > 1
        if ~exist([PathName,char(a.FileNames(ii))],'file')
            uiwait(errordlg(char([cellstr(...
                'Raw data files not found. The project is correpted.'); ...
                cellstr('The Project is not opened.')])));
            handles = Initialize(hObject, eventdata, handles);
            return
        end
    else
        if ~exist([PathName,char(a.FileNames)],'file')
            uiwait(errordlg(char([cellstr(...
                'Raw data files not found. The project is correpted.');...
                cellstr('The Project is not opened.')])));
            handles = Initialize(hObject, eventdata, handles);
            return
        end
    end
end
h = waitbar2(0.02,'Loading...');
m = sum(a.ColumnNo~=0);
if a.FileNumbers == 1
    RawData = importdata([PathName a.FileNames]);
    for jj = 1:5
        j = a.ColumnNo(jj);
        if j
            Data = RawData(:,j)';
            if  jj == 5
                if ~strcmpi(Theta,'d')
                    aa = cellstr(handles.UserData.Project.Units);
                    aa(5) = {'rad'};
                    handles.UserData.Project.Units = char(aa);
                else
                    Data = Data /180*pi;
                    aa = cellstr(handles.UserData.Project.Units);
                    aa(5) = {'Degree'};
                    handles.UserData.Project.Units = char(aa);
                end
            end
            if jj == 1
                Time  = Data ;
                dTime =Time(:,2:end)-meshgrid(Time(:,1),1:size(Time,2)-1)';
                try
                    delete([PathName 'AllDatas.mat']);
                end
                save([PathName 'AllDatas.mat'],'Time');
                save([PathName 'AllDatas.mat'],'dTime','-append');
            else
                eval([char(name(jj)) '_Lab_Pos = Data;']);
                save([PathName 'AllDatas.mat'],...
                    [char(name(jj)) '_Lab_Pos'],'-append');
            end
        end
        if ~ishandle(waitbar2(jj/5))
            break
        end
    end
else
    temp = importdata([PathName,char(a.FileNames(ii))]);
    Data = zeros(a.FileNumbers,size(temp,1),m);
    Col = find(a.ColumnNo~=0);
    for ii = 1:a.FileNumbers
        RawData = importdata([PathName,char(a.FileNames(ii))]);
        for jj = 1:m
            j = a.ColumnNo(Col(jj));
            Data(ii,:,jj) = RawData(:,j);
        end
        if ~mod(ii,a.FileNumbers/20)
            if ~ishandle(waitbar2(ii/a.FileNumbers))
                break
            end
        end
    end
    if  a.ColumnNo(5)
        if ~strcmpi(Theta,'d')
            aa = cellstr(handles.UserData.Project.Units);
            aa(5) = {'rad'};
            handles.UserData.Project.Units = char(aa);
        else
            Data = Data /180*pi;
            aa = cellstr(handles.UserData.Project.Units);
            aa(5) = {'Degree'};
            handles.UserData.Project.Units = char(aa);
        end
    end
    Time  = Data(:,:,1);
    dTime = Time(:,2:end)-meshgrid(Time(:,1),1:size(Time ,2)-1)';
    try
        delete([PathName 'AllDatas.mat']);
    end
    save([PathName 'AllDatas.mat'],'Time');
    save([PathName 'AllDatas.mat'],'dTime','-append');
    clear Time dTime
    for j = 2:m
        jj = Col(j);
        eval([char(name(jj)) '_Lab_Pos = Data(:,:,j);']);
        save([PathName 'AllDatas.mat'],[char(name(jj)) '_Lab_Pos'],...
            '-append');
        eval(['clear ' char(name(jj)) '_Lab_Pos;']);
    end
end
if ishandle(h)
    close(h);
end
if a.ColumnNo(2) && a.ColumnNo(3) && a.ColumnNo(5)
    aa = load([PathName 'AllDatas.mat'], 'X_Lab_Pos');
    x = aa.X_Lab_Pos;
    aa = load([PathName 'AllDatas.mat'], 'Y_Lab_Pos');
    y = aa.Y_Lab_Pos;
    aa = load([PathName 'AllDatas.mat'], 'Theta_Lab_Pos');
    Theta_Body_Pos = aa.Theta_Lab_Pos;
    [X_Body_Pos, Y_Body_Pos] = body(x,y,Theta_Body_Pos);
    save([PathName 'AllDatas.mat'],'X_Body_Pos','Y_Body_Pos',...
        'Theta_Body_Pos','-append');
    if a.ColumnNo(4)
        aa = load([PathName 'AllDatas.mat'], 'Z_Lab_Pos');
        Z_Body_Pos = aa.Z_Lab_Pos;
        save([PathName 'AllDatas.mat'],'Z_Body_Pos','-append');
    end
end



% --------------------------------------------------------------------
function out = CheckProjectSave(hObject,handles)
% Check if any new changes in project saved or not.
out = 'No';
if isfield(handles.UserData.Project,'Changed')
    if handles.UserData.Project.Changed
        qstring = ['The current project didn''t save. '...
            'Do you want to save it?'];
        out = questdlg(qstring,'Save Warning','Yes','No','Cancel','Yes');
    end
end



% --------------------------------------------------------------------
function status = SaveOrSaveAs(hObject,handles)
% Check that the case is save of save as.
if isfield(handles.UserData.Project,'FileName')
    if ~strcmpi(handles.UserData.Project.FileName,'')
        status = SaveProject(hObject,handles);
        return;
    end
end
status = SaveProjectas(hObject,handles);



% --------------------------------------------------------------------
function status = SaveProjectas(hObject,handles)
% Save project as... . User can open it later and continue its work.
filename = handles.UserData.Project.ProjectName;
status = 0;
if ~numel(filename)
    filename = 'MyProject';
end
filters = {'*.mat'};
experssion = {'Matlab Data File (*.mat)'};
handles.UserData.Project.PathName = get(handles.ProjectPathName,'string');
pathnameold = handles.UserData.Project.PathName;
[filename, pathname, filterindex] = uiputfile (...
    [filters;experssion]','Save Project As',[pathnameold filename,'.mat']);
if filterindex
    [a,b] = fileparts(filename);
    handles.UserData.Project.PathName = pathname;
    set(handles.ProjectPathName,'string',pathname);
    handles.UserData.Project.FileName = [b '.mat'];
    status = SaveProject(hObject,handles);
end



% --------------------------------------------------------------------
function status = SaveProject(hObject,handles)
% Save project. User can open it later and continue its work.
filename = [handles.UserData.RawData.PathName 'AllDatas.mat'];
handles.UserData.Project.PathName = get(handles.ProjectPathName,'string');
a = handles.UserData.Project.PathName;
b = handles.UserData.Project.FileName;
UserData = handles.UserData;
h = findobj(allchild(handles.Description),'flat','Tag','Editor');
UserData.Project.Description = get(h,'string');
h = findobj(allchild(handles.Results),'flat','Tag','Editor');
UserData.Project.Results = get(h,'string');
h = findobj(allchild(handles.Log),'flat','Tag','Editor');
UserData.Project.Log = get(h,'string');
UserData.LastStatus.Fraction = get(handles.Fraction,'value');
UserData.LastStatus.ShowFit  = get(handles.ShowFit,'value');
UserData.LastStatus.Weight = get(handles.Weight,'value');
UserData.LastStatus.PopDataSet = get(handles.PopDataSet,'value');
UserData.LastStatus.PopDimention = get(handles.PopDimention,'value');
UserData.LastStatus.LabFrame = get(handles.LabFrame,'value');
save(filename , 'UserData', '-append');
copyfile(filename ,[a b],'f');
Save_iniFile(handles)
status = 1;
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
    '  -- Save Project As ', b,' to ',a];
Add_TextLog(hObject,handles,s1);



% --------------------------------------------------------------------
function Disable_All(hObject, handles)
% At the beginning of the program because there isn't any data, 
% almost all menues and icons disable.

set(handles.SaveProject,'Enable','off');
set(handles.SaveProjectAs,'Enable','off');
set(handles.SaveFigureAs,'Enable','off');
set(handles.ExportAxesData,'Enable','off');
set(handles.PrintAxes,'Enable','off');
set(handles.TimeAverage,'Enable','off');
set(handles.Ensemble,'Enable','off');
set(handles.TimeEnsembelAverage,'Enable','off');
set(handles.Anomaly,'Enable','off');
set(handles.DiffusionStatistics,'Enable','off');
set(handles.ShowDescription,'Enable','off');
set(handles.DisplacmentHistogram,'Enable','off');
set(handles.VelocityAutocorrelation,'Enable','off');
set(handles.ClearAxes,'Enable','off');
set(handles.ShowDescription,'Enable','off');
set(handles.Trajectory,'Enable','off');
set(handles.Position,'Enable','off');
set(handles.AxisMethod,'Enable','off');
set(handles.Grid,'Enable','off');
set(handles.ErrorBar,'Enable','off');
set(handles.EditAxes,'Enable','off');
set(handles.LabFrame,'Enable','off');
set(handles.BodyFrame,'Enable','off');
set(handles.PopDimention,'Enable','off');
set(handles.PopDataSet,'Enable','off');
set(handles.Fraction,'Enable','off');
set(handles.Weight,'Enable','off');
set(handles.ShowFit,'Enable','off');
set(handles.SaveProjectIcon,'Enable','off');
set(handles.SaveFigureAsIcon,'Enable','off');
set(handles.ExportAxisDataIcon,'Enable','off');
set(handles.PrintIcon,'Enable','off');
set(handles.tcIcon,'Enable','off');
set(handles.tucIcon,'Enable','off');
set(handles.ensIcon,'Enable','off');
set(handles.tecIcon,'Enable','off');
set(handles.teucIcon,'Enable','off');
set(handles.AnomalyIcon,'Enable','off');
set(handles.HistogramIcon,'Enable','off');
set(handles.VAFIcon,'Enable','off');
set(handles.TrajectoryIcon,'Enable','off');
set(handles.XYIcon,'Enable','off');
set(handles.XZIcon,'Enable','off');
set(handles.YZIcon,'Enable','off');
set(handles.SimpleIcon,'Enable','off');
set(handles.SemilogxIcon,'Enable','off');
set(handles.SemilogyIcon,'Enable','off');
set(handles.LoglogIcon,'Enable','off');
set(handles.GridNoneIcon,'Enable','off');
set(handles.GridMajorIcon,'Enable','off');
set(handles.GridMinorIcon,'Enable','off');
set(handles.ErrorBarIcon,'Enable','off');
set(handles.FitIcon,'Enable','off');
set(handles.ShowPlotToolsIcon,'Enable','off');
guidata(hObject, handles);



% --------------------------------------------------------------------
function Enable_All(hObject, handles)
% After loading raw data or opening a project, menus and icons will be enabled.
set(handles.SaveProject,'Enable','on');
set(handles.SaveProjectAs,'Enable','on');
set(handles.SaveFigureAs,'Enable','on');
set(handles.ExportAxesData,'Enable','on');
set(handles.PrintAxes,'Enable','on');
set(handles.TimeAverage,'Enable','on');
if handles.UserData.RawData.FileNumbers ~= 1
    set(handles.Ensemble,'Enable','on');
end
set(handles.TimeEnsembelAverage,'Enable','on');
set(handles.ShowDescription,'Enable','on');
set(handles.DisplacmentHistogram,'Enable','on');
set(handles.VelocityAutocorrelation,'Enable','on');
set(handles.ClearAxes,'Enable','on');
set(handles.ShowDescription,'Enable','on');
set(handles.ShowResults,'Enable','on');
set(handles.ShowLog,'Enable','on');
set(handles.Trajectory,'Enable','on');
set(handles.Position,'Enable','on');
set(handles.AxisMethod,'Enable','on');
set(handles.Grid,'Enable','on');
set(handles.ErrorBar,'Enable','on');
set(handles.EditAxes,'Enable','on');
set(handles.LabFrame,'Enable','on');
set(handles.GridNoneIcon,'state','on');
set(handles.SimpleIcon,'state','on');
theta = handles.UserData.RawData.ColumnNo(5);
x = handles.UserData.RawData.ColumnNo(2);
y = handles.UserData.RawData.ColumnNo(3);
if (x && y && theta)
    set(handles.BodyFrame,'Enable','on');
end
set(handles.PopDimention,'Enable','on');
set(handles.PopDataSet,'Enable','on');
set(handles.Fraction,'Enable','on');
set(handles.Weight,'Enable','on');
set(handles.ShowFit,'Enable','on');
set(handles.SaveProjectIcon,'Enable','on');
set(handles.SaveFigureAsIcon,'Enable','on');
set(handles.ExportAxisDataIcon,'Enable','on');
set(handles.PrintIcon,'Enable','on');
set(handles.tcIcon,'Enable','on');
set(handles.tucIcon,'Enable','on');
if handles.UserData.RawData.FileNumbers ~= 1
    set(handles.ensIcon,'Enable','on');
end
set(handles.tecIcon,'Enable','on');
set(handles.teucIcon,'Enable','on');
set(handles.HistogramIcon,'Enable','on');
set(handles.VAFIcon,'Enable','on');
set(handles.TrajectoryIcon,'Enable','on');
set(handles.XYIcon,'Enable','on');
set(handles.XZIcon,'Enable','on');
set(handles.YZIcon,'Enable','on');
ColumnNumber = handles.UserData.RawData.ColumnNo;
cnt = 1;
clear empty
for i = 2:5
    if ColumnNumber(i)==0
        if i == 2
            set(handles.XYIcon,'Enable','off');
            set(handles.XZIcon,'Enable','off');
        end
        if i == 3
            set(handles.XYIcon,'Enable','off');
            set(handles.YZIcon,'Enable','off');
        end
        if i == 4
            set(handles.XZIcon,'Enable','off');
            set(handles.YZIcon,'Enable','off');
        end
        empty(cnt) = i;
        cnt = cnt + 1;
    end
end
set(handles.SimpleIcon,'Enable','on');
set(handles.SemilogxIcon,'Enable','on');
set(handles.SemilogyIcon,'Enable','on');
set(handles.LoglogIcon,'Enable','on');
set(handles.GridNoneIcon,'Enable','on');
set(handles.GridMajorIcon,'Enable','on');
set(handles.GridMinorIcon,'Enable','on');
set(handles.ErrorBarIcon,'Enable','on');
set(handles.FitIcon,'Enable','on');
set(handles.ShowPlotToolsIcon,'Enable','on');
guidata(hObject, handles);



% --------------------------------------------------------------------
function handles = Calculate_MSD(hObject, handles, Method)
% Calculate Mean Square Displacements according to loaded raw data.

BdLb     = char(handles.BdLb(get(handles.LabFrame,'value')+1));
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
ChckStat = eval(['get(handles.',Method,',''Checked'');']);
if strcmpi(ChckStat,'off')
    Check = true;
    for ii = 2:5
        if handles.UserData.RawData.ColumnNo(ii)
            varname = char(handles.ColumnName(ii));
            load(filename,[varname BdLb 'Pos']);
            eval(['MD = MD_' Method '(' varname BdLb 'Pos,varname);']);
            eval(['clear ' varname BdLb 'Pos']);
            eval([varname BdLb Method '_dx = MD.dx;']);
            save(filename,'-append',[varname BdLb Method '_dx']);
            eval(['clear ' varname BdLb Method '_dx']);
            eval([varname BdLb Method '_dx2 = MD.dx2;']);
            save(filename,'-append',[varname BdLb Method '_dx2']);
            eval(['clear ' varname BdLb Method '_dx2']);
            eval([varname BdLb Method '_dx_err = MD.dx_err;']);
            save(filename,'-append',[varname BdLb Method '_dx_err']);
            eval(['clear ' varname BdLb Method '_dx_err']);
            eval([varname BdLb Method '_dx2_err = MD.dx2_err;']);
            save(filename,'-append',[varname BdLb Method '_dx2_err']);
            eval(['clear ' varname BdLb Method '_dx2_err']);
            if ~MD.Complete
                Check = false;
                break
            end
            clear MD
        end
    end
    if Check
        eval(['set(handles.' Method ',''checked'',''on'');']);
    end
end



% --------------------------------------------------------------------
function handles = Calculate_Diffusion(hObject,eventdata, handles, Method)
% Calculate diffusion coefficient according to selected "Method"
onoff ={'on';'off'};
handles.UserData.Fig.Last = Method;
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
set(handles.CurrentMethod,'String',Method);
if strcmpi(Method,'TimeCorr') || strcmpi(Method,'TimeUnCorr')
    set(handles.DiffusionStatistics,'Enable','on');
else
    set(handles.DiffusionStatistics,'Enable','off');
end
BdLb = char(handles.BdLb(get(handles.LabFrame,'value')+1));
DimentionIndex = get(handles.PopDimention,'value');
Dimentions = get(handles.PopDimention,'string');
CurrentDimention = char(Dimentions(DimentionIndex));
DataSetIndex = get(handles.PopDataSet,'value')-2;
Weight = get(handles.Weight,'value');
Fraction = str2double(get(handles.Fraction ,'String'));
Unit = char(handles.UserData.Project.Units(DimentionIndex+1));
UTime = char(handles.UserData.Project.Units(1));
dTime = load(filename,'dTime');
dTime = dTime.dTime;
eval(['a = load(''' filename ''','''...
    CurrentDimention BdLb Method '_dx'','''...
    CurrentDimention BdLb Method '_dx2'','''...
    CurrentDimention BdLb Method '_dx_err'','''...
    CurrentDimention BdLb Method '_dx2_err'');']);
eval(['Parameters.dx = a.' CurrentDimention BdLb Method '_dx;']);
eval(['Parameters.dx2 = a.' CurrentDimention BdLb Method '_dx2;']);
eval(['Parameters.dx_err = a.' CurrentDimention BdLb Method '_dx_err;']);
eval(['Parameters.dx2_err = a.' CurrentDimention BdLb Method '_dx2_err;']);
eval(['Diffusion = Diffusion_' Method ...
    '(dTime,Parameters,Fraction,Weight,DataSetIndex);']);
eval([CurrentDimention BdLb Method ' = Diffusion;']);
save(filename,'-append',[CurrentDimention BdLb Method]);
eval(['clear ' CurrentDimention BdLb Method]);
if ~(strcmpi(Method,'TimeCorr') || strcmpi(Method,'TimeUnCorr'))
    DataSetIndex = -1;
end
st = get(handles.PopDataSet,'string');
st = char(st(DataSetIndex+2));
handles.UserData.Fig.YLabel = ['<\Delta' CurrentDimention ...
    '^2>-<\Delta' CurrentDimention '>^2/2(' Unit '^2)'];
if DataSetIndex < 0
    handles.UserData.Fig.XLabel = ['Time (' UTime ')'];
    if isfield(Diffusion,'D_Err')
        handles.UserData.Fig.Title = {[Method ' Diffusion ' ...
            CurrentDimention ' ' BdLb(2:end-1) 'Frame, #' st ];...
            ['Fraction=' num2str(Fraction) ' Weight=' num2str(Weight)...
            ' so (D=' num2str(Diffusion.D) ' \pm ' ...
            num2str(Diffusion.D_Err) ')']};
    else
        handles.UserData.Fig.Title = {[Method ' Diffusion ' ...
            CurrentDimention ' ' BdLb(2:end-1) 'Frame, #' st ];...
            ['Fraction=' num2str(Fraction) ' Weight=' num2str(Weight)...
            ' so (D=' num2str(Diffusion.D) ')']};
    end
    handles.UserData.Fig.x = dTime(1,:);
    handles.UserData.Fig.y = Diffusion.Dt;
    handles.UserData.Fig.yFit = Diffusion.yFit;
    handles.UserData.Fig.Err = Diffusion.Dt_Err;
elseif DataSetIndex == 0
    handles.UserData.Fig.XLabel = ['Time (' UTime ')'];
    if isfield(Diffusion,'D_Err')
        handles.UserData.Fig.Title = {[Method  ' Diffusion ' ...
            CurrentDimention ' ' BdLb(2:end-1) 'Frame, #' st ];...
            ['Fraction=' num2str(Fraction) ...
            ' Weight=' num2str(Weight) ' so (D=' num2str(Diffusion.D)...
            ' \pm ' num2str(Diffusion.D_Err) ')']};
    else
        handles.UserData.Fig.Title = {[Method  ' Diffusion ' ...
            CurrentDimention ' ' BdLb(2:end-1) 'Frame, #' st ];...
            ['Fraction=' num2str(Fraction) ...
            ' Weight=' num2str(Weight) ' so (D=' num2str(Diffusion.D) ')']};
    end
    handles.UserData.Fig.x = dTime(1,:);
    handles.UserData.Fig.y = Diffusion.Dt_S;
    handles.UserData.Fig.yFit = Diffusion.yFit;
    handles.UserData.Fig.Err = Diffusion.Dt_S_Err;
else
    handles.UserData.Fig.XLabel = ['Time (' UTime ')'];
    if isfield(Diffusion,'D_Err')
        handles.UserData.Fig.Title = {[Method ' Diffusion ' ...
            CurrentDimention ' ' BdLb(2:end-1) 'Frame, #' st ];...
            ['Fraction=' num2str(Fraction) ...
            ' Weight=' num2str(Weight) ' so (D=' num2str(Diffusion.D)...
            ' \pm ' num2str(Diffusion.D_Err) ')']};
    else
        handles.UserData.Fig.Title = {[Method ' Diffusion ' ...
            CurrentDimention ' ' BdLb(2:end-1) 'Frame, #' st ];...
            ['Fraction=' num2str(Fraction) ...
            ' Weight=' num2str(Weight) ' so (D=' num2str(Diffusion.D) ')']};
    end
    handles.UserData.Fig.x = dTime(DataSetIndex,:);
    handles.UserData.Fig.y = Diffusion.Dt_S(DataSetIndex,:);
    handles.UserData.Fig.yFit = Diffusion.yFit;
    handles.UserData.Fig.Err = Diffusion.Dt_S_Err(DataSetIndex,:);
end
handles = Set_AxesData(hObject, eventdata, handles);
set(handles.Anomaly,'Enable','on');
set(handles.AnomalyIcon,'Enable','on');
handles.UserData.LastMethod = Method;
handles.UserData.LastTitle = handles.UserData.Fig.Title;
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
    '  -- Calculate Diffusion Coefficients using '...
    ,handles.UserData.LastMethod ' Averaging Method'];
Add_TextLog(hObject,handles,s1);
s0 = '-------------------------------';
s1 = datestr(now,'yyyy-mmm-dd HH:MM:SS');
s2 = '  -- Calculate Diffusion Coeff.';
if isfield(Diffusion,'D_Err')
    s21= ['D = ',num2str(Diffusion.D), ...
        ' with D_Err = ', num2str(Diffusion.D_Err)];
    s22= ['V = ',num2str(Diffusion.V), ...
        ' with V_Err = ', num2str(abs(Diffusion.V_Err))];
else
    s21= ['D = ',num2str(Diffusion.D)];
    s22= ['V = ',num2str(Diffusion.V)];
end
s29= '  -- Options:';
s3 = ['Method: ',handles.UserData.LastMethod];
Dimention = get(handles.PopDimention,'String');
DataSet = get(handles.PopDataSet,'String');
s4 = ['Dimension: ',char(Dimention(get(handles.PopDimention,'value')))];
s5 = ['Dataset: ',char(DataSet(get(handles.PopDataSet,'value')))];
if get(handles.LabFrame,'Value')
    s6 = 'Frame: LabFrame';
else
    s6 = 'Frame: BodyFrame';
end
s7 = '  -- Fit Options:';
s8 = ['Fraction: ',get(handles.Fraction,'String')];
s9 = ['Weight Status: ',char(onoff(get(handles.Weight,'Value')+1))];
Add_TextResult(hObject,handles,'',s0,s1,s2,s21,s22...
    ,s29,s3,s4,s5,s6,s7,s8,s9);



% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------



% --------------------------------------------------------------------
function KOJA_CreateFcn(hObject, eventdata, handles)



% --------------------------------------------------------------------
function KOJA_OpeningFcn(hObject, eventdata, handles, varargin)
% When main window opens, it sets colors of window items and then set
% initial variables.
handles = Clear_Axes(hObject, eventdata, handles);
color = .9;
set(hObject,'color',[color color color]);
set(handles.uipanel7,'backgroundcolor',[color color color]);
set(handles.uipanel8,'backgroundcolor',[color color color]);
set(handles.uipanel9,'backgroundcolor',[color color color]);
set(handles.uipanel12,'backgroundcolor',[color color color]);
set(handles.CurrentData ,'backgroundcolor',[color color color]);
set(handles.BodyFrame ,'backgroundcolor',[color color color]);
set(handles.text13 ,'backgroundcolor',[color color color]);
set(handles.text14 ,'backgroundcolor',[color color color]);
set(handles.text23 ,'backgroundcolor',[color color color]);
set(handles.text22 ,'backgroundcolor',[color color color]);
set(handles.Weight ,'backgroundcolor',[color color color]);
set(handles.ShowFit ,'backgroundcolor',[color color color]);
set(handles.CurrentDataSet ,'backgroundcolor',[color color color]);
set(handles.CurrentDimention ,'backgroundcolor',[color color color]);
set(handles.CurrentMethod ,'backgroundcolor',[color color color]);
set(handles.LabFrame ,'backgroundcolor',[color color color]);
axes(handles.axes6);
AP = Logo;
hold on; axis equal; axis off;
a = hsv2rgb([255*(rand(1)) 211 200]/255);
plot(real(AP), imag(AP),  'color', a, 'linewidth', 1);
axes(handles.axes1);
handles.Description = Edit_Description('CALLBACK',...
    hObject,eventdata,handles);
set(handles.Description,'visible','off');
handles.Log = Edit_Log('CALLBACK',hObject,eventdata,handles);
set(handles.Log,'visible','off');
handles.Results = Edit_Results('CALLBACK',hObject,eventdata,handles);
handles = Initialize(hObject, eventdata, handles);
handles.ColumnName = {'Time','X','Y','Z','Theta'};
handles.BdLb   = {'_Body_', '_Lab_'};
handles.output = hObject;
ini = Load_iniFile;
if isfield(ini,'Project_PathName')
    set(handles.ProjectPathName,'string',ini.Project_PathName);
else
    set(handles.ProjectPathName,'string','D:\');
end
guidata(hObject, handles);



% --------------------------------------------------------------------
function varargout = KOJA_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;



% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------



% --------------------------------------------------------------------
function LoadRawData_Callback(hObject, eventdata, handles)
% Callback functin for "load raw data". When user clicks on "load raw data",
% a window of load raw data will be opened.
checkans = CheckProjectSave(hObject,handles);
if strcmpi(checkans ,'Cancel')
    return
end;
handles = Initialize(hObject, eventdata, handles);
if strcmpi(checkans ,'Yes')
    handles.UserData.Project.Changed = ~SaveOrSaveAs(hObject,handles);
end
ini = Load_iniFile;
if isfield(ini,'RawData_PathName')
    pathname = ini.RawData_PathName;
    set(handles.ProjectPathName,'string',ini.Project_PathName);
else
    pathname = 'D:\';
end
try
    delete([pathname 'AllDatas.mat']);
end
[FileName,PathName] = uigetfile({'*.txt';'*.mat';'*.dat';'*.*'}...
    ,'Peak Raw Data Files','MultiSelect','on',pathname);
if PathName
    if iscell(FileName)
        FileNumbers = length(FileName);
    else
        FileNumbers = 1;
    end
    if FileNumbers == 1
        Data = importdata([PathName,FileName]);
    else
        Data = importdata([PathName,char(FileName(1))]);
    end
    if ~isnumeric(Data)
        uiwait(errordlg('The selected file is not a raw data file.'));
        return;
    end
    if size(Data,1) > 10
        Data = Data(1:10,:);
    end
    a = load_raw_data('CALLBACK',hObject,eventdata,handles,Data,ini);
    waitfor(a,'Visible','off');
    aa = get(a,'userdata');
    close(a);
    delete(a);
    if isstruct(aa)
        handles.UserData.RawData.ColumnNo = aa.ColumnNo;
        handles.UserData.RawData.FileNames = FileName;
        handles.UserData.RawData.FileNumbers = FileNumbers;
        handles.UserData.RawData.PathName = PathName;
        handles.UserData.Project.ProjectName = aa.ProjectName;
        handles.UserData.Project.Description = aa.Description;
        handles.UserData.Project.Changed = 1;
        handles.UserData.Project.Units = char(aa.Units);
        handles = Save_RawDatatoAllDatas(hObject,eventdata,handles);
        Save_iniFile(handles);
        s1 = '-------------------------------';
        s2 = ['Project Name: ' handles.UserData.Project.ProjectName];
        Add_TextResult(hObject,handles,'',s1,s2);
        Enable_All(hObject, handles);
        handles = Set_WindowItems(hObject,handles);
        s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Loading Raw Data'];
        Add_TextLog(hObject,handles,s1);
        handles = Trajectory_Callback(hObject, eventdata, handles);
        h = findobj(allchild(handles.Description),'flat','Tag','Editor');
        set(h,'string',handles.UserData.Project.Description);
        set(handles.projectname,'string',...
            handles.UserData.Project.ProjectName);
        set(handles.projectname,'string',aa.ProjectName);
    end
end
guidata(hObject,handles);



% --------------------------------------------------------------------
function OpenProject_Callback(hObject, eventdata, handles)
% Callback functin for "open project". When user clicks on "open project",
% a window will be open which user should set a path and file name to its project.

checkans = CheckProjectSave(hObject,handles);
if strcmpi(checkans ,'Cancel')
    return
end;
if strcmpi(checkans ,'Yes')
    handles.UserData.Project.Changed = ~SaveOrSaveAs(hObject,handles);
end
ini = Load_iniFile;
if isfield(ini,'Project_PathName')
    pathname = ini.Project_PathName;
    set(handles.ProjectPathName,'string',ini.Project_PathName);
else
    pathname = 'D:\';
end
try
    delete([pathname 'AllDatas.mat']);
end
filters = {'*.mat'};
experssion = {'MATLAB Data File (*.mat)'};
[filename, pathname, filterindex] = uigetfile (...
    [filters;experssion]','Open Project', [pathname '*.mat']);
if filterindex
    load([pathname filename],'UserData');
    if exist('UserData','var')
        if ~isfield(UserData,'RawData') || ...
                ~isfield(UserData,'Project')
            uiwait(errordlg('This Mat file isn''t a project file.'));
            return
        end
    else
        uiwait(errordlg('This Mat file isn''t a project file.'));
        return
    end
    if ~isfield(UserData.RawData,'ColumnNo') || ...
            ~isfield(UserData.RawData,'FileNames') || ...
            ~isfield(UserData.RawData,'FileNumbers') || ...
            ~isfield(UserData.Project,'ProjectName') || ...
            ~isfield(UserData.Project,'FileName')
        uiwait(errordlg('This Mat file isn''t a project file.'));
        return
    end
    handles = Initialize(hObject, eventdata, handles);
    handles.UserData = UserData;
    pn = handles.UserData.RawData.PathName;
    copyfile([pathname filename],[pn 'AllDatas.mat'],'f')
    if strcmpi(handles.UserData.Project.FileName,'')
        return
    end
    if handles.UserData.Fig.YLabel == 0
        handles = Clear_Axes(hObject, eventdata, handles);
    else
        handles = Set_AxesData(hObject, eventdata, handles);
    end
    s1 = '-------------------------------';
    s2 = ['Project Name  : ' handles.UserData.Project.ProjectName];
    Add_TextResult(hObject,handles,'',s1,s2);
    Enable_All(hObject, handles);
    handles = Set_WindowItems(hObject,handles);
    set(handles.Fraction,'value',handles.UserData.LastStatus.Fraction);
    set(handles.ShowFit,'value',handles.UserData.LastStatus.ShowFit);
    set(handles.Weight,'value',handles.UserData.LastStatus.Weight);
    set(handles.PopDataSet,'value',handles.UserData.LastStatus.PopDataSet);
    set(handles.PopDimention,'value',...
        handles.UserData.LastStatus.PopDimention);
    set(handles.LabFrame,'value',handles.UserData.LastStatus.LabFrame);
    set(handles.CurrentMethod,'string',handles.UserData.LastMethod );
    if strcmpi(handles.UserData.LastMethod,'TimeCorr') || ...
            strcmpi(handles.UserData.LastMethod,'TimeUnCorr')
        set(handles.DiffusionStatistics,'Enable','on');
    else
        set(handles.DiffusionStatistics,'Enable','off');
    end
    set(handles.projectname,'string',handles.UserData.Project.ProjectName);
    set(handles.ProjectPathName,'string',pathname);
    handles.UserData.Project.PathName = pathname;
    Save_iniFile(handles);
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Opening Project'];
    Add_TextLog(hObject,handles,s1);
    h = findobj(allchild(handles.Description),'flat','Tag','Editor');
    set(h,'string',handles.UserData.Project.Description);
    h = findobj(allchild(handles.Results),'flat','Tag','Editor');
    set(h,'string',handles.UserData.Project.Results);
    handles.UserData.Project.Changed = 0;
end
guidata(hObject,handles);



% --------------------------------------------------------------------
function SaveProject_Callback(hObject, eventdata, handles)
% Callback functin for "save project".
handles.UserData.Project.Changed = ~SaveOrSaveAs(hObject,handles);
guidata(hObject,handles);



% --------------------------------------------------------------------
function SaveProjectAs_Callback(hObject, eventdata, handles)
% Callback functin for "save project".
handles.UserData.Project.Changed = ~SaveProjectas(hObject,handles);
guidata(hObject,handles);



% --------------------------------------------------------------------
function SaveFigureAs_Callback(hObject, eventdata, handles)
% Callback functin for "save figure as". When user click on "save figure as", 
% the figure in plotting area will be saved as jpg, bmp, png, eps, .....

fig = handles.UserData.Fig;
hfig = figure('Tag','SaveFigureAs');
set(hfig ,'visible','off');
haxes = axes('Parent',hfig,'Tag','');
Set_AxesData(hObject, eventdata, handles,'SaveFigureAs');
set(hfig ,'visible','off');
filters = {'*.fig','*.jpg','*.png','*.bmp','*.eps','*.pdf','*.ai',...
    '*.emf','*.m','*.pbm','*.pcx','*.pgm','*.ppm','*.tif','*.tif'};
experssion  = {'MATLAB figure (*.fig)','JPEG image (*.jpg)',...
    'Portable Network Graphics (*.png)','Windows bitmap (*.bmp)',...
    'EPS Level (*.eps)','Portable Document Format (*.pdf)',...
    'Adobe® Illustrator `88 (*.ai)','Enhanced metafile (*.emf)',...
    'MATLAB M-file  (*.m)','Portable bitmap (*.pbm)',...
    'Paintbrush 24-bit (*.pcx)','Portable Graymap (*.pgm)',...
    'Portable Pixmap (*.ppm)','TIFF image(compressed) (*.tif)',...
    'TIFF image (*.tif)'};
filename = char(fig.Title(1));
handles.UserData.Project.PathName = get(handles.ProjectPathName,'string');
pathname = handles.UserData.Project.PathName;
if isempty(filename)
    filename = ['Fig_' datestr(now,'yyyy-mmm-dd_HH-MM-SS')];
else
    ind = regexpi(filename, '[ A-Z]');
    filename = filename(ind);
    filename(findstr(filename,' ')) = '_';
end
[filename, pathname, filterindex] = uiputfile (...
    [filters;experssion]','Save Figure As', [pathname filename,'.fig']);
if filterindex
    [a,b] = fileparts(filename);
    if isempty(b)
        b = ['Fig_' datestr(now,'yyyy-mmm-dd_HH-MM-SS')];
    end
    set(hfig,'visible','on');
    ext = char(filters(filterindex));
    if filterindex==15
        saveas(hfig,[pathname, b, ext(2:end)],'tiffn');
    else
        saveas(hfig,[pathname, b, ext(2:end)],ext(3:end));
    end;
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
        '  -- Save Figure with name ',filename,'.',ext(3:end),...
        ' to ',pathname];
    Add_TextLog(hObject,handles,s1);
end
close(hfig)
guidata(hObject,handles);



% --------------------------------------------------------------------
function ExportAxesData_Callback(hObject, eventdata, handles)
% Callback functin for "export axis data". When user clicks on export axes data,
% the data of plotted figure will be save as dat, txt, or xls file to use in any 
% other external programs such as origin, excell , .....

fig = handles.UserData.Fig;
filters = {'*.txt','*.mat','*.xls'};
experssion = {'Text File (*.txt)','MATLAB Data File (*.mat)',...
    'Excel File (*.xls)'};
if isempty(fig.Title)
    fig.Title = ['AxisData_' datestr(now,'yyyy-mmm-dd_HH-MM-SS')];
end
filename = char(fig.Title(1));
if isempty(filename)
    filename = ['Fig_' datestr(now,'yyyy-mmm-dd_HH-MM-SS')];
else
    ind = regexpi(filename, '[ A-Z]');
    filename = filename(ind);
    filename(findstr(filename,' ')) = '_';
end
handles.UserData.Project.PathName = get(handles.ProjectPathName,'string');
pathname = handles.UserData.Project.PathName;
[filename, pathname, filterindex] = uiputfile (...
    [filters;experssion]','Export Axes Data', [pathname filename,'.txt']);
data(:,1) = fig.x(:,1);
data(:,2:size(fig.y,2)+1) = fig.y;
switch filterindex
    case 1
        [a,b] = fileparts(filename);
        if isempty(b)
            b = ['AxisData_' datestr(now,'yyyy-mmm-dd_HH-MM-SS')];
        end
        save([pathname, b, '.txt'],'data','-ascii');
    case 2
        [a,b] = fileparts(filename);
        if isempty(b)
            b = ['AxisData_' datestr(now,'yyyy-mmm-dd_HH-MM-SS')];
        end
        save([pathname, b, '.mat'],'data');
    case 3
        [a,b] = fileparts(filename);
        if isempty(b)
            b = ['AxisData_' datestr(now,'yyyy-mmm-dd_HH-MM-SS')];
        end
        xlswrite([pathname, b, '.xls'],data);
end
if filterindex
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
        '  -- Export Axis Data as a MAT file with name ',...
        filename,' to ',pathname];
    Add_TextLog(hObject,handles,s1);
end
guidata(hObject,handles);



% --------------------------------------------------------------------
function PrintAxes_Callback(hObject, eventdata, handles)
% Callback functin for "print axes". When user clicks on "print axes" 
% a copy of the axes plotted in figure area will be sent to printer.

hfig = figure('Tag','PrintAxes');
haxes = axes('Parent',hfig,'Tag','');
set(hfig ,'visible','off');
Set_AxesData(hObject, eventdata, handles, 'PrintAxes');
set(hfig ,'visible','off');
uiwait(printpreview(hfig));
guidata(hObject,handles);
close(hfig);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Print Current Figure'];
Add_TextLog(hObject,handles,s1);



% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% Colse a main window and exit the program.
close(handles.KOJA);



% --------------------------------------------------------------------
function EditAxes_Callback(hObject, eventdata, handles)
% Callback functin for "edit axes". When user clicks on edit axes,
% a plotted axes will be open in new figure and there where be many 
% other extra tools to change the view of the figure. E.g. colors,
% thicknesses, labels, etc.

hfig = figure('Tag','EditAxis');
haxes = axes('Parent',hfig,'Tag','');
handles = Set_AxesData(hObject, eventdata, handles, 'EditAxis');
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Show Plot in New Window'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function ShowResults_Callback(hObject, eventdata, handles)
% % Callback functin for "Show results". When user clicks on "show results",
% a results window will be opened.
set(handles.Results,'visible','on');



% --------------------------------------------------------------------
function ShowDescription_Callback(hObject, eventdata, handles)
% % Callback functin for "Show description". When user clicks on "show description",
% a description window will be opened.
set(handles.Description,'visible','on');



% --------------------------------------------------------------------
function ShowLog_Callback(hObject, eventdata, handles)
% Callback functin for "Show log". When user clicks on "show log",
% a log window will be opened.
set(handles.Log,'visible','on');



% --------------------------------------------------------------------
function ClearResultsPanel_Callback(hObject, eventdata, handles)
% Callback functin for "clear results". When user clicks on "clear results",
% texts in results window will be clear.

set(handles.Text_Result,'string','');
handles.UserData.Project.TextResult = '';
set(handles.ShowDescription,'Checked','off');
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Clear Results Panel'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function ClearLogPanel_Callback(hObject, eventdata, handles)
% Callback functin for "clear log". When user clicks on "clear log",
% texts in log window will be clear.
set(handles.Text_Log,'string','');
handles.UserData.Project.TextLog = '';
guidata(hObject,handles);



% --------------------------------------------------------------------
function ClearAxes_Callback(hObject, eventdata, handles)
% Callback functin for "clear axes". When user clicks on "clear axes",
% plotted axes in figure panel will be clear.
handles = Clear_Axes(hObject, eventdata, handles);
guidata(hObject,handles);



% --------------------------------------------------------------------
function TimeCorr_Callback(hObject, eventdata, handles)
% Callback function for TimeCorr function. When user clicks on 
% "time average ----> correlated" the program will calculate diffusion coefficinet
% using this method.
Method = 'TimeCorr';
handles = Calculate_MSD(hObject, handles, Method);
handles = Calculate_Diffusion(hObject,eventdata, handles, Method);
guidata(hObject,handles);



% --------------------------------------------------------------------
function TimeUncorr_Callback(hObject, eventdata, handles)
% Callback function for TimeUnCorr function. When user clicks on 
% "time average ----> uncorrelated" the program will calculate diffusion coefficinet
% using this method.
Method = 'TimeUncorr';
handles = Calculate_MSD(hObject, handles, Method);
handles = Calculate_Diffusion(hObject,eventdata, handles, Method);
set(handles.TimeUncorr,'checked','on');
guidata(hObject,handles);



% --------------------------------------------------------------------
function Ensemble_Callback(hObject, eventdata, handles)
% Callback function for ensemble function. When user clicks on 
% "ensemble average" the program will calculate diffusion coefficinet
% using this method.
Method = 'Ensemble';
set(handles.PopDataSet,'value',1);
handles = Calculate_MSD(hObject, handles, Method);
handles = Calculate_Diffusion(hObject,eventdata, handles, Method);
set(handles.Ensemble,'checked','on');
guidata(hObject,handles);



% --------------------------------------------------------------------
function TimeEnsCorr_Callback(hObject, eventdata, handles)
% Callback function for TimeEnsCorr function. When user clicks on 
% "time-ensemble average ----> correlated" the program will calculate diffusion coefficinet
% using this method.
Method = 'TimeEnsCorr';
set(handles.PopDataSet,'value',1);
handles = Calculate_MSD(hObject, handles, Method);
handles = Calculate_Diffusion(hObject,eventdata, handles, Method);
set(handles.TimeEnsCorr,'checked','on');
guidata(hObject,handles);



% --------------------------------------------------------------------
function TimeEnsUnCorr_Callback(hObject, eventdata, handles)
% Callback function for TimeEnsUnCorr function. When user clicks on 
% "time-ensembe average ----> uncorrelated" the program will calculate diffusion coefficinet
% using this method.
Method = 'TimeEnsUnCorr';
set(handles.PopDataSet,'value',1);
handles = Calculate_MSD(hObject, handles, Method);
handles = Calculate_Diffusion(hObject,eventdata, handles, Method);
set(handles.TimeEnsUnCorr,'checked','on');
guidata(hObject,handles);



% --------------------------------------------------------------------
function GridNone_Callback(hObject, eventdata, handles)
% Remove any grid from axes
set(handles.GridMajor,'checked','off');
set(handles.GridMinor,'checked','off');
set(handles.GridNone,'checked','on');
handles = Set_AxesData(hObject, eventdata, handles);
handles.UserData.Fig.Grid = 'GridNone';
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Clear any Grid'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function GridMajor_Callback(hObject, eventdata, handles)
% Add major grid to axes
set(handles.GridMajor,'checked','on');
set(handles.GridMinor,'checked','off');
set(handles.GridNone,'checked','off');
handles = Set_AxesData(hObject, eventdata, handles);
handles.UserData.Fig.Grid = 'GridMajor';
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Change to Major Grid'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function GridMinor_Callback(hObject, eventdata, handles)
% Add minor grid to axes
set(handles.GridMajor,'checked','off');
set(handles.GridMinor,'checked','on');
set(handles.GridNone,'checked','off');
handles = Set_AxesData(hObject, eventdata, handles);
handles.UserData.Fig.Grid = 'GridMinor';
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Change to Minor Grid'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function SemilogX_Callback(hObject, eventdata, handles)
% Plot in semilogx
set(handles.PlotSimple ,'checked','off');
set(handles.SemilogX ,'checked','on');
set(handles.SemilogY ,'checked','off');
set(handles.Loglog ,'checked','off');
handles = Set_AxesData(hObject, eventdata, handles);
handles.UserData.Fig.Grid = 'SemilogX';
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- SemilogX'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function SemilogY_Callback(hObject, eventdata, handles)
% plot in semilogy
set(handles.PlotSimple ,'checked','off');
set(handles.SemilogX ,'checked','off');
set(handles.SemilogY ,'checked','on');
set(handles.Loglog ,'checked','off');
handles = Set_AxesData(hObject, eventdata, handles);
handles.UserData.Fig.Grid = 'SemilogY';
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- SemilogY'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function PlotSimple_Callback(hObject, eventdata, handles)
% plot in simple mode
set(handles.PlotSimple ,'checked','on');
set(handles.SemilogX ,'checked','off');
set(handles.SemilogY ,'checked','off');
set(handles.Loglog ,'checked','off');
handles = Set_AxesData(hObject, eventdata, handles);
handles.UserData.Fig.Grid = 'PlotSimple';
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Simple Plot'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function Loglog_Callback(hObject, eventdata, handles)
% plot in log log
set(handles.PlotSimple ,'checked','off');
set(handles.SemilogX ,'checked','off');
set(handles.SemilogY ,'checked','off');
set(handles.Loglog ,'checked','on');
handles = Set_AxesData(hObject, eventdata, handles);
handles.UserData.Fig.Grid = 'Loglog';
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- LogLog'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function ErrorBar_Callback(hObject, eventdata, handles)
% Add errorbars to figure if available
if strcmpi(get(handles.ErrorBar,'checked'),'on')
    set(handles.ErrorBar,'checked','off');
    set(handles.ErrorBarIcon,'state','off');
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Hide ErrorBars'];
    Add_TextLog(hObject,handles,s1);
else
    set(handles.ErrorBar,'checked','on');
    set(handles.ErrorBarIcon,'state','on');
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Show ErrorBars'];
    Add_TextLog(hObject,handles,s1);
end



% --------------------------------------------------------------------
function Anomaly_Callback(hObject, eventdata, handles)
% Callback function for anomaly. When user click on "anomaly", 
% the program will calculate the amount of anomaly for the last
% method of calculating diffusion. 

handles.UserData.Fig.Last = 'Anomaly';
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
Method   = handles.UserData.LastMethod;
BdLb     = char(handles.BdLb(get(handles.LabFrame,'value')+1));
Weight   = get(handles.Weight,'value');
fraction = str2double(get(handles.Fraction ,'String'));
DimentionIndex = get(handles.PopDimention,'value');
Dimentions = get(handles.PopDimention,'string');
CurrentDimention = char(Dimentions(DimentionIndex));
DataSetIndex = get(handles.PopDataSet,'value')-2;
if ~isempty(findstr(Method,'Ens')) || (DataSetIndex == 0)
    DataSetIndex = -1;
    set(handles.PopDataSet,'value',1);
end
Unit = char(handles.UserData.Project.Units(DimentionIndex+1));
UTime = char(handles.UserData.Project.Units(1));
x = load(filename, 'dTime');
x = x.dTime;
eval(['a = load(''' filename ''','''...
    CurrentDimention BdLb Method '_dx'','''...
    CurrentDimention BdLb Method '_dx2'','''...
    CurrentDimention BdLb Method '_dx_err'','''...
    CurrentDimention BdLb Method '_dx2_err'');']);
eval(['Parameters.dx = a.' CurrentDimention BdLb Method '_dx;']);
eval(['Parameters.dx2 = a.' CurrentDimention BdLb Method '_dx2;']);
eval(['Parameters.dx_err = a.' CurrentDimention BdLb Method '_dx_err;']);
eval(['Parameters.dx2_err = a.' CurrentDimention BdLb Method '_dx2_err;']);
eval(['Diffusion = Diffusion_' Method ...
    '(x,Parameters,fraction,Weight,DataSetIndex);']);
x = x(1,:);
if DataSetIndex < 0
    y = Diffusion.Dt;
elseif DataSetIndex > 0
    y = Diffusion.Dt_S(DataSetIndex,:);
end
if ~get(handles.Weight,'value')
    WW = ones(1,length(y));
    A_P = Anomaly(y,x,fraction,WW);
else
    A_P = Anomaly(y,x,fraction,handles.UserData.Fig.Err);
end
handles.UserData.Fig.XLabel = ['Log Time (' UTime ')'];
handles.UserData.Fig.YLabel = ['Log <\Delta' CurrentDimention ...
    '^2>-<\Delta' CurrentDimention '>^2(' Unit '^2)'];
handles.UserData.Fig.Title = {handles.UserData.LastTitle{1}; ...
    [handles.UserData.LastTitle{2} ' & Anomaly = ' num2str(A_P.Value)]};
handles.UserData.Fig.x = A_P.x;
handles.UserData.Fig.y = A_P.y;
handles.UserData.Fig.yFit = A_P.yFit;
handles = Set_AxesData(hObject, eventdata, handles);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Calculate Anomaly'];
Add_TextLog(hObject,handles,s1);
s0 = '-------------------------------';
s1 = datestr(now,'yyyy-mmm-dd HH:MM:SS');
s2 = ' -- Calculate Anomaly';
s25 = ['Value: ',num2str(A_P.Value),' with Err ', num2str(A_P.da)];
s26 = ['Kind: ', A_P.String];
s27 = '  -- Options:';
s3 = ['Method: ',handles.UserData.LastMethod];
Dimention = get(handles.PopDimention,'String');
DataSet = get(handles.PopDataSet,'String');
s4 = ['Dimension: ',char(Dimention(get(handles.PopDimention,'value')))];
s5 = ['Dataset: ',char(DataSet(get(handles.PopDataSet,'value')))];
if get(handles.LabFrame,'Value')
    s6 = 'Frame: LabFrame';
else
    s6 = 'Frame: BodyFrame';
end
s7 = '  -- Fit Options:';
s8 = ['Fraction: ',get(handles.Fraction,'String')];
s9 = ['Weight Status: ',get(handles.Weight,'Value')];
Add_TextResult(hObject,handles,'',s0,s1,s2,s3,s25...
    ,s26,s27,s4,s5,s6,s7,s8,s9);
guidata(hObject,handles);



% --------------------------------------------------------------------
function CalculateTheroy_Callback(hObject, eventdata, handles)
% Callback function for theory. When user clicks on "theory", 
% window of theory will be opened.
Theory('CALLBACK',hObject,eventdata,handles);



% --------------------------------------------------------------------
function DiffusionStatistics_Callback(hObject, eventdata, handles)
% Callback function for diffusion statistics. When user clicks on "diffusion statistics",
% program will draw diffusion coefficient for each data set statistically and draw a 
% horizontal line be half of final diffusion coefficient.

handles.UserData.Fig.Last = 'DiffusionStatistics';
Method = handles.UserData.LastMethod;
handles = Calculate_MSD(hObject, handles,Method);
set(handles.PopDataSet,'value',2);
BdLb = char(handles.BdLb(get(handles.LabFrame,'value')+1));
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
DimentionIndex = get(handles.PopDimention,'value');
Dimentions = get(handles.PopDimention,'string');
CurrentDimention = char(Dimentions(DimentionIndex));
Weight = get(handles.Weight,'value');
Fraction = str2double(get(handles.Fraction ,'String'));
Unit = char(handles.UserData.Project.Units(DimentionIndex+1));
UTime = char(handles.UserData.Project.Units(1));
load(filename, [CurrentDimention BdLb Method]);
eval(['handles.UserData.Fig.y = ' CurrentDimention BdLb Method '.D_S;']);
eval(['D = ' CurrentDimention BdLb Method '.D;']);
handles.UserData.Fig.Err = 0;
handles.UserData.Fig.x = 1:length(handles.UserData.Fig.y);
handles.UserData.Fig.yFit = (1:length(handles.UserData.Fig.x))*0+D;
handles.UserData.Fig.XLabel = 'Number of Data Sets';
handles.UserData.Fig.YLabel = ['Diffusion Coefficients (' ...
    Unit '^2/' UTime ')'];
handles.UserData.Fig.Title = {['Statistic of ' Method ' ' ...
    CurrentDimention ' ' BdLb(2:end-1) 'Frame']; ...
    ['Fraction=' num2str(Fraction) ' Weight=' num2str(Weight)...
    '(D_{final}=' num2str(D) ')']};
handles = Set_AxesData(hObject, eventdata, handles);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
    '  -- Draw Diffusion Statistics'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function DisplacmentHistogram_Callback(hObject, eventdata, handles)
% Callback function for histogram function. When user clicks on "Displacement histogram",
% porgram will calculate displacements histogram.

handles.UserData.Fig.Last = 'DisplacmentHistogram';
Method = 'Ensemble';
handles.UserData.LastMethod = Method;
set(handles.DiffusionStatistics,'enable','off');
set(handles.CurrentMethod,'string',Method);
handles = Calculate_MSD(hObject, handles,Method);
set(handles.PopDataSet,'value',2);
BdLb = char(handles.BdLb(get(handles.LabFrame,'value')+1));
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
DimentionIndex = get(handles.PopDimention,'value');
Dimentions = get(handles.PopDimention,'string');
CurrentDimention = char(Dimentions(DimentionIndex));
Unit = char(handles.UserData.Project.Units(DimentionIndex+1));
dx = load(filename, [CurrentDimention BdLb Method '_dx']);
eval(['dx = dx.' CurrentDimention BdLb Method '_dx;']);
dTime = load(filename, 'dTime');
N     = size(dTime.dTime,2);
dTime = dTime.dTime(1,:);
Data(size(dx,1),N) = 0;

for i = 1:N
    Data(:,i) = dx(:,i)/sqrt(dTime(i));
end
hist_par = Histogram(Data(:));
cfun = fit(hist_par.X',hist_par.Y','gauss1');
handles.UserData.Fig.Err = 0;
handles.UserData.Fig.x = hist_par.X;
handles.UserData.Fig.y = hist_par.Y;
handles.UserData.Fig.yFit = feval(cfun,hist_par.X');
handles.UserData.Fig.XLabel = ['Displacments (' Unit ')'];
handles.UserData.Fig.YLabel = 'Frequency';
handles.UserData.Fig.Title = {['Historgram of Displacments '...
    CurrentDimention ' ' BdLb(2:end-1) 'Frame ' Method ...
    ', D_{hist} = ' num2str((cfun.c1)^2/4)]};
handles = Set_AxesData(hObject, eventdata, handles);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
    '  -- Calculate Displacement Histogram For Ensemble Average'];
Add_TextLog(hObject,handles,s1);
s0 = '-------------------------------';
s1 = datestr(now,'yyyy-mmm-dd HH:MM:SS');
s2 = ' -- Calculate Displacement Histogram';
s25 = ['D_hist: ',num2str((cfun.c1)^2/4)];
s26 = '  -- Options:';
s3 = 'Method: Ensemble';
Dimention = get(handles.PopDimention,'String');
DataSet = get(handles.PopDataSet,'String');
s4 = ['Dimension: ',char(Dimention(get(handles.PopDimention,'value')))];
s5 = ['Dataset: ',char(DataSet(get(handles.PopDataSet,'value')))];
if get(handles.LabFrame,'Value')
    s6 = 'Frame: LabFrame';
else
    s6 = 'Frame: BodyFrame';
end
Add_TextResult(hObject,handles,'',s0,s1,s2,s3,s25,s26,s4,s5,s6);
guidata(hObject,handles);



% --------------------------------------------------------------------
function VelocityAutocorrelation_Callback(hObject, eventdata, handles)
% Callback function for velocity autocorrelation function. When user clicks on "velocity autocorrelation",
% porgram will calculate velocity autocorrelation function.

handles.UserData.Fig.Last = 'VelocityAutocorrelation';
BdLb = char(handles.BdLb(get(handles.LabFrame,'value')+1));
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
DimentionIndex = get(handles.PopDimention,'value');
Dimentions = get(handles.PopDimention,'string');
CurrentDimention = char(Dimentions(DimentionIndex));
Fraction = str2double(get(handles.Fraction ,'String'));
DataSetIndex = get(handles.PopDataSet,'value')-2;
x = load(filename, [CurrentDimention BdLb  'Pos']);
eval(['x = x.' CurrentDimention BdLb  'Pos;']);
Time = load(filename, 'Time');
Time = Time.Time;
Unit = char(handles.UserData.Project.Units(DimentionIndex+1));
UTime = char(handles.UserData.Project.Units(1));
AutoCorr_Par = AutoCorr_Vel(x,Time,Fraction);
cfun = fit(AutoCorr_Par.t',AutoCorr_Par.fun','exp1');
if DataSetIndex < 0
    Time = AutoCorr_Par.t';
    y    = AutoCorr_Par.fun';
elseif DataSetIndex > 0
    cfun = fit(AutoCorr_Par.t_S(DataSetIndex,:)',...
        AutoCorr_Par.fun_S(DataSetIndex,:)','exp1');
    Time = AutoCorr_Par.t_S(DataSetIndex,:)';
    y    = AutoCorr_Par.fun_S(DataSetIndex,:)';
elseif DataSetIndex == 0
    Time = AutoCorr_Par.t_S;
    y    = AutoCorr_Par.fun_S;
end
handles.UserData.Fig.Err = AutoCorr_Par.err;
handles.UserData.Fig.x = Time';
handles.UserData.Fig.y = y';
handles.UserData.Fig.yFit = feval(cfun,Time(:,1));
handles.UserData.Fig.XLabel = ['Time(' UTime ')'];
handles.UserData.Fig.YLabel = ['Velocity Autocorrelation (('...
    Unit '/' UTime ')^2)'];
handles.UserData.Fig.Title = {['Velocity Autocorrelation Function of '...
    CurrentDimention ' ' BdLb(2:end-1) 'Frame, \beta = '...
    num2str(-1/cfun.b) '(' UTime ')']};
handles = Set_AxesData(hObject, eventdata, handles);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
    '  -- Calculate Velocity Autocorrelation Function'];
Add_TextLog(hObject,handles,s1);
s0 = '-------------------------------';
s1 = datestr(now,'yyyy-mmm-dd HH:MM:SS');
s2 = ' -- Calculate Velocity Autocorrelation Function';
ss3 = ['Time nead to reach simple diffusion: ',num2str(-1/cfun.b),...
    '(' UTime ')'];
Dimention = get(handles.PopDimention,'String');
DataSet = get(handles.PopDataSet,'String');
s3 = '  -- Options:';
s4 = ['Dimension: ',char(Dimention(get(handles.PopDimention,'value')))];
s5 = ['Dataset: ',char(DataSet(get(handles.PopDataSet,'value')))];
if get(handles.LabFrame,'Value')
    s6 = 'Frame: LabFrame';
else
    s6 = 'Frame: BodyFrame';
end
s7 = '  -- Fit Options:';
s8 = ['Fraction: ',get(handles.Fraction,'String')];
s9 = ['Weight Status: ',get(handles.Weight,'Value')];
Add_TextResult(hObject,handles,'',s0,s1,s2,ss3,s3,s4,s5,s6,s7,s8,s9);
guidata(hObject,handles);



% --------------------------------------------------------------------
function handles = Trajectory_Callback(hObject, eventdata, handles)
% Callback function for trajectory. When user clicks on "trajectory",
% porgram will plot trajectory versus time according to selected data set and dimension.
handles.UserData.Fig.Last = 'Trajectory';
BdLb = char(handles.BdLb(get(handles.LabFrame,'value')+1));
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
DimentionIndex = get(handles.PopDimention,'value');
Dimentions = get(handles.PopDimention,'string');
CurrentDimention = char(Dimentions(DimentionIndex));
DataSetIndex = get(handles.PopDataSet,'value')-2;
if DataSetIndex < 0
    set(handles.PopDataSet,'value',2);
    DataSetIndex = 0;
end
x = load(filename, [CurrentDimention BdLb 'Pos']);
eval(['x = x.' CurrentDimention BdLb  'Pos;']);
Time = load(filename, 'Time');
Time = Time.Time;
Unit = char(handles.UserData.Project.Units(DimentionIndex+1));
UTime = char(handles.UserData.Project.Units(1));
if DataSetIndex == 0
    y    = x;
    ss   = 'All';
elseif DataSetIndex > 0
    Time = Time(DataSetIndex,:);
    y    = x(DataSetIndex,:);
    ss   = num2str(DataSetIndex);
end
handles.UserData.Fig.Err = 0;
handles.UserData.Fig.yFit = 0;
handles.UserData.Fig.x = Time';
handles.UserData.Fig.y = y';
handles.UserData.Fig.XLabel = ['Time(' UTime ')'];
handles.UserData.Fig.YLabel = ['Position of ' ...
    CurrentDimention '('  Unit ')'];
handles.UserData.Fig.Title = {['Trajectory of '  CurrentDimention ' '...
    BdLb(2:end-1) 'Frame, #' ss]};
handles = Set_AxesData(hObject, eventdata, handles);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Draw Trajectory for',...
    CurrentDimention,' for Dataset ',ss];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function XY_Callback(hObject, eventdata, handles)
% Callback function for position in xy plane. When user clicks on "xy",
% porgram will plot position in xy plane to selected data set.
handles.UserData.Fig.Last = 'XY';
BdLb = char(handles.BdLb(get(handles.LabFrame,'value')+1));
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
DataSetIndex = get(handles.PopDataSet,'value')-2;
if DataSetIndex < 0
    set(handles.PopDataSet,'value',2);
    DataSetIndex = 0;
end
x = load(filename, ['X' BdLb  'Pos']);
eval(['x = x.X' BdLb  'Pos;']);
y = load(filename, ['Y' BdLb  'Pos']);
eval(['y = y.Y' BdLb  'Pos;']);
Unitx = char(handles.UserData.Project.Units(2));
Unity = char(handles.UserData.Project.Units(3));
if DataSetIndex == 0
    ss   = 'All';
elseif DataSetIndex > 0
    x = x(DataSetIndex,:);
    y = y(DataSetIndex,:);
    ss   = num2str(DataSetIndex);
end
handles.UserData.Fig.Err = 0;
handles.UserData.Fig.yFit = 0;
handles.UserData.Fig.x = x';
handles.UserData.Fig.y = y';
handles.UserData.Fig.XLabel = ['X(' Unitx ')'];
handles.UserData.Fig.YLabel = ['Y(' Unity ')'];
handles.UserData.Fig.Title = {['Position in XY ' BdLb(2:end-1)...
    'Frame, #' ss]};
handles = Set_AxesData(hObject, eventdata, handles);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
    '  -- Draw Position in XY plane for Dataset ',ss];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function XZ_Callback(hObject, eventdata, handles)
% Callback function for position in xz plane. When user clicks on "xz",
% porgram will plot position in xz plane to selected data set.
handles.UserData.Fig.Last = 'XZ';
BdLb = char(handles.BdLb(get(handles.LabFrame,'value')+1));
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
DataSetIndex = get(handles.PopDataSet,'value')-2;
if DataSetIndex < 0
    set(handles.PopDataSet,'value',2);
    DataSetIndex = 0;
end
x = load(filename, ['X' BdLb  'Pos']);
eval(['x = x.X' BdLb  'Pos;']);
y = load(filename, ['Z' BdLb  'Pos']);
eval(['y = y.Z' BdLb  'Pos;']);
Unitx = char(handles.UserData.Project.Units(2));
Unity = char(handles.UserData.Project.Units(4));
if DataSetIndex == 0
    ss   = 'All';
elseif DataSetIndex > 0
    x = x(DataSetIndex,:);
    y = y(DataSetIndex,:);
    ss   = num2str(DataSetIndex);
end
handles.UserData.Fig.Err = 0;
handles.UserData.Fig.yFit = 0;
handles.UserData.Fig.x = x';
handles.UserData.Fig.y = y';
handles.UserData.Fig.XLabel = ['X(' Unitx ')'];
handles.UserData.Fig.YLabel = ['Z(' Unity ')'];
handles.UserData.Fig.Title = {['Position in XZ ' BdLb(2:end-1) ...
    'Frame, #' ss]};
handles = Set_AxesData(hObject, eventdata, handles);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
    '  -- Draw Position in XZ plane for Dataset ',ss];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function YZ_Callback(hObject, eventdata, handles)
% Callback function for position in yz plane. When user clicks on "yz",
% porgram will plot position in yz plane to selected data set.
handles.UserData.Fig.Last = 'YZ';
BdLb = char(handles.BdLb(get(handles.LabFrame,'value')+1));
pathname = handles.UserData.RawData.PathName;
filename = [pathname 'AllDatas.mat'];
DataSetIndex = get(handles.PopDataSet,'value')-2;
if DataSetIndex < 0
    set(handles.PopDataSet,'value',2);
    DataSetIndex = 0;
end
x = load(filename, ['Y' BdLb  'Pos']);
eval(['x = x.Y' BdLb  'Pos;']);
y = load(filename, ['Z' BdLb  'Pos']);
eval(['y = y.Z' BdLb  'Pos;']);
Unitx = char(handles.UserData.Project.Units(3));
Unity = char(handles.UserData.Project.Units(4));
if DataSetIndex == 0
    ss   = 'All';
elseif DataSetIndex > 0
    x = x(DataSetIndex,:);
    y = y(DataSetIndex,:);
    ss   = num2str(DataSetIndex);
end
handles.UserData.Fig.Err = 0;
handles.UserData.Fig.yFit = 0;
handles.UserData.Fig.x = x';
handles.UserData.Fig.y = y';
handles.UserData.Fig.XLabel = ['Y(' Unitx ')'];
handles.UserData.Fig.YLabel = ['Z(' Unity ')'];
handles.UserData.Fig.Title = {['Position in YZ ' BdLb(2:end-1)...
    'Frame, #' ss]};
handles = Set_AxesData(hObject, eventdata, handles);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
    '  -- Draw Position in YZ plane for Dataset ',ss];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);



% --------------------------------------------------------------------
function BodyFrame_Callback(hObject, eventdata, handles)
% Callback function for bodyframe. When user choose "body frame" in current frame panel,
% program calculate displacements and positions in body frame and from then every quantity
% will be calculated in body frame.

if get(hObject,'value')
    set(hObject,'value',1);
    handles = Set_MenuTicks(hObject,handles);
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Switch to Body Frame'];
    Add_TextLog(hObject,handles,s1);
    handles = Clear_Axes(hObject, eventdata, handles);
    handles.UserData.LastMethod ='';
    set(handles.Anomaly,'enable','off');
    set(handles.AnomalyIcon,'enable','off');
    set(handles.CurrentMethod ,'string','');
    handles = Trajectory_Callback(hObject, eventdata, handles);
    guidata(hObject,handles);
end
set(hObject,'value',1);



% --------------------------------------------------------------------
function LabFrame_Callback(hObject, eventdata, handles)
% Callback function for labframe. When user choose "lab frame" in current frame panel,
% from then every quantity will be calculated in lab frame.

if get(hObject,'value')
    set(hObject,'value',1);
    handles = Set_MenuTicks(hObject,handles);
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Switch to Lab Frame'];
    Add_TextLog(hObject,handles,s1);
    handles = Clear_Axes(hObject, eventdata, handles);
    handles.UserData.LastMethod ='';
    set(handles.Anomaly,'enable','off');
    set(handles.AnomalyIcon,'enable','off');
    set(handles.CurrentMethod,'string','');
    handles = Trajectory_Callback(hObject, eventdata, handles);
    guidata(hObject,handles);
end
set(hObject,'value',1);



% --------------------------------------------------------------------
function Fraction_Callback(hObject, eventdata, handles)
% Callback function for fraction. User can change the portion of 
% data from begining for fitting. Fraction can be value between 0-1.

s = get(handles.Fraction,'string');
if isempty(str2double(s))
    set(handles.Fraction,'string','0.1');
end
if (str2double(s) <= 0)  || (str2double(s) > 1)
    set(handles.Fraction,'string','0.1');
end
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),...
    '  -- Change Fraction Value to',s];
Add_TextLog(hObject,handles,s1);
if ~isempty(handles.UserData.Fig.Last)
    eval([handles.UserData.Fig.Last ...
        '_Callback(hObject,eventdata, handles);']);
end
guidata(hObject,handles);



% --------------------------------------------------------------------
function Fraction_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function PopDataSet_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function PopDimention_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function CurrentMethod_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function PopDimention_Callback(hObject, eventdata, handles)
% Callback function for dimension pop-up menu. User can change 
% dimension using this pop-up menu.
temp = get(handles.PopDimention,'string');
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Set Dimention to ',...
    char(temp(get(handles.PopDimention,'value')))];
Add_TextLog(hObject,handles,s1);
if ~isempty(handles.UserData.Fig.Last)
    eval([handles.UserData.Fig.Last ...
        '_Callback(hObject,eventdata, handles);']);
end



% --------------------------------------------------------------------
function PopDataSet_Callback(hObject, eventdata, handles)
% Callback function for data set pop-up menu. User can change 
% data set using this pop-up menu.
temp = get(handles.PopDataSet,'string');
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Set DataSet to ',...
    char(temp(get(handles.PopDataSet,'value')))];
Add_TextLog(hObject,handles,s1);
if ~isempty(handles.UserData.Fig.Last)
    eval([handles.UserData.Fig.Last ...
        '_Callback(hObject,eventdata, handles);']);
end



% --------------------------------------------------------------------
function ShowFit_Callback(hObject, eventdata, handles)
% Callback function for showfit. User can decide to show or not show
% a fitting line on plotted axes.
if get(handles.ShowFit,'Value')
    set(handles.FitIcon,'state','on');
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Show Fit'];
    Add_TextLog(hObject,handles,s1);
else
    set(handles.FitIcon,'state','off');
    s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Hide Fit'];
    Add_TextLog(hObject,handles,s1);
end



% --------------------------------------------------------------------
function Weight_Callback(hObject, eventdata, handles)
% Callback function for weight. User can decide to use or not use weight
% when  fitting to a data.
if ~isempty(handles.UserData.Fig.Last)
    eval([handles.UserData.Fig.Last ...
        '_Callback(hObject,eventdata, handles);']);
end
temp = {'off' 'on'};
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Set Weight ',...
    char(temp(get(handles.Weight,'value')+1))];
Add_TextLog(hObject,handles,s1);



% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------



function LoadRawDataIcon_ClickedCallback(hObject, eventdata, handles)
LoadRawData_Callback(hObject, eventdata, handles);


function OpenProjectIcon_ClickedCallback(hObject, eventdata, handles)
OpenProject_Callback(hObject, eventdata, handles);


function SaveProjectIcon_ClickedCallback(hObject, eventdata, handles)
handles.UserData.Project.Changed = ~SaveOrSaveAs(hObject,handles);
guidata(hObject,handles);


function PrintIcon_ClickedCallback(hObject, eventdata, handles)
PrintAxes_Callback(hObject, eventdata, handles);


function SaveFigureAsIcon_ClickedCallback(hObject, eventdata, handles)
SaveFigureAs_Callback(hObject, eventdata, handles);


function ExportAxisDataIcon_ClickedCallback(hObject, eventdata, handles)
ExportAxesData_Callback(hObject, eventdata, handles);


function tcIcon_ClickedCallback(hObject, eventdata, handles)
TimeCorr_Callback(hObject, eventdata, handles);


function tucIcon_ClickedCallback(hObject, eventdata, handles)
TimeUncorr_Callback(hObject, eventdata, handles);


function ensIcon_ClickedCallback(hObject, eventdata, handles)
Ensemble_Callback(hObject, eventdata, handles);


function tecIcon_ClickedCallback(hObject, eventdata, handles)
TimeEnsCorr_Callback(hObject, eventdata, handles);


function teucIcon_ClickedCallback(hObject, eventdata, handles)
TimeEnsUnCorr_Callback(hObject, eventdata, handles);


function AnomalyIcon_ClickedCallback(hObject, eventdata, handles)
Anomaly_Callback(hObject, eventdata, handles);


function TheoryIcon_ClickedCallback(hObject, eventdata, handles)
CalculateTheroy_Callback(hObject, eventdata, handles);


function HistogramIcon_ClickedCallback(hObject, eventdata, handles)
DisplacmentHistogram_Callback(hObject, eventdata, handles);


function VAFIcon_ClickedCallback(hObject, eventdata, handles)
VelocityAutocorrelation_Callback(hObject, eventdata, handles);


function TrajectoryIcon_ClickedCallback(hObject, eventdata, handles)
Trajectory_Callback(hObject, eventdata, handles);


function XYIcon_ClickedCallback(hObject, eventdata, handles)
XY_Callback(hObject, eventdata, handles);


function XZIcon_ClickedCallback(hObject, eventdata, handles)
XZ_Callback(hObject, eventdata, handles);


function YZIcon_ClickedCallback(hObject, eventdata, handles)
YZ_Callback(hObject, eventdata, handles);


function SimpleIcon_ClickedCallback(hObject, eventdata, handles)
set(handles.SimpleIcon,'state','on');
set(handles.SemilogxIcon,'state','off');
set(handles.SemilogyIcon,'state','off');
set(handles.LoglogIcon,'state','off');
PlotSimple_Callback(hObject, eventdata, handles);


function SemilogxIcon_ClickedCallback(hObject, eventdata, handles)
set(handles.SimpleIcon,'state','off');
set(handles.SemilogxIcon,'state','on');
set(handles.SemilogyIcon,'state','off');
set(handles.LoglogIcon,'state','off');
SemilogX_Callback(hObject, eventdata, handles);


function SemilogyIcon_ClickedCallback(hObject, eventdata, handles)
set(handles.SimpleIcon,'state','off');
set(handles.SemilogxIcon,'state','off');
set(handles.SemilogyIcon,'state','on');
set(handles.LoglogIcon,'state','off');
SemilogY_Callback(hObject, eventdata, handles);


function LoglogIcon_ClickedCallback(hObject, eventdata, handles)
set(handles.SimpleIcon,'state','off');
set(handles.SemilogxIcon,'state','off');
set(handles.SemilogyIcon,'state','off');
set(handles.LoglogIcon,'state','on');
Loglog_Callback(hObject, eventdata, handles);


function GridNoneIcon_ClickedCallback(hObject, eventdata, handles)
set(handles.GridNoneIcon,'state','on');
set(handles.GridMajorIcon,'state','off');
set(handles.GridMinorIcon,'state','off');
GridNone_Callback(hObject, eventdata, handles);


function GridMajorIcon_ClickedCallback(hObject, eventdata, handles)
set(handles.GridNoneIcon,'state','off');
set(handles.GridMajorIcon,'state','on');
set(handles.GridMinorIcon,'state','off');
GridMajor_Callback(hObject, eventdata, handles);


function GridMinorIcon_ClickedCallback(hObject, eventdata, handles)
set(handles.GridNoneIcon,'state','off');
set(handles.GridMajorIcon,'state','off');
set(handles.GridMinorIcon,'state','on');
GridMinor_Callback(hObject, eventdata, handles);


function FitIcon_OffCallback(hObject, eventdata, handles)
set(handles.ShowFit,'Value',0);
handles = Set_AxesData(hObject, eventdata, handles);
guidata(hObject,handles);


function FitIcon_OnCallback(hObject, eventdata, handles)
set(handles.ShowFit,'Value',1);
handles = Set_AxesData(hObject, eventdata, handles);
guidata(hObject,handles);


function ErrorBarIcon_OffCallback(hObject, eventdata, handles)
set(handles.ErrorBar,'check','off');
handles.UserData.Fig.ShowErr = get(handles.ErrorBar,'Checked');
handles = Set_AxesData(hObject, eventdata, handles);
set(handles.ErrorBarIcon,'state',handles.UserData.Fig.ShowErr);
set(handles.ErrorBar,'check',handles.UserData.Fig.ShowErr);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Check ErrorBar "OFF"'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);


function ErrorBarIcon_OnCallback(hObject, eventdata, handles)
set(handles.ErrorBar,'check','on');
handles.UserData.Fig.ShowErr = get(handles.ErrorBar,'Checked');
handles = Set_AxesData(hObject, eventdata, handles);
set(handles.ErrorBarIcon,'state',handles.UserData.Fig.ShowErr);
set(handles.ErrorBar,'check',handles.UserData.Fig.ShowErr);
s1 = [datestr(now,'yyyy-mmm-dd HH:MM:SS'),'  -- Check ErrorBar "ON"'];
Add_TextLog(hObject,handles,s1);
guidata(hObject,handles);


function ShowPlotToolsIcon_ClickedCallback(hObject, eventdata, handles)
EditAxes_Callback(hObject, eventdata, handles);



% --------------------------------------------------------------------
function ProductHelp_Callback(hObject, eventdata, handles)
open usermanual-koja.pdf


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
txt = {'';...
    'KOJA: A MATLAB Program to Calculate Transitional and Rotational ';...
    '           Diffusion Coefficient of a Single Particle.';...
    '   ';...
    '   Version 1.0';...
    '   By: Mohammad A.Charsooghi, ';...
    '         Ehsan A.Akhlaghi and et al. ';...
    '         IASBS, Zanjan, Iran                            May 13, 2010';...
    '   ';...
    };
h = msgbox(txt,'About KOJA');
set(h,'color',[.9 .9 .9])



% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------



% --------------------------------------------------------------------
function KOJA_CloseRequestFcn(hObject, eventdata, handles)
checkans = CheckProjectSave(hObject,handles);
if strcmpi(checkans ,'Cancel')
    return
end;
if strcmpi(checkans ,'Yes')
    handles.UserData.Project.Changed = ~SaveOrSaveAs(hObject,handles);
end
try
    Save_iniFile(handles);
    pathname = handles.UserData.RawData.PathName;
    filename = [pathname 'AllDatas.mat'];
    delete(filename);
end
set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));
