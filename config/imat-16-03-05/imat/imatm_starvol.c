#include <math.h>
#include <stdlib.h>
#include "mex.h"

/* Input Arguments */
#define X	      	prhs[0]
#define N	      	prhs[1]
#define M	      	prhs[2]
#define CUTOFF_LOWER prhs[3]
#define CUTOFF_UPPER prhs[4]
#define ITER					prhs[5]
#define RANDX     prhs[6]
#define RANDY     prhs[7]

/* Output Arguments */
#define SIZEX           	plhs[0]
#define SIZEY           	plhs[1]
#define PITER               plhs[2]
#define Y                   plhs[3]

#define Pi	3.14159265359

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	double *x,*nn,*mm,*Cutoff_lower,*Cutoff_upper, *Iter,*randx,*randy,*y;
	double *sizex,*sizey,*piter;
	double s1,s2,s3,s4;
	int n,m,cutoff_lower,cutoff_upper;
    int iter,i,j,s,a,b;
    unsigned long p,ij;

	x 		= mxGetPr(X);
	nn 		= mxGetPr(N);
	mm	= mxGetPr(M);
	Cutoff_lower	= mxGetPr(CUTOFF_LOWER);
    Cutoff_upper	= mxGetPr(CUTOFF_UPPER);
	Iter 			= mxGetPr(ITER);
   	randx 			= mxGetPr(RANDX);
   	randy 			= mxGetPr(RANDY);   	
   	
	iter= Iter[0];
	n=nn[0];
	m=mm[0];
	cutoff_lower=Cutoff_lower[0];
	cutoff_upper=Cutoff_upper[0];	
	
	sizex = mxCalloc(iter+1,sizeof(double));	
	SIZEX	= mxCreateDoubleMatrix(iter,1,mxREAL);
	sizex=mxGetPr(SIZEX);		
    sizey = mxCalloc(iter+1,sizeof(double));	
	SIZEY	= mxCreateDoubleMatrix(iter,1,mxREAL);	
	sizey=mxGetPr(SIZEY);
    y= mxCalloc(n*m,sizeof(double));	
    Y	= mxCreateDoubleMatrix(n*m,1,mxREAL);	
	y=mxGetPr(Y);
	piter= mxCalloc(1,sizeof(double));	
	PITER	= mxCreateDoubleMatrix(1,1,mxREAL);	
	piter=mxGetPr(PITER);
	
	
    p=0;
    
    /*Fold back chop1*/
    ij=0;
/*
    for(i=0;i<n;i++) for(j=0;j<m;j++)    { *(y+i*m+j)=x[ij]; ij++; }
    */
    
    for(i=0;i<iter;i++)
    {
      a=randx[i]-1;
      b=randy[i]-1;
      if(x[a*m+b]>cutoff_lower && x[a*m+b]<cutoff_upper)
      {

      s=0;
        while(a+s<n && x[(a+s)*m+b]>cutoff_lower && x[(a+s)*m+b]<cutoff_upper) s++;
        s1=s;
        s=0;
                while(a-s>0 && x[(a-s)*m+b]>cutoff_lower && x[(a-s)*m+b]<cutoff_upper) s++;
        s2=s;
         s=0;        
                while(b+s<m && x[a*m+b+s]>cutoff_lower && x[a*m+b+s]<cutoff_upper)  s++; 
        s3=s;
        s=0;
                while(b-s>0 && x[a*m+b-s]>cutoff_lower && x[a*m+b-s]<cutoff_upper) s++;
        s4=s;
        sizex[p]=s1+s2;
        sizey[p]=s3+s4;
        p++;
   
      }
   }
  piter[0]=p-1;
}

