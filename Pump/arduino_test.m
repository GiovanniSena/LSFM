%s = serial('COM4','BaudRate',9600, 'Terminator', 'LF/CR');
%s.set('Terminator', 'CR/LF');

%fopen(s);
%s.get()
fprintf(s, 'start');

pause(5);
fprintf(s, 'stop');
fclose(s);