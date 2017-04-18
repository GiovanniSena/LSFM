int CRootAcqMFCDlg::findTransformation(ShortImage *I1, ShortImage *I2, double scale0, double scale1, double scaleMult, int nIterations, double z_over_x, double L, double **best_A) {
//find the transformation A that maps the current image to the previous one, with units of translation in pixels
//i.e. I2(Ax + h) = I1(x)
//A is the transformation matrix, sigma is a vector of values calculated from the image intensities
//and its gradients, as well as the transformation matrix and its derivatives
//dxA is the derivative of A wrt theta_x, etc.
//theta is the vector theta_x, theta_y, theta_z
//and is used to calculate the derivative of A wrt angles
//b (after gauss jordan inversion of S) is the calculated update to theta
	double **dA, **A, **temp_mat, sigma[27], **dxA, **dyA, **dzA, *theta, cosx, cosy, cosz, sinx, siny, sinz, **S, *b, tot;
	double *dxI2, *dyI2, *dzI2, *dxI1, *dyI1, *dzI1, *weight, xo, yo, zo, xx, yy, zz, *temp_v1, *temp_v2, temp_f1, temp_f2, temp_f3, L2, best_L2;
	ShortImage *rI1, *rI2, *xI2;
	FILE *trackFile, *trackLogFile;
	int i, j, p, x, y, z, rw, rh, rdepth, rwh, iter, x1, x2, y1, y2, z1, z2;
	double scale_xy, scale_z;
	char fname[1024];
	bool zero_overlap_flag;

// 	sprintf(fname, "%s\\track_%d_%d.txt", saveDir, acquisitionNumber, curScan);
// 	trackFile = fopen(fname, "w");

// 	sprintf(fname, "%s\\track_log_%d_%d.txt", saveDir, acquisitionNumber, curScan);
// 	trackLogFile = fopen(fname, "w");

	theta = new double[3];
	theta[0] = theta[1] = theta[2] = 0.0;
	S = new double *[6];
	for (i = 0; i < 6; i++) S[i] = new double[6];
	b = new double[6];
	temp_v1 = new double[4];
	temp_v2 = new double[4];
	
	xI2 = new ShortImage();
	rI1 = new ShortImage();
	rI2 = new ShortImage();

	A = new double *[4];
	dA = new double *[4];
	dxA = new double *[4];
	dyA = new double *[4];
	dzA = new double *[4];
	temp_mat = new double *[4];
	for (i = 0; i < 4; i++) {
		A[i] = new double[4];
		dA[i] = new double[4];
		dxA[i] = new double[4];
		dyA[i] = new double[4];
		dzA[i] = new double[4];
		temp_mat[i] = new double[4];
	}
	best_A[0][0] = 1.0;
	best_A[0][1] = 0.0;
	best_A[0][2] = 0.0;
	best_A[0][3] = 0.0;
			
	best_A[1][0] = 0.0;
	best_A[1][1] = 1.0;
	best_A[1][2] = 0.0;
	best_A[1][3] = 0.0;

	best_A[2][0] = 0.0;
	best_A[2][1] = 0.0;
	best_A[2][2] = 1.0;
	best_A[2][3] = 0.0;

	best_A[3][0] = 0.0;
	best_A[3][1] = 0.0;
	best_A[3][2] = 0.0;
	best_A[3][3] = 1.0;
	for (scale_xy = scale0; scale_xy >= scale1; scale_xy *= scaleMult) {
		fprintf(trackLogFile, "Starting tracking at scale_xy = %f\n", scale_xy);
		fflush(trackLogFile);
		best_L2 = FLT_MAX;    
		for (i = 0; i < 4; i++) {
			for (j = 0; j < 4; j++)
				A[i][j] = best_A[i][j];
		}
		theta[0] = atan2(-A[1][2], A[2][2]);
		theta[1] = atan2(A[0][2], sqrt(pow(A[1][2], 2.0) + pow(A[2][2], 2.0)));
		theta[2] = atan2(-A[0][1], A[0][0]);

		scale_z = z_over_x * scale_xy;
		if (scale_z < 1.0) scale_z = 1.0;

		fprintf(trackLogFile, "Resizing I1 (scale_xy: %f, scale_z: %f)\n", scale_xy, scale_z);
		fflush(trackLogFile);
		I1->resize(scale_xy, scale_z, rI1);
		fprintf(trackLogFile, "Resizing I2 (scale_xy: %f, scale_z: %f)\n", scale_xy, scale_z);
		fflush(trackLogFile);
		I2->resize(scale_xy, scale_z, rI2);
		fprintf(trackLogFile, "Done resizing\n");
		fflush(trackLogFile);
		if (rI1->pix == NULL) {
			fprintf(trackLogFile, "rI1->pix is null!\n");
			fflush(trackLogFile);
			break;
		}
		if (rI2->pix == NULL) {
			fprintf(trackLogFile, "rI2->pix is null!\n");
			fflush(trackLogFile);
			break;
		}
		fprintf(trackLogFile, "Smoothing rI1\n");
		fflush(trackLogFile);
		rI1->smooth(2, 2, 1);
		fprintf(trackLogFile, "Smoothing rI2\n");
		fflush(trackLogFile);
		rI2->smooth(2, 2, 1);
		fprintf(trackLogFile, "Done smoothing\n");
		fflush(trackLogFile);

		rw = rI2->w;
		rh = rI2->h;
		rdepth = rI2->depth;
		rwh = rw*rh;

		x1 = (int)((double)ROI_x1/scale_xy)+1;
		x2 = (int)((double)ROI_x2/scale_xy)-1;
		y1 = (int)((double)ROI_y1/scale_xy)+1;
		y2 = (int)((double)ROI_y2/scale_xy)-1;
		z1 = 1;
		z2 = rdepth-1;

		xo = -(double)TRACK_X/scale_xy;
		yo = -(double)TRACK_Y/scale_xy;
		zo = -0.5*(double)rdepth;
		xI2->w = rw;
		xI2->h = rh;
		xI2->depth = rdepth;
		xI2->pix = new unsigned short[rw*rh*rdepth];
		dxI1 = new double[rw*rh*rdepth];
		dyI1 = new double[rw*rh*rdepth];
		dzI1 = new double[rw*rh*rdepth];
		dxI2 = new double[rw*rh*rdepth];
		dyI2 = new double[rw*rh*rdepth];
		dzI2 = new double[rw*rh*rdepth];
		weight = new double[rw*rh*rdepth];

		memset(dxI1, 0, sizeof(double)*rw*rh*rdepth);
		memset(dyI1, 0, sizeof(double)*rw*rh*rdepth);
		memset(dzI1, 0, sizeof(double)*rw*rh*rdepth);
		memset(dxI2, 0, sizeof(double)*rw*rh*rdepth);
		memset(dyI2, 0, sizeof(double)*rw*rh*rdepth);
		memset(dzI2, 0, sizeof(double)*rw*rh*rdepth);
		memset(weight, 0, sizeof(double)*rw*rh*rdepth);
        
        
        
		for (iter = 0; iter < nIterations; iter++) {
			fprintf(trackLogFile, "\tStarting iteration %d\n", iter);
			fflush(trackLogFile);
			cosx = cos(theta[0]);
			cosy = cos(theta[1]);
			cosz = cos(theta[2]);
			sinx = sin(theta[0]);
			siny = sin(theta[1]);
			sinz = sin(theta[2]);
			
//initialize the derivatives of A from theta calculated previously:
			dxA[0][0] = 0.0;
			dxA[0][1] = 0.0;
			dxA[0][2] = 0.0;
			dxA[0][3] = 0.0;

			dxA[1][0] = cosx*siny*cosz-sinx*sinz;
			dxA[1][1] = -cosx*siny*sinz-sinx*cosz;
			dxA[1][2] = -cosx*cosy;
			dxA[1][3] = 0.0;
			dxA[2][0] = sinx*siny*cosz+cosx*sinz;
			dxA[2][1] = -sinx*siny*sinz+cosx*cosz;
			dxA[2][2] = -sinx*cosy;
			dxA[2][3] = 0.0;

			dxA[3][0] = 0.0;
			dxA[3][1] = 0.0;
			dxA[3][2] = 0.0;
			dxA[3][3] = 1.0;

			dyA[0][0] = -siny*cosz;
			dyA[0][1] = siny*sinz;
			dyA[0][2] = cosy;
			dyA[0][3] = 0.0;

			dyA[1][0] = sinx*cosy*cosz;
			dyA[1][1] = -sinx*cosy*sinz;
			dyA[1][2] = sinx*siny;
			dyA[1][3] = 0.0;

			dyA[2][0] = -cosx*cosy*cosz;
			dyA[2][1] = cosx*cosy*sinz;
			dyA[2][2] = -cosx*siny;
			dyA[2][3] = 0.0;

			dyA[3][0] = 0.0;
			dyA[3][1] = 0.0;
			dyA[3][2] = 0.0;
			dyA[3][3] = 1.0;

			dzA[0][0] = -cosy*sinz;
			dzA[0][1] = -cosy*cosz;
			dzA[0][2] = 0.0;
			dzA[0][3] = 0.0;

			dzA[1][0] = -sinx*siny*sinz+cosx*cosz;
			dzA[1][1] = -sinx*siny*cosz-cosx*sinz;
			dzA[1][2] = 0.0;
			dzA[1][3] = 0.0;

			dzA[2][0] = cosx*siny*sinz+sinx*cosz;
			dzA[2][1] = cosx*siny*cosz-sinx*sinz;
			dzA[2][2] = 0.0;
			dzA[2][3] = 0.0;

			dzA[3][0] = 0.0;
			dzA[3][1] = 0.0;
			dzA[3][2] = 0.0;
			dzA[3][3] = 1.0;
            

//transform the resized current image
			A[3][0] /= scale_xy;
			A[3][1] /= scale_xy;
			A[3][2] /= scale_z;
			A[3][3] = 1.0;

			fprintf(trackLogFile, "\tApplying transformation:\n");
			for (i = 0; i < 4; i++) {
				for (j = 0; j < 4; j++) {
					fprintf(trackLogFile, "\t%f", A[i][j]);
				}
				fprintf(trackLogFile, "\n");
			}
			fflush(trackLogFile);
			rI2->applyTransformation(A, xI2->pix);
			fprintf(trackLogFile, "\tDone applying transformation\n");
			fflush(trackLogFile);
			A[3][0] *= scale_xy;
			A[3][1] *= scale_xy;
			A[3][2] *= scale_z;
			A[3][3] = 1.0;

			fprintf(trackLogFile, "\tCalculating L2\n");
			fflush(trackLogFile);
			L2 = calcL2(rI1, xI2, ROI_x1/scale_xy, ROI_x2/scale_xy, ROI_y1/scale_xy, ROI_y2/scale_xy, 0, rdepth-1);
			if (L2 < best_L2) {
				best_L2 = L2;
				for (i = 0; i < 4; i++) {
					for (j = 0; j < 4; j++)
						best_A[i][j] = A[i][j];
				}
			}
			fprintf(trackLogFile, "\tDone calculating L2\n");
			fflush(trackLogFile);
			for (i = 0; i < 27; i++) sigma[i] = 0.0;
			
			fprintf(trackLogFile, "\tCalculating tracking terms\n");
			fflush(trackLogFile);
			tot = 0.0;
			for (z = z1, zz = zo + (double)z1; z < z2; z++, zz += 1.0) {
				for (y = y1, yy = yo + (double)y1; y < y2; y++, yy += 1.0) {
					for (x = x1, xx = xo + (double)x1; x < x2; x++, xx += 1.0) {
						p = x+y*rw+z*rwh;
						dxI1[p] = ((double)rI1->pix[p+1] - (double)rI1->pix[p]);
						dyI1[p] = ((double)rI1->pix[p+rw] - (double)rI1->pix[p]);
						dzI1[p] = ((double)rI1->pix[p+rwh] - (double)rI1->pix[p]);

						dxI2[p] = ((double)xI2->pix[p+1] - (double)xI2->pix[p]);
						dyI2[p] = ((double)xI2->pix[p+rw] - (double)xI2->pix[p]);
						dzI2[p] = ((double)xI2->pix[p+rwh] - (double)xI2->pix[p]);
						
						if ((xI2->pix[p] == 0) || (xI2->pix[p+1] == 0) || (xI2->pix[p+rw] == 0) || (xI2->pix[p+rwh] == 0))
							weight[p] = 0.0;
						else if ((rI1->pix[p] == 0) || (rI1->pix[p+1] == 0) || (rI1->pix[p+rw] == 0) || (rI1->pix[p+rwh] == 0))
							weight[p] = 0.0;
						else
							weight[p] = L / (L + pow(dxI2[p] - dxI1[p], 2.0) + pow(dyI2[p] - dyI1[p], 2.0) + pow(dzI2[p] - dzI1[p], 2.0));
					
						temp_v1[0] = dxI2[p];
						temp_v1[1] = dyI2[p];
						temp_v1[2] = dzI2[p];
						temp_v1[3] = 0.0;

						matVectMult(dxA, temp_v1, temp_v2);
						temp_f1 = xx*temp_v2[0] + yy*temp_v2[1] + zz*temp_v2[2];
						
						matVectMult(dyA, temp_v1, temp_v2);
						temp_f2 = xx*temp_v2[0] + yy*temp_v2[1] + zz*temp_v2[2];
						
						matVectMult(dzA, temp_v1, temp_v2);
						temp_f3 = xx*temp_v2[0] + yy*temp_v2[1] + zz*temp_v2[2];
						
						sigma[0] += temp_f1*temp_f1*weight[p];
						sigma[1] += temp_f2*temp_f2*weight[p];
						sigma[2] += temp_f3*temp_f3*weight[p];
						sigma[3] += dxI2[p]*dxI2[p]*weight[p];
						sigma[4] += dyI2[p]*dyI2[p]*weight[p];
						sigma[5] += dzI2[p]*dzI2[p]*weight[p];
						sigma[6] += temp_f1*((double)xI2->pix[p] - (double)rI1->pix[p])*weight[p];
						sigma[7] += temp_f2*((double)xI2->pix[p] - (double)rI1->pix[p])*weight[p];
						sigma[8] += temp_f3*((double)xI2->pix[p] - (double)rI1->pix[p])*weight[p];
						sigma[9] += temp_f1*dxI2[p]*weight[p];
						sigma[10] += temp_f1*dyI2[p]*weight[p];
						sigma[11] += temp_f1*dzI2[p]*weight[p];
						sigma[12] += temp_f2*dxI2[p]*weight[p];
						sigma[13] += temp_f2*dyI2[p]*weight[p];
						sigma[14] += temp_f2*dzI2[p]*weight[p];
						sigma[15] += temp_f3*dxI2[p]*weight[p];
						sigma[16] += temp_f3*dyI2[p]*weight[p];
						sigma[17] += temp_f3*dzI2[p]*weight[p];
						sigma[18] += dxI2[p]*((double)xI2->pix[p] - (double)rI1->pix[p])*weight[p];
						sigma[19] += dyI2[p]*((double)xI2->pix[p] - (double)rI1->pix[p])*weight[p];
						sigma[20] += dzI2[p]*((double)xI2->pix[p] - (double)rI1->pix[p])*weight[p];
						sigma[21] += temp_f1*temp_f2*weight[p];
						sigma[22] += temp_f1*temp_f3*weight[p];
						sigma[23] += temp_f2*temp_f3*weight[p];
						sigma[24] += dxI2[p]*dyI2[p]*weight[p];
						sigma[25] += dxI2[p]*dzI2[p]*weight[p];
						sigma[26] += dyI2[p]*dzI2[p]*weight[p];
						tot += weight[p];
					}
				}
			}
			fprintf(trackLogFile, "\tDone calculating tracking terms\n");
			fflush(trackLogFile);
/*			sprintf(fname, "%s\\weight_%f_%d.tif", saveDir, scale_xy, iter);
			writeTIFFFromFloat(weight, rw, rh, rdepth, fname);
			sprintf(fname, "%s\\dx_%f_%d.tif", saveDir, scale_xy, iter);
			writeTIFFFromFloat(dxI2, rw, rh, rdepth, fname);
			sprintf(fname, "%s\\dy_%f_%d.tif", saveDir, scale_xy, iter);
			writeTIFFFromFloat(dyI2, rw, rh, rdepth, fname);
			sprintf(fname, "%s\\dz_%f_%d.tif", saveDir, scale_xy, iter);
			writeTIFFFromFloat(dzI2, rw, rh, rdepth, fname);
*/
			zero_overlap_flag = false;
			if (tot < 1.0) {
//it is possible that zero overlap is caused by the way
//zero pixels at the border are propagated to the scaled, smoothed
//images, especially at large scales.  So unless this is the smallest scale,
//just skip to the next scale
				fprintf(trackLogFile, "Zero overlap at iteration %d, scale_xy %f, best_A:\n", iter, scale_xy);
				for (i = 0; i < 4; i++) {
					for (j = 0; j < 4; j++)
						fprintf(trackLogFile, "%f\t", best_A[i][j]);
					fprintf(trackLogFile, "\n");
				}
				fflush(trackLogFile);
				zero_overlap_flag = true;
				break;
			}
			S[0][0] = sigma[0];
			S[0][1] = sigma[21];
			S[0][2] = sigma[22];
			S[0][3] = sigma[9];
			S[0][4] = sigma[10];
			S[0][5] = sigma[11];

			S[1][0] = sigma[21];
			S[1][1] = sigma[1];
			S[1][2] = sigma[23];
			S[1][3] = sigma[12];
			S[1][4] = sigma[13];
			S[1][5] = sigma[14];

			S[2][0] = sigma[22];
			S[2][1] = sigma[23];
			S[2][2] = sigma[2];
			S[2][3] = sigma[15];
			S[2][4] = sigma[16];
			S[2][5] = sigma[17];

			S[3][0] = sigma[9];
			S[3][1] = sigma[12];
			S[3][2] = sigma[15];
			S[3][3] = sigma[3];
			S[3][4] = sigma[24];
			S[3][5] = sigma[25];

			S[4][0] = sigma[10];
			S[4][1] = sigma[13];
			S[4][2] = sigma[16];
			S[4][3] = sigma[24];
			S[4][4] = sigma[4];
			S[4][5] = sigma[26];

			S[5][0] = sigma[11];
			S[5][1] = sigma[14];
			S[5][2] = sigma[17];
			S[5][3] = sigma[25];
			S[5][4] = sigma[26];
			S[5][5] = sigma[5];

			b[0] = -sigma[6];
			b[1] = -sigma[7];
			b[2] = -sigma[8];
			b[3] = -sigma[18];
			b[4] = -sigma[19];
			b[5] = -sigma[20];

			fprintf(trackLogFile, "\tInverting tracking matrix\n");
			fflush(trackLogFile);
			gaussj(S, b);
			fprintf(trackLogFile, "\tDone inverting tracking matrix\n");
			fflush(trackLogFile);

			cosx = cos(b[0]);
			cosy = cos(b[1]);
			cosz = cos(b[2]);
			sinx = sin(b[0]);
			siny = sin(b[1]);
			sinz = sin(b[2]);

			dA[0][0] = cosy*cosz;
			dA[0][1] = -cosy*sinz;
			dA[0][2] = siny;
			dA[0][3] = 0.0;

			dA[1][0] = sinx*siny*cosz + cosx*sinz;
			dA[1][1] = cosx*cosz-sinx*siny*sinz;
			dA[1][2] = -sinx*cosy;
			dA[1][3] = 0.0;

			dA[2][0] = -cosx*siny*cosz + sinx*sinz;
			dA[2][1] = cosx*siny*sinz + sinx*cosz;
			dA[2][2] = cosx*cosy;
			dA[2][3] = 0.0;

			dA[3][0] = b[3]*scale_xy;
			dA[3][1] = b[4]*scale_xy;
			dA[3][2] = b[5]*scale_z;
			dA[3][3] = 1.0;

			fprintf(trackLogFile, "\tCalculating temp_mat\n");
			fflush(trackLogFile);

			matMult(A, dA, temp_mat);

			fprintf(trackLogFile, "\tDone with matrix multiplication\n");
			fflush(trackLogFile);

			for (i = 0; i < 4; i++) {
				for (j = 0; j < 4; j++)
					A[i][j] = temp_mat[i][j];
			}
			fprintf(trackLogFile, "\tDone calculating temp_mat\n");
			fflush(trackLogFile);
//HERE
//calculate angles from A:
			theta[0] = atan2(-A[1][2], A[2][2]);
			theta[1] = atan2(A[0][2], sqrt(pow(A[1][2], 2.0) + pow(A[2][2], 2.0)));
			theta[2] = atan2(-A[0][1], A[0][0]);
			
			fprintf(trackFile, "%f\t%f\t%d\t%f\t", scale_xy, scale_z, iter, tot);
			for (i = 0; i < 27; i++)
				fprintf(trackFile, "%f\t", sigma[i]);
			for (i = 0; i < 6; i++)
				fprintf(trackFile, "%f\t", b[i]);
			for (i = 0; i < 3; i++)
				fprintf(trackFile, "%f\t", theta[i]);
			
			temp_v1[0] = 0.0;
			temp_v1[1] = 0.0;
			temp_v1[2] = 0.0;
			temp_v1[3] = 1.0;
			fprintf(trackLogFile, "\tCalculating temp_v2\n");
			fflush(trackLogFile);
			vectMatMult(temp_v1, A, temp_v2);
			for (i = 0; i < 3; i++)
				fprintf(trackFile, "%f\t", temp_v2[i]-temp_v1[i]);
			fprintf(trackFile, "%f\n", L2);
			fflush(trackFile);
			fprintf(trackLogFile, "\tDone calculating temp_v2\n");
			fflush(trackLogFile);
		} // END ITER LOOP
		fprintf(trackLogFile, "Freeing dxI1\n");
		fflush(trackLogFile);
		delete dxI1;
		fprintf(trackLogFile, "Freeing dyI1\n");
		fflush(trackLogFile);
		delete dyI1;
		fprintf(trackLogFile, "Freeing dzI1\n");
		fflush(trackLogFile);
		delete dzI1;
		fprintf(trackLogFile, "Freeing dxI2\n");
		fflush(trackLogFile);
		delete dxI2;
		fprintf(trackLogFile, "Freeing dyI2\n");
		fflush(trackLogFile);
		delete dyI2;
		fprintf(trackLogFile, "Freeing dzI2\n");
		fflush(trackLogFile);
		delete dzI2;
		fprintf(trackLogFile, "Freeing weight\n");
		fflush(trackLogFile);
		delete weight;
		fprintf(trackLogFile, "Freeing rI1->pix\n");
		fflush(trackLogFile);
		delete rI1->pix;
		fprintf(trackLogFile, "Freeing rI2->pix\n");
		fflush(trackLogFile);
		delete rI2->pix;
		fprintf(trackLogFile, "\tFreeing xI2->pix\n");
		fflush(trackLogFile);
		delete xI2->pix;
		fprintf(trackLogFile, "Done\n");
		fflush(trackLogFile);
	}
	for (i = 0; i < 6; i++) delete S[i];
	delete S;
	delete b;
	delete temp_v1;
	delete temp_v2;
	for (i = 0; i < 4; i++) {
		delete A[i];
		delete dA[i];
		delete dxA[i];
		delete dyA[i];
		delete dzA[i];
		delete temp_mat[i];
	}
	delete A;
	delete dA;
	delete dxA;
	delete dyA;
	delete dzA;
	delete temp_mat;
	delete theta;
	delete xI2;
	delete rI1;
	delete rI2;
	fclose(trackFile);
	fclose(trackLogFile);

	if (zero_overlap_flag) {
		for (i = 0; i < 4; i++) {
			for (j = 0; j < 4; j++) {
				if (i == j)
					best_A[i][j] = 1.0;
				else
					best_A[i][j] = 0.0;
			}
		}
		return -2;
	}
	return 0;
}