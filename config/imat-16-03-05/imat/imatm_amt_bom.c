#include <math.h>
#include <stdlib.h>
#include "mex.h"

/* Input Arguments */
#define DIG_S_Y				prhs[0]
#define SMAX	         	prhs[1]
#define S_BEGIN         	prhs[2]
#define ITER					prhs[3]
#define LENG         		prhs[4]
#define RAND_VEKTOR        prhs[5]
#define ATTENUATE        prhs[6]
#define AMPLIFY            prhs[7]


/* Output Arguments */
#define AMT           	plhs[0]
#define MDY					plhs[1]
#define MDX					plhs[2]

#define Pi	3.14159265359

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	double *Dig_s_y, *S_end, *Iter,*Rand_vekt,*Smax;
	double *amt,vinkel;
	double *mdy,*mdx;
	double dx;
	double pp,dd;
	int *Attenuate,*Amplify;
    int  attenuate,amplify;
	unsigned long rand_vektor[2000000];
    unsigned long	iter,i,point_c,point_xa,point_xb,point_xc,s;
	unsigned long smax;
    double point_ya,point_yb,point_yc;
    double m1,m2,theta,dxca,dxbc;

    
    
	Dig_s_y		= mxGetPr(DIG_S_Y);
	Smax 		= mxGetPr(SMAX);
	Iter 			= mxGetPr(ITER);
    Rand_vekt   = mxGetPr(RAND_VEKTOR);
    Attenuate  = mxGetPr(ATTENUATE);
    Amplify  = mxGetPr(AMPLIFY);
    
	iter      	= Iter[0];
	smax	= Smax[0];
	attenuate=Attenuate[0];
	amplify=Amplify[0];
	
 	for(i=0;i<iter;i++) rand_vektor[i]  = Rand_vekt[i];
 	
 	/* Allocate output arrays */
	amt = mxCalloc(smax,sizeof(double));
	mdy = mxCalloc(smax,sizeof(double));
	mdx = mxCalloc(smax,sizeof(double));
	
   /* Allocate and assign output pointers */
	AMT	= mxCreateDoubleMatrix(smax+1,1,mxREAL);
    MDY= mxCreateDoubleMatrix(smax+1,1,mxREAL);
    MDX= mxCreateDoubleMatrix(smax+1,1,mxREAL);
    
    /* Assign arrays with pointers */
	amt = mxGetPr(AMT);
    mdy = mxGetPr(MDY);
    mdx = mxGetPr(MDX);    
    
    for(s=1;s<=smax;s++) { amt[s]=0;	mdy[s]=0; mdx[s]=0; }
    pp=0.0;
    for(i=0;i<iter;i++)
    {
      point_c=rand_vektor[i];
      point_yc=Dig_s_y[point_c];     
      pp=pp+1.0;
      dx=0.0;
      for(s=1;s<=smax;s++)
      {
        dx=dx+1.0;
        point_ya=Dig_s_y[point_c+s];
        point_yb=Dig_s_y[point_c-s];
        m1=atan((point_ya-point_yc)/(dx));
        m2=atan((point_yc-point_yb)/(-dx));
        theta=m1+m2;        
        dd=point_yb-point_ya;      

      amt[s]= amt[s] + fabs(theta);      
      mdy[s] = mdy[s] + fabs(dd);
      mdx[s] = mdx[s] + 2*s;    

      
  }
  }
  
  for(s=1;s<=smax;s++)
  {
      amt[s]= amt[s]/pp;
      mdy[s] = mdy[s]/pp;
      mdx[s] = mdx[s]/pp;      
  }
  
}

