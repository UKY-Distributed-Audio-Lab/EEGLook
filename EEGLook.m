function varargout = EEGLook(varargin)
% EEGLOOK MATLAB code for EEGLook.fig
%      EEGLOOK, by itself, creates a new EEGLOOK or raises the existing
%      singleton*.
%
%      H = EEGLOOK returns the handle to a new EEGLOOK or the handle to
%      the existing singleton*.
%
%      EEGLOOK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EEGLOOK.M with the given input arguments.
%
%      EEGLOOK('Property','Value',...) creates a new EEGLOOK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EEGLook_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EEGLook_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EEGLook

% Last Modified by GUIDE v2.5 06-Sep-2017 10:47:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EEGLook_OpeningFcn, ...
                   'gui_OutputFcn',  @EEGLook_OutputFcn, ...
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


% --- Executes just before EEGLook is made visible.
function EEGLook_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EEGLook (see VARARGIN)

% Choose default command line output for EEGLook
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EEGLook wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EEGLook_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
% This function prompts for new file and initalizes arrays

function OpenFile_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If previous file was opened, remove relevant fields from structure
if isfield(handles,'wake')
  handles = rmfield(handles,'wake');
  handles = rmfield(handles,'REM');
  handles = rmfield(handles,'NREM');
  handles = rmfield(handles,'drowse');
  handles = rmfield(handles,'none');
end

%  Default fixed graphic window length
handles.GraphicWindowLength = 30; % in seconds

% Prompt for file name
if ~isfield(handles,'p')
   [handles.f,handles.p] = uigetfile('*.mat');
else
   [handles.f,handles.p] = uigetfile([handles.p, '\*.mat']);
end
% If menu not canceled get information about the file
if ~isempty(handles.f)
    inx = find(handles.f == '_');  % End of base name
    inp = find(handles.f == '.');  % end of base name plus index
    if ~isempty(inx)
        % Open up file process and plot for first time
       handles.specwin = 4;  % Spectral window in seconds
       % Initalize Channels to display first
       handles.eegchan1 = 1;
       handles.eegchan2 = 2;
       handles.eegstring_axes2 = '1';
       handles.eegstring_axes6 = '2';
       handles.emgchan = 1;
       handles.accchan = 1;
       handles.basename = handles.f(1:inx(end));
       handles.blocknum = str2double(handles.f(inx(end)+1:inp(end)-1));
       % load in new data file and append fields to struct handles
       gg = load([handles.p,handles.f]);  % Assign variables to dummy struct
       fldnames = fieldnames(gg);
       % append each vaiable to handles
       for kfld = 1:length(fldnames)
           dum = getfield(gg,fldnames{kfld});
           handles = setfield(handles,fldnames{kfld},dum);
       end
       clear('gg')
       handles.TwoSecondTickEnabled = true;
       handles.paddedwindow = false;
       
       handles.gpts = [ 0 , 0]; %used for moving forwards and backwards

       %initialize flags for keypress hotkeys
       handles.wake_key = false;
       handles.drowsing_key = false;
       handles.nrem_key = false;
       handles.rem_key = false;
       handles.nolabel_key = false;
       
       handles.change_channel = false; %track when the channel is changing
       handles.reset_view_button = false;

       % If vigilance markers not present initialize empty arrays
       if ~isfield(handles,'wake')
           % Initalize marker points files
           handles.wake = [];
           handles.NREM = [];
           handles.REM = [];
           handles.drowse = [];
           handles.none = [];
       end
       handles = updategraphs(handles,1);

    else
        errordlg(['File ' handles.f ' is not named in expected format.'], 'File not opened')
    end


else
        errordlg(['File ' handles.p handles.f ' not found'], 'File not opened')
end

% Update handles structure
guidata(hObject, handles);


% For Selecting EEG Channel (axes2)
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

contents = cellstr(get(hObject,'String'));
dum = contents{get(hObject,'Value')};
handles.eegchan1 = str2double(dum);
handles.eegstring_axes2 = dum;
% Update handles structure

handles.change_channel = true;
handles = updategraphs(handles,0);        %update the graph
guidata(hObject, handles);

% For Selecting EEG Channel
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % For Selecting Accelerometer Channel
% % --- Executes during object creation, after setting all properties.
% function popupmenu2_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
%
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --------------------------------------------------------------------
function Quit_Callback(hObject, eventdata, handles)
% hObject    handle to Quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

btt = questdlg('Do you want to quit (did you save markers)?', 'Checking', 'Go Back', 'Quit', 'Go Back');
if btt(1) == 'Q'
delete(handles.output)
end

%  Set EMG plots
% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
contents = cellstr(get(hObject,'String'));
dum = contents{get(hObject,'Value')};
handles.emgchan = str2double(dum);
% Update handles structure
handles = updategraphs(handles,0);
guidata(hObject, handles);



% Set EMG plots
% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% % Button to advance to open next get
% % --------------------------------------------------------------------
% function GetNextBlock_Callback(hObject, eventdata, handles)
% % hObject    handle to GetNextBlock (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% if isfield(handles,'in')
%   handles = rmfield(handles,'in');
% end
%
% handles.blocknum = handles.blocknum+1;
% handles.f = [handles.basename num2str(handles.blocknum) '.mat'];
% if exist([handles.p handles.f],'file')
%         % Open up file process and plot for first time
%        handles = load([handles.p,handles.f]);
%        handles = updategraphs(handles,1);
%     else
%         errordlg(['File ' [handles.p handles.f] ' does not exist.'], 'File not opened')
% end
% % Update handles structure
% guidata(hObject, handles);
%
% %  Button to advance to open previous get
% % --------------------------------------------------------------------
% function GetPreviousBlock_Callback(hObject, eventdata, handles)
% % hObject    handle to GetPreviousBlock (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% if isfield(handles,'in')
%   handles = rmfield(handles,'in');
% end
%
% handles.blocknum = handles.blocknum-1;
% handles.f = [handles.basename num2str(handles.blocknum) '.mat'];
% if exist([handles.p handles.f],'file')
%         % Open up file process and plot for first time
%        handles = load([handles.p,handles.f]);
%        handles = updategraphs(handles,1);
%     else
%         errordlg(['File ' [handles.p handles.f] ' does not exist.'], 'File not opened')
% end
% % Update handles structure
% guidata(hObject, handles);
%

% --- Hot Key press
function handles = WakeMark(handles)
% hObject    handle to WakeMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    xlimits = get(handles.axes2,'XLim'); %.00416
    xp = xlimits(1) + .00416;
    handles.wake_key = false;
% If previous marker there in any other category, remove it
handles = rmrepeat(xp,handles);
% Assign new point to array

%if ((yp > handles.ym(1)) && (yp < handles.ym(2)))
      % newmark = animatedline([xp; xp],handles.ymi(:,1),'Color','g','LineStyle',':','LineWidth',handles.thinline);
       inst = find(handles.wake>=xp);   %  Find point in WAKE greater than or equal to selelcted point
       if isempty(inst)
           handles.wake = [handles.wake xp];  %  Stuff it in marker array
       else
           handles.wake = [handles.wake(1:inst(1)-1), xp, handles.wake(inst(1):length(handles.wake))];  %  Stuff it in marker array
       end
       if isfield(handles,'h2')
       delete(handles.h2)
       end
       axes(handles.axes2);
       yl = ylim;
       for ki=1:length(handles.wake)
           handles.h2(ki) =animatedline([handles.wake(ki); handles.wake(ki)],yl,'Color','g','LineStyle',':','LineWidth',4);
           set(handles.h2(ki),'Visible','on');
       end


% --- Executes on button press in NREMMark.
function handles = NREMMark(handles)
% hObject    handle to NREMMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off
if handles.nrem_key && handles.paddedwindow
    xlimits = get(handles.axes2,'XLim'); %.00416
    xp = xlimits(1) + .00416;
    handles.nrem_key = false;
else
    [xp,yp] = ginput(1);
end
% If previous marker there in any other category, remove it
handles = rmrepeat(xp,handles);
% Assign new point to array

%if ((yp > handles.ym(1)) && (yp < handles.ym(2)))
      % newmark = animatedline([xp; xp],handles.ymi(:,1),'Color','g','LineStyle',':','LineWidth',handles.thinline);
       inst = find(handles.NREM>=xp);   %  Find point in WAKE greater than or equal to selelcted point
       if isempty(inst)
           handles.NREM = [handles.NREM xp];  %  Stuff it in marker array
       else
           handles.NREM = [handles.NREM(1:inst(1)-1), xp, handles.NREM(inst(1):length(handles.NREM))];  %  Stuff it in marker array
       end
       if isfield(handles,'h1')
       delete(handles.h1)
       end
       axes(handles.axes2);
       yl = ylim;
       for ki=1:length(handles.NREM)
           handles.h1(ki) =animatedline([handles.NREM(ki); handles.NREM(ki)],yl,'Color','k','LineStyle',':','LineWidth',4);
           set(handles.h1(ki),'Visible','on');
       end




% --- Executes on button press in REMMark.
function handles = REMMark(handles)
% hObject    handle to REMMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off
if handles.rem_key && handles.paddedwindow
    xlimits = get(handles.axes2,'XLim'); %.00416
    xp = xlimits(1) + .00416;
    handles.rem_key = false;
else
    [xp,yp] = ginput(1);
end
% If previous marker there in any other category, remove it
handles = rmrepeat(xp,handles);
% Assign new point to array

%if ((yp > handles.ym(1)) && (yp < handles.ym(2)))
      % newmark = animatedline([xp; xp],handles.ymi(:,1),'Color','g','LineStyle',':','LineWidth',handles.thinline);
       inst = find(handles.REM>=xp);   %  Find point in WAKE greater than or equal to selelcted point
       if isempty(inst)
           handles.REM = [handles.REM xp];  %  Stuff it in marker array
       else
           handles.REM = [handles.REM(1:inst(1)-1), xp, handles.REM(inst(1):length(handles.REM))];  %  Stuff it in marker array
       end
       if isfield(handles,'h0')
       delete(handles.h0)
       end
       axes(handles.axes2);
       yl = ylim;
       for ki=1:length(handles.REM)
           handles.h0(ki) =animatedline([handles.REM(ki); handles.REM(ki)],yl,'Color','m','LineStyle',':','LineWidth',4);
           set(handles.h0(ki),'Visible','on');
       end

% --- Executes on button press in DrowsingMark.
function handles = DrowsingMark(handles)
% hObject    handle to DrowsingMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    xlimits = get(handles.axes2,'XLim'); %.00416
    xp = xlimits(1) + .00416;
    handles.drowsing_key = false;
% If previous marker there in any other category, remove it
handles = rmrepeat(xp,handles);
% Assign new point to array
   inst = find(handles.drowse>=xp);   %  Find point in WAKE greater than or equal to selelcted point
   if isempty(inst)
       handles.drowse = [handles.drowse xp];  %  Stuff it in marker array
   else
       handles.drowse = [handles.drowse(1:inst(1)-1), xp, handles.drowse(inst(1):length(handles.drowse))];  %  Stuff it in marker array
   end
   if isfield(handles,'h3')
   delete(handles.h3)
   end
   axes(handles.axes2);
   yl = ylim;
   for ki=1:length(handles.drowse)
       handles.h3(ki) =animatedline([handles.drowse(ki); handles.drowse(ki)],yl,'Color','c','LineStyle',':','LineWidth',4);
       set(handles.h3(ki),'Visible','on');
   end   



% --- Executes on button press in NotLabeledMark.
function handles = NotLabeledMark(handles)
% hObject    handle to NotLabeledMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    xlimits = get(handles.axes2,'XLim'); %.00416
    xp = xlimits(1) + .00416;
    handles.drowsing_key = false;
% If previous marker there in any other category, remove it
handles = rmrepeat(xp,handles);
% Assign new point to array
   inst = find(handles.none>=xp);   %  Find point in WAKE greater than or equal to selelcted point
   if isempty(inst)
       handles.none = [handles.none xp];  %  Stuff it in marker array
   else
       handles.none = [handles.none(1:inst(1)-1), xp, handles.none(inst(1):length(handles.none))];  %  Stuff it in marker array
   end
   if isfield(handles,'h4')
   delete(handles.h4)
   end
   axes(handles.axes2);
   yl = ylim;
   for ki=1:length(handles.none)
       handles.h4(ki) =animatedline([handles.none(ki); handles.none(ki)],yl,'Color','y','LineStyle',':','LineWidth',4);
       set(handles.h4(ki),'Visible','on');
   end


% --- Executes on button press in DeleteMark.
function DeleteMark_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


zoom off
[xp,yp] = ginput(1);
% handles.backupex = handles.ex;
% handles.backupin = handles;
%guidata(hObject, handles);
      if ~isempty(handles.wake)
     [ma(1) ia(1)] = min(abs(xp-handles.wake));  %Find inhale point with minimum distance from selected point
      else
          ma(1) = NaN;
          ai(1) = NaN;
      end
      if ~isempty(handles.NREM)
     [ma(2), ia(2)] = min(abs(xp-handles.NREM));  %Find exhale point with minimum distance from selected point
     else
          ma(2) = NaN;
          ai(2) = NaN;
      end
      if ~isempty(handles.REM)
     [ma(3), ia(3)] = min(abs(xp-handles.REM));  %Find exhale point with minimum distance from selected point
     else
          ma(3) = NaN;
          ai(3) = NaN;
      end
      if ~isempty(handles.drowse)
     [ma(4), ia(4)] = min(abs(xp-handles.drowse));  %Find exhale point with minimum distance from selected point
     else
          ma(4) = NaN;
          ai(4) = NaN;
      end
      if ~isempty(handles.none)
     [ma(5), ia(5)] = min(abs(xp-handles.none));  %Find exhale point with minimum distance from selected point
     else
          ma(5) = NaN;
          ai(5) = NaN;
      end
     [me5, ime5] = min(ma);
     % If nearest point was an wake, modify wake array
      if ime5(1) == 1
            clearpoints(handles.h2(ia(1)));
            delete(handles.h2(ia(1)));
            if ia(1) < length(handles.wake)
                handles.wake = [handles.wake(1:ia(1)-1) handles.wake(ia(1)+1:length(handles.wake))];
                handles.h2 = [handles.h2(1:ia(1)-1), handles.h2(ia(1)+1:length(handles.h2))];
                guidata(hObject, handles);
            else
                handles.wake = [handles.wake(1:ia(1)-1)];
                handles.h2 = [handles.h2(1:ia(1)-1)];

                guidata(hObject, handles);
            end


      elseif ime5 == 2
            clearpoints(handles.h1(ia(2)));
            delete(handles.h1(ia(2)));
            if ia(2) < length(handles.NREM)
                handles.NREM = [handles.NREM(1:ia(2)-1) handles.NREM(ia(2)+1:length(handles.NREM))];
                handles.h1 = [handles.h1(1:ia(2)-1), handles.h1(ia(2)+1:length(handles.h1))];
                guidata(hObject, handles);
            else
                handles.NREM = [handles.NREM(1:ia(2)-1)];
                handles.h1 = [handles.h1(1:ia(2)-1)];

                guidata(hObject, handles);
            end

      elseif ime5 == 3
            clearpoints(handles.h0(ia(3)));
            delete(handles.h0(ia(3)));
            if ia(3) < length(handles.REM)
                handles.REM = [handles.REM(1:ia(3)-1) handles.REM(ia(3)+1:length(handles.REM))];
                handles.h0 = [handles.h0(1:ia(3)-1), handles.h0(ia(3)+1:length(handles.h0))];
                guidata(hObject, handles);
            else
                handles.REM = [handles.REM(1:ia(3)-1)];
                handles.h0 = [handles.h0(1:ia(3)-1)];

                guidata(hObject, handles);
            end

     elseif ime5 == 4
            clearpoints(handles.h3(ia(4)));
            delete(handles.h3(ia(4)));
            if ia(4) < length(handles.drowse)
                handles.drowse = [handles.drowse(1:ia(4)-1) handles.drowse(ia(4)+1:length(handles.drowse))];
                handles.h3 = [handles.h3(1:ia(4)-1), handles.h3(ia(4)+1:length(handles.h3))];
                guidata(hObject, handles);
            else
                handles.drowse = [handles.drowse(1:ia(4)-1)];
                handles.h3 = [handles.h3(1:ia(4)-1)];
                guidata(hObject, handles);
            end

     elseif ime5 == 5
            clearpoints(handles.h4(ia(5)));
            delete(handles.h4(ia(5)));
            if ia(4) < length(handles.none)
                handles.none = [handles.none(1:ia(5)-1) handles.none(ia(5)+1:length(handles.none))];
                handles.h4 = [handles.h4(1:ia(5)-1), handles.h4(ia(5)+1:length(handles.h4))];
                guidata(hObject, handles);
            else
                handles.none = [handles.none(1:ia(5)-1)];
                handles.h4 = [handles.h4(1:ia(5)-1)];
                guidata(hObject, handles);
            end



      end


guidata(hObject, handles);

% % --- Executes on button press in Forward.
% function Forward_Callback(hObject, eventdata, handles)
% % hObject    handle to Forward (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes2)
% gpts = get(handles.axes2,'XLim');
% len = (gpts(2)-gpts(1));
% adv = len*0.75;
% set(handles.axes2,'XLim', [gpts(1)+adv, gpts(2) + adv])
% if handles.TwoSecondTickEnabled
%     %reset two second interval on graph
%     handles = setTwoSecIntervals(handles);
% end
% guidata(hObject, handles);

% --------------------------------------------------------------------
function SetGraphicWindow_Callback(hObject, eventdata, handles)
% hObject    handle to SetGraphicWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pmt = {'Window View in Seconds:'};
%def = {num2str(handles.GraphicWindowLength)};  %  Use most recently defined values of ps

%  Display dialog box for paramter inputs (PSD segmentation points and power level adjustment
def = {'30'};
answ = inputdlg(pmt,'Set Window Length',1,def,'on');
if ~isempty(answ)
    handles.GraphicWindowLength = str2num(answ{1});
end
zoom off
axes(handles.axes2)
gpts = get(handles.axes2,'XLim');
set(handles.axes2,'XLim', [gpts(1), gpts(1) + handles.GraphicWindowLength/(60^2)])
handles.paddedwindow = false;    %keep track of the view selection
guidata(hObject, handles);



% --- Executes on button press in Backward.
function Backward_Callback(hObject, eventdata, handles)
% hObject    handle to Backward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes2)
handles.gpts = get(handles.axes2,'XLim');
len = (handles.gpts(2)-handles.gpts(1));
if ~handles.paddedwindow
    adv = len*0.75;
else
    adv = len*0.5;
end
handles.gpts(1) = handles.gpts(1) - adv;
handles.gpts(2) = handles.gpts(2) - adv;
set(handles.axes2,'XLim', [handles.gpts(1),handles.gpts(2)])

%handles = updategraphs(handles,0);
handles = twosecondtick(handles);
handles = paddedwindow(handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function SaveStateMarkers_Callback(hObject, eventdata, handles)
% hObject    handle to SaveStateMarkers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'wake')
    wake = handles.wake;
    NREM = handles.NREM;
    REM = handles.REM;
    drowse = handles.drowse;
    none = handles.none;
    save([handles.p, handles.f], 'wake','NREM','REM', 'drowse', 'none', '-append')
    msgbox(['File ' handles.f ' updated'], 'Vigilance state vector saved')
else
     errordlg(['File ' handles.f ' not updated'], 'Vigilance state vector not found')
end
guidata(hObject, handles);


% --- Executes on button press in Zoom1.
function Zoom1_Callback(hObject, eventdata, handles)
% hObject    handle to Zoom1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%remove lines from the padded window function if the user chooses to zoom,
%and if the padded function is enabled.
handles.paddedwindow = false;
zstate = get(handles.Zoom1,'Value');
if zstate == 1
    zoom off
 %   set(handles.Zoom1, 'Value', 0)
else
    zoom on
%    set(handles.Zoom1, 'Value', 1)
end



% --- Executes on button press in PanToggle.
function PanToggle_Callback(hObject, eventdata, handles)
% hObject    handle to PanToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%if padded window is enabled, remove the lines already drawn in the graph,
%because they are confusing when the user pans to either direction.
handles.paddedwindow = false;

panstate = get(handles.PanToggle,'Value');
if panstate == 1
    pan on
else
    pan off
end


% --------------------------------------------------------------------
function BigView_Callback(hObject, eventdata, handles)
% hObject    handle to BigView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


graphchoice = menu('Select Data type to display', 'EEG', 'Spectrogram', 'EMG');
figure

%switch to handle the different 'bigview' selections from the user
switch graphchoice

    %working
    case 1   % If EEG was selected
        plot(handles.tax, handles.curdiff_eeg1)
        ylabel('uV')
        xlabel('Hours')
        axis('tight')
        %title(handles.basename(1:end-1));

    %TODO not working, there is no plot() statment here?
    case 2  % If spectrogram was selected
       fs = handles.fs;
       cwin = hamming(5)*hamming(17)';  %  Smoothing window
       nm = sum(sum(cwin));
       cwin = cwin/nm;
       swin = handles.specwin;
       [spec, fax, tsax] = spectrogram(handles.curdiff_eeg1,hamming(swin*fs),round(swin*fs/2),2*swin*fs,fs);
       spec = conv2(spec,cwin,'same');
       dbspec = 10*log10(abs(spec/fs).^2/(swin));
       %dbspec = 20*log10(abs(spec));
       uplim = 0;
       %this is where the matlab graphs the spectrogram, is this the
       %problem?
      imagesc(handles.tax(1)+tsax/60^2,fax,dbspec, [uplim-40,uplim]); axis('xy'); xlabel('Hours'); colorbar
     %  imagesc(handles.tax(1)+tsax/60^2,fax,dbspec); axis('xy'); xlabel('Hours'); colorbar
      colormap('jet')
       set(gca,'YLim',[0 30])
       ylabel('Hz')
       xlabel('Hours')
    %
    case 3  % If EMG was selected
       plot(handles.taxemg, handles.emgs(:,handles.emgchan))
       ylabel('mV')
       xlabel('Hours')
       axis('tight')

    %
    case 4  % if EOG data was selected
       plot(handles.tax, handles.S(:,5)/1000)
       ylabel('mV')
       xlabel('Hours')
       axis('tight')
end
%set(gcf,'Position',[-1804         648         955         316]);
guidata(hObject, handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.TwoSecondTickEnabled = true;
%handles = setTwoSecIntervals(handles);
guidata(hObject, handles);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
set(handles.axes2,'xTickMode', 'auto');
handles.TwoSecondTickEnabled = false;
guidata(hObject, handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
grid;

% --- Executes on button press in forward1.
function forward1_Callback(hObject, eventdata, handles)
% hObject    handle to forward1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2)
handles.gpts = get(handles.axes2,'XLim');
len = (handles.gpts(2) - handles.gpts(1));
if ~handles.paddedwindow
    adv = len*0.75;
else
    adv = len*0.5;
end
handles.gpts(1) = handles.gpts(1) + adv;
handles.gpts(2) = handles.gpts(2) + adv;
set(handles.axes2,'XLim', [handles.gpts(1),handles.gpts(2)])

%handles = updategraphs(handles,0);
handles = twosecondtick(handles);
handles = paddedwindow(handles);

guidata(hObject, handles);


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
dum = contents{get(hObject,'Value')};
handles.eegchan2 = str2double(dum);
handles.eegstring_axes6 = dum;
% Update handles structure

handles.change_channel = true;
handles = updategraphs(handles,0);        %update the graph
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on figure1 or any of its controls
function figure1_WindowKeyPressFcn(hObject , eventdata , handles)
keypressed = get(gcf,'currentkey');
switch keypressed
    case 'leftarrow'
        axes(handles.axes2)
        handles.gpts = get(handles.axes2,'XLim');
        len = (handles.gpts(2)-handles.gpts(1));
        adv = len*0.5;
        handles.gpts(1) = handles.gpts(1) - adv;
        handles.gpts(2) = handles.gpts(2) - adv;
        set(handles.axes2,'XLim', [handles.gpts(1),handles.gpts(2)])
        handles = twosecondtick(handles);
        handles = paddedwindow(handles);
        guidata(hObject,handles);
    case 'rightarrow'
        axes(handles.axes2)
        handles.gpts = get(handles.axes2,'XLim');
        len = (handles.gpts(2) - handles.gpts(1));
        adv = len*0.5;
        handles.gpts(1) = handles.gpts(1) + adv;
        handles.gpts(2) = handles.gpts(2) + adv;
        set(handles.axes2,'XLim', [handles.gpts(1),handles.gpts(2)])
        handles = twosecondtick(handles);
        handles = paddedwindow(handles);
        guidata(hObject,handles);
    case 'd'
        handles.drowsing_key = true;
        
        handles = DrowsingMark(handles);
    case 'a'
        handles.wake_key = true;
        handles = WakeMark(handles);
    case 'r'
        handles.rem_key = true;
        handles = REMMark(handles);
    case 's'
        handles.nrem_key = true;
        handles = NREMMark(handles);
    case 'f'
        handles.nolabel_key = true;
        handles = NotLabeledMark(handles);
end
guidata(hObject,handles);



% --------------------------------------------------------------------
function Sixty_second_button_Callback(hObject, eventdata, handles)
% hObject    handle to Sixty_second_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.paddedwindow = true;
handles.gpts = get(handles.axes2,'XLim');
% handles = updategraphs(handles,0);
n = floor((handles.gpts(1)-handles.tax(1))/(30/60^2));
if n < 1;
    handles.gpts(1) = handles.tax(1);
else
    handles.gpts(1) = handles.tax(1)+ n*30/60^2; % - .00416;
end
handles = twosecondtick(handles);
handles = paddedwindow(handles);
axes(handles.axes2)
guidata(hObject, handles);


% --- Executes on button press in resetView.
function resetView_Callback(hObject, eventdata, handles)
% hObject    handle to resetView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.paddedwindow = false;
handles.reset_view_button = true;
handles = updategraphs(handles,0);
guidata(hObject, handles);


% --- Executes on button press in delete_all_markers_button.
function delete_all_markers_button_Callback(hObject, eventdata, handles)
% hObject    handle to delete_all_markers_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = questdlg('Are you sure you want to delete ALL markers?',...
    'Warning!','Cancel','Delete All','Cancel');
if strcmp(answer,'Delete All')
    handles.wake = [];
    handles.NREM = [];
    handles.REM = [];
    handles.drowse = [];
    handles.none = [];
    
    if isfield(handles,'h0')
        for i = 1:length(handles.h0)
            handles.h0(i).delete;
        end
    end
    
    if isfield(handles,'h1')
        for i = 1:length(handles.h1)
            handles.h1(i).delete;
        end
    end
    
    if isfield(handles,'h2')
        for i = 1:length(handles.h2)
            handles.h2(i).delete;
        end
    end
    
    if isfield(handles,'h3')
        for i = 1:length(handles.h3)
            handles.h3(i).delete;
        end
    end
    
    if isfield(handles,'h4')
        for i = 1:length(handles.h4)
            handles.h4(i).delete;
        end
    end
end
guidata(hObject,handles);
