#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#include "mex.h"

/* Input Arguments */
#define XPICTURE      	prhs[0]
#define RANDOMVECTOR    prhs[1]
#define ITERATIONS      prhs[2]
#define SMAX            prhs[3]
#define NM              prhs[4]
#define PWCOR           prhs[5]
/* Output Arguments */
#define ANGLES          plhs[0]
#define MDY             plhs[1]
#define MDX             plhs[2]


#define Pi	3.14159265359

double sq(double x)
{
  double temp=x*x;
  return(fabs(temp));
}

double dist2p(double x1,double y1,double x2,double y2)
{
  return(sqrt(sq(x2-x1)+sq(y2-y1)));
}


void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
  double *X;
  double *angles,*mdy,*mdx;
  double *iterations_pointer;
  double *smax_pointer;
  double *randomvectorDB;
  double *Nm,*Pwcor;
  int found,gun,pwcor,Bok,Cok;
  unsigned long t,s,smax,iterations,ww,nm,i;
  unsigned long curpos,Xcur,circurposseek;
  unsigned long seek,seekB,seekC;
  double sd,acarg;
  double Ax,Ay;
  double Bx,By;
  double Cx,Cy;
  double B1x,B1y;
  double C1x,C1y;
  double B2x,B2y;
  double C2x,C2y;
  double dAB,dAC,dCB;
  double distanceB,lastdistanceB;
  double distanceC,lastdistanceC;
  double theta,dd1,dd2,sqrtD;
  double alpha,alpha2,alpha3,alpha4;
  double Bxplus,Bxminus;
  double Cxplus,Cxminus;
  
  X=mxGetPr(XPICTURE);
  randomvectorDB=mxGetPr(RANDOMVECTOR);
  iterations_pointer=mxGetPr(ITERATIONS);
  iterations=iterations_pointer[0];
  smax_pointer=mxGetPr(SMAX);
  smax=smax_pointer[0];
  Nm=mxGetPr(NM);
  nm=Nm[0];
  Pwcor=mxGetPr(PWCOR);
  pwcor=Pwcor[0];
  
  
  angles = mxCalloc(smax,sizeof(double));
  mdy = mxCalloc(smax,sizeof(double));
  mdx = mxCalloc(smax,sizeof(double));
  ANGLES=mxCreateDoubleMatrix(smax+1,1,mxREAL);
  MDY=mxCreateDoubleMatrix(smax+1,1,mxREAL);
  MDX=mxCreateDoubleMatrix(smax+1,1,mxREAL);

  angles=mxGetPr(ANGLES);
  mdy=mxGetPr(MDY);
  mdx=mxGetPr(MDX);
  
  for(s=0;s<=smax;s++)
  {
    angles[s]=0;
    mdy[s]=0;
    mdx[s]=0;
  }

  
  /* 1. Choose random point t */
  /* 2. Set radius s */
  /* 3. Find A, B, C. */
  /* 4. Calculate angle */
  /* 5. Increase radius s */
  /* 6. Go to 3  */
  for(t=0;t<iterations;t++)
  {
    seek=1;
    seekB=1;
    seekC=1;
    distanceB=0;
    distanceC=0;
    gun=0;
    for(s=1;s<=smax && gun==0;s++)
    {
      /*===================*/
      /* Get point A	   */
      /*===================*/
      curpos=randomvectorDB[t]; 	    /* Position of the t'th random point A */
      Ax=curpos;	       	            /* For the sake of easy understanding, */
      Ay=X[curpos];			            /* point A is stored in new variables */
      /*===================*/
      /* Seek point B	   */
      /*===================*/		    /* Point B must be to the right of point A   */
      seek=seekB;			            /* seek used as index, for searching in the */
      found=0;  			
      sd=s;
      while(!found)		       
      { 			    
  	    lastdistanceB=distanceB;	   
  	    distanceB=dist2p(Ax,Ay,curpos+seek,X[curpos+seek]);
  	    if((lastdistanceB-sd<=0 && distanceB-sd>=0) ||(lastdistanceB-sd>=0 && distanceB-sd<=0) || curpos+seek>=nm) { found=1; } else seek++;	    
  	  }
      /* Store point B */
      Bok=0;
      if(curpos+seek+1<nm)
      {
        B2x=curpos+(seek-1);
        B2y=X[curpos+(seek-1)];
        B1x=curpos+seek;
        B1y=X[curpos+seek];
        if(pwcor==1)
        {
          alpha=(B1y-B2y)/(B1x-B2x);
          alpha2=alpha*alpha; alpha4=alpha2*alpha2;
          sqrtD=sqrt(4.0*sq((alpha*B2y-alpha2*B2x-alpha*Ay-Ax))-4.0*(alpha2+1.0)*(sq(B2y-alpha*B2x-Ay)-sq(sd)+sq(Ax)));
          Bxplus =(-2.0*(alpha*B2y-alpha2*B2x-alpha*Ay-Ax)+sqrtD)/(2.0*(alpha2+1.0));
          Bxminus=(-2.0*(alpha*B2y-alpha2*B2x-alpha*Ay-Ax)-sqrtD)/(2.0*(alpha2+1.0));        
          Bx=0;
          if(fabs(distanceB-sd)<fabs(lastdistanceB-sd)) Bx=B1x; else Bx=B2x;
          if(B2x<=Bxplus  && B1x>=Bxplus)  Bx=Bxplus;          
          if(B2x<=Bxminus && B1x>=Bxminus) Bx=Bxminus;          	  
          By=alpha*Bx+B2y-alpha*B2x;
        }
        else
        {
  	      if(fabs(lastdistanceB-sd)<fabs(distanceB-sd) && seek>1)
  	      {
	        Bx=B2x; By=B2y;
  	      }
	      else
	      {
	        Bx=B1x; By=B1y;
	      }
        }
        Bok=1;
      }
      distanceB=lastdistanceB;
      seekB=seek-1;
      if(seekB<1) seekB=1;
      /*================*/
      /* Seek point C	*/
      /*================*/
      seek=seekC;
      found=0;
      while(!found)
      {
        lastdistanceC=distanceC;
        distanceC=dist2p(Ax,Ay,curpos-seek,X[curpos-seek]);
    	if((lastdistanceC-sd<=0 && distanceC-sd>=0) ||(lastdistanceC-sd>=0 && distanceC-sd<=0) || curpos-seek<=1) { found=1; } else seek++;  	   
      }
      Cok=0;
      if(curpos-seek>2)
      {
        C2x=curpos-seek;
        C2y=X[curpos-seek];
        C1x=curpos-(seek-1);
        C1y=X[curpos-(seek-1)];
        if(pwcor==1)
        { 
  	      alpha=(C1y-C2y)/(C1x-C2x);
          alpha2=alpha*alpha; alpha4=alpha2*alpha2;
          sqrtD=sqrt(4.0*sq((alpha*C2y-alpha2*C2x-alpha*Ay-Ax))-4.0*(alpha2+1.0)*(sq(C2y-alpha*C2x-Ay)-sq(sd)+sq(Ax)));
          Cxplus =(-2.0*(alpha*C2y-alpha2*C2x-alpha*Ay-Ax)+sqrtD)/(2.0*(alpha2+1.0));
          Cxminus=(-2.0*(alpha*C2y-alpha2*C2x-alpha*Ay-Ax)-sqrtD)/(2.0*(alpha2+1.0));        
          Cx=0;	
          if(fabs(distanceC-sd)<fabs(lastdistanceC-sd)) Cx=C2x; else Cx=C1x;
          if(C2x<=Cxplus  && C1x>=Cxplus)  Cx=Cxplus;          
          if(C2x<=Cxminus && C1x>=Cxminus) Cx=Cxminus;          	  
          Cy=alpha*Cx+C2y-alpha*C2x;        
        }
        else
        {
  	      if(fabs(lastdistanceC-s)<fabs(distanceC-s) && seek>1)
	      {
	        Cx=C1x;
  	        Cy=C1y;
  	      }
	      else
	      {
	        Cx=C2x;
  	        Cy=C2y;
	      }
        }
        Cok=1;
      }
      distanceC=lastdistanceC;
      seekC=seek-1;
      if(seekC<1) seekC=1;
      /*=======================*/
  	  /* Calculate angle */
      if(Bok==1 && Cok==1)
      {      
        dCB=sqrt(sq(Cx-Bx)+sq(Cy-By));
        if(pwcor==1)
        { 
          acarg=dCB/(2*sd);
	      if(acarg>=1) acarg=1.0;
	      if(acarg<=-1) acarg=-1.0;
          theta=acos(acarg); 
        }
        else
        {
          dAB=sqrt(sq(Ax-Bx)+sq(Ay-By));
          dAC=sqrt(sq(Ax-Cx)+sq(Ay-Cy));
          if(fabs((dAC*dAC+dAB*dAB-dCB*dCB)/(2.0*dAC*dAB))<1) theta=acos((dAC*dAC+dAB*dAB-dCB*dCB)/(2.0*dAC*dAB));
          if((dAC*dAC+dAB*dAB-dCB*dCB)/(2.0*dAC*dAB)>=1) theta=0;
          if((dAC*dAC+dAB*dAB-dCB*dCB)/(2.0*dAC*dAB)<=-1) theta=Pi;    
          theta=fabs(Pi-theta);
        }
        dd1=fabs(Cy-By);
        dd2=fabs(Cx-Bx);
        angles[s]=angles[s]+fabs(theta);
        mdy[s]=mdy[s]+fabs(dd1);
        mdx[s]=mdx[s]+fabs(dd2);
      }      
    }
  }
  for(s=1;s<=smax;s++)
  {
    angles[s]=angles[s]/iterations;
    mdy[s]=mdy[s]/iterations;
    mdx[s]=mdx[s]/iterations;
  }
}
