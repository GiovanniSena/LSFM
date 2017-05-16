%% Use to test the LED clusters.
% Set the state to 1 or 0 to switch the cluster on or off.

[ ljudObj, ljhandle ] =LED_initialize();

port= 4; % Two channesl to use: 4 and 5
state=0; % Set 1 to switch on, 0 to switch off

LED_switch(ljudObj, ljhandle, port, state);
currState= LED_readStatus(ljudObj, ljhandle, port);
disp(currState);