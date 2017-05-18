function mat_rs = tr_resizeStack_GS( originalImg, scale_xy, scale_z )
%%  TR_RESIZESTACK Resize stack scaling it.
%   Takes an input stack of images and rescales it according to the
%   required parameters. The scaling in X and Y is identical. The scaling
%   in Z (i.e. the number of stacks) can be chosen independently.
%   The original image is interpolated to produce a smaller version of it.
%   Given an original stack of WxHxD pixels, the final stack's dimensions will be W/scale_xy, H/scale_xy, D/scale_z
%   See: http://stackoverflow.com/questions/12520152/resizing-3d-matrix-image-in-matlab

%   Original dimensions
    [h, w, d] = size(originalImg); % h= #rows=dimension y; w=#columns=dimension x; d=#slices=dimension z
	
%   Required dimensions
    new_h = round(h/scale_xy);
	new_w = round(w/scale_xy);
	new_d = round(d/scale_z);
    fprintf('Scaling image from [%d, %d, %d] to [%d, %d, %d] ... ', h, w, d, new_h, new_w, new_d);
    
%   NB in 'size': first dimension is y, second dimension is x, third dimension is z
    [y, x, z]=...
        ndgrid(linspace(1,size(originalImg,1),new_h),...
        linspace(1,size(originalImg,2),new_w),...
        linspace(1,size(originalImg,3),new_d));

%   Interpolate image
    mat_rs=uint16(interp3(single(originalImg),x,y,z)); %interp3 uses x,y,x graph order, not matrix order...
    fprintf('Done!\n');
end