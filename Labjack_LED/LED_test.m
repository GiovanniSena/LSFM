[ ljudObj, ljhandle ] =LED_initialize();

port= 4; % Two channesl to use: 4 and 5
state=0; % Set 1 to switch on, 0 to switch off

LED_switch(ljudObj, ljhandle, port, state);
currState= LED_readStatus(ljudObj, ljhandle, port);
disp(currState);