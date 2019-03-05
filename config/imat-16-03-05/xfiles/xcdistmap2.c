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
#define RIVERX       prhs[3] 
#define RIVERY       prhs[4]
#define SR           prhs[5]

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
  Sm	        = mxGetPr(SM);
  N=Pp1[0];
  M=Pp2[0];
  S=Sm[0];
  NM=N*M;
	
  
  pic2= mxCalloc(N*M,sizeof(double));	
  PIC2= mxCreateDoubleMatrix(1,N*M,mxREAL);
  pic2= mxGetPr(PIC2);
 
  sqS1=(S+1)*(S+1);
 

    for(s1=0;s1<sr;s1++)
    {
      for(s2=s1+1;s2<sr;s2++)
      {
        x1=riverx[s1];
        y1=rivery[s1];
        x2=riverx[s2];
        y2=rivery[s2];
        dist=sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
        dx=(x1-x2)/dist;
        dy=(y1-y2)/dist;
        for(x=x1;x<=x2;x=x+dx)
        {
          for(y=y1;y<=y2;y=y+dy)
          {
            pic[N*(m+x1)+(n+x2)]=;
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