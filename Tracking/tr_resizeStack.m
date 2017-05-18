function mat_rs = tr_resizeStack( originalImg, scale_xy, scale_z )
%%  TR_RESIZESTACK Resize stack scaling it.
%   Takes an input stack of images and rescales it according to the
%   required parameters. The scaling in X and Y is identical. The scaling
%   in Z (i.e. the number of stacks) can be chosen independently.
%   The original image is interpolated to produce a smaller version of it.
%   Given an original stack of WxHxD pixels, the final stack's dimensions will be W/scale_xy, H/scale_xy, D/scale_z
%   See: http://stackoverflow.com/questions/12520152/resizing-3d-matrix-image-in-matlab

%   Original dimensions
    [w, h, depth] = size(originalImg);
	
%   Required dimensions
    nx = round(h/scale_xy);
	ny = round(w/scale_xy);
	nz = round(depth/scale_z);
    fprintf('Scaling image from [%d, %d, %d] to [%d, %d, %d] ... ', w, h, depth, ny, nx, nz);
    
%   Create linearly spaced vectors
    [y, x, z]=...
        ndgrid(linspace(1,size(originalImg,1),ny),...
        linspace(1,size(originalImg,2),nx),...
        linspace(1,size(originalImg,3),nz));
    
%   Interpolate image
    mat_rs=uint16(interp3(single(originalImg),x,y,z));
    fprintf('Done!\n');
end