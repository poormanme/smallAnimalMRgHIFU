function varargout = runExpGui(varargin)
%% GUI to pause execution after inputs are given, prompting to start scans
% Created by M. Poorman - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
% RUNEXPGUI MATLAB code for runExpGui.fig
%      RUNEXPGUI, by itself, creates a new RUNEXPGUI or raises the existing
%      singleton*.
%
%      H = RUNEXPGUI returns the handle to a new RUNEXPGUI or the handle to
%      the existing singleton*.
%
%      RUNEXPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNEXPGUI.M with the given input arguments.
%
%      RUNEXPGUI('Property','Value',...) creates a new RUNEXPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before runExpGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to runExpGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help runExpGui

% Last Modified by GUIDE v2.5 02-Oct-2014 09:01:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @runExpGui_OpeningFcn, ...
                   'gui_OutputFcn',  @runExpGui_OutputFcn, ...
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


% --- Executes just before runExpGui is made visible.
function runExpGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to runExpGui (see VARARGIN)

% Choose default command line output for runExpGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes runExpGui wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = runExpGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
close all;


% --- Executes on button press in runExp.
function runExp_Callback(hObject, eventdata, handles)
% hObject    handle to runExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.UserData = 1; %matlab version fix by R Weires
uiresume(handles.figure1);
guidata(hObject,handles);
% 
