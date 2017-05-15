 function MAIN( )
 %% MAIN Main code for the LaserDAQ
 % This is the main file to run the Laser Sheet Fluorescence Microscopy
 % (LSFM) user interface.
 % Please ensure that all the necessary hardware is connected and switched
 % on and that their ports are correctly configured in the file ".\CFG\myConfig.ini"
 % Refer to the LSFM user manual for further details.
 % Initial code by Paolo Baesso
 % Further modifications by members of the "Lab of plant morphogenesys"
 % Imperial College London
 
    diary('D:\myMATLAB\LaserDAQ\Logs\log.txt');
    disp('========================================');
    disp(date); 
 % Start diary
 % Check that myConfig.ini file exists. If so, start GUI.
    fileName = 'D:\myMATLAB\LaserDAQ\CFG\myConfig.ini';
    if(exist(fileName)==2) 
     % Create the GUI
        mainFig= mainGUI(fileName);
        set(mainFig, 'Visible','on');
        
        % Temporaly disable all buttons until the hardware is ready
        InterfaceObj=findobj(mainFig,'Enable','on'); %Search for all active buttons ...
        InterfaceObj2= findobj(mainFig, 'Enable', 'Inactive'); % ... and for the Inactive ones
        set(InterfaceObj,'Enable','off'); %... set them to be disabled
        set(InterfaceObj2, 'Enable', 'off'); %...while we do the initial stuff
     
     % Retrieve configuration parameters   
       confPar=getappdata(mainFig, 'confPar');

     % Initialize LABJACK
       [ledobj, ledhandl]=LED_initialize;
       setappdata(mainFig, 'ledobj', ledobj); 
       setappdata(mainFig, 'ledhandl', ledhandl);
     
     % Initialize CAMERA   
       [vidobj, videosrc]= camera_initialize('qimaging');
       setappdata(mainFig, 'vidobj', vidobj); 
       setappdata(mainFig, 'videosrc', videosrc);
        %NEED A CAMERA CONFIGURE
     
     % Initialize FILTER WHEEL
       fwPort= confPar.filterwh.port;
       FWSerial = FW_initialize(fwPort);
       setappdata(mainFig, 'FWSerial', FWSerial);
     
     % Initialize WEBCAM
        % A USB camera can be used to monitor the setup remotely.
        % If the camera is used, uncomment the following two lines.
       %webcam = web_initialize();
       %setappdata(mainFig, 'webcam', webcam); 
     
     % Initialize PUMP
        pumpPort= confPar.pump.port;
        myPump = pump_initialize(pumpPort);
        setappdata(mainFig, 'myPump' , myPump);
        
     % Initialize TEMPERATURE HARDWARE and create TIMERS
        tempPort= confPar.temperature.port;
        myTemp = tempHW_initialize(tempPort);
        setappdata(mainFig, 'myTemp' , myTemp);
        timer_createGUITemp(mainFig);
        timer_createPeltierThermostat(mainFig);
        temperatureGUITimer=getappdata(mainFig, 'temperatureGUITimer');
        start(temperatureGUITimer);
     
     % Initialize MOTORS
        try
            HW_SN(mainFig);
            HW_initialize(mainFig);
            %HW_home( mainFig );
        catch
            msg = ['Error while opening motors'];
            errordlg(msg);
        end

     % Enable the user interface
        set(InterfaceObj,'Enable','on');
        set(InterfaceObj2, 'Enable', 'Inactive');
        
    else
        errorstring = 'I could not locate file "myConfig.ini". Execution will now stop';
        h = errordlg(errorstring);
    end
 % Close diary
    diary off;
end

