#include <math.h>
#include <stdlib.h>
#include "mex.h"
/*        [angle,mdy]=amt_2dSQ(y',N,M,hill_cutoff_off,hill_cutoff_on,Piter1,Piter2,Randx1,Randy1,Randx2,Randy2);*/

/* Input Arguments */
#define X	      	prhs[0]
#define N	      	prhs[1]
#define M	      	prhs[2]
#define CUTOFF_LOWER prhs[3]
#define CUTOFF_UPPER prhs[4]
#define ITER1	   prhs[5]
#define ITER2	   prhs[6]
#define RANDX1     prhs[7]
#define RANDY1     prhs[8]
#define RANDX2     prhs[9]
#define RANDY2     prhs[10]

/* Output Arguments */
#define YDATA           	plhs[0]

#define Pi	3.14159265359

double sq(double x)
{
  return(x*x);
}


void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	double *x,*nn,*mm,*Cutoff_lower,*Cutoff_upper, *Iter1, *Iter2,*randx1,*randy1,*randx2,*randy2;
	double *ydata;
	double sd,mdy,theta;
	int n,m,cutoff_lower,cutoff_upper;
    int iter1,iter2,i,j,s,smax;
    int px1,py1,px2,py2;
    unsigned long p;

	x 		= mxGetPr(X);
	nn 		= mxGetPr(N);
	mm	= mxGetPr(M);
	Cutoff_lower	= mxGetPr(CUTOFF_LOWER);
    Cutoff_upper	= mxGetPr(CUTOFF_UPPER);
	Iter1 			= mxGetPr(ITER1);
    Iter2 			= mxGetPr(ITER2);
   	randx1 			= mxGetPr(RANDX1);
   	randy1 			= mxGetPr(RANDY1);   	
   	randx2 			= mxGetPr(RANDX2);
   	randy2 			= mxGetPr(RANDY2);   	

   	
	iter1= Iter1[0];
	iter2= Iter2[0];
	n=nn[0];
	m=mm[0];
	cutoff_lower=Cutoff_lower[0];
	cutoff_upper=Cutoff_upper[0];	
	

	ydata = mxCalloc((n*n+m*m)+1,sizeof(double));	
	YDATA	= mxCreateDoubleMatrix((n*n+m*m),1,mxREAL);
	ydata=mxGetPr(YDATA);		
    

for(i=0;i<=n*n+m*m;i++)
{
  ydata[i]=0;
}

    p=0;
    for(i=0;i<iter1;i++)
    {
      px1=randx1[i]-1;
      py1=randy1[i]-1;
      for(j=0;j<iter2;j++)
      {
        px2=randx2[j]-1;
        py2=randy2[j]-1;
      
        sd=sq(px1-px2)+sq(py1-py2);
        
        s=sd;
        if(s>0)
        {
        mdy=x[px1*m+py1]-x[px2*m+py2];
        theta=atan(mdy/sqrt(sd));     
        ydata[s]=ydata[s]+abs(mdy);
        p++;
        }
      }

   }
/*
   for(s=0;s<=(n*n+m*m);s++)
   {
     ydata[s]=ydata[s]/p;
   }
   */
}

