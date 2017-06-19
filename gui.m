function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 14-Jun-2017 17:15:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% dame graficke prvky do stavu inactive
set(handles.proceed, 'Enable', 'inactive');
set(handles.playFiltered, 'Enable', 'inactive');
set(handles.playUnfiltered, 'Enable', 'inactive');
set(handles.stopsound, 'Enable', 'inactive');
set(handles.showfilter, 'Enable', 'inactive');
set(handles.showperiodogram, 'Enable', 'inactive');
set(handles.savefiltered, 'Enable', 'inactive');

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function pathEdit_Callback(hObject, eventdata, handles)
% hObject    handle to pathEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathEdit as text
%        str2double(get(hObject,'String')) returns contents of pathEdit as a double


% --- Executes during object creation, after setting all properties.
function pathEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.wav','Zvol WAV audio soubor');
set(handles.pathEdit,'String',strcat(PathName, FileName));

global y Fs;
y = [];
if exist(FileName, 'file') ~= 2
    disp('Zadany vstupni soubor neexistuje.');
else
    [y,Fs] = audioread(strcat(PathName, FileName));
    set(handles.textFs,'String',Fs);
    set(handles.textFile,'String',FileName);
    set(handles.proceed, 'Enable', 'on');
    set(handles.playFiltered, 'Enable', 'on');
    set(handles.playUnfiltered, 'Enable', 'on')
    set(handles.stopsound, 'Enable', 'on');
    set(handles.showfilter, 'Enable', 'on');
    set(handles.showperiodogram, 'Enable', 'on');
    set(handles.savefiltered, 'Enable', 'inactive');
end

% --- Executes on button press in proceed.
function proceed_Callback(hObject, eventdata, handles)
% hObject    handle to proceed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global y Fs filtered;
t = (0:length(y)-1)/Fs;	% definujeme si casovou osu

axes(handles.axes1)
plot(t,y)
ylabel('Amplituda signalu')
xlabel('Cas (s)')
title('Audiosignal pred filtraci')
grid on

[BW, status] = str2num(get(handles.edit2, 'String'));
if status
    if BW>=1 & BW<= 99
        filtered = filtrace(y, Fs, BW);
    else
        disp('Cislo musi byt v intervalu 1 az 99');
        return
    end
else
    disp('Chyba spatne zadane cislo');
    return
end
    
axes(handles.axes3)
plot(t,filtered)
ylabel('Amplituda signalu')
xlabel('Cas (s)')
title('Audiosignal po filtraci')
grid

axes(handles.axes4)
plot(t,filtered,t,y) 
ylabel('Amplituda signalu')
xlabel('Cas (s)')
title('Porovnani signalu pred filtraci a po filtraci')
legend('Pred filtraci','Po filtraci')
grid


% --- Executes on button press in playUnfiltered.
function playUnfiltered_Callback(hObject, eventdata, handles)
% hObject    handle to playUnfiltered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global y Fs;
soundsc(y,Fs);

% --- Executes on button press in playFiltered.
function playFiltered_Callback(hObject, eventdata, handles)
% hObject    handle to playFiltered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global filtered Fs;
soundsc(filtered,Fs);


% --- Executes on button press in stopsound.
function stopsound_Callback(hObject, eventdata, handles)
% hObject    handle to stopsound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound


% --- Executes on button press in showfilter.
function showfilter_Callback(hObject, eventdata, handles)
% hObject    handle to showfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global d Fs;
fvtool(d,'Fs',Fs);

% --- Executes on button press in showperiodogram.
function showperiodogram_Callback(hObject, eventdata, handles)
% hObject    handle to showperiodogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y filtered Fs;

[py,fy] = periodogram(y,[],[],Fs);
[pfiltered,ffiltered] = periodogram(filtered,[],[],Fs);

figure(1)
plot(fy,20*log10(abs(py)),ffiltered,20*log10(abs(pfiltered)),'--')
ylabel('Vykon/Frekvence (dB/Hz)')
xlabel('Frekvence (Hz)')
title('Vykonove spektrum')
legend('Puvodni','Filtrovany')
grid


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in demo.
function demo_Callback(hObject, eventdata, handles)
% hObject    handle to demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global y Fs filtered;

Fs = 1000; 
dt = 1/Fs;
t = dt:dt:2;

% Signal
f = 1;  % Frekvence [Hz]
a = 1;  % Amplituda
signal = sin(2*pi.*t.*f);   % demo sinusovy signal
% Noise
fNoise = 50;    % frekvence sumu [Hz]
aNoise = 0.25;  % amplituda simu
noise  = aNoise*sin(2*pi.*t.*fNoise); % pridame tam 50 hz sum
% signal + sum
y = signal + noise;

filtered = filtrace(y, Fs, 2); % vyfiltrujeme zkusebno signal
% zapneme si jenom prvky co jsou potrebne
set(handles.textFs,'String',Fs);
set(handles.textFile,'String','DEMO');
set(handles.proceed, 'Enable', 'on');
set(handles.playFiltered, 'Enable', 'inactive');
set(handles.playUnfiltered, 'Enable', 'inactive')
set(handles.stopsound, 'Enable', 'on');
set(handles.showfilter, 'Enable', 'on');
set(handles.showperiodogram, 'Enable', 'on');
set(handles.savefiltered, 'Enable', 'inactive');
    
axes(handles.axes1)
plot(t,y)
ylabel('Amplituda signalu')
xlabel('Cas (s)')
title('Audiosignal pred filtraci')
grid on

axes(handles.axes3)
plot(t,filtered)
ylabel('Amplituda signalu')
xlabel('Cas (s)')
title('Audiosignal po filtraci')
grid

axes(handles.axes4)
plot(t,filtered,t,y) 
ylabel('Amplituda signalu')
xlabel('Cas (s)')
title('Porovnani signalu pred filtraci a po filtraci')
legend('Pred filtraci','Po filtraci')
grid


% --- Executes on button press in savefiltered.
function savefiltered_Callback(hObject, eventdata, handles)
% hObject    handle to savefiltered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y Fs;
% Dialog pro ulozeni souboru
[file,path] = uiputfile('filtered.wav','Ulozit vyfiltrovany zvuk');
audiowrite(strcat(path, file),y,Fs);
