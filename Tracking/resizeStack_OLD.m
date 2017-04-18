function [ resizedImg ] = resizeStack_OLD( originalImg, scale_xy, scale_z )
    %resizedImg = originalImg;
    
    %void ShortImage::resize(double scale_xy, double scale_z, ShortImage *ret) {
	%double *pixels, *tots, v;
	%int p, q, x, y, z, rw, rh, rwh, rd, cxi, cyi, czi;
	%double s_x, s_y, s_z, cxd, cyd, czd, mult_x1, mult_x2, mult_y1, mult_y2, mult_z1, mult_z2;
	
    [w, h, depth] = size(originalImg);
	rw = round(w/scale_xy);
	rh = round(h/scale_xy);
	rd = round(depth/scale_z);
	rwh = rw*rh;
    
	s_x = rw/w;
	s_y = rh/h;
	s_z = rd/depth;

	%ret = resizedImg
	resizedImg = zeros(rw, rh, rd, 'uint16');

	pixels = zeros(rw, rh, rd);
	tots = zeros(rw, rh, rd);
	
	p = 1;
    czd = 1;
    for z= 1: depth
    %for (z = 0, czd = 0.0; z < depth; z++, czd += s_z) {
        cyd = 1;
		czi = round(czd);
        for y= 1: h
		%for (y = 0, cyd = 0.0; y < h; y++, cyd += s_y) {
            cxd = 1;	
            cyi = round(cyd);
            for x= 1: w
			%for (x = 0, cxd = 0.0; x < w; x++, p++, cxd += s_x) {
				cxi = round(cxd);
				q = cxi+cyi*rw+czi*rwh;

				mult_x1 = MIN(cxi+1, (x+1)*s_x) - cxd;
				mult_y1 = MIN(cyi+1, (y+1)*s_y) - cyd;
				mult_z1 = MIN(czi+1, (z+1)*s_z) - czd;
				mult_x2 = s_x - mult_x1;
				mult_y2 = s_y - mult_y1;
				mult_z2 = s_z - mult_z1;
		
                % HERE!!!
				v = double(originalImg(p)); 
				pixels(cxi, cyi, czi) = pixels(cxi, cyi, czi) + v*mult_x1*mult_y1*mult_z1;
				tots(cxi, cyi, czi) = tots(cxi, cyi, czi) + mult_x1*mult_y1*mult_z1;
                
                if (cxi+1 < rw) 
                    pixels(q+1) = pixels(q+1) + v*mult_x2*mult_y1*mult_z1;
					tots(q+1) = tots(q+1) + mult_x2*mult_y1*mult_z1;
                    if (cyi+1 < rh) 
						pixels[q+rw+1] += v*mult_x2*mult_y2*mult_z1;
						tots[q+rw+1] += mult_x2*mult_y2*mult_z1;
                        if (czi + 1 < rd) 
							pixels[q+rwh+rw+1] += v*mult_x2*mult_y2*mult_z2;
							tots[q+rwh+rw+1] += mult_x2*mult_y2*mult_z2;
                        end
                    end
                end
                if (cyi+1 < rh) 
					pixels[q+rw] += v*mult_x1*mult_y2*mult_z1;
					tots[q+rw] += mult_x1*mult_y2*mult_z1;
                    if (czi+1 < rd) 
						pixels[q+rwh+rw] += v*mult_x1*mult_y2*mult_z2;
						tots[q+rwh+rw] += mult_x1*mult_y2*mult_z2;
                    end
                end
                if (czi + 1 < rd) 
					pixels[q+rwh] += v*mult_x1*mult_y1*mult_z2;
					tots[q+rwh] += mult_x1*mult_y1*mult_z2;
                end
                cxd = cxd + s_x;
                p = p+1;
            end
            cyd = cyd + s_y;
        end
        czd = czd + s_z;
    end
    for (x = 0; x < rwh*rd; x++)
		ret->pix[x] = (unsigned short)(0.5 + pixels[x]/tots[x]);
    end
	delete pixels;
	delete tots;
    %make sure zero pixels are propagated to the resized image	
	p = 0;
    for z= 1: depth
	%for (z = 0, czd = 0.0; z < depth; z++, czd += s_z) 
		czi = round(czd);
        for y= 1: h
		%for (y = 0, cyd = 0.0; y < h; y++, cyd += s_y) 
			cyi = round(cyd);
            for x= 1: w
			%for (x = 0, cxd = 0.0; x < w; x++, p++, cxd += s_x) 
				cxi = (int)cxd;
                if (pix[p] == 0) 
					q = cxi + cyi*rw+czi*rwh;
					ret->pix[q] = 0;
                    if (cxi+1 < rw) 
						ret->pix[q+1] = 0;
                        if (cyi+1 < rh) 
							ret->pix[q+rw+1] = 0;
                            if (czi + 1 < rd)
								ret->pix[q+rwh+rw+1] = 0;
                            end
                        end
                    end
                    if (cyi+1 < rh) 
						ret->pix[q+rw] = 0;
                        if (czi+1 < rd) 
							ret->pix[q+rwh+rw] = 0;
                        end
                    end
                    if (czi + 1 < rd)
						ret->pix[q+rwh] = 0;
                    end
                end
                p= p+1;
                cxd = cxd + s_x;
            end
            cyd = cyd + s_y;
        end
        czd = czd + s_z;
    end

end