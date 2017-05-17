function HW_SN( source )
%%  HWSN Write the motors serial numbers
%   Stores the serial numbers of the Thorlabs actuatorsin the GUI's application data.
%   The numbers are stored as a 6-elements array defined as:
%   [Sx, Sy, Sz, Cx, F, Shutter]

    serialStages= [83844136, 83857341, 83857284, 83857395, 83857266, 85834430];
    setappdata(source, 'HWSN', serialStages);
end

