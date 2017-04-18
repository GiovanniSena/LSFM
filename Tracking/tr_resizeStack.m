function mat_rs = tr_resizeStack( originalImg, scale_xy, scale_z )
%% Resize stack scaling it.
% The original image is interpolated to produce a smaller version of it.
% The final image dimensions will be W/scale_xy, H/scale_xy, D/scale_z
% http://stackoverflow.com/questions/12520152/resizing-3d-matrix-image-in-matlab

    % Original dimensions
    [w, h, depth] = size(originalImg);
	
    % Output dimensions
    nx = round(h/scale_xy);
	ny = round(w/scale_xy);
	nz = round(depth/scale_z);
    
    %myMsg= ['Scaling image from [' num2str(w) ', ' num2str(h) ', ' num2str(depth) '] to [' num2str(ny) ', ' num2str(nx) ', ' num2str(nz) ']'];
    %disp(myMsg);
    fprintf('Scaling image from [%d, %d, %d] to [%d, %d, %d] ... ', w, h, depth, ny, nx, nz);
    
    [y x z]=...
        ndgrid(linspace(1,size(originalImg,1),ny),...
        linspace(1,size(originalImg,2),nx),...
        linspace(1,size(originalImg,3),nz));
    %mat_rs=interp3(im,y,x,z);
    mat_rs=uint16(interp3(single(originalImg),x,y,z));
    %myMsg= 'Scaling done!';
    %disp(myMsg);
    fprintf('Done!\n');

end