function handles = rmrepeat(xp,handles)
% This function will check to see if any marker is present at postion XP.
% If so it will remove it in preparation for a new marker placement
%

instw = find(handles.wake==xp);   %  Check if already a WAKE marker
instN = find(handles.NREM==xp);   %  Check if already an NREM marker
instR = find(handles.REM==xp);   %  Check if already a REM marker
instd = find(handles.drowse==xp);   %  Check if already a drowsing marker
instm = find(handles.none==xp);   %  Check if already a none marker
% Is there already a wake?
if ~isempty(instw)    % if so remove it
    inst = instw;
    lst = length(handles.wake);
    if inst(1) == 1  % if first point
      handles.wake = [handles.wake(inst(1)+1:length(handles.wake))];
    elseif inst == lst % if last point
      handles.wake = handles.wake(1:lst-1);
    else % if between point
      handles.wake=[handles.wake(1:(inst(1)-1)), handles.wake(inst(1)+1:lst)]; 
    end
end
% Is there already an NREM?
if ~isempty(instN)    % if so remove it
    inst = instN;
    lst = length(handles.NREM);
    if inst(1) == 1  % if first point
      handles.NREM = [handles.NREM(inst(1)+1:length(handles.NREM))];
    elseif inst == lst % if last point
      handles.NREM = handles.NREM(1:lst-1);
    else % if between point
      handles.NREM=[handles.NREM(1:(inst(1)-1)), handles.NREM(inst(1)+1:lst)]; 
    end
end
% Is there already a REM?
if ~isempty(instR)    % if so remove it
    inst = instR;
    lst = length(handles.REM);
    if inst(1) == 1  % if first point
      handles.REM = [handles.REM(inst(1)+1:length(handles.REM))];
    elseif inst == lst % if last point
      handles.REM = handles.REM(1:lst-1);
    else % if between point
      handles.REM=[handles.REM(1:(inst(1)-1)), handles.REM(inst(1)+1:lst)]; 
    end
end
% Is there already a drowse?
if ~isempty(instd)    % if so remove it
    inst = instd;
    lst = length(handles.drowse);
    if inst(1) == 1  % if first point
      handles.drowse = [handles.drowse(inst(1)+1:length(handles.drowse))];
    elseif inst == lst % if last point
      handles.drowse = handles.drowse(1:lst-1);
    else % if between point
      handles.drowse=[handles.drowse(1:(inst(1)-1)), handles.drowse(inst(1)+1:lst)]; 
    end
end
% Is there already a none?
if ~isempty(instm)    % if so remove it
    inst = instm;
    lst = length(handles.none);
    if inst(1) == 1  % if first point
      handles.none = [handles.none(inst(1)+1:length(handles.none))];
    elseif inst == lst % if last point
      handles.none = handles.none(1:lst-1);
    else % if between point
      handles.none=[handles.none(1:(inst(1)-1)), handles.none(inst(1)+1:lst)]; 
    end
end

