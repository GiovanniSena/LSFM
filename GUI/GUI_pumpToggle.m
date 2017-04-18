function GUI_pumpToggle( state )
 %% GUI_PUMPTOGGLE Summary of this function goes here
 %   Detailed explanation goes here
    
    radioButton =  getappdata(gcf, 'pumpRadio');
    selectPump = str2num(get(get(radioButton,'SelectedObject'), 'tag')); %#ok<ST2NM>
    myPump = getappdata(gcf, 'myPump');
    if(state==0)
        pump_stop(myPump, selectPump);
    else
        pump_start(myPump, selectPump); % START THE PUMP
        
        pump1Speed = getappdata(gcf, 'pump1Speed'); 
        pumpEdit_call_calibrated( pump1Speed, pump1Speed , 1); % SET THE INITIAL SPEED FOR PUMP 1
        
        pump2Speed = getappdata(gcf, 'pump2Speed');
        pumpEdit_call_calibrated( pump2Speed, pump2Speed , 2); % SET THE INITIAL SPEED FOR PUMP 2
    end
    
    Pump1Ind = getappdata(gcf, 'Pump1Ind');
    Pump2Ind = getappdata(gcf, 'Pump2Ind');
    
    switch selectPump
        case 0 %BOTH
           if (state==1)
                set(Pump1Ind, 'string', '<html>PUMP1<br>ON');
                set(Pump1Ind, 'backgroundcolor', 'green'); 
                set(Pump2Ind, 'string', '<html>PUMP2<br>ON');
                set(Pump2Ind, 'backgroundcolor', 'green');
                setappdata(gcf, 'isPump1On', 1);
                setappdata(gcf, 'isPump2On', 1);
           else
                set(Pump1Ind, 'string', '<html>PUMP1<br>OFF');
                set(Pump1Ind, 'backgroundcolor', 'default'); 
                set(Pump2Ind, 'string', '<html>PUMP2<br>OFF');
                set(Pump2Ind, 'backgroundcolor', 'default');
                setappdata(gcf, 'isPump1On', 0);
                setappdata(gcf, 'isPump2On', 0);
           end
        case 1
            if (state==1)
                set(Pump1Ind, 'string', '<html>PUMP1<br>ON');
                set(Pump1Ind, 'backgroundcolor', 'green'); 
                setappdata(gcf, 'isPump1On', 1);
            else
                set(Pump1Ind, 'string', '<html>PUMP1<br>OFF');
                set(Pump1Ind, 'backgroundcolor', 'default'); 
                setappdata(gcf, 'isPump1On', 0);
            end
        case 2
            if (state==1)
                set(Pump2Ind, 'string', '<html>PUMP2<br>ON');
                set(Pump2Ind, 'backgroundcolor', 'green'); 
                setappdata(gcf, 'isPump2On', 1);
            else
                set(Pump2Ind, 'string', '<html>PUMP2<br>OFF');
                set(Pump2Ind, 'backgroundcolor', 'default'); 
                setappdata(gcf, 'isPump2On', 0);
            end
    end
end

