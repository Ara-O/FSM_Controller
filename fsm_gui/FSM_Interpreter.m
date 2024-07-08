function varargout = FSM_Interpreter(varargin)
% FSM_INTERPRETER M-file for FSM_Interpreter.fig
%      FSM_INTERPRETER, by itself, creates a new FSM_INTERPRETER or raises the existing
%      singleton*.
%
%      H = FSM_INTERPRETER returns the handle to a new FSM_INTERPRETER or the handle to
%      the existing singleton*.
%
%      FSM_INTERPRETER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FSM_INTERPRETER.M with the given input arguments.
%
%      FSM_INTERPRETER('Property','Value',...) creates a new FSM_INTERPRETER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FSM_Interpreter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FSM_Interpreter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FSM_Interpreter

% Last Modified by GUIDE v2.5 04-Apr-2016 17:56:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FSM_Interpreter_OpeningFcn, ...
    'gui_OutputFcn',  @FSM_Interpreter_OutputFcn, ...
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
% Remix by Angela. Woot! Woot!


% --- Executes just before FSM_Interpreter is made visible.
function FSM_Interpreter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FSM_Interpreter (see VARARGIN)

% Choose default command line output for FSM_Interpreter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FSM_Interpreter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FSM_Interpreter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtFsmInputFn_Callback(hObject, eventdata, handles)
% hObject    handle to txtFsmInputFn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFsmInputFn as text
%        str2double(get(hObject,'String')) returns contents of txtFsmInputFn as a double
fn = get(hObject, 'String');
if ~isempty(fn)
    updateTables(handles);
end

% --- Executes during object creation, after setting all properties.
function txtFsmInputFn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFsmInputFn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowseFsm.
function btnBrowseFsm_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseFsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% prompt user to get a .fsm file. get the filename and file path
%[fn, path] = uigetfile({'*.fsm','FSM files';'*.*','All files'});
[fn, path] = uigetfile('*.fsm','FSM files', 'MultiSelect', 'on');

% make sure there was something selected
if ~isequal(fn,0)
    %Check if just one file was selected
    if ischar(fn)
            % remove '.fsm'
            fn2 = fn(1:end-4);
            % set the other textboxes to the same name
            %   set(handles.txtOutputFn, 'String', [fn2 '.m']);
            set(handles.txtWorldFile, 'String', [fn2 '.world']);
            set(handles.txtLaunchFile, 'String', [fn2 '.launch']);
            
            % add file path to Matlab
            addpath(path);
            % set the textbox to the name of the file
            set(handles.txtFsmInputFn, 'String', fn);
            refreshGraph(handles)
            
            set(handles.tblEvents,'Data',{});
            set(handles.tblRobotStart,'Data',{});
            
            if isfield(handles, 'memoized_Read_FSM')
                handles.memoized_Read_FSM.clearCache;
            end
            
            handles.memoized_Read_FSM = memoize(@func_Read_FSM);
            
            % Update handles 
            guidata(hObject, handles);
            
            updateTables(handles)

    else 
        % Multiple files selected
        % remove '.fsm'
        formattedN = cellfun(@(x) x(1:end-4) + "||", fn, 'UniformOutput',false);
        formattedN = cell2mat([formattedN{:}]);
        fN = formattedN(1:end-2);

        for i = 1:numel(fn)
            % add file path to Matlab
            addpath(path);
        end

         % set the other textboxes to the same name
         set(handles.txtWorldFile, 'String', [fN '.world']);
         set(handles.txtLaunchFile, 'String', [fN '.launch']);

         % set the textbox to the name of the file
         set(handles.txtFsmInputFn, 'String', fN);
         set(handles.tblEvents,'Data',{});
         set(handles.tblRobotStart,'Data',{});
         refreshGraph(handles)
         
         % clearing the cache on a new file
         if isfield(handles, 'memoized_Read_FSM_Incremental')
            handles.memoized_Read_FSM_Incremental.clearCache;
         end
            
         handles.memoized_Read_FSM_Incremental = memoize(@func_Read_FSM_Incremental);
            
         % Update handles 
         guidata(hObject, handles);

         %Update tables for multiple data
         updateTablesIncremental(fn, handles)
    end
end



function txtMapInputFn_Callback(hObject, eventdata, handles)
% hObject    handle to txtMapInputFn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMapInputFn as text
%        str2double(get(hObject,'String')) returns contents of txtMapInputFn as a double
fn = get(hObject, 'String');
if ~isempty(fn)
    refreshGraph(handles);
end

% --- Executes during object creation, after setting all properties.
function txtMapInputFn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMapInputFn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowseMap.
function btnBrowseMap_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fn = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files'; '*.*','All Files'});
if ~isequal(fn,0)
    set(handles.txtMapInputFn, 'String', fn)
end

% --- Executes on button press in btnUpdateMap.
function btnUpdateMap_Callback(hObject, eventdata, handles)
% hObject    handle to btnUpdateMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% refresh graph data
refreshGraph(handles)


function txtOutputFn_Callback(hObject, eventdata, handles)
% hObject    handle to txtOutputFn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtOutputFn as text
%        str2double(get(hObject,'String')) returns contents of txtOutputFn as a double


% --- Executes during object creation, after setting all properties.
function txtOutputFn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtOutputFn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton21.
function btnFSMOutput_Callback(hObject, eventdata, handles)
fn = get(handles.txtFsmInputFn,'String');

parsedFn = strcat(strsplit(fn, "||"), '.fsm');

if(contains(fn, "||"))
   [states, eventsArr, ~] = handles.memoized_Read_FSM_Incremental(parsedFn);
          
   % get important stuff
   fn2 = get(handles.txtOutputFn,'String'); % m file name
   
   %get events
   events = get(handles.tblEvents, 'Data');
     
   initial_state = get(handles.txtInitialState,'String');
   final_state = get(handles.txtFinalState,'String');
   if ~isempty(fn)
      func_writeFSMDataIncremental(fn2, events, eventsArr, states, initial_state, final_state, fn, handles)
   end
else
    [states, ~] = handles.memoized_Read_FSM(fn);

    % get important stuff
    fn2 = get(handles.txtOutputFn,'String'); % m file name

    events = get(handles.tblEvents, 'Data');

    initial_state = get(handles.txtInitialState,'String');
    final_state = get(handles.txtFinalState,'String');

    % make output (.m) file
    if ~isempty(fn)
        func_writeFSMData(fn2, events, states, initial_state, final_state, fn)
    end


end

% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in btnWriteOutput.
function btnWriteOutput_Callback(hObject, eventdata, handles)
% hObject    handle to btnWriteOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fn = get(handles.txtFsmInputFn,'String');
% [states, ~] = func_Read_FSM(fn);

% get important stuff
fn2 = get(handles.txtOutputFn,'String'); % m file name
tasks = get(handles.tblTasks,'Data');
numTasks = size(tasks,1);
% assignin('base', 'tasks', tasks);
regions = get(handles.tblRegions,'Data');
% assignin('base', 'regions', regions);
numRegions = size((regions),1);
events = get(handles.tblEvents, 'Data');
% assignin('base', 'events', events);
numEvents = size((events),1);
bot = str2double(get(handles.txtBot,'String'));
% initial_state = get(handles.txtInitialState,'String');
% final_state = get(handles.txtFinalState,'String');

%fn = strcat(num2str(numTasks), "tasks", num2str(bot), "robots", num2str(regions), "regions_rn");
% where to start putting new tasks
% m=size(tasks,1)+1;

% separate the regtsk options and the reg options
% for p=1:numRegions
%     % if the size of the reg name is 4 or 5 (reg4, reg10 vs regtsk4)
%     if size(regions{p,1},2) == 4 || size(regions{p,1},2) == 5
%         % set the task name to reg name
%         tasks(m,1) = regions(p,1);
%         % get the two region x,y coords
%         regx1 = regions{p,2};
%         regy1 = regions{p,3};
%         regx2 = regions{p,4};
%         regy2 = regions{p,5};
%         
%         % find the midpoint x and y
%         tasks{m,2} = ((regx1+regx2)/2);
%         tasks{m,3} = ((regy1+regy2)/2);
%         
%         tasks{m,4} = 'D';
%         tasks{m,5}= 'M';
%                 
%         % increment for next task row
%         m=m+1;
%     end
% end

% get how many tasks there now are
% numTasks = size(tasks,1);

% get robot table info
robot = get(handles.tblRobotStart, 'Data');
s=size(robot,1);
robot = robot(1:s,2:end);


% make output (.m) file
if ~isempty(fn2)
%     func_writeUserData(fn2, bot, tasks, regions, events, states, initial_state, final_state, numTasks, numRegions, numEvents,fn)
    func_writeUserData(fn2, bot, tasks, regions, 0, 0, 0, 0, numTasks, numRegions, numEvents,fn, robot)

end

% --- Executes on button press in btnImportFsm.
function btnImportFsm_Callback(hObject, eventdata, handles)
% hObject    handle to btnImportFsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refreshGraph(handles)

set(handles.tblEvents,'Data',{});
set(handles.tblRobotStart,'Data',{});

updateTables(handles)


function txtxRange_Callback(hObject, eventdata, handles)
% hObject    handle to txtxRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtxRange as text
%        str2double(get(hObject,'String')) returns contents of txtxRange as a double


% --- Executes during object creation, after setting all properties.
function txtxRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtxRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtyRange_Callback(hObject, eventdata, handles)
% hObject    handle to txtyRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtyRange as text
%        str2double(get(hObject,'String')) returns contents of txtyRange as a double


% --- Executes during object creation, after setting all properties.
function txtyRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtyRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in btnSaveDataReg.
function btnSaveDataReg_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveDataReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This saves the data to a MAT file. In future versions, this could save to
% a text file or an excel file so that it can be edited outside of the GUI.
%   bots = get(handles.tblBots,'Data');
tasks = get(handles.tblTasks,'Data');
regions = get(handles.tblRegions,'Data');
events = get(handles.tblEvents,'Data');
robotStart = get(handles.tblRobotStart, 'Data');
fsmName = get(handles.txtFsmInputFn, 'String');

%uisave({'bots', 'tasks', 'regions', 'events'})
uisave({'tasks', 'regions', 'events', 'robotStart', 'fsmName'})


% --- Executes on button press in btnLoadDataReg.
function btnLoadDataReg_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadDataReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat','MAT-files');
if isequal(filename,0) || isequal(pathname,0)
    %disp('User selected Cancel')
else
    addpath(pathname);
    %disp(['User selected',fullfile(pathname,filename)])
    s = load(filename);
    %  set(handles.tblBots,'Data', s.bots);
    set(handles.tblTasks,'Data', s.tasks);
    set(handles.tblRegions,'Data', s.regions);
    set(handles.tblEvents,'Data', s.events);
    set(handles.tblRobotStart, 'Data', s.robotStart);
    set(handles.txtFsmInputFn, 'String', s.fsmName);
    
    %   eventNames = s.events(:,1)';
    %   regionNames = s.regionsData(:,1)';
    %   % update event list in regions table
    %   set(handles.tblEvents,'ColumnFormat',{'char','numeric','numeric','numeric','numeric',eventNames,eventNames})
    
    %   % update states list in events table
    %   set(handles.tblEvents,'ColumnFormat',{'char','char','char',regionNames})
    
    
    refreshGraph(handles)
    updateTables(handles)
end



function txtFinalState_Callback(hObject, eventdata, handles)
% hObject    handle to txtFinalState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFinalState as text
%        str2double(get(hObject,'String')) returns contents of txtFinalState as a double


% --- Executes during object creation, after setting all properties.
function txtFinalState_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFinalState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in txtInitialState.
function txtInitialState_Callback(hObject, eventdata, handles)
% hObject    handle to txtInitialState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns txtInitialState contents as cell array
%        contents{get(hObject,'Value')} returns selected item from txtInitialState


% --- Executes during object creation, after setting all properties.
function txtInitialState_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtInitialState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBot_Callback(hObject, eventdata, handles)
% hObject    handle to txtBot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBot as text
%        str2double(get(hObject,'String')) returns contents of txtBot as a
%        double




% --- Executes during object creation, after setting all properties.
function txtBot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when entered data in editable cell(s) in tblTasks.
function tblTasks_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tblTasks (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if eventdata.Indices(2) > 2 && eventdata.Indices(2) < 4
    refreshGraph(handles)
end


% --- Executes when entered data in editable cell(s) in tblRegions.
function tblRegions_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tblRegions (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if eventdata.Indices(2) > 1 && eventdata.Indices(2) < 6
    refreshGraph(handles)
end

function refreshGraph(handles)
% refresh axes with current image data and region data

% % Display image to scale first
% fn = get(handles.txtMapInputFn,'String');
% x_bounds = get(handles.txtxRange, 'String');
% y_bounds = get(handles.txtyRange, 'String');
% if ~isempty(fn)
%     %read image data from file
%     img = imread(fn);
%     % scale image if bounds are specified
%     if ~isempty(x_bounds) && ~isempty(y_bounds)
%         % get individual values and convert from string to double
%         x = str2double(regexp(x_bounds,'[,]','split'));
%         y = str2double(regexp(y_bounds,'[,]','split'));
%     else
%         x = [0 size(img,1)];
%         y = [0 size(img,2)];
%     end
%     %plot image
%     image(x,y,img)
% imshow(img);
%     hold on;
% end

% Display tasks on top of image map
tasks = get(handles.tblTasks,'Data');

% col numbers of x and y in task table
taskXcol = 2;
taskYcol = 3;

%plot all tasks
for i =1:size(tasks,1)
    x = tasks{i,taskXcol};
    y = tasks{i,taskYcol};
    plot(x,y,'*');
    hold on
end

% Display regions on top of image map
regions = get(handles.tblRegions,'Data');
% assignin('base', 'regions', regions);
% rName = 1;
rx1 = 2;
ry1 = 3;
rx2 = 4;
ry2 = 5;

for i =1:size(regions,1)
    % (x1,y1) to (x1,y2) to (x2,y2) to (x2,y1) to (x1,y1)
    % xS = [x1,x1,x2,x2,x1];  % Points for the corners
    % yS = [y1,y2,y2,y1,y1];
    x= [regions{i,rx1}, regions{i,rx1}, regions{i,rx2}, regions{i,rx2}, regions{i,rx1}];
    y= [regions{i,ry1}, regions{i,ry2}, regions{i,ry2}, regions{i,ry1}, regions{i,ry1}];
    hold on
    plot(x,y,':');
end
try
    % get robot start table info
    robotStart = get(handles.tblRobotStart, 'Data');
    % assignin('base', 'robotStart', robotStart);
    % go through each row
    for k = 1:size(robotStart,1)
        % get x and y's
        xR = robotStart{k,2};
        yR = robotStart{k,3};
        %     assignin('base', 'xR', xR);
        %     assignin('base', 'yR', yR);
        hold on
        % plot as an o
        plot(xR,yR,'o');
    end
end
hold off



function updateTables(handles)
fn = get(handles.txtFsmInputFn,'String');
if ~isempty(fn)
    [states, event_names] = handles.memoized_Read_FSM(fn);
    events = get(handles.tblEvents,'Data');
    
    if isempty(events)
        % if logic to event names, such as 'a' = bot 1, 's' = task, 'e' = region, enter code here
        for i=1:length(event_names)
            events{i,1} = event_names{i};
            
            % Determine which bot for that event
            if strcmp(event_names{i}(1),'a')
                events{i,2} = 1; % bot is 1
            elseif strcmp(event_names{i}(1),'b')
                events{i,2} = 2; % bot is 2
            elseif strcmp(event_names{i}(1),'c')
                events{i,2} = 3; % bot is 3
            elseif strcmp(event_names{i}(1),'d')
                events{i,2} = 4; % bot is 4
            elseif strcmp(event_names{i}(1),'e')
                events{i,2} = 5; % bot is 5
            elseif strcmp(event_names{i}(1),'f')
                events{i,2} = 6; % bot is 6
            elseif strcmp(event_names{i}(1),'g')
                events{i,2} = 7; % bot is 7
            elseif strcmp(event_names{i}(1),'h')
                events{i,2} = 8; % bot is 8
            elseif strcmp(event_names{i}(1),'i')
                events{i,2} = 9; % bot is 9
            elseif strcmp(event_names{i}(1),'j')
                events{i,2} = 10; % bot is 10
            elseif strcmp(event_names{i}(1),'k')
                events{i,2} = 11; % bot is 11
            elseif strcmp(event_names{i}(1),'l')
                events{i,2} = 12; % bot is 12
            elseif strcmp(event_names{i}(1),'m')
                events{i,2} = 13; % bot is 13
            elseif strcmp(event_names{i}(1),'n')
                events{i,2} = 14; % bot is 14
            elseif strcmp(event_names{i}(1),'o')
                events{i,2} = 15; % bot is 15
            elseif strcmp(event_names{i}(1),'p')
                events{i,2} = 16; % bot is 16
            elseif strcmp(event_names{i}(1),'q')
                events{i,2} = 17; % bot is 17
            elseif strcmp(event_names{i}(1),'r')
                events{i,2} = 18; % bot is 18
            elseif strcmp(event_names{i}(1),'s')
                events{i,2} = 19; % bot is 19
            elseif strcmp(event_names{i}(1),'t')
                events{i,2} = 20; % bot is 20
            elseif strcmp(event_names{i}(1),'u')
                events{i,2} = 21; % bot is 21
            elseif strcmp(event_names{i}(1),'v')
                events{i,2} = 22; % bot is 22
            elseif strcmp(event_names{i}(1),'w')
                events{i,2} = 23; % bot is 23
            elseif strcmp(event_names{i}(1),'x')
                events{i,2} = 24; % bot is 24
            elseif strcmp(event_names{i}(1),'y')
                events{i,2} = 25; % bot is 25
            elseif strcmp(event_names{i}(1),'z')
                events{i,2} = 26; % bot is 26
            end
            
            % get robot numbers
            robVal = [];
            for m=1:size((events),1)
                robVal = [robVal events{m,2}];
            end
            
            % find max value
            maxRobVal = max(robVal(:));
            % set as amt of robots
            set(handles.txtBot, 'String', num2str(maxRobVal));
            
            %Determine region or task based on controllable or uncontrollable event
            %             for n=1:size((states),1)
            %                 for m=1:size((states{n,2}),1)
            %                     if strcmp(states{n,2}{m,1},event_names{i})
            %                         if strcmp(states{n,2}{m,3},'c')
            %                             events{i,3} = 'Task'; % controllable event: Task
            %                             break
            %                         else
            %                             events{i,3} = 'Region'; % uncontrollable event: Region
            %                             break
            %                         end
            %                     end
            %                 end
            %             end
            
            % determine region or task based on last letter of event name
            % all e and f will be regions and s will be task
            if strcmp(event_names{i}(end), 's')
                events{i,3} = 'Task'; % controllable event: Task
            else
                events{i,3} = 'Region'; % uncontrollable event: Region
            end           
%             events{i,4} = ''; % type_name which must be selected from defined tasks & regions
        end
    end
    
    % Set events table
    set(handles.tblEvents,'Data',events);
    
    % get task_names
    tasks = get(handles.tblTasks,'Data');
    task_names = tasks(:,1);
    
    % get region_names
    regions = get(handles.tblRegions,'Data');
    region_names = regions(:,1);
    
    % combine task_names and region_names into one list
    type_names = [task_names; region_names]';
    
    % update task_region_names in events table
    set(handles.tblEvents,'ColumnFormat',{'char','numeric',{'Task', 'Region'},type_names})
    
    % update initial state with default first entry of FSM
    set(handles.txtInitialState,'String',states{1,1})
    
    numTasks = str2double(get(handles.txtTotalNumReg, 'String'));
    numRegions = str2double(get(handles.txtTotalNumTasks, 'String'));
    
    taskRegTotal = numTasks + numRegions;
    
    m=1;
    n=1;
%     assignin('base', 'regions', regions);
    regName = {};
    % separate the regtsk options and the reg options
    for p=1:size(regions,1)
        % if the size of the reg name is 4 (reg4 or reg04 vs regtsk4)
        if size(regions{p,1},2) == 4 || size(regions{p,1},2) == 5
            % add to name array in cell format (or it will concatenate)
            regName(m)=regions(p,1);
            % increment
            m=m+1;
        else
            % it's a regtsk, add to this list
            regTskNames(n) = regions(p,1);
            % increment it's index
            n=n+1;
        end
    end
%     
%     assignin('base', 'events', events);
%     assignin('base', 'regTskNames', regTskNames);
%     assignin('base', 'task_names', task_names);

% go through each row in events to update the last column
    for k = 1:size(events,1)
        % get the event name
        eventname = events{k,1};
        % get the last letter
        lastLetter = eventname(end);
        
%         if taskRegTotal < 10
            % if it's the old format 'a1s'
            if length(eventname) == 3
                % the number is one digit located one back from the end
                eventNum = eventname(end-1);
                if taskRegTotal > 9
                    eventNum = ['0' eventNum];
                end
            else % it's the new method or double digits
                % the number is in the 2 and 3 spot
                eventNum = eventname(2:3);
                % make sure you remove the '01' to '1' (make a num then a str
                % again)
%                 eventNum = num2str(str2double(eventNum));
            end
%         else % theyre in the format a01s and you want the middle two and keep the 0
%             eventNum = eventname(2:3);
%         end
            
            
        % find the letter match
        switch lastLetter
            case {'f'} % these are regtsk type name events
                % go through the names of regtsk's options
                for r=1:length(regTskNames)
                    % get the nth name
                    n = regTskNames{r};
                    
                    % if its in format regtsk#
                    if length(n) == 7
                        % just get the last number
                        n2 = n(end);
                    else % it's in format regtsk##
                        n2=n(7:end); % get the 7th to end value
                    end
                    
                    % compare the regtsk's number to the event name's
                    % number
                    if strcmp(n2,eventNum)
                        % they match, set that column to that regtsk name
                        events{k,4} = n;
                        % stop looping
                        break;
                    end
                end
                
            case {'e'} % these are 'reg' type name events
                % go through the reg name options
                for r=1:length(regName)
                    % get the nth name
                    n = regName{r};
                    
                    % if it's in format reg#
                    if length(n) == 4
                        % get the end
                        n2 = n(end);
                    else % it's format reg##
                        % get the 4th to end number
                        n2=n(4:end);
                    end
                    
                    % compare the reg number to the event name number
                    if strcmp(n2,eventNum)
                        % match, set the event column to that
                        events{k,4} = n;
                        break; % stop looping
                    end
                end
                
            case {'s'} % these are tsk type name events
                % already found these names above but are in column vector,
                % transpose to row vector
                task_names = task_names';
                
                % go through the task name options
                for r=1:length(task_names)
                    % get the name
                    n = task_names{r};
                    % if it's format tsk#
                    if length(n) == 4
                        % get the end
                        n2 = n(end);
                    else % it's format tsk##
                        n2=n(4:end); % get the last 2 (or 3 or 4..)
                    end
                    
                    % compare the tsk name number with the event's number
                    if strcmp(n2,eventNum)
                        events{k,4} = n; % match, set event column
                        break; % stop looping
                    end
                end % end for case s
                
        end % end switch
                
    end % end main for 
    
    % update data table
    set(handles.tblEvents, 'Data', events);
    
    % update marked state with first marked state in FSM
    for n=1:length(states)
        if states{n,3}
            set(handles.txtFinalState,'String',states{n,1})
            break
        end
    end
    
    % Get the data from the robot start table (so it can be set)
    robotStart = get(handles.tblRobotStart, 'Data');
       
    % Set Robot Start Location Table
    if isempty(robotStart)
        % get how many robots
        maxRobVal = str2double(get(handles.txtBot, 'String'));
        
        % empty x and y
        for num=1:maxRobVal
            robotStart{num,2} = '';
            robotStart{num,3} = '';
        end
        
        
        %         i=1;
        %         % weed out the regtsk options
        %         for p=1:size(regions,1)
        %             % if the size of the reg name is 4 (reg4 vs regtsk4)
        %             if size(regions{p,1},2) == 4
        %                 % add to temp array in cell format (or it will concatenate)
        %                 regNames(i)=regions(p,1);
        %                 % increment
        %                 i=i+1;
        %             end
        %         end
        
        if ~isempty(regName)
            % Make a dropdown of the 'reg#' options
            set(handles.tblRobotStart,'ColumnFormat',{regName});
        else
            noReg = {'noReg'};
            set(handles.tblRobotStart,'ColumnFormat',{noReg});
        end
        % update robot start table
        set(handles.tblRobotStart,'Data',robotStart);
    end
    
end



% --- Executes on button press in btnAddTask.
function btnAddTask_Callback(hObject, eventdata, handles)
% hObject    handle to btnAddTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tasks_id = get(handles.tblTasks,'UserData');
if ~isempty(tasks_id)
    tasks = get(handles.tblTasks,'Data');
    
    if tasks_id(1) == size(tasks,1)
        % insert new row at end of tasks
        tasks{tasks_id(1)+1,1} = 'tsk';
        tasks{tasks_id(1)+1,2} = 0;
        tasks{tasks_id(1)+1,3} = 0;
        tasks{tasks_id(1)+1,4} = 'gotogoal';
        tasks{tasks_id(1)+1,5} = 'start';
    else
        % insert new row in middle of tasks
        for i = (size(tasks,1)+1):-1:tasks_id(1)+1
            for j=1:size(tasks,2)
                tasks{i,j} = tasks{i-1,j};
            end
        end
        
        tasks{tasks_id(1)+1,1} = 'tsk';
        tasks{tasks_id(1)+1,2} = 0;
        tasks{tasks_id(1)+1,3} = 0;
        tasks{tasks_id(1)+1,4} = 'gotogoal';
        tasks{tasks_id(1)+1,5} = 'start';
    end
    set(handles.tblTasks,'Data',tasks)
    
end

% --- Executes on button press in btnAddRegion.
function btnAddRegion_Callback(hObject, eventdata, handles)
% hObject    handle to btnAddRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
regions_id = get(handles.tblRegions,'UserData');
if ~isempty(regions_id)
    regions = get(handles.tblRegions,'Data');
    
    if regions_id(1) == size(regions,1)
        % insert new row at end of regions
        regions{regions_id(1)+1,1} = 'reg';
        regions{regions_id(1)+1,2} = 0;
        regions{regions_id(1)+1,3} = 0;
        regions{regions_id(1)+1,4} = 0;
        regions{regions_id(1)+1,5} = 0;
    else
        % insert new row in middle of regions
        for i = (size(regions,1)+1):-1:regions_id(1)+1
            for j=1:size(regions,2)
                regions{i,j} = regions{i-1,j};
            end
        end
        
        regions{regions_id(1)+1,1} = 'reg';
        regions{regions_id(1)+1,2} = 0;
        regions{regions_id(1)+1,3} = 0;
        regions{regions_id(1)+1,4} = 0;
        regions{regions_id(1)+1,5} = 0;
    end
    set(handles.tblRegions,'Data',regions)
    
end

% --- Executes on button press in btnDeleteTask.
function btnDeleteTask_Callback(hObject, eventdata, handles)
% hObject    handle to btnDeleteTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tasks_id = get(handles.tblTasks,'UserData');
if ~isempty(tasks_id)
    tasks = get(handles.tblTasks,'Data');
    
    if tasks_id(1) == size(tasks,1)
        % delete last row of tasks
        tasks = tasks(1:tasks_id(1)-1,:);
    else
        % insert new row in middle of tasks
        for i = tasks_id(1):size(tasks,1)-1
            for j=1:size(tasks,2)
                tasks{i,j} = tasks{i+1,j};
            end
        end
        
        tasks = tasks(1:size(tasks,1)-1,:);
    end
    set(handles.tblTasks,'Data',tasks)
    
end


% --- Executes on button press in btnDeleteRegion.
function btnDeleteRegion_Callback(hObject, eventdata, handles)
% hObject    handle to btnDeleteRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
regions_id = get(handles.tblRegions,'UserData');
if ~isempty(regions_id)
    regions = get(handles.tblRegions,'Data');
    
    if regions_id(1) == size(regions,1)
        % delete last row of regions
        regions = regions(1:regions_id(1)-1,:);
    else
        % insert new row in middle of regions
        for i = regions_id(1):size(regions,1)-1
            for j=1:size(regions,2)
                regions{i,j} = regions{i+1,j};
            end
        end
        
        regions = regions(1:size(regions,1)-1,:);
    end
    set(handles.tblRegions,'Data',regions)
    
end

% --- Executes when selected cell(s) is changed in tblTasks.
function tblTasks_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tblTasks (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'UserData',eventdata.Indices)


% --- Executes when selected cell(s) is changed in tblRegions.
function tblRegions_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tblRegions (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'UserData',eventdata.Indices)


% --- Executes on button press in btnWorldGenFile.
function btnWorldGenFile_Callback(hObject, eventdata, handles)
% hObject    handle to btnWorldGenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% pass fsm name to id folder
fn = get(handles.txtFsmInputFn,'String');
% get some stuff to pass
worldFileName = get(handles.txtWorldFile,'String');
tasks = get(handles.tblTasks,'Data');
regions = get(handles.tblRegions,'Data');
numRobots = str2double(get(handles.txtBot,'String'));
robotStart = get(handles.tblRobotStart, 'Data');
obstacleNum = str2double(get(handles.txtObstacleNum, 'String'));
% assignin('base', 'robotStart', robotStart);

% make the 2nd and 3rd columns of robot start numbers instead of strings
% but use num2cell cause they're also in cell format
% for i=1:numRobots
%     robotStart(i,2)=num2cell(str2double(robotStart(i,2)));
%     robotStart(i,3)=num2cell(str2double(robotStart(i,3)));
% end
% make file
if ~isempty(worldFileName)
   % worldFileGenerator(tasks, numRobots, regions, worldFileName, robotStart, fn, obstacleNum);
   worldFileGazeboGenerator(tasks, numRobots, regions, worldFileName, robotStart, fn, obstacleNum);
end


% --- Executes on button press in btnLauchFileGen.
function btnLauchFileGen_Callback(hObject, eventdata, handles)
% hObject    handle to btnLauchFileGen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the file names
launchName = get(handles.txtLaunchFile, 'String');
worldName = get(handles.txtWorldFile, 'String');
folderName = get(handles.txtFsmInputFn, 'String');
robotNum = str2double(get(handles.txtBot, 'String'));

% make lauch file if both have text
if ~isempty(launchName) && ~isempty(worldName)
    %Get number of tasks
    tasks = get(handles.tblTasks,'Data');
    numTasks = size(tasks,1);
    regions = get(handles.tblRegions,'Data');
    regAmount=0;
    % find the amount of regions
    for p=1:size(regions,1)
        if length(regions{p,1}) < 6
            regAmount = regAmount+1;
        end
    end
    numScenarios = get(handles.txtScenario, 'String')
    
    %Get robot starting locations
    robot = get(handles.tblRobotStart, 'Data');
    s=size(robot,1);
    robotsLoc = robot(1:s,2:end);

    %launchFileGenerator_mb(launchName, worldName, folderName, robotNum);
    launchGazeboFileGenerator(launchName, worldName, folderName, robotNum, numTasks, regAmount,numScenarios, robotsLoc );

    %--------
    %launchFileGenerator_movebase(launchName, worldName, folderName, robotNum);
    %launchFileGenerator_movebasegoal(launchName, worldName, folderName, robotNum);
end


function txtWorldFile_Callback(hObject, eventdata, handles)
% hObject    handle to txtWorldFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtWorldFile as text
%        str2double(get(hObject,'String')) returns contents of txtWorldFile as a double


% --- Executes during object creation, after setting all properties.
function txtWorldFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtWorldFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtLaunchFile_Callback(hObject, eventdata, handles)
% hObject    handle to txtLaunchFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLaunchFile as text
%        str2double(get(hObject,'String')) returns contents of txtLaunchFile as a double


% --- Executes during object creation, after setting all properties.
function txtLaunchFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLaunchFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkRandomize.
function chkRandomize_Callback(hObject, eventdata, handles)
% hObject    handle to chkRandomize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkRandomize

% get value
chkVal = get(hObject,'Value');

% if checked
if chkVal == 1
    % make button clickable
    set(handles.btnGenRandStart, 'Enable', 'on');
else
    % not checked, turn off clickable
    set(handles.btnGenRandStart, 'Enable', 'off');
end

% --- Executes when entered data in editable cell(s) in tblEvents.
function tblEvents_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tblEvents (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in tblRobotStart.
function tblRobotStart_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tblRobotStart (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)




% --- Executes when selected cell(s) is changed in tblRobotStart.
function tblRobotStart_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tblRobotStart (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnCheckStart.
function btnCheckStart_Callback(hObject, eventdata, handles)
% hObject    handle to btnCheckStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

robotStart = get(handles.tblRobotStart, 'Data');
regions = get(handles.tblRegions, 'Data');
% assignin('base', 'robotStart', robotStart);
% flag if a warning occured
w=0;

% for every row in the robot start table
for i = 1:size(robotStart,1)
    % get the region name and x and y values
    robotReg = robotStart{i,1};
    robotX = robotStart{i,2}; % as numbers, not strings
    robotY = robotStart{i,3};
    
    if (isempty(robotX) || isnan(robotX) || isempty(robotY) || isnan(robotY))
        warndlg('Enter numbers in all cells! Actual numbers will be checked');
        w=2; % flag as not a region issue but type issue
    end
    
    % go through the regions table
    for j=1:size(regions,1)
        % find the matching region in the region table
        if strcmp(regions{j,1},robotReg)
            % get both x and y coords
            regx1 = regions{j,2}; % already in number format
            regx2 = regions{j,4};
            regy1 = regions{j,3};
            regy2 = regions{j,5};
            break; % found it, quit searching
        end
    end
    
    % find the minimum and maximum x and y values
    minX = min(regx1,regx2);
    maxX = max(regx1,regx2);
    minY = min(regy1,regy2);
    maxY = max(regy1,regy2);
    
    % if the entered x value is below the min or above the max
    if (robotX < minX || robotX > maxX)
        % reset that value
        robotStart{i,2} = robotX*10000;
        % Show a warning
        %         warndlg('There was a problem with an X. A -- was added to the end', 'Robot Start Location Issue');
        % flag there was a problem with values
        w=1;
    end
    
    % Same with y
    if (robotY > maxY || robotY < minY)
        robotStart{i,3} = robotY*10000;
        %         warndlg('There was a problem with a Y. A -- was added to the end', 'Robot Start Location Issue')
        w=1;
    end
    
end % end loop

% if no warning
if w ~= 1
    % let user know values were good
    warndlg('No problems', 'All Good');
elseif w == 1 % there was a value problem (as opposed to type problem)
    % show warning
    warndlg('There was a problem!! Invalid number(s) was multiplied by 10000', 'Robot Start Location Issue')
    % there was a warning, reload table with the --'s
    set(handles.tblRobotStart, 'Data', robotStart);
end



% --- Executes on button press in btnGenRandStart.
function btnGenRandStart_Callback(hObject, eventdata, handles)
% hObject    handle to btnGenRandStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get needed data
regions = get(handles.tblRegions,'Data');
robotStart = get(handles.tblRobotStart, 'Data');

% RANDOM REGION
% index var
i=1;
regNames={};
% weed out the regtsk options
for p=1:size(regions,1)
    % if the size of the reg name is 4
    if size(regions{p,1},2) < 6
        % add to temp array in cell format (or it will concatenate)
        regNames(i)=regions(p,1);
        % increment
        i=i+1;
    end
end


% create a random differing region, x, and y for each robot
for k = 1:size(robotStart, 1)
    %     % random region selection
    %     % max num of regions for rand
    %     regRange = size(regNames,2);
    %     % get a random num from 1 to max num of regions
    %     regNum = round(1 + (regRange-1).*rand(1));
    if ~isempty(regNames)
        % find the right row in the regions table - loop through each row
        for letter=1:size(regions,1)
            % RANDOM REGION if the first 4 letters are a match (strcmp complains if strings
            % are different sizes and reg4 is dif length than regtsk4)
            %         if strncmp(regions{letter,1},regNames{1,regNum},size(regNames{1,regNum},2))
            % put region name into first column
            %             robotStart{k,1} =  regions{letter,1};
            
            % use for NON random region
            if strcmp(robotStart{k,1}, regions{letter,1})
                % get the 2 x,y's for that region
                x1 = cell2mat(regions(letter,2)); % Extract the corners of the region
                x2 = cell2mat(regions(letter,4));
                y1 = cell2mat(regions(letter,3));
                y2 = cell2mat(regions(letter,5));
                % Create a random start in the region, based on the corners.
                % And put them in their rightful places
                robotStart{k,2} = (x2-x1)*rand(1) + x1;
                robotStart{k,3} = (y2-y1)*rand(1) + y1;
                % remove the region chosen from the list of options (so other
                % robots won't be in the same region).
                
                % RANDOM REGION
                %             regNames(regNum) = [];
                break; % stop searching and move to next robot
            end
        end
    else
        x1 = -19; % Extract the corners of the region
        x2 = 19;
        y1 = -19;
        y2 = 19;
        % Create a random start in the region, based on the corners.
        % And put them in their rightful places
        robotStart{k,2} = (x2-x1)*rand(1) + x1;
        robotStart{k,3} = (y2-y1)*rand(1) + y1;
    end
end

% update table data
set(handles.tblRobotStart, 'Data', robotStart);
% graph the robots
refreshGraph(handles);


% --- Executes on button press in btnSetReg.
function btnSetReg_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

regions = get(handles.tblRegions, 'Data');
tasks = get(handles.tblTasks, 'Data');
numRegions = str2double(get(handles.txtTotalNumReg, 'String'));
numTasks = str2double(get(handles.txtTotalNumTasks, 'String'));
total = numRegions + numTasks;


regAmount=0;
% find the amount of regions
for p=1:size(regions,1)
    if length(regions{p,1}) < 6
        regAmount = regAmount+1;
    end
end

% row counter where to put the regtsk (start at the one after the last reg)
i = regAmount + 1;

for j = 1:size(tasks,1)
    taskname = tasks{j,1};
    if total < 10
        tasknum = taskname(end);
    else
        tasknum = taskname(end-1:end);
    end
    
    % make the 2x2 regions with names
    regions{i,1} = ['regtsk' tasknum];
    regions{i,2} = tasks{j,2}-1;
    regions{i,3} = tasks{j,3}-1;
    regions{i,4} = tasks{j,2}+1;
    regions{i,5} = tasks{j,3}+1;
    
    i = i+1;
    
end

set(handles.tblRegions, 'Data', regions);
refreshGraph(handles);

%assignin('base', 'regNames', regNames);
%assignin('base', 'taskNames', taskNames);


function txtObstacleNum_Callback(hObject, eventdata, handles)
% hObject    handle to txtObstacleNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtObstacleNum as text
%        str2double(get(hObject,'String')) returns contents of txtObstacleNum as a double


% --- Executes during object creation, after setting all properties.
function txtObstacleNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtObstacleNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtNumTasks_Callback(hObject, eventdata, handles)
% hObject    handle to txtNumTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNumTasks as text
%        str2double(get(hObject,'String')) returns contents of txtNumTasks as a double


% --- Executes during object creation, after setting all properties.
function txtNumTasks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNumTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtTaskRegOrder_Callback(hObject, eventdata, handles)
% hObject    handle to txtTaskRegOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTaskRegOrder as text
%        str2double(get(hObject,'String')) returns contents of txtTaskRegOrder as a double


% --- Executes during object creation, after setting all properties.
function txtTaskRegOrder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTaskRegOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkRandomTasks.
function chkRandomTasks_Callback(hObject, eventdata, handles)
% hObject    handle to chkRandomTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkRandomTasks

randTask = get(hObject, 'Value');
if randTask == 1
    set(handles.txtTaskRegOrder, 'Enable', 'on');
    set(handles.txtNumTasks, 'Enable', 'on');
    set(handles.btnGenerateTasks, 'Enable', 'on');
else
    set(handles.txtTaskRegOrder, 'Enable', 'off');
    set(handles.txtNumTasks, 'Enable', 'off');
    set(handles.btnGenerateTasks, 'Enable', 'off');
end


% --- Executes on button press in btnGenerateTasks.
function btnGenerateTasks_Callback(hObject, eventdata, handles)
% hObject    handle to btnGenerateTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get stuff
numTasks = str2double(get(handles.txtNumTasks, 'String'));
regOrder = get(handles.txtTaskRegOrder, 'String');
regions = get(handles.tblRegions, 'Data');
% empty task table
set(handles.tblTasks, 'Data', {})

% counter for how many reg tsk's are in the current regions table
numOldRegTsk = 0;
% region name index counter
n=1;
regionNames={};
% find how many 'regtsk's' are in the region table and collect reg names
% loop all rows
for i=1:size(regions,1)
    % if first 6 chars match regtsk
    if strncmp(regions{i,1}, 'regtsk', 6)
        % increment counter
        numOldRegTsk = numOldRegTsk+1;
    else  % it's a reg, store it
        regionNames{n} = regions{i,1};
        n=n+1;
    end
end

totalRegTasks = numTasks+length(regionNames);

% make sure there are regtsk's before trying to remove them
if numOldRegTsk ~= 0
    % initialize cell matrix
    reg={};
    % if there are other rows
    if ~isempty(regOrder)
        % loop through the rows that aren't regtsk's
        for i=1:(size(regions,1)-numOldRegTsk)
            % add those to a new variable which will be later set to the region
            % table data
            reg(i,:) = regions(i,:);
        end
    end
else % there aren't any regtsk's
    reg = regions;
    i = size(regions,1);
end

% increment so you can add more rows there
i = i+1;


% make sure they want at least one task
if numTasks ~= 0
    % if there are regions
    if ~isempty(regOrder)
        % remove any spaces
        regOrder(regOrder==' ') = [];
        % get just the numbers and in separate strings
        regOrder = strsplit(regOrder, ',');
        % add 'reg' to the beginning of the number
        regOrder = strcat({'reg'},regOrder);
    end
    
    
    % for task names, make a range of number from 1 to combo for reg and tasks
    range = 1:totalRegTasks;
    
    % initialize for holding the region numbers
    regNums = [];
    % go through the region names
    for h=1:length(regionNames)
        % get the name
        regName = regionNames{h};
        % if it's in form reg#
        if length(regName) == 4
            % add end of string to array but in number format
            regNums= [regNums str2double(regName(end))];
        else % it's in reg## form
            % add last 2 to array in num form
            regNums = [regNums str2double(regName(4:5))];
        end
    end
    
   
    % make sure they're in order
    regNums = sort(regNums);
    
    % check if the region order entered is empty
    if ~isempty(regOrder)
        % xor to remove the region numbers form the task names
        taskNums = setxor(regNums, range);
    else
        taskNums = setxor(regNums, range)';
    end

    % and make them strings (string arrays have to be cells says internet)
    taskNumsStr = strtrim(cellstr(num2str(taskNums'))');
    %assignin('base', 'taskNumsStr', taskNumsStr);
   
%     taskNames = [];
    
% if there are 0-9 combined task and regions, they wont have 0's in them
    if totalRegTasks < 10
        % add 'tsk' in front of num
        taskNames = strcat({'tsk'},taskNumsStr);
        % make the 'regtsk' names
        regtsk = strcat({'regtsk'}, taskNumsStr);
        %assignin('base', 'i', i);
    else
        for number = 1:length(taskNumsStr)
            if str2double(taskNumsStr{number}) < 10
                % add 'tsk' in front of num
                taskNames(number) = strcat({'tsk0'},taskNumsStr{number});
                % make the 'regtsk' names
                regtsk(number) = strcat({'regtsk0'}, taskNumsStr{number});
            else
                % add 'tsk' in front of num
                taskNames(number) = strcat({'tsk'},taskNumsStr{number});
                % make the 'regtsk' names
                regtsk(number) = strcat({'regtsk'}, taskNumsStr{number});
            end
        end
    end
% 
%     assignin('base', 'taskNames', taskNames);
%     assignin('base', 'regtsk', regtsk);
        
    noRegIndex = 1;
    % go through each task
    for k = 1:numTasks
        % find the row in the regions table that matches the region name
        for letter=1:size(regions,1)
            % if there are regions
            if ~isempty(regOrder)
                % do they match?
                if strncmp(regOrder(k), regions{letter,1},5)
                    % get the 2 x,y's for that region
                    x1 = cell2mat(regions(letter,2)); % Extract the corners of the region
                    x2 = cell2mat(regions(letter,4));
                    y1 = cell2mat(regions(letter,3));
                    y2 = cell2mat(regions(letter,5));
                    % Create a random location in the region, based on the corners.
                    % And put them in their rightful places
                    tasks{k,2} = round((x2-x1)*rand(1) + x1);
                    tasks{k,3} = round((y2-y1)*rand(1) + y1);
                    
                    % add the name to that row (task name elements are cells, use {}
                    tasks{k,1} = taskNames{k};
                    
                    % add the 1 weird column - doesn't matter
                    tasks{k,4} = 'D';
                    
                    % from column in the form: odd numbered tasks are
                    % start and even are tsk(#-1)
                    
                    % check if it's even
                    if mod(taskNums(k),2) == 0 %it's even
                        % set the task name to 'tsk' followed by the prev
                        % task num
                        tsknm = ['tsk' num2str(taskNums(k-1))];
                        % set in column
                        tasks{k,5} = tsknm;
                    else %its odd
                        % just set to start
                        tasks{k,5} = 'start';
                    end
                    
                    % make the 2x2 regions with names
                    reg{i,1} = regtsk{k};
                    reg{i,2} = tasks{k,2}-1;
                    reg{i,3} = tasks{k,3}-1;
                    reg{i,4} = tasks{k,2}+1;
                    reg{i,5} = tasks{k,3}+1;
                    
                    %increment i for next time
                    i=i+1;
                    
                    break; % stop searching and move to next task
                end
            else
                % use wall boundaries (approx these numbers)
                x1 = -19;
                x2 = 19;
                y1 = -19;
                y2 = 19;
                
                % Create a random location in the region, based on the corners.
                % And put them in their rightful places
                tasks{k,2} = round((x2-x1)*rand(1) + x1);
                tasks{k,3} = round((y2-y1)*rand(1) + y1);
                
                % add the name to that row (task name elements are cells, use {}
                tasks{k,1} = taskNames{k};
                % add the 2 weird columns
                tasks{k,4} = 'D';
                tasks{k,5} = 'M';
                
                % make the 2x2 regions with names
                reg{noRegIndex,1} = regtsk{k};
                reg{noRegIndex,2} = tasks{k,2}-1;
                reg{noRegIndex,3} = tasks{k,3}-1;
                reg{noRegIndex,4} = tasks{k,2}+1;
                reg{noRegIndex,5} = tasks{k,3}+1;
                
                %increment i for next time
                noRegIndex=noRegIndex+1;  
                break;
            end
        end
    end
    
    % update table
    set(handles.tblTasks, 'Data', tasks);
end

% assignin('base', 'reg', reg);

% update table
set(handles.tblRegions, 'Data', reg);
% show the tasks/regions on graph
refreshGraph(handles);



function txtTotalNumTasks_Callback(hObject, eventdata, handles)
% hObject    handle to txtTotalNumTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTotalNumTasks as text
%        str2double(get(hObject,'String')) returns contents of txtTotalNumTasks as a double


% --- Executes during object creation, after setting all properties.
function txtTotalNumTasks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTotalNumTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtTotalNumReg_Callback(hObject, eventdata, handles)
% hObject    handle to txtTotalNumReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTotalNumReg as text
%        str2double(get(hObject,'String')) returns contents of txtTotalNumReg as a double


% --- Executes during object creation, after setting all properties.
function txtTotalNumReg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTotalNumReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnName.
function btnName_Callback(hObject, eventdata, handles)
% hObject    handle to btnName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

numRegions = str2double(get(handles.txtTotalNumReg, 'String'));
numTasks = str2double(get(handles.txtTotalNumTasks, 'String'));
tasks = get(handles.tblTasks, 'Data');
regions = get(handles.tblRegions, 'Data');

if numTasks ~= 0
    
    total = numTasks+numRegions;
    allNumbers = 1:total;
    taskNums = 1:numTasks;
    
    for i = 1:numTasks
        if total > 9 && i < 10
            tasks{i,1} = strcat('tsk0', num2str(allNumbers(i)));
        else
            tasks{i,1} = strcat('tsk', num2str(allNumbers(i)));
        end
    end
    
    i = i+1;
    
    for j = 1:numRegions
        if total > 9 && i < 10
            regions{j,1} = strcat('reg0', num2str(allNumbers(i)));
        else
            regions{j,1} = strcat('reg', num2str(allNumbers(i)));
        end
        i = i+1;
    end
    
    j = j+1;
    
    for m = taskNums
        if total > 9 && m < 10
            regions{j,1} = strcat('regtsk0', num2str(taskNums(m)));
        else
            regions{j,1} = strcat('regtsk', num2str(taskNums(m)));
        end
        j = j+1;
    end
    
    set(handles.tblTasks, 'Data', tasks);
    set(handles.tblRegions, 'Data', regions);
end



function txtScenario_Callback(hObject, eventdata, handles)
% hObject    handle to txtScenario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtScenario as text
%        str2double(get(hObject,'String')) returns contents of txtScenario as a double

% get the scenario num desired
scenarioNum = str2double(get(hObject, 'String'));
% get the fsm name
fsmName = get(handles.txtFsmInputFn, 'String'); % fsm file name
fsmName = fsmName(1:end-4); % remove the .fsm from the name

% if it's the first scenario it doesn't need the number in it
if scenarioNum == 1
    mfile = 'userdata.m';
    worldfile = [fsmName '.world'];
    launchfile = [fsmName '.launch'];
else % put the number in it
    mfile = ['userdata' num2str(scenarioNum) '.m'];
    worldfile = [fsmName num2str(scenarioNum) '.world'];
    launchfile = [fsmName num2str(scenarioNum) '.launch'];
end

set(handles.txtOutputFn, 'String', mfile);
set(handles.txtWorldFile, 'String', worldfile);
set(handles.txtLaunchFile, 'String', launchfile);


% --- Executes during object creation, after setting all properties.
function txtScenario_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtScenario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
