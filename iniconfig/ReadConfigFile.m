function [ output_args ] = ReadConfigFile( filename )
    %%Read the file and returns a struct containing the configuration
    %%parameters.
    % 
        ini = IniConfig();
        ini.ReadFile(filename);
        sections = ini.GetSections();
        [keys, count_keys] = ini.GetKeys(sections{1});
        values = ini.GetValues(sections{1}, keys)
        %new_values(:) = {rand()};
        %ini.SetValues(sections{1}, keys, new_values, '%.3f');
        %ini.WriteFile('example1.ini');
end

