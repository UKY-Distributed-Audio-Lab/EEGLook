function handles = updategraphs(handles, ftflag)
%
%  FTFLAG should be 1 for first time the function is called in the main
%  program to set up axes.  Subsequent calls should be 0 to maintain axes
%  proporties

xxold = get(handles.axes1,'XLim');  % get current xaxis limits for later restore
        % EEG1 (axes2)
       if length(handles.eegstring_axes2) == 1
           axes(handles.axes2)
           handles.curdiff_eeg1 = handles.S(:,handles.eegchan1);
           limeeg = 50; % 6*median(abs(handles.curdiff_eeg1));
           %subtaction: handles.S(:,1) - handles.S(:,2);
           plot(handles.tax, handles.curdiff_eeg1)
           ylabel('uV');
           axis('tight')
           set(gca,'YLim', [-limeeg(1) limeeg(1)])
           yl = [-limeeg(1) limeeg(1)];
  %         title(handles.basename(1:end-1), 'Interpreter', 'none');
  set(gca,'XTickLabel', [])
       else
           axes(handles.axes2)
           %subtaction: handles.S(:,index1) - handles.S(:,index2);
           %get index of eeg waves to subtract
           
           index1 = str2double(handles.eegstring_axes2(1));
           index2 = str2double(handles.eegstring_axes2(3));
           handles.curdiff_eeg1 = handles.S(:,index1) - handles.S(:,index2);  % Current difference
           limeeg = 50; %  6*median(abs(handles.curdiff_eeg1));
           %plot the subtaction
           plot(handles.tax, handles.curdiff_eeg1)
           ylabel('uV');
           axis('tight')
           set(gca,'YLim', [-limeeg(1) limeeg(1)])
           yl = [-limeeg(1) limeeg(1)];
   %        title(handles.basename(1:end-1));
   set(gca,'XTickLabel', [])
       end         
       
        % EEG2 (axes6)
       if length(handles.eegstring_axes6) == 1
           axes(handles.axes6)
           handles.curdiff_eeg2 = handles.S(:,handles.eegchan2);
           limeeg = 50; % 6*median(abs(handles.curdiff_eeg2));
           %subtaction: handles.S(:,1) - handles.S(:,2);
           plot(handles.tax, handles.curdiff_eeg2)
           ylabel('uV');
           axis('tight')
           set(gca,'YLim', [-limeeg(1) limeeg(1)])
           yl = [-limeeg(1) limeeg(1)];
    %       title(handles.basename(1:end-1), 'Interpreter', 'none');
    set(gca,'XTickLabel', [])
       else
           axes(handles.axes6)
           %subtaction: handles.S(:,index1) - handles.S(:,index2);
           %get index of eeg waves to subtract
           
           index1 = str2double(handles.eegstring_axes6(1));
           index2 = str2double(handles.eegstring_axes6(3));
           handles.curdiff_eeg2 = handles.S(:,index1) - handles.S(:,index2);  % Current difference
           limeeg = 50; %  6*median(abs(handles.curdiff_eeg2));
           %plot the subtaction
           plot(handles.tax, handles.curdiff_eeg2)
           ylabel('uV');
           axis('tight')
           set(gca,'YLim', [-limeeg(1) limeeg(1)])
           yl = [-limeeg(1) limeeg(1)];
     %      title(handles.basename(1:end-1));
     set(gca,'XTickLabel', [])
       end
           
%         if handles.TwoSecondTickEnabled
%             %reset two second interval on graph
%             axes(handles.axes2);
%             limitsHours = get(handles.axes2,'xLim');
%             limitsSecs = limitsHours * 3600;
%             
%             newIntervalLength = limitsSecs(2) - limitsSecs(1);
%             newTickMarkers = zeros(1,int8(newIntervalLength / 2));
%             newTickMarkers(1) = limitsHours(1);
%             
%             if limitsSecs(2) - limitsSecs(1) <= 60
%               for i = 2:int8(newIntervalLength/2)
%                   %add continually add two, then convert to hours
%                   newTickMarkers(i) = (newTickMarkers(i - 1) + .00055);
%               end
%               set(handles.axes2, 'xTick', newTickMarkers);
%               handles.TwoSecondTickEnabled = true;
%               grid on;
%             end
%         end
        
%         if handles.paddedwindow && ~ftflag
%             %refresh the tick markers if the user has selected the 60 second mode
%             zoom off
%             handles.GraphicWindowLength = 60;
%             axes(handles.axes2);
%             set(handles.axes2,'XLim', [handles.gpts(1), handles.gpts(1) + handles.GraphicWindowLength/(60^2)]);
% 
%             axes(handles.axes2);
%             handles.line1 = vline(handles.gpts(1) + .00416,'r');
%             handles.line2 = vline(handles.gpts(2) - .00416,'r');
% 
%             axes(handles.axes6);
%             handles.line3 = vline(handles.gpts(1) + .00416,'r');
%             handles.line4 = vline(handles.gpts(2) - .00416,'r');
%         end
       
        %only update markers if forward or backward
       %update everyething on channel change
       axes(handles.axes2);
       if isfield(handles,'wake')
           for ki=1:length(handles.wake)
               handles.h2(ki) =animatedline([handles.wake(ki); handles.wake(ki)],yl,'Color','g','LineStyle',':','LineWidth',4);
               set(handles.h2(ki),'Visible','on');
           end
       end
       
       if isfield(handles,'NREM')
           for ki=1:length(handles.NREM)
               handles.h1(ki) =animatedline([handles.NREM(ki); handles.NREM(ki)],yl,'Color','k','LineStyle',':','LineWidth',4);
               set(handles.h1(ki),'Visible','on');
           end
       end
       
       if isfield(handles,'REM')
           for ki=1:length(handles.REM)
               handles.h0(ki) =animatedline([handles.REM(ki); handles.REM(ki)],yl,'Color','m','LineStyle',':','LineWidth',4);
               set(handles.h0(ki),'Visible','on');
           end
       end
       
        if isfield(handles,'drowse')
           for ki=1:length(handles.drowse)
               handles.h3(ki) =animatedline([handles.drowse(ki); handles.drowse(ki)],yl,'Color','c','LineStyle',':','LineWidth',4);
               set(handles.h3(ki),'Visible','on');
           end
        end
       
        
        if isfield(handles,'none')
           for ki=1:length(handles.none)
               handles.h4(ki) =animatedline([handles.none(ki); handles.none(ki)],yl,'Color','y','LineStyle',':','LineWidth',4);
               set(handles.h4(ki),'Visible','on');
           end
       end
       
       
       cwin = hamming(5)*hamming(17)';  %  Smoothing window
       nm = sum(sum(cwin));
       cwin = cwin/nm;%h
       
       % Spectrogram
       %handles.gpts has current xlimits
       %handles.change_channel triggers on channel dropdown boxes
       if handles.change_channel || (ftflag == 1)
           fs = handles.fs;
           swin = handles.specwin;
           [spec, fax, tsax] = spectrogram(handles.curdiff_eeg1,hamming(swin*fs),round(swin*fs/2),2*swin*fs,fs);
           spec = conv2(spec,cwin,'same');
           axes(handles.axes1);
           dbspec = 10*log10(abs(spec/fs).^2/(swin));
           uplim = 0; %median(max(dbspec));     
           imagesc(handles.tax(1)+tsax/60^2,fax,dbspec, [uplim-40,uplim]); axis('xy'); xlabel('Hours'); colorbar
         %  imagesc(handles.tax(1)+tsax/60^2,fax,dbspec); axis('xy'); xlabel('Hours'); colorbar 
           colormap('jet')
           set(gca,'YLim',[0 30])
           ylabel('Hz');
           handles.change_channel = false;
           title(handles.f(1:end-4), 'Interpreter', 'none');
       end
       
       % Plot EMG
       axes(handles.axes4)     
       plot(handles.taxemg, handles.emgs(:,handles.emgchan))
       limemg = .5; %  3*median(abs(handles.emgs(:,handles.emgchan)));
       axis('tight')
       set(gca,'YLim', [-limemg(1) limemg(1)])
       ylabel('mV');
       

       linkaxes([handles.axes1, handles.axes2, handles.axes4, handles.axes6],'x');
       linkaxes([handles.axes2,handles.axes6],'y');
%        if handles.paddedwindow && ~ftflag
%            axes(handles.axes2);
%            set(handles.axes2,'XLim', [handles.gpts(1), handles.gpts(1) + handles.GraphicWindowLength/(60^2)]);
%        elseif ftflag ~= 1
%            set(handles.axes1,'XLim', xxold);
%        end
       
       %check for bad y axis limits on eeg ( > 60 uV )
       eegLim = get(handles.axes2,'YLim');
       if eegLim(1) < -100
           axes(handles.axes2);
           ylim([-50 50]);
       end
       
       if ~ftflag && ~handles.reset_view_button
            set(handles.axes2,'XLim',xxold);
       end
       handles.reset_view_button = false;