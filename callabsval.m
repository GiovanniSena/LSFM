function y = callabsval(input)  %#codegen
y = input;
% Check the target. Do not use coder.ceval if callabsval is
% executing in MATLAB
if coder.target('MATLAB')
  % Executing in MATLAB, call function absval
  y = y * 10;
else
  % Executing in the generated code. 
  % Call the initialize function before calling the 
  % C function for the first time
  coder.ceval('absval_initialize');

  % Call the generated C library function absval
  y = coder.ceval('absval',y);
  
  % Call the terminate function after
  % calling the C function for the last time
  coder.ceval('absval_terminate');
end