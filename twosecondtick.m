function handles = twosecondtick(handles)
if handles.TwoSecondTickEnabled
    %reset two second interval on graph
    axes(handles.axes2);
    limitsHours = get(handles.axes2,'xLim');
    limitsSecs = limitsHours * 3600;

    newIntervalLength = limitsSecs(2) - limitsSecs(1);
    newTickMarkers = zeros(1,int8(newIntervalLength / 2));
    newTickMarkers(1) = limitsHours(1);

    if limitsSecs(2) - limitsSecs(1) <= 60
      for i = 2:int8(newIntervalLength/2)
          %add continually add two, then convert to hours
          newTickMarkers(i) = (newTickMarkers(i - 1) + .00055);
      end
      set(handles.axes2, 'xTick', newTickMarkers);
      handles.TwoSecondTickEnabled = true;
      grid on;
    end
end