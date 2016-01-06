function varargout = userinterface(varargin)
% USERINTERFACE MATLAB code for userinterface.fig
%      USERINTERFACE, by itself, creates a new USERINTERFACE or raises the existing
%      singleton*.
%
%      H = USERINTERFACE returns the handle to a new USERINTERFACE or the handle to
%      the existing singleton*.
%
%      USERINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USERINTERFACE.M with the given input arguments.
%
%      USERINTERFACE('Property','Value',...) creates a new USERINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before userinterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to userinterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help userinterface

% Last Modified by GUIDE v2.5 06-Jan-2016 12:09:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @userinterface_OpeningFcn, ...
                   'gui_OutputFcn',  @userinterface_OutputFcn, ...
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


% --- Executes just before userinterface is made visible.
function userinterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to userinterface (see VARARGIN)

% Choose default command line output for userinterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.selectdriftROI,'Visible','off'); 
set(handles.threshCEM,'Visible','off'); 
set(handles.textthreshCEM,'Visible','off'); 
set(handles.text19,'Visible','off'); 
% UIWAIT makes userinterface wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = userinterface_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in browseAnat.
function browseAnat_Callback(hObject, eventdata, handles)
% hObject    handle to browseAnat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, dir] = uigetfile('','Load anatomical .fid file');
set(handles.filepathtext,'String',[dir fname]);
handles.anatPath = [dir fname];
guidata(hObject,handles);



function filepathtext_Callback(hObject, eventdata, handles)
% hObject    handle to filepathtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filepathtext as text
%        str2double(get(hObject,'String')) returns contents of filepathtext as a double

% --- Executes during object creation, after setting all properties.
function filepathtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filepathtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadImg.
function loadImg_Callback(hObject, eventdata, handles)
% hObject    handle to loadImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = readInFID(handles.anatPath);
axis(handles.axes3);
handles.anatImg = imagesc(flipud(abs(img)));axis image;title('Anatomical Image');colormap gray;
set(gca,'Xtick',[],'Ytick',[]);
guidata(hObject,handles);


% --- Executes on button press in selectFocusROI.
function selectFocusROI_Callback(hObject, eventdata, handles)
% hObject    handle to selectFocusROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value');
    axis(handles.axes3);
    hold on;
    xlabel('Draw Focus ROI - press enter when done','Color','r');
    f = imrect();
    pause
    handles.output.focusROI = createMask(f,handles.anatImg);
    [r,c] = find(handles.output.focusROI > 0);
    handles.output.focusvect = [r(1)-1 c(1)-1 r(end)-r(1)+2 c(end)-c(1)+2];
    guidata(hObject,handles);
    xlabel('');
    uiwait(handles.figure1);
end

% --- Executes on button press in selectdriftROI.
function selectdriftROI_Callback(hObject, eventdata, handles)
% hObject    handle to selectdriftROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(hObject,'Visible','off');

if get(hObject,'Value');
    axis(handles.axes3);
    hold on;
    xlabel('Draw Drift ROI - press enter when done','Color','red');
    f = imrect();
    pause
    handles.output.driftROI = createMask(f,handles.anatImg);
    [r,c] = find(handles.output.driftROI>0);
    handles.output.driftvect = [r(1)-1 c(1)-1 r(end)-r(1)+2 c(end)-c(1)+2];
    guidata(hObject,handles);
    xlabel('');
    uiwait(handles.figure1);
end

% --- Executes on button press in quitCEMselect.
function quitCEMselect_Callback(hObject, eventdata, handles)
% hObject    handle to quitCEMselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of quitCEMselect
if get(hObject,'Value')
    set(handles.textthreshCEM,'Visible','on');  
    set(handles.threshCEM,'Visible','on'); 
    set(handles.text19,'Visible','on'); 
else
    set(handles.textthreshCEM,'Visible','off'); 
    set(handles.threshCEM,'Visible','off');
    set(handles.text19,'Visible','off'); 
end

function threshCEM_Callback(hObject, eventdata, handles)
% hObject    handle to threshCEM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshCEM as text
%        str2double(get(hObject,'String')) returns contents of threshCEM as a double
handles.output.threshCEM = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function threshCEM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshCEM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in driftCorrSelect.
function driftCorrSelect_Callback(hObject, eventdata, handles)
% hObject    handle to driftCorrSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of driftCorrSelect
if get(hObject,'Value')
    set(handles.selectdriftROI,'Visible','on');   
else
    set(handles.selectdriftROI,'Visible','off'); 
end

function targetRiseval_Callback(hObject, eventdata, handles)
% hObject    handle to targetRiseval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of targetRiseval as text
%        str2double(get(hObject,'String')) returns contents of targetRiseval as a double
a = get(hObject,'String');
handles.output.targetRise = a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function targetRiseval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetRiseval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startingTemperature_Callback(hObject, eventdata, handles)
% hObject    handle to startingTemperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startingTemperature as text
%        str2double(get(hObject,'String')) returns contents of startingTemperature as a double
handles.output.startingTemp = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function startingTemperature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startingTemperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vmax_Callback(hObject, eventdata, handles)
% hObject    handle to vmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vmax as text
%        str2double(get(hObject,'String')) returns contents of vmax as a double
handles.output.vmax = get(hObject,'Value')/1000; %mV
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function vmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vmin_Callback(hObject, eventdata, handles)
% hObject    handle to vmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vmin as text
%        str2double(get(hObject,'String')) returns contents of vmin as a double
handles.output.vmin = get(hObject,'Value')/1000; %mV
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function vmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frequency_Callback(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequency as text
%        str2double(get(hObject,'String')) returns contents of frequency as a double
handles.output.frequency = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ncycles_Callback(hObject, eventdata, handles)
% hObject    handle to ncycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ncycles as text
%        str2double(get(hObject,'String')) returns contents of ncycles as a double
handles.output.nycles = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ncycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseDyn.
function browseDyn_Callback(hObject, eventdata, handles)
% hObject    handle to browseDyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, dir] = uigetfile('','point to dynamic fid file');
set(handles.filepathtext_dyn,'String',[dir fname]);
handles.output.dynPath = [dir fname];
guidata(hObject,handles);


function filepathtext_dyn_Callback(hObject, eventdata, handles)
% hObject    handle to filepathtext_dyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filepathtext_dyn as text
%        str2double(get(hObject,'String')) returns contents of filepathtext_dyn as a double


% --- Executes during object creation, after setting all properties.
function filepathtext_dyn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filepathtext_dyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pgain_Callback(hObject, eventdata, handles)
% hObject    handle to pgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pgain as text
%        str2double(get(hObject,'String')) returns contents of pgain as a double
handles.output.pgain = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pgain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function igain_Callback(hObject, eventdata, handles)
% hObject    handle to igain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of igain as text
%        str2double(get(hObject,'String')) returns contents of igain as a double
handles.output.igain = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function igain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to igain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dgain_Callback(hObject, eventdata, handles)
% hObject    handle to dgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dgain as text
%        str2double(get(hObject,'String')) returns contents of dgain as a double
handles.output.dgain = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function dgain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function selectdriftROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectdriftROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargout = handles.output;
if ~isfield(handles.output,'pgain')
    handles.output.pgain = str2num(get(handles.pgain,'String'));
end
if ~isfield(handles.output,'igain')
    handles.output.igain = str2num(get(handles.igain,'String'));
end
if ~isfield(handles.output,'dgain')
    handles.output.dgain = str2num(get(handles.dgain,'String'));
end
if ~isfield(handles.output,'targetRise')
    handles.output.targetRise= str2num(get(handles.targetRiseval,'String'));
end
if ~isfield(handles.output,'startingTemp')
    handles.output.startingTemp= str2num(get(handles.startingTemperature,'String'));
end
if ~isfield(handles.output,'vmax')
    handles.output.vmax= str2num(get(handles.vmax,'String'))/1000; %mV
end
if ~isfield(handles.output,'vmin')
    handles.output.vmin= str2num(get(handles.vmin,'String'))/1000; %mV
end
if ~isfield(handles.output,'frequency')
    handles.output.frequency= str2num(get(handles.frequency,'String'));
end
if ~isfield(handles.output,'ncycles')
    handles.output.ncycles= str2num(get(handles.ncycles,'String'));
end
if ~isfield(handles.output,'ipaddress')
    handles.output.ipaddress= str2num(get(handles.ipaddress,'String'));
end
if ~isfield(handles.output,'filepathtext_dyn')
    handles.output.filepathtext_dyn= str2num(get(handles.filepathtext_dyn,'String'));
end
if (handles.quitCEMselect) && (~isfield(handles.output,'threshCEM'))
    handles.output.threshCEM= str2num(get(handles.threshCEM,'String'));
end
guidata(hObject,handles);
uiresume(handles.figure1);


function ipaddress_Callback(hObject, eventdata, handles)
% hObject    handle to ipaddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ipaddress as text
%        str2double(get(hObject,'String')) returns contents of ipaddress as a double
handles.output.ipaddress = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ipaddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ipaddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
