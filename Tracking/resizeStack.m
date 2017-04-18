function mat_rs = resizeStack( originalImg, scale_xy, scale_z )
%% Resize stack scaling it.
%http://stackoverflow.com/questions/12520152/resizing-3d-matrix-image-in-matlab

    %% desired output dimensions
    [w, h, depth] = size(originalImg);
	nx = round(h/scale_xy);
	ny = round(w/scale_xy);
	nz = round(depth/scale_z);
    
[y x z]=...
   ndgrid(linspace(1,size(originalImg,1),ny),...
          linspace(1,size(originalImg,2),nx),...
          linspace(1,size(originalImg,3),nz));
%mat_rs=interp3(im,y,x,z);
mat_rs=uint16(interp3(single(originalImg),x,y,z));

end