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
#define KN           prhs[3]
#define KM           prhs[4]

/* Output Arguments */
#define PIC2       plhs[0]

#define Pi	3.14159265359

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
  double *Pp1,*Pp2,*Sm;
  double *pic,*pic2;
  int p1,p2,NM,S;  
  int i,j,s1,s2;  
  int N,M,n,m;
  double sum;
  double sqS1;
  pic           = mxGetPr(PIC);  
  Pp1 	        = mxGetPr(P1);
  Pp2	        = mxGetPr(P2);
  Kn	        = mxGetPr(KN);
  Km	        = mxGetPr(KM);
  N=Pp1[0];
  M=Pp2[0];
  kn=Kn[0];
  km=Km[0];
  NM=N*M;
	
  
  pic2= mxCalloc(N*M,sizeof(double));	
  PIC2= mxCreateDoubleMatrix(1,N*M,mxREAL);
  pic2= mxGetPr(PIC2);
 
  sqS1=(S+1)*(S+1);
 

    for(n=0;n<N-kn;n=n+kn)
    {
      for(m=0;m<M-kn;m=m+km)
      {
        sum=0.0;
        for(s1=0;s1<=S;s1++)
        {
          for(s2=0;s2<=S;s2++)
          {
            sum=sum+pic[N*(m+s1)+(n+s2)];
            /* */
            i++;
          }
        }
        pic2[N*m+n]=sum/sqS1;
      }
    }
  for(n=0;n<N;n++) pic2[n]=pic2[N+n];
  for(n=0;n<N;n++) pic2[N*(M-1)+n]=pic2[N*(M-2)+n];
  for(m=0;m<M;m++) pic2[N*m+0]=pic2[N*m+1];
  for(m=0;m<M;m++) pic2[N*m+N-1]=pic2[N*m+N-2];
  /* [n,m] = N*m+n */
  
  
  }