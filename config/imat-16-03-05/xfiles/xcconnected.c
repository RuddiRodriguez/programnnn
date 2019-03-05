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
#define BGVALUE1	 prhs[3]
#define BGVALUE2	 prhs[4]
#define CHKPOINTS    prhs[5]
#define NCHK         prhs[6]
#define DUMMY        prhs[7]

/* Output Arguments */
#define BACKGROUND       plhs[0]

#define Pi	3.14159265359

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
  double *picd,*Pp1,*Pp2;
  double *Bgvalue1,*Bgvalue2,*Nchk;
  double *pic;
  double *chkpoints,*newchkpoints,*runchkpoints;  
  double *background;
  int p1,p2,p1p2,nchk;  
  int i,j,N,newN,n;
  int bgvalue1,bgvalue2;
  int runchkpoints_n1,runchkpoints_n2;
  
  
  pic           = mxGetPr(PIC);  
  Pp1 	        = mxGetPr(P1);
  Pp2	        = mxGetPr(P2);
  Bgvalue1 	= mxGetPr(BGVALUE1);
  Bgvalue2	= mxGetPr(BGVALUE2);
  Nchk      = mxGetPr(NCHK);
  chkpoints = mxGetPr(CHKPOINTS);

  p1=Pp1[0];
  p2=Pp2[0];
  p1p2=p1*p2;
  nchk=Nchk[0];
  bgvalue1=Bgvalue1[0];
  bgvalue2=Bgvalue2[0];
	
  
  background= mxCalloc(p1*p2,sizeof(double));	
  BACKGROUND= mxCreateDoubleMatrix(1,p1*p2,mxREAL);
  background= mxGetPr(BACKGROUND);
  
  newchkpoints= mxCalloc(2*p1*p2,sizeof(double)); 
  DUMMY       = mxCreateDoubleMatrix(1,2*p1*p2,mxREAL);	
  newchkpoints=mxGetPr(DUMMY);
  
  runchkpoints= mxCalloc(2*p1*p2,sizeof(double)); 
  DUMMY       = mxCreateDoubleMatrix(1,2*p1*p2,mxREAL);	
  runchkpoints=mxGetPr(DUMMY);
  
  for(i=0;i<nchk;i++)
  {
    runchkpoints[i]=chkpoints[i];
    runchkpoints[i+p1p2]=chkpoints[i+nchk];
  }

  
  
  N=1;
  while(N!=0)
  {
    newN=0;
    for(n=0;n<N;n++)
    {
      for(i=-1;i<=1;i++)
      {
        for(j=-1;j<=1;j++)
        {
          runchkpoints_n1=runchkpoints[n];
          runchkpoints_n2=runchkpoints[n+p1p2];
          if(runchkpoints_n1+i>=0 && runchkpoints_n2+j>=0 && runchkpoints_n1+i<p1 && runchkpoints_n2+j<p2)
  	      {
            if(pic[runchkpoints_n1+i+(runchkpoints_n2+j)*p1]>bgvalue1  && pic[runchkpoints_n1+i+(runchkpoints_n2+j)*p1]<=bgvalue2 && background[runchkpoints_n1+i+(runchkpoints_n2+j)*p1]==0)
            {
              newchkpoints[newN]=runchkpoints_n1+i;
              newchkpoints[newN+p1p2]=runchkpoints_n2+j;
	          newN++;
              background[runchkpoints_n1+i+(runchkpoints_n2+j)*p1]=1;
	        }
	      }            
        }
      }
    }
    N=newN;
    for(i=0;i<N;i++) 
    {
      runchkpoints[i]=newchkpoints[i];
      runchkpoints[i+p1p2]=newchkpoints[i+p1p2];
    }
  }
}


