 function HW_SN( source )
 %HWSN Write the motors serial numbers
 %   
    serialStages= [83844136, 83857341, 83857284, 83857395, 83857266, 85834430]; %Sx, Sy, Sz, Cx, F, Shutter
    setappdata(source, 'HWSN', serialStages);
end

