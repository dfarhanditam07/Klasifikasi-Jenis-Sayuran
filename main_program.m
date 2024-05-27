% Adi Pamungkas, S.Si, M.Si
% Website: https://pemrogramanmatlab.com/
% Email  : adipamungkas@st.fisika.undip.ac.id

function varargout = main_program(varargin)
% MAIN_PROGRAM MATLAB code for main_program.fig
%      MAIN_PROGRAM, by itself, creates a new MAIN_PROGRAM or raises the existing
%      singleton*.
%
%      H = MAIN_PROGRAM returns the handle to a new MAIN_PROGRAM or the handle to
%      the existing singleton*.
%
%      MAIN_PROGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_PROGRAM.M with the given input arguments.
%
%      MAIN_PROGRAM('Property','Value',...) creates a new MAIN_PROGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_program_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_program_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_program

% Last Modified by GUIDE v2.5 01-Jan-2019 14:51:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_program_OpeningFcn, ...
    'gui_OutputFcn',  @main_program_OutputFcn, ...
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


% --- Executes just before main_program is made visible.
function main_program_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_program (see VARARGIN)

% Choose default command line output for main_program
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(hObject,'center');

% UIWAIT makes main_program wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_program_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% menampilkan menu open file
[nama_file, nama_path] = uigetfile('*.jpg');

% jika ada file yang dipilih maka akan mengeksekusi perintah di bawahnya
if ~isequal(nama_file,0)
    % membaca file citra
    Img = imread(fullfile(nama_path, nama_file));
    % menampilkan citra pada axes 1
    axes(handles.axes1)
    imshow(Img)
    title('Citra Asli')
    % menampilkan nama file citra pada edit1
    set(handles.edit1,'String',nama_file)
    % menyimpan variabel Img pada lokasi handles
    handles.Img = Img;
    guidata(hObject, handles)
else
    % jika tidak ada file yang dipilih maka akan kembali
    return
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% memanggil variabel Img yang ada di lokasi handles
Img = handles.Img;
% konversi citra RGB menjadi grayscale
Img_gray = rgb2gray(Img);
% konversi citra grayscale menjadi biner
bw = im2bw(Img_gray,graythresh(Img_gray));
% operasi morfologi
bw = imcomplement(bw);
bw = imfill(bw,'holes');
bw = bwareaopen(bw,100);
% menampilkan citra biner hasil segmentasi pada axes2
axes(handles.axes2)
imshow(bw)
title('Citra biner')
% ekstraksi komponen RGB
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
% mengubah nilai background menjadi nol
R(~bw) = 0;
G(~bw) = 0;
B(~bw) = 0;
RGB = cat(3,R,G,B);
% menampilkan citra RGB hasil segmentasi pada axes3
axes(handles.axes3)
imshow(RGB)
title('Hasil Segmentasi')
% menyimpan variabel bw pada lokasi handles
handles.bw = bw;
guidata(hObject, handles)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% memanggil variabel Img & bw yang ada di lokasi handles
Img = handles.Img;
bw = handles.bw;
% ekstraksi ciri warna RGB
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
R(~bw) = 0;
G(~bw) = 0;
B(~bw) = 0;
Red = sum(sum(R))/sum(sum(bw));
Green = sum(sum(G))/sum(sum(bw));
Blue = sum(sum(B))/sum(sum(bw));
% ekstraksi ciri warna HSV
HSV = rgb2hsv(Img);
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);
H(~bw) = 0;
S(~bw) = 0;
V(~bw) = 0;
Hue = sum(sum(H))/sum(sum(bw));
Saturation = sum(sum(S))/sum(sum(bw));
Value = sum(sum(V))/sum(sum(bw));
% ekstraksi ciri ukuran
Area = sum(sum(bw));
% mengisi hasil ekstraksi ciri pada variabel ciri_sayur
ciri_sayur = cell(7,2);
ciri_sayur{1,1} = 'Red';
ciri_sayur{2,1} = 'Green';
ciri_sayur{3,1} = 'Blue';
ciri_sayur{4,1} = 'Hue';
ciri_sayur{5,1} = 'Saturation';
ciri_sayur{6,1} = 'Value';
ciri_sayur{7,1} = 'Area';
ciri_sayur{1,2} = Red;
ciri_sayur{2,2} = Green;
ciri_sayur{3,2} = Blue;
ciri_sayur{4,2} = Hue;
ciri_sayur{5,2} = Saturation;
ciri_sayur{6,2} = Value;
ciri_sayur{7,2} = Area;
% menampilkan ciri_sayur pada tabel
set(handles.text2,'String','Hasil Ekstraksi Ciri')
set(handles.uitable1,'Data',ciri_sayur,'RowName',1:7)
ciri_uji = [Red,Green,Blue,Hue,Saturation,Value,Area];
% menyimpan variabel ciri_uji pada lokasi handles
handles.ciri_uji = ciri_uji;
guidata(hObject, handles)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% memangil variabel ciri_uji pada lokasi handles
ciri_uji = handles.ciri_uji;
% load hasil pelatihan knn
load hasil_pelatihan
% standarisasi ciri uji
ciri_ujiZ = (ciri_uji - muZ)./sigmaZ;
% konversi ciri uji ke PC
score_uji = ciri_ujiZ*coeff;
% ekstrak PC1 & PC2
PC1 = score_uji(:,1);
PC2 = score_uji(:,2);
% mengujikan data uji pada knn
hasil_uji = predict(Mdl,[PC1,PC2]);
% menampilkan hasil pengujian pada edit2
set(handles.edit2,'String',hasil_uji)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mereset button2
axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

set(handles.edit1,'String',[])
set(handles.edit2,'String',[])
set(handles.text2,'String',[])
set(handles.uitable1,'Data',[])


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
