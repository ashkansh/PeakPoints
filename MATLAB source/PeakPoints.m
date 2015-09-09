function varargout = PeakPoints(varargin)
%PEAKPOINTS M-file for PeakPoints.fig
%      %peakpoints finds maximum and minimum points in a vector.
%   This code is developed to find peak points and number of cycles in
%   seismic analysis of structures. However, it can be used for any vector.
%  
% Ashkan Shahbazian, v1.1
% University of Coimbra

% peakdet function developed by Eli Billauer used in this code.
% http://www.billauer.co.il/peakdet.html

%%
% first define your vector, then use [cycle]=peakpoints(vector) in the command line;
% Example: import vector.txt to workspace and write peakpoints(vector)

% Last Modified by GUIDE v2.5 07-Sep-2015 16:31:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PeakPoints_OpeningFcn, ...
                   'gui_OutputFcn',  @PeakPoints_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before PeakPoints is made visible.
function PeakPoints_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for PeakPoints
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PeakPoints wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = PeakPoints_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delta = get(handles.edit1,'string');
delta=str2double(delta);

[filename, pathname]=uigetfile({'*.txt'},'File Selector');
fullpathname=strcat(pathname, filename);
%text=fileread(fullpathname);
Data=load(fullpathname);
plot(Data,'-r','parent',handles.axes1);
fontSize = 20; % Whatever you want.
% First for the first axes:
axes(handles.axes1);
xlabel('Time', 'FontSize', fontSize);
ylabel('Data', 'FontSize', fontSize);


%delta=0.1; % by default
v = Data(:)'; % Just in case this wasn't a proper vector
x = (1:length(v))';
maxtab=[]; mintab=[];
mn = Inf; mx = -Inf;
mnpos = NaN; mxpos = NaN;
lookformax=1;
for vi=1:1:length(v);
    value=v(vi);
    this=value;
if this > mx, mx = this; mxpos = x(vi); end
if this < mn, mn = this; mnpos = x(vi); end
  if lookformax
    if this < mx-delta
      maxtab = [maxtab ;mxpos mx];
      mn = this; mnpos = x(vi);
      lookformax = 0;
    end  
  else
    if this > mn+delta
      mintab = [mintab ; mnpos mn];
      mx = this; mxpos = x(vi);
      lookformax = 1;
    end
  end
end

for imin=1:1:length(mintab);
    cycle(mintab(imin,1),1)=mintab(imin,2);
end
for imax=1:1:length(maxtab);
    cycle(maxtab(imax,1),1)=maxtab(imax,2);
end
cycle(cycle==0) = [];
%cycle=[0; cycle];

plot(cycle,'o-k','parent',handles.axes2);
fontSize = 20; % Whatever you want.
% First for the first axes:
axes(handles.axes2);
xlabel('Peak #', 'FontSize', fontSize);
ylabel('Data', 'FontSize', fontSize);

set(handles.text3, 'String', fullpathname);

dat = cycle; 

cnames = {'Data'};
a = uitable('Parent',PeakPoints,'Data',dat,'ColumnName',cnames,'Position',[1100 150 130 250]);
guidata(hObject, handles);
