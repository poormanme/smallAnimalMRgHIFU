function varargout = mrhifuSetUpGui(varargin)
%% Provides GUI to take inputs and plug into reconstruction/experiment
% Created by M. Poorman, W. Grissom - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
% mrhifuSetUpGui MATLAB code for mrhifuSetUpGui.fig
%      mrhifuSetUpGui, by itself, creates a new mrhifuSetUpGui or raises the existing
%      singleton*.
%
%      H = mrhifuSetUpGui returns the handle to a new mrhifuSetUpGui or the handle to
%      the existing singleton*.
%
%      mrhifuSetUpGui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in mrhifuSetUpGui.M with the given input arguments.
%
%      mrhifuSetUpGui('Property','Value',...) creates a new mrhifuSetUpGui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the mrhifuSetUpGui before mrhifuSetUpGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mrhifuSetUpGui_OpeningFcn via varargin.
%
%      *See mrhifuSetUpGui Options on GUIDE's Tools menu.  Choose "mrhifuSetUpGui allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mrhifuSetUpGui

% Last Modified by GUIDE v2.5 17-Sep-2014 15:27:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mrhifuSetUpGui_OpeningFcn, ...
                   'gui_OutputFcn',  @mrhifuSetUpGui_OutputFcn, ...
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


% --- Executes just before mrhifuSetUpGui is made visible.
function mrhifuSetUpGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mrhifuSetUpGui (see VARARGIN)
load('baseim.mat')
handles.baseim = abs(img(:,:));
% handles.output.focusShape = 0;
% guidata(hObject,handles);

% Choose default command line output for mrhifuSetUpGui
handles.output = hObject;
handles.output.focusShape = 'none';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mrhifuSetUpGui wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = mrhifuSetUpGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
close all;

function targT_Callback(hObject, eventdata, handles)
% hObject    handle to targT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of targT as text
%        str2double(get(hObject,'String')) returns contents of targT as a double
handles.output.targT = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function targT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function iGain_Callback(hObject, eventdata, handles)
% hObject    handle to iGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iGain as text
%        str2double(get(hObject,'String')) returns contents of iGain as a double
handles.output.iGain = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function iGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dGain_Callback(hObject, eventdata, handles)
% hObject    handle to dGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dGain as text
%        str2double(get(hObject,'String')) returns contents of dGain as a double
handles.output.dGain = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function dGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pGain.
function pGain_Callback(hObject, eventdata, handles)
% hObject    handle to pGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pGain contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pGain
handles.output.pGain = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calcCEM.
function calcCEM_Callback(hObject, eventdata, handles)
% hObject    handle to calcCEM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calcCEM
handles.output.calcCEM = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in calcDrift.
function calcDrift_Callback(hObject, eventdata, handles)
% hObject    handle to calcDrift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calcDrift
calcDrift = get(hObject,'Value');
if calcDrift == 1;
    axes(handles.baselinedrift);
    im = imagesc(handles.baseim);colormap gray; axis off;
    f = imellipse(handles.baselinedrift);
    handles.output.driftmask = createMask(f,im);
    guidata(hObject,handles);
    uiwait(handles.figure1);
end

% --- Executes on button press in calcWaterFat.
function calcWaterFat_Callback(hObject, eventdata, handles)
% hObject    handle to calcWaterFat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calcWaterFat
handles.output.calcWaterFat = get(hObject,'Value');
guidata(hObject,handles);


function te_Callback(hObject, eventdata, handles)
% hObject    handle to te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of te as text
%        str2double(get(hObject,'String')) returns contents of te as a double
handles.output.te = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function te_CreateFcn(hObject, eventdata, handles)
% hObject    handle to te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tr_Callback(hObject, eventdata, handles)
% hObject    handle to tr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tr as text
%        str2double(get(hObject,'String')) returns contents of tr as a double
handles.output.tr = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function tr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filepath_Callback(hObject, eventdata, handles)
% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filepath as text
%        str2double(get(hObject,'String')) returns contents of filepath as a double
handles.output.filepath = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function filepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxV_Callback(hObject, eventdata, handles)
% hObject    handle to maxV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxV as text
%        str2double(get(hObject,'String')) returns contents of maxV as a double
handles.output.maxV = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function maxV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in runTemp.
% function runTemp_Callback(hObject, eventdata, handles)
% % hObject    handle to runTemp (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % continue with code
% handles.output.continue = 1;
% guidata(hObject,handles);
% % close
% close all;


% --- Executes on button press in outparams.
function outparams_Callback(hObject, eventdata, handles)
% hObject    handle to outparams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% runExpGui;
guidata(hObject,handles);
uiresume(handles.figure1);

% --- Executes on button press in focus.
function focus_Callback(hObject, eventdata, handles)
% hObject    handle to focus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.baseline);
im = imagesc(handles.baseim);colormap gray; axis off;
if strcmp(handles.output.focusShape,'Rect') ==1
    disp('Draw focus on image');
    f = imrect(handles.baseline);
    handles.output.fmask = createMask(f,im);
elseif strcmp(handles.output.focusShape,'Freehand') == 1
    disp('Draw focus on image');
    f = imfreehand(handles.baseline);
    handles.output.fmask = createMask(f,im);
elseif strcmp(handles.output.focusShape,'Ellipse') == 1
    disp('Draw focus on image');
    f = imellipse(handles.baseline); 
    handles.output.fmask = createMask(f,im);
else
    disp('WARNING --- Must select focus shape first');
end


guidata(hObject,handles);
uiwait(handles.figure1);

function ipAddress_Callback(hObject, eventdata, handles)
% hObject    handle to ipAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ipAddress as text
%        str2double(get(hObject,'String')) returns contents of ipAddress as a double
handles.output.ipAddress = get(hObject,'String');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ipAddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ipAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in focusShape.
function focusShape_Callback(hObject, eventdata, handles)
% hObject    handle to focusShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns focusShape contents as cell array
%        contents{get(hObject,'Value')} returns selected item from focusShape
contents = cellstr(get(hObject,'String'));
handles.output.focusShape = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function focusShape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to focusShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
