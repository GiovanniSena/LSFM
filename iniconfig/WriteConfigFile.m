function [ output_args ] = WriteConfigFile( filename, configStruct )
    %%Takes all element in the struct and writes them in a *.ini file.
    %\\icnas4.cc.ic.ac.uk\pbaesso\MATLAB\LaserDAQ\iniconfig\example32.ini
        ini = IniConfig();
        ini.AddSections('MAIN');
        ini.AddKeys('MAIN', 'value1', 2);
        ini.AddKeys('MAIN', 'value2', 3.14);
        ini.WriteFile('example31.ini')
%       ini.RemoveKeys('Some Section 1', {'some_key1', 'some_key3'})
%       ini.RenameKeys('Some Section 1', 'some_key2', 'renamed_some_key2')
%       ini.RenameSections('Some Section 1', 'Renamed Section 1')
        ini.WriteFile(filename)
     

end

