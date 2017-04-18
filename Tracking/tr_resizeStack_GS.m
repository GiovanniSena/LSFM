function mat_rs = tr_resizeStack( originalImg, scale_xy, scale_z )
%% Resize stack scaling it.
% The original image is interpolated to produce a smaller version of it.
% The final image dimensions will be W/scale_xy, H/scale_xy, D/scale_z
% http://stackoverflow.com/questions/12520152/resizing-3d-matrix-image-in-matlab

    % Original dimensions
    [h, w, d] = size(originalImg); % h= #rows=dimension y; w=#columns=dimension x; d=#slices=dimension z
	
    % Output dimensions
    new_h = round(h/scale_xy);
	new_w = round(w/scale_xy);
	new_d = round(d/scale_z);
    
    fprintf('Scaling image from [%d, %d, %d] to [%d, %d, %d] ... ', h, w, d, new_h, new_w, new_d);
    
    % NB in 'size': first dimension is y, second dimension is x, third dimension is z
    [y x z]=...
        ndgrid(linspace(1,size(originalImg,1),new_h),...
        linspace(1,size(originalImg,2),new_w),...
        linspace(1,size(originalImg,3),new_d))
 
    mat_rs=uint16(interp3(single(originalImg),x,y,z)); %interp3 uses x,y,x graph order, not matrix order...
   
    fprintf('Done!\n');

end