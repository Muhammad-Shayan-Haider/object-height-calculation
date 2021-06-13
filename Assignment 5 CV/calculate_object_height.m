function varargout = calculate_object_height(varargin)
% CALCULATE_OBJECT_HEIGHT MATLAB code for calculate_object_height.fig
%      CALCULATE_OBJECT_HEIGHT, by itself, creates a new CALCULATE_OBJECT_HEIGHT or raises the existing
%      singleton*.
%
%      H = CALCULATE_OBJECT_HEIGHT returns the handle to a new CALCULATE_OBJECT_HEIGHT or the handle to
%      the existing singleton*.
%
%      CALCULATE_OBJECT_HEIGHT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCULATE_OBJECT_HEIGHT.M with the given input arguments.
%
%      CALCULATE_OBJECT_HEIGHT('Property','Value',...) creates a new CALCULATE_OBJECT_HEIGHT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calculate_object_height_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calculate_object_height_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calculate_object_height

% Last Modified by GUIDE v2.5 08-Dec-2020 12:14:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calculate_object_height_OpeningFcn, ...
                   'gui_OutputFcn',  @calculate_object_height_OutputFcn, ...
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


% --- Executes just before calculate_object_height is made visible.
function calculate_object_height_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calculate_object_height (see VARARGIN)

% Choose default command line output for calculate_object_height
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calculate_object_height wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calculate_object_height_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global original_image;
    [File_Name, Path_Name] = uigetfile('PATHNAME');
    if isequal(File_Name, 0)
        disp('user selected cancel');
        return;
    end
    path = fullfile(Path_Name, File_Name);
    axes(handles.axes1);
    original_image = imread(path);
    [x, y, z] = size(original_image);
    str = [num2str(x) ' x ' num2str(y)];
    imshow(original_image);
    set(handles.original_image_size, 'String', str);
    if z == 3
        set(handles.original_image_bands, 'String', 'RGB');
    end
    if z == 1
        set(handles.original_image_bands, 'String', 'Grayscale');
    end
    


% --- Executes on button press in calculate_height.
function calculate_height_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global original_image;
    [labels, image] = thresholding(original_image);
    stats = regionprops(labels,'BoundingBox'); 
    axes(handles.axes2);
    imshow(image);                      
    for k = 1 : size(stats)
        BB = stats(k).BoundingBox;
        rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],...
            'EdgeColor','r','LineWidth',2 );
        pixels_height = BB(4) - BB(2);               
        length_of_pixel = 1 / 96;
        height = length_of_pixel * pixels_height;              
        text(BB(1), BB(2), height + " inches");
        set(gcf,'DefaultTextColor','green');                        
    end
    up = 0;
    down = 0;
    [x, y, z] = size(image);
    for i = 1 : x
        for j = 1 : y
            if labels(i, j) == 1 && up == 0
                up = i;
            end
            if labels(i, j) == 1
                down = i;
            end
        end
    end
    height = down - up;
%     height = height * (1 / 96);
    str = [num2str(height) ' pixels'];
    set(handles.object_height, 'String', str);
