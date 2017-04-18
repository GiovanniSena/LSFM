function [ B ] = tr_applyTransformBrute( I0, R )
 %% TR_APPLYTRANSFORMBRUTE Summary of this function goes here
 %   Detailed explanation goes here
    [sizex, sizey, sizez] = size( I0);
    x0= -0.5*double(sizex);
    y0= -0.5*double(sizey);
    z0= -0.5*double(sizez);
    
    tempVec= zeros(sizex* sizey* sizez, 1, 'uint16');
    p=1;
    z= z0;
    for( zi=1: sizez)
        y= y0;
        for (yi=1:sizey)
            x= x0;
            for (xi= 1:sizex)
                
                xp= x*R(1,1) + y*R(1,2) + z*R(1,3) + R(1,4) -x0;
                yp= x*R(2,1) + y*R(2,2) + z*R(2,3) + R(2,4) -y0;
                zp= x*R(3,1) + y*R(3,2) + z*R(3,3) + R(3,4) -z0;
                %xp= x*R(1,1) + y*R(2,1) + z*R(3,1) + R(4,1) -x0;
                %yp= x*R(1,2) + y*R(2,2) + z*R(3,2) + R(4,2) -y0;
                %zp= x*R(1,3) + y*R(2,3) + z*R(3,3) + R(4,3) -z0;
                tempVec(p)= I0(xp+1, yp+1, zp+1);
                %tempVec(p)=0;
                %disp([num2str(xp) ' ' num2str(yp) ' ' num2str(zp) ' ' num2str(tempVec(p))]);
                x=x+1;
                p= p+1;
            end
            y= y+1;
        end
        z=z+1;
    end
    B = reshape(tempVec, sizex, sizey, sizez);
end

% applyTransformation(double **A, unsigned short *ret) {
% 	//I(x)->I(xA)
% 	int xi, yi, zi, p;
% 	double x, y, z, xo, yo, zo, xp, yp, zp;
% 
% 	xo = -0.5*(double)w;
% 	yo = -0.5*(double)h;
% 	zo = -0.5*(double)depth;
% 
% 	p = 0;
% 	for (zi = 0, z = zo; zi < depth; zi++, z+=1.0) {
% 		for (yi = 0, y = yo; yi < h; yi++, y+=1.0) {
% 			for (xi = 0, x = xo; xi < w; xi++, x+=1.0, p++) {
% 				xp = x*A[0][0] + y*A[1][0] + z*A[2][0] + A[3][0] - xo;
% 				yp = x*A[0][1] + y*A[1][1] + z*A[2][1] + A[3][1] - yo;
% 				zp = x*A[0][2] + y*A[1][2] + z*A[2][2] + A[3][2] - zo;
% 				ret[p] = getPixel(xp, yp, zp);	
% 			}
% 		}
% 	}
% }