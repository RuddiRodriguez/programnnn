/* PIC = unfolded picture,  reshape(pic,1,p1*p2) */
/* P1  = rows */
/* P2  = cols */
/* BGVALUE1 = LOWER*/
/* BGVALUE2 = UPPER */
/* CHKPOINT = initial checkpoints */
/* NCHK     = number of checkpoints */

#include <math.h>
#include <stdlib.h>
#include "mex.h"

/* Input Arguments */
#define PIC	      	 prhs[0]
#define P1           prhs[1]  /* rows */
#define P2           prhs[2]  /* cols */
#define SM           prhs[3]  /* submatrixsize  1 -> 3x3 */
#define CUT	      	 prhs[4]
#define PIXN    	 prhs[5]

/* Output Arguments */
#define PIC2       plhs[0]

#define Pi	3.14159265359

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
  double *Pp1,*Pp2,*Sm,*Cut,*Pixn;
  double *pic,*pic2;
  int p1,p2,NM,S,cut,pixn;  
  int i,j,s1,s2;  
  int N,M,n,m;
  double max,min,pixel,xn;
  
  pic           = mxGetPr(PIC);  
  Pp1 	        = mxGetPr(P1);
  Pp2	        = mxGetPr(P2);
  Sm	        = mxGetPr(SM);
  Cut	        = mxGetPr(CUT);
  Pixn	        = mxGetPr(PIXN);
  N=Pp1[0];
  M=Pp2[0];
  S=Sm[0];
  cut=Cut[0];
  pixn=Pixn[0];
  
  NM=N*M;
	
  
  pic2= mxCalloc(N*M,sizeof(double));	
  PIC2= mxCreateDoubleMatrix(1,N*M,mxREAL);
  pic2= mxGetPr(PIC2);
 
 

    for(n=S;n<N-S;n++)
    {
      for(m=S;m<M-S;m++)
      {
       xn=0;
      /*=================*/
        /* Analyse subcell */
        min=1e30;
        max=-1e30;
        for(s1=-S;s1<=S;s1++)
        {
          for(s2=-S;s2<=S;s2++)
          {
            pixel=pic[N*(m+s1)+(n+s2)];
            if(pixel<cut) xn++;
            if(pixel<min) min=pixel;
            if(pixel>max) max=pixel;
          }
        }
        /* ===================*/
        /* 1. Process subcell */
        if(xn>=pixn)
        {
          for(s1=-S;s1<=S;s1++)
          {
            for(s2=-S;s2<=S;s2++)
            {
              pic2[N*(m+s1)+(n+s2)]=min;
            }            
          }        
        }
        /*====================*/
        /* 2. Process subcell */
        if(xn<pixn)
        {
          for(s1=-S;s1<=S;s1++)
          {
            for(s2=-S;s2<=S;s2++)
            {
              pic2[N*(m+s1)+(n+s2)]=max; /*pic[N*(m+s1)+(n+s2)];*/
            }            
          }        
        }                   
      }
    }
  for(n=0;n<N;n++) pic2[n]=pic2[N+n];
  for(n=0;n<N;n++) pic2[N*(M-1)+n]=pic2[N*(M-2)+n];
  for(m=0;m<M;m++) pic2[N*m+0]=pic2[N*m+1];
  for(m=0;m<M;m++) pic2[N*m+N-1]=pic2[N*m+N-2];
  /* [n,m] = N*m+n */
  
  
  }