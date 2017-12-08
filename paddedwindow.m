function handles = paddedwindow(handles)
if handles.paddedwindow
    %refresh the tick markers if the user has selected the 60 second mode
    zoom off
    handles.GraphicWindowLength = 60;
    axes(handles.axes2);
    handles.gpts(2) = handles.gpts(1) + handles.GraphicWindowLength/(60^2);
    set(handles.axes2,'XLim', handles.gpts);

    axes(handles.axes2);
    handles.line1 = vline(handles.gpts(1) + .00416,'r');
    handles.line2 = vline(handles.gpts(2) - .00416,'r');

    axes(handles.axes6);
    handles.line3 = vline(handles.gpts(1) + .00416,'r');
    handles.line4 = vline(handles.gpts(2) - .00416,'r');
end