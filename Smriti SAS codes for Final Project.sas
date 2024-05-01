/*MODEL I Load your data */
DATA gpa;
    INFILE 'C:\Users\dell\Desktop\stat\SAS Project/gpa.txt';
    INPUT ID Y X1 X2 X3;
RUN;
PROC PRINT DATA = gpa;
run;

/* Fit a simple linear regression model with alpha=0.01 */
PROC REG DATA=gpa;
    MODEL Y = X1 /ALPHA = 0.01;
RUN;
/* Obtain residuals */
PROC REG DATA=gpa;
    MODEL Y = X1 / RESIDUALS PREDICTED;
    OUTPUT OUT=ResidualsOut;
RUN;

/* Residual Plot */
PROC SGSCATTER DATA=ResidualsOut;
    PLOT Residuals*X1;
RUN;
/* Lack of Fit Test */
PROC REG DATA=gpa;
    MODEL Y = X1 / LACKFIT ALPHA=0.05;
RUN;

/*MODEL II (a)& (b) Test linear regression model using X1 and X2 and interpret */
/*interaction term data */
DATA gpa2;
	SET gpa;
	X12 = X1*X2;
RUN;

PROC PRINT DATA =gpa2;
run;
/* reduced model  */
/* Fit a multiple linear regression model with alpha=0.05 */
PROC REG DATA=gpa2;
    MODEL Y = X1 X2 /ALPHA = 0.05;
	OUTPUT out=a p=predict r=res;
RUN;
/* (c) the full model with Interaction term X12 = X1 * X2 */
PROC REG DATA=gpa2;
    MODEL Y = X1 X2 X12 /ALPHA=0.05;
	OUTPUT out=a p=predict r=res;
RUN;
/* whether the interaction term should be included */
DATA pvalue;
	/*sum of squares error = sse */
	sse_redModel = 225.81307;
	sse_fullModel = 220.62473;
	mse = 0.31473; /*Mean square error in full model*/
	obs  = ( (sse_redModel - sse_fullModel) / 1 ) / mse;
	prob = 1-probf(obs, 1, 701); 
RUN;
PROC PRINT DATA=pvalue;
RUN;
/* Model III: Multiple linear regression using X1, X2, and X3 */

/* Fit a multiple linear regression model with alpha=0.05 */
PROC REG DATA=gpa2;
    MODEL Y = X1 X2 X3;
	OUTPUT out=a p=predict r=res;
RUN;

/* (b) Test whether beta1 = 0 and beta2 = 0.05, alpha = 0.05 */
/* Define the hypotheses:
   Null hypothesis (H0): beta1 = 0, beta2 = 0.05
   Alternative hypothesis (H1): At least one of the coefficients is not equal to the specified values */
/* Data for new y */
DATA gpa3;
	SET gpa;
	Ynew = Y - 0.05*X2;
RUN;
PROC PRINT DATA=gpa3;
RUN;
PROC REG DATA=gpa3;
    MODEL Ynew = X3;
	OUTPUT out=a p=predict r=res;
RUN;
DATA pvalue;
/*sum of squares error = sse */
	sse_redModel = 246.14532;
	sse_fullModel = 225.63654;
	mse = 0.32188; /*Mean square error in full model*/
	obs  = ( (sse_redModel - sse_fullModel) / 2 ) / mse;
	prob = 1-probf(obs, 2, 701); 
RUN;
PROC PRINT DATA=pvalue;
RUN;
*/4. compare MODEL 1and MODEL II;
DATA pvalue;
/*sum of squares error = sse */
	sse_redModel = 238.44095;
	sse_fullModel = 225.81307;
	mse = 0.32167; /*Mean square error in full model*/
	obs  = ( (sse_redModel - sse_fullModel) / 1 ) / mse;
	prob = 1-probf(obs, 1, 702); 
RUN;
PROC PRINT DATA=pvalue;
RUN;
*/ compare MODEL 1and MODEL III;
DATA pvalue;
/*sum of squares error = sse */
	sse_redModel = 238.44095;
	sse_fullModel = 225.63654;
	mse = 0.32188; /*Mean square error in full model*/
	obs  = ( (sse_redModel - sse_fullModel) / 2 ) / mse;
	prob = 1-probf(obs, 1, 701); 
RUN;
PROC PRINT DATA=pvalue;
RUN;
*/ compare MODEL 11and MODEL III;
DATA pvalue;
/*sum of squares error = sse */
	sse_redModel = 225.81307;
	sse_fullModel = 225.63654;
	mse = 0.32188; /*Mean square error in full model*/
	obs  = ( (sse_redModel - sse_fullModel) / 1 ) / mse;
	prob = 1-probf(obs, 1, 701); 
RUN;
PROC PRINT DATA=pvalue;
RUN;
