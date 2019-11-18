% Obligatorisk  programmering i MATLAB 
function geodata
    % SIMPLE_GUI2 Select a data set from the pop-up menu and display
     f = figure('Position',[50,300,700,400]);
     h = [];
% 'Position'
    h(1) = axes('Units','pixels','Position',[100,30,350,350]);
    % Construct the components.
    h(2) = uicontrol('Style','popupmenu',...
               'String',{'Peaks','Membrane','Sinc', 'point'},...
               'Position',[600,20,100,25],...
               'Callback',@popup_menu_Callback);      
    set(h, 'Units', 'normalized'); 
    
   % button for rotation, 5 degrees
    h(3) = uicontrol('String', 'Rotate', ...
        'Position', [600, 50, 100, 25],...
        'Callback', @button_rotate_Callback);
    
    % butten for plan view:
    h(4) = uicontrol('String', 'Plan view', ...
        'Position', [600, 80, 100, 25],...
        'Callback', @button_above_Callback);
    
    % button: view image from x to z perspective:
    h(5) = uicontrol('String', 'Sideview 1', ...
        'Position', [600, 140, 100, 25],...
        'Callback', @button_side1_Callback);
    
    h(6) = uicontrol('String', 'Sideview 2', ...
        'Position', [600, 110, 100, 25],...
        'Callback', @button_side2_Callback);
    
    %shows orginal
    h(7) = uicontrol('String', 'Original', ...
        'Position', [600, 230, 100, 25], ...
        'Callback', @button_original_Callback);
  
    % timer 
    h(8) = uicontrol('Style', 'text',...
        'Unit', 'pix', ...
        'Position', [600, 260, 100, 25], ...
        'String', 'Time: 00');
    
    % start&stop buttons for timer
    h(9) = uicontrol('String', 'Start Time',...
        'Position', [600, 200, 100, 25], ...
        'Callback', @button_timerStart);
    
    h(10) = uicontrol('String', 'Stop Time', ...
        'Position', [600, 170, 100, 25],...
        'Callback', @button_timerStop);
        
    
    % Assure resize automatically.
    f.Units = 'normalized';
    set(h, 'Units', 'normalized');
    set(h, 'FontSize', 12);

    % Generate the data to plot.
    peaks_data = peaks(35);
    colormap(spring);
    shading interp;
    membrane_data = membrane;
    [x,y] = meshgrid(-8:.5:8);
    r = sqrt(x.^2+y.^2) + eps;
    sinc_data= sin(r)./r;
    point_data=2*exp(-abs(x)-abs(y));
  
   

    
    % Create a plot in the axes.
    current_data = peaks_data;
    s = surf(current_data);
   
    function button_rotate_Callback(source, eventdata)
        rotate(s, [0 0 1], 5);
    end
    
    function button_above_Callback(source, eventdata)
        view(2);
    end

    function button_side1_Callback(source, eventdata)
        view(90, 0);
    end

    function button_side2_Callback(source, eventdata)
        view(180, 0);
    end

    function button_original_Callback(source, eventdata)
        view(3);
    end
    
    % seconds atm
    START = 60 - str2double(datestr(now, 'ss'));
    % making timer element
    tmr = timer('Name', 'Reminder', ...
        'Period', 1, ...%'StartDelay', START, ...
        'TasksToExecute', inf,...
        'ExecutionMode', 'fixedSpacing', ...
        'TimerFcn', {@oppdater});
    
    curr_time = 0;
    
    function button_timerStart(source, eventdata)
        set (h(8), 'String', 'Time: 00');
        start(tmr);
    end

    function button_timerStop(source, eventdata)
        stop(tmr);
        delete(tmr);
    end
    
    function oppdater(varargin)
        curr_time = curr_time + 1;
        curr_str  = "Time: " + curr_time;
        set(h(8), 'String', curr_str);
        %button_rotate_Callback();
        if mod(curr_time, 60) == 0
            X = load('handel.mat');
            sound(X.y, X.Fs*2.5);
            clear X;
        end
    end

   %  Pop-up menu callback. Read the pop-up menu Value property to
   function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val}
      case 'Peaks' % User selects Peaks.
         current_data = peaks_data;
      case 'Membrane' 
         current_data = membrane_data;
      case 'Sinc' 
         current_data = sinc_data;
      case 'point'
         current_data = point_data;
      end    
      surf(current_data);
      
   end
end

