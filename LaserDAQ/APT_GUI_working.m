clear; close all; clc;
global actxHandle; % make h a global variable so it can be used outside the main
          % function. Useful when you do event handling and sequential           move
actxHandle = COM.MGMOTOR_MGMotorCtrl_1;

nStages = 6; %Specifies the number of THORLABS modules in the hub
serialStages= [83844136, 83857341, 83857284, 83857395, 83857266, 85834430]; %Sx, Sy, Sz, Cx, F, Shutter

%% Simple tab gui
GUI_TEST

%% Create Matlab Figure Container
set(0,'defaultfigureposition',[50 50 600 400]');
fpos    = get(0,'DefaultFigurePosition'); % figure default position
fpos(3) = 600; % figure window size;Width
fpos(4) = 600; % Height
 
mainWindow = figure('Position', fpos,...
           'Menu','None',...
           'Name','APT GUI');

%% Create ActiveX Controller
%h = [actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400 ], f) actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400 ], f)];
%h = [actxcontrol('MGMOTOR.MGMotorCtrl.1',[00 00 300 200 ], f) actxcontrol('MGMOTOR.MGMotorCtrl.1',[250 120 300 200 ], f)];
for i = 1:nStages
     if (i<=3)
         actxHandle(i) = actxcontrol('MGMOTOR.MGMotorCtrl.1',[00 (i-1)*200 300 200 ], mainWindow);
     elseif ((i>3) && (i ~= 6))
         actxHandle(i) = actxcontrol('MGMOTOR.MGMotorCtrl.1',[300 (i-4)*200 300 200 ], mainWindow);
     elseif (i == 6)
         actxHandle(i) = actxcontrol('MGMOTOR.MGMotorCtrl.1',[300 (i-4)*200 300 200 ], mainWindow);
     end
end

%% Initialize Hardware

for i = 1:nStages
    actxHandle(i).StartCtrl;% Start Control
    SN = serialStages(i);% Define the serial number of the hardware
    set(actxHandle(i),'HWSerialNum', SN); %Set serial numer in control
    actxHandle(i).Identify; % Indentify the device
    pause(0.5); %500 msec pause while each stage is blinking
end

for i = 1: (nStages-1)
    %actxHandle(i).MoveHome(0,0); %%Find home location for stepper motors (chId, returnMode)
end
 
pause(5); % waiting for the GUI to load up;

%% Event Handling
for i = 1: (nStages-1)
    actxHandle(i).registerevent({'MoveComplete' 'MoveCompleteHandler'});
end

%% Sending Moving Commands
timeout = 10; % timeout for waiting the move to be completed
%h.MoveJog(0,1); % Jog
 
% Move a absolute distance
%h(2).SetAbsMovePos(0,2);
%h(2).MoveAbsolute(0,1==0);
%  
% t1 = clock; % current time
% while(etime(clock,t1)<timeout) 
% % wait while the motor is active; timeout to avoid dead loop
%     s = h(2).GetStatusBits_Bits(0);
%     if (IsMoving(s) == 0)
%       pause(2); % pause 2 seconds;
%       h(2).MoveHome(0,0);
%       disp('Home Started!');
%       break;
%     end
% end


