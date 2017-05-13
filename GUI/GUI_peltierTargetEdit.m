function [ output_args ] = GUI_peltierTargetEdit( source, ~ )
%%  GUI_TARGETTEMPEDIT: executes when the user changes the target temperature (PELTIER > AUTO)
%   Check that input number is numeric and comprised within "reasonable"
%   temperatures.

    input = str2double(get(source,'string'));
    display(input);
    if isnan(input)
      input= 23.0;
    else
      if (input < 20)
          input = 20.0;
      end
      if (input > 25)
          input = 25.0;
      end
    end
    dispNum= num2str(input, '%2.1f');
    set(source, 'String', dispNum);
end



