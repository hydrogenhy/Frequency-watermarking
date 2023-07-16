function varargout = water_mark(varargin)
% WATER_MARK MATLAB code for water_mark.fig
%      WATER_MARK, by itself, creates a new WATER_MARK or raises the existing
%      singleton*.
%
%      H = WATER_MARK returns the handle to a new WATER_MARK or the handle to
%      the existing singleton*.
%
%      WATER_MARK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATER_MARK.M with the given input arguments.
%
%      WATER_MARK('Property','Value',...) creates a new WATER_MARK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before water_mark_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to water_mark_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help water_mark

% Last Modified by GUIDE v2.5 28-May-2023 21:35:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @water_mark_OpeningFcn, ...
                   'gui_OutputFcn',  @water_mark_OutputFcn, ...
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


% --- Executes just before water_mark is made visible.
function water_mark_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to water_mark (see VARARGIN)

% Choose default command line output for water_mark
handles.output = hObject;
axes(handles.before); 
imshow("lenna.bmp");
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes water_mark wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global method;
method = 1;
global filename;
filename = "lenna.bmp";
global water_mark_f;
water_mark_f = [0];
global water_marked;
water_marked = [0];



% --- Outputs from this function are returned to the command line.
function varargout = water_mark_OutputFcn(hObject, eventdata, handles) 
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
global filename;
[filename, filepath]=uigetfile({'*.bmp;*.jpg;*.tif;*.jpeg;*.png'},'选择图片文件');

if ~(isequal(filename,0) ||  isequal(filepath,0))
    file_class = extractAfter(filename,".");
else
    file_class = "NULL";
    errordlg('没有选中文件，请重新选择','出错');
    return;
end
class_sum = ["bmp", "jpg", "tif", "jpeg", "png"];
if ismember(file_class, class_sum) 
    set(handles.path,'string',[filepath filename]);
else
     errordlg('选中文件格式有误','出错');
     return;
end
axes(handles.before); 
imshow(filename);
set(handles.result, 'String', '未检测');


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close()


% --- Executes on selection change in method.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method
global method;
method = get(handles.method,'value');
% disp(method)

% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in encode.
function encode_Callback(hObject, eventdata, handles)
% hObject    handle to encode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global method;
global filename;
global water_mark_f;
global water_marked;
if method == 1
    [water_mark_f, water_marked] = fft_encode(filename);
elseif method == 2
    [water_mark_f, water_marked] = dct_encode(filename);
elseif method == 3
    [water_mark_f, water_marked] = dwt_encode(filename);
    imwrite(uint8(real(water_marked)), strcat(extractBefore(filename,"."), '_dwt.bmp'));
end

axes(handles.after); 
imshow(real(water_mark_f), []);
set(handles.result, 'String', '未检测');


% --- Executes on button press in decode.
function decode_Callback(hObject, eventdata, handles)
% hObject    handle to decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global method;
global filename;
global water_mark_f;
if method == 1
    [water_mark_f, check] = fft_decode(filename);
elseif method == 2
    [water_mark_f, check] = dct_decode(filename);
elseif method == 3
    [water_mark_f, check] = dwt_decode(filename);
end
axes(handles.after); 
imshow(real(water_mark_f), []);
if check == 0
    set(handles.result, 'String', '未篡改');
else
    set(handles.result, 'String', '被篡改');        
end        

% --- Executes on button press in pic.
function pic_Callback(hObject, eventdata, handles)
% hObject    handle to pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global water_marked;
axes(handles.after); 
imshow(uint8(real(water_marked)));


% --- Executes on button press in f.
function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global water_mark_f;
axes(handles.after); 
imshow(real(water_mark_f), []);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global water_marked;
global water_mark_f;
global filename;
global method;
method_sum = ["_fft", "_dct", "_dwt"];
imwrite(uint8(real(water_marked)), strcat(extractBefore(filename,"."), method_sum(method))+'.bmp');
warndlg(strcat('成功保存为', strcat(extractBefore(filename,"."),  method_sum(method))+'.bmp'), '提示');

% --- Executes during object creation, after setting all properties.
function save_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

