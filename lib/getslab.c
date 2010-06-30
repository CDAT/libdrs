/*
     getslab.c,v 2.8 1995/03/30 00:50:57 drach Exp
     getslab.c,v
 * Revision 2.8  1995/03/30  00:50:57  drach
 * Added disclaimer
 *
 * Revision 2.7  1993/10/20  17:18:41  drach
 * Make data char * uniformly, for Unicos.
 *
 * Revision 2.6  1993/07/14  22:31:00  drach
 * Removed text after #endif, etc.
 *
 * Revision 2.5  1993/07/13  01:13:10  drach
 * Merged Sun, Unicos, SGI, and HP versions.
 *
 * Revision 2.4  1993/06/16  18:12:01  drach
 * Add error message when buffer memory cannot be obtained.
 *
 * Revision 2.3  1993/01/05  02:05:04  drach
 * Modified to use getpelem for PROGRAM representation, rather than getelemd
 * for file representation.
 *
 * Revision 2.2  1992/08/07  21:36:50  drach
 * Added extern declaration for getnd, to fix
 * bug in SGI version.
 *
 * Revision 2.1  1992/05/22  01:09:39  drach
 * - Moved error messages to stderr;
 * - call free(buf) after errors
 *
 * Revision 2.0  1992/03/07  00:12:24  drach
 * Entered into RCS
 *
                     Data Retrieval and Storage System

**********************************************************************

			DISCLAIMER

   This software was prepared as an account of work sponsored by an
   agency of the United States Government. Neither the United
   States Government nor the University of California nor any of
   their employees, makes any warranty, express or implied, or
   assumes any liability or responsibility for the accuracy,
   completeness, or usefulness of any information, apparatus,
   product, or process disclosed, or represents that its use would
   not infringe privately owned rights. Reference herein to any
   specific commercial products, process, or service by trade name,
   trademark, manufacturer, or otherwise, does not necessarily
   constitute or imply its endorsement, recommendation, or favoring
   by the United States Government or the University of California.
   The views and opinions of authors expressed herein do not
   necessarily state or reflect those of the United States
   Government or the University of California, and shall not be
   used for advertising or product endorsement purposes.
   
**********************************************************************/
#include <stdio.h>
#ifdef mac
#include <stdlib.h>
#include <string.h>
#else
#include <malloc.h>
#endif
//#include <memory.h>
#include <math.h>
#include "drscdf.h"


#ifdef cray
#define Drscall(X,E) E=X;\
	if(Drstest(E)) \
        {fprintf(stderr,"Fatal error in %s, line %d\n",ROUTINE,__LINE__);\
	 return(E);\
	}
#define Drscall2(X,E) E=X;\
	if(Drstest(E)) \
        {fprintf(stderr,"Fatal error in %s, line %d\n",ROUTINE,__LINE__);\
	 free(buf);\
	 return(E);\
	}

#endif				/* cray */

#if defined(sun) || defined(sgi)

#define Drscall(X,E) E=X;\
	if(drstest_(&E)) \
        {fprintf(stderr,"Fatal error in %s, line %d\n",ROUTINE,__LINE__);\
	 return(E);\
	}
#define Drscall2(X,E) E=X;\
	if(drstest_(&E)) \
        {fprintf(stderr,"Fatal error in %s, line %d\n",ROUTINE,__LINE__);\
	 free(buf);\
	 return(E);\
	}
#endif /* sun||sgi */

#ifdef hpux
#define Drscall(X,E) E=X;\
	if(drstest(&E)) \
        {fprintf(stderr,"Fatal error in %s, line %d\n",ROUTINE,__LINE__);\
	 return(E);\
	}
#define Drscall2(X,E) E=X;\
	if(drstest(&E)) \
        {fprintf(stderr,"Fatal error in %s, line %d\n",ROUTINE,__LINE__);\
	 free(buf);\
	 return(E);\
	}
#endif /* hpux */

#define Swap(A,B,C) {C=B;B=A;A=C;}
#define SetRoutine(X) char *ROUTINE=X
#define MXDIM 4			/* Max number of dimensions in DRS variable */
#ifdef mac
static void *buf;
#else	
static char *buf;		/* Input buffer */
#endif
static int bpe;		/* Bytes per element */
static int actdimlen[MXDIM],actdimu[MXDIM];	/* Actual dimension lengths returned */
static float cyfe[MXDIM], cyle[MXDIM],cyfu[MXDIM],cylu[MXDIM]; /* Actual first, last values of dimensions. */

#ifdef cray
extern int Setdim(),Getpelem(),Inqdict(),Getdat(),Getdim(),Getrge2(),
	Drstest(),Setvdim(),Seterr();
fortran int SETCDIM(),GETDRSER();
/* Fortran interface */
int
GETSLAB(lu,rank,order,fe,le,cycle,data,datadim)
	int *lu,*rank,order[],datadim[];
	float fe[],le[],cycle[];
	char data[];
{
	int getslab_(int *,int *,int *,float *,float *,float *,char *,int *);
	return(getslab_(lu,rank,order,fe,le,cycle,data,datadim));
}	

#endif /* cray */

#if defined(sun) || defined(sgi)

extern int setdim_(),getpelem_(),inqdict_(),getdat_(),getdim_(),
	getrge2_(),drstest_(),setvdim_(),setcdim_(),getnd_();

#endif /* sun||sgi */

#ifdef hpux

extern int setdim(),getpelem(),inqdict(),getdat(),getdim(),
	getrge2(),drstest(),setvdim(),setcdim(),getnd();

#endif /* hpux */
/**********************************************************************

      Routine: 
      -------                                                        */

#ifdef hpux
int getslab(lu,rank,order,fe,le,cycle,data,datadim)
#else /* !hpux */
int getslab_(lu,rank,order,fe,le,cycle,data,datadim)
#endif
	int *lu,*rank,order[],datadim[];
	float fe[],le[],cycle[];
	char data[];

                                                                     /*
      Description:
      -----------

      Read a slab of data, from a DRS data variable. A slab of data
      is a rectangular, multidimensional section of the data variable
      defined by the user dimension ranges [fe[],le[]]. If a user
      dimension range is larger than the variable dimension range
      and wraparound is specified (cycle[i] != 0.0) then the dimension
      is treated as circular, and the data is wrapped around, in that
      dimension. If wraparound is not specified (cycle[i]=0.0) then
      only that portion of the dimension which intersects the data
      variable is returned.
      

      Arguments:
      ---------

      lu    =: Fortran logical unit number of DRS file
      rank  =: number of dimension in the variable
      order =: array of dimension numbers, of length rank (Note 1)
      fe    =: array of dimension first elements, of length rank (Note 2)
      le    =: array of dimension last elements, of length rank (Note 2)
      cycle =: array of dimension cycles, of length rank (Note 5)
      data   := returned data array
      datadim =: number of elements in each dimension
      
      Function Returns:
      ----------------
        0: success
      
      Author: Bob Drach
      ------

      Date: 3/8/90
      ----

      Notes:
      -----
      (1) If no transposition of dimensions is desired, specify
      orders=[1 2 ... rank]; otherwise the ith dimension returned
      will be order[i-1].

      (2) The range [fe[i],le[i]] may be larger than the actual
      range of dimension values (in the data file). If cycle != 0.0,
      then the dimensions will be treated as circular, and the
      data will be read with wraparound.

      (3) Setname should be called before Getslab.

      (4) Data is returned in Fortran order (first dimension varying
      most rapidly.

      (5) Specify cycle[i-1]=0.0 if
      no wraparound is desired for the ith dimension. It is an error
      if cycle[i] < 0.0 or cycle[i] <= actual dimension range.


      Glossary: (All arrays are in file dimension ordering.)
      --------
      dtype: dimension type
      bufdim: dimensions of current buffer array
      offset: offset into user array
      dfe: file first element
      dle: file last element
      dmin: buffer first element
      dmax: buffer last element
      fefrom: user first element
      lefrom: user last element
      cyclefrom: user cycle
      orderfrom: 1-origin permutation vector, mapping buffer to user array
      datadimfrom: user array dimensions
      d: permutation vector, mapping file to user dimensions
      dimlen: file dimension length

**********************************************************************/
{
	
	int err,i,etype,saveunit,saverep,dum,fatallevel,rankf,usecycle=1;
	DRS_NAME name[MXDIM];
	DRS_UNITS unit[MXDIM];
	int dtype[MXDIM],bufdim[MXDIM],offset[MXDIM],oper,ndim;
	float dfe[MXDIM],dle[MXDIM],dmin[MXDIM],dmax[MXDIM];
	float fefrom[MXDIM],lefrom[MXDIM],cyclefrom[MXDIM];
	int orderfrom[MXDIM],datadimfrom[MXDIM],d[MXDIM],dimlen[MXDIM];
	
	SetRoutine("getslab_");
				/* Translate to file dimension ordering. */
	for(i=0; i<MXDIM; i++)
	{
		d[i]= i<*rank ? order[i]-1 : i;
		fefrom[d[i]]= i<*rank ? fe[i] : 0.0;
		lefrom[d[i]]= i<*rank ? le[i] : 0.0;
		cyclefrom[d[i]]= i<*rank ? cycle[i] : 0.0;
		orderfrom[i]=i+1; /* Will use DRS to do the transposition */
				  /* so buffer and user array dimensions */
				  /* will be ordered the same. */
		datadimfrom[d[i]]= i<*rank ? datadim[i] : 1;
		bufdim[i]=1;
	}
	
				/* Initialize read buffer */
	if((buf=(void *)malloc(sizeof(void *))) == NULL) 
	{
		fprintf(stderr,"Error in routine getslab_: cannot allocate memory.\n");
		return(IDRS_NOMEMORY);
	}
	
				/* Inquire the current variable. */
	oper=IDRS_GETFIRSTVAR;
	fatallevel=IDRS_FATAL;
	
#ifdef cray
	Drscall2(GETDRSER(&saveunit,&saverep,&dum),err);
	Drscall2(Seterr(saveunit,fatallevel),err);
	Drscall2(Inqdict(*lu,oper),err);

#endif /* cray */

#if defined(sun) || defined(sgi)

	Drscall2(getdrser_(&saveunit,&saverep,&dum),err);
	Drscall2(seterr_(&saveunit,&fatallevel),err);
	Drscall2(inqdict_(lu,&oper),err);

#endif /* sun||sgi */

#ifdef hpux

	Drscall2(getdrser(&saveunit,&saverep,&dum),err);
	Drscall2(seterr(&saveunit,&fatallevel),err);
	Drscall2(inqdict(lu,&oper),err);

#endif /* hpux */

	while(err==IDRS_INEXACTMATCH)
	{
		oper=IDRS_GETNEXTVAR;
#ifdef cray
		Drscall2(Inqdict(*lu,oper),err);

#endif /* cray */

#if defined(sun)||defined(sgi)
		Drscall2(inqdict_(lu,&oper),err);

#endif /* sun||sgi */

#ifdef hpux
		Drscall2(inqdict(lu,&oper),err);

#endif /* hpux */
	}		
		
	if(err!=IDRS_SUCCESS)
	{
		fprintf(stderr,"Error in routine getslab_: no matching variable.\n");
		free(buf);
		return(IDRS_VDBNOTFOUND);
	}
#ifdef cray
	Drscall2(Seterr(saveunit,saverep),err);
				/* Get rank and check */
	GETND(&rankf);

#endif /* cray */

#if defined(sun)||defined(sgi)

	Drscall2(seterr_(&saveunit,&saverep),err);
				/* Get rank and check */
	getnd_(&rankf);
#endif /* sun||sgi */

#ifdef hpux

	Drscall2(seterr(&saveunit,&saverep),err);
				/* Get rank and check */
	getnd(&rankf);
#endif /* hpux */
	if(rankf!=*rank)
	{
		fprintf(stderr,"Error in routine getslab_: rank does not match file rank.\n");
		fprintf(stderr,"Input rank=%d, file rank=%d.\n",*rank,rankf);
		free(buf);
		return(-1);
	}
	
				/* Get dimension info. */
	for(i=0; i<*rank; i++)
	{
		ndim=i+1;
		name[i][IDRS_NAMELEN-1]=unit[i][IDRS_UNITSLEN-1]='\0';
		

#ifdef cray
		Drscall2(Getdim(ndim,name[i],unit[i],&dtype[i],&dimlen[i],
			&dfe[i],&dle[i]),err);

#endif /* cray */

#if defined(sun)||defined(sgi)
		Drscall2(getdim_(&ndim,name[i],unit[i],&dtype[i],&dimlen[i],
			&dfe[i],&dle[i],IDRS_NAMELEN-1,IDRS_UNITSLEN-1),err);
#endif /* sun||sgi */

#ifdef hpux
		Drscall2(getdim(&ndim,name[i],unit[i],&dtype[i],&dimlen[i],
			&dfe[i],&dle[i],IDRS_NAMELEN-1,IDRS_UNITSLEN-1),err);
#endif /* hpux */
	}
				/* Check that cycle is reasonable. */
	for(i=0; i<*rank; i++)
	{
		if(cyclefrom[i]==0.0) continue;
		if(cyclefrom[i]<0.0 || (dfe[i]+cyclefrom[i])<=dle[i])
		{
			fprintf(stderr,"Error in routine %s: cycle=%f is negative or too small.\n",
			       ROUTINE,cyclefrom[i]);
			free(buf);
			return(-2);
		}
	}		
				/* Get program element byte length */
#ifdef cray
	Drscall2(Getpelem(&etype,&bpe),err);
#endif /* cray */

#if defined(sun)||defined(sgi)
	Drscall2(getpelem_(&etype,&bpe),err);
#endif /* sun||sgi	 */

#ifdef hpux
	Drscall2(getpelem(&etype,&bpe),err);
#endif /* hpux */
				/* Initialize user array offset.*/
	for(i=0; i<MXDIM; i++)
		offset[i]=0;
	    
				/* Get the data */
	if((err=getslab1(*lu,*rank,orderfrom,fefrom,lefrom,cyclefrom,name,
		     dfe,dle,datadimfrom,data,*rank-1,bufdim,offset,dmin,dmax,bpe,d,dtype)))
	{
		fprintf(stderr,"Error getting data in routine %s, line %d\n",ROUTINE,__LINE__);
		free(buf);
		return(err);
	}

				/* Set cycle stuff for subsequent getcdim call */
	for(i=0;i<MXDIM;i++)
	{
		cyfu[i]=cyfe[d[i]];
		cylu[i]=cyle[d[i]];
		actdimu[i]=actdimlen[d[i]];
	}
	
#ifdef cray
	Drscall2(SETCDIM(rank,cyfu,cylu,fe,le,cycle,actdimu,&usecycle),err);
#endif /* cray */

#if defined(sun)||defined(sgi)
	Drscall2(setcdim_(rank,cyfu,cylu,fe,le,cycle,actdimu,&usecycle),err);
#endif /* sun||sgi */

#ifdef hpux
	Drscall2(setcdim(rank,cyfu,cylu,fe,le,cycle,actdimu,&usecycle),err);
#endif /* hpux */
	
	free(buf);
	return(IDRS_SUCCESS);
}

int
getslab1(lu,rank,order,fe,le,cycle,name,dfe,dle,datadim,data,dim,bufdim,offset,dmin,dmax,nbytes,d,dtype)
	int lu,rank,order[],datadim[],dim,nbytes,offset[],d[],dtype[],bufdim[];
	float fe[],le[],cycle[],dfe[],dle[],dmin[],dmax[];
	char *data;
	DRS_NAME name[];
{
	int err,dlen,i,idmin,idmax,ndim,idim,
	     datadimto[MXDIM],bufdimto[MXDIM],offsetto[MXDIM],reverse,setfirst=1;
	double n;
	float dlow,dhigh,temp;
	
	SetRoutine("getslab1");
				/* If dimension <= 0, get the data */
	
	if(dim < 0) 
	{
				/* Set the dimension ranges */
				/* Note: DRS will do the transposition of dimensions.*/

		for(i=0; i<rank; i++)
		{
			ndim=i+1;
			idim=0;
			switch (dtype[d[i]])
			{
			  case IDRS_EQUALLY_SPACED:
#ifdef cray
				Drscall(Setdim(ndim,name[d[i]]," ",idim,dmin[d[i]],dmax[d[i]]),err);
#endif /* cray */

#if defined(sun)||defined(sgi)
				Drscall(setdim_(&ndim,name[d[i]]," ",&idim,&dmin[d[i]],&dmax[d[i]],strlen(name[d[i]]),strlen(" ")),err);
#endif /* sun||sgi */

#ifdef hpux
				Drscall(setdim(&ndim,name[d[i]]," ",&idim,&dmin[d[i]],&dmax[d[i]],strlen(name[d[i]]),strlen(" ")),err);
#endif /* hpux */
				break;
			  case IDRS_UNEQUALLY_SPACED:
#ifdef cray
				Drscall(Setvdim(ndim," ",name[d[i]]," "," ",dmin[d[i]],dmax[d[i]]),err);
#endif /* cray */

#if defined(sun)||defined(sgi)
				Drscall(setvdim_(&ndim," ",name[d[i]]," "," ",&dmin[d[i]],&dmax[d[i]],1,strlen(name[d[i]]),1,1),err);
#endif /* sun||sgi */

#ifdef hpux
				Drscall(setvdim(&ndim," ",name[d[i]]," "," ",&dmin[d[i]],&dmax[d[i]],1,strlen(name[d[i]]),1,1),err);
#endif /* hpux */
				break;
			}
		}
			
				/* Extend buffer size, if necessary. */
		if((buf=(void *)realloc(buf,nbytes)) == NULL){
			fprintf(stderr,"Cannot extend getslab buffer to %d bytes. \nTry using routine getdat or reading in increments?\n",nbytes);
			return(IDRS_NOMEMORY);
		}
			
				/* Get the data */
#ifdef cray
		Drscall(Getdat(lu,buf,nbytes),err);
#endif /* cray */

#if defined(sun)||defined(sgi)
		Drscall(getdat_(&lu,buf,&nbytes),err);
#endif /* sun||sgi */

#ifdef hpux
		Drscall(getdat(&lu,buf,&nbytes),err);
#endif /* hpux */
		
				/* Buffer has dimensions already transposed, */
				/* so change arrays to 'to' ordering.*/
		for(i=0; i<MXDIM; i++)
		{
			datadimto[i]=datadim[d[i]];
			bufdimto[i]=bufdim[d[i]];
			offsetto[i]=offset[d[i]];
		}
		
				/* Copy buffer to user array, */
				/* in Fortran order. */
		if(copybuf(buf,data,rank,order,datadimto,bufdimto,offsetto,bpe)) return(-1);
	}
	
				/* Otherwise, generate the intervals */
				/* for this dimension and pass to the */
				/* next dimension.*/

	else			/* dim >= 0 */
	{
		actdimlen[dim]=0;
		
				/* The following algorithm depends on */
				/* the file and requested ranges */
				/* both being monotonically increasing; */
				/* so dink with the ranges to support */
				/* the general case.*/
				/* reverse=1 iff the user requested ranges */
				/* have been (temporarily) reversed. */

		if(dle[dim]<dfe[dim])
			Swap(dfe[dim],dle[dim],temp);

		reverse=0;
		if(le[dim]<fe[dim])
		{
			Swap(fe[dim],le[dim],temp);
			reverse=1;
		}
				/* If the user range was reversed, then the */
				/* buffer will be filled from the top down */
				/* (in this dimension). */
		offset[dim]= (reverse ? datadim[dim] : 0);
		
				/* Set the correct dimension range */
				/* for DRS and pass to the next */
				/* level (dimension) */
		ndim=dim+1;
		if(cycle[dim] != 0.0)
		{
				/* Wraparound: generate the successive intervals */
			n=-floor(-(fe[dim]-dle[dim])/cycle[dim]);
			dmin[dim]=fe[dim]-n*cycle[dim];
			do
			{
				dmax[dim]= (le[dim] < (dfe[dim]+(n+1)*cycle[dim])) ?
					le[dim]-n*cycle[dim] :
						dle[dim];
				
#ifdef cray
				Drscall(Getrge2(lu,ndim,dmin[dim],dmax[dim],&idmin,&idmax,&dlow,&dhigh),err);
#endif /* cray */

#if defined(sun)||defined(sgi)
				Drscall(getrge2_(&lu,&ndim,&dmin[dim],&dmax[dim],&idmin,&idmax,&dlow,&dhigh),err);
#endif /* sun||sgi */

#ifdef hpux
				Drscall(getrge2(&lu,&ndim,&dmin[dim],&dmax[dim],&idmin,&idmax,&dlow,&dhigh),err);
#endif /* hpux */
				dlen=abs(idmax-idmin)+1;

				/* Set return lengths, first and last values */
				/* for getedim. */

				actdimlen[dim]+= dlen;
				
				if(setfirst)
				{
					cyfe[dim]=dlow+n*cycle[dim];
					setfirst=0;
				}
				cyle[dim]=dhigh+n*cycle[dim];

				bufdim[dim]=dlen;
				/* Put the generated range into the correct order. */
				/* If the user range is reversed, then the user buffer */
				/* is being filled top down (in this dimension), */
				/* so subtract the length BEFORE the read (otherwise */
				/* add the length AFTER the read. */
				if(reverse)
				{
					Swap(dmin[dim],dmax[dim],temp);
					offset[dim]=offset[dim]-dlen;
				}
				
				if((err=getslab1(lu,rank,order,fe,le,cycle,name,dfe,dle,datadim,data,dim-1,
						  bufdim,offset,dmin,dmax,nbytes*dlen,d,dtype)))
				{
					fprintf(stderr,"Error getting data in routine %s, line %d\n",ROUTINE,__LINE__);
					return(err);
				}
					
				if(!reverse)
					offset[dim]=offset[dim]+dlen;
				
				n+=1.0;
				dmin[dim]=dfe[dim];
			}
			while (le[dim] >= (dfe[dim]+n*cycle[dim]));
		}
		else		/* No wraparound */
		{
			dmin[dim]=fe[dim];
			dmax[dim]=le[dim];
			offset[dim]=0;
#ifdef cray
			Drscall(Getrge2(lu,ndim,dmin[dim],dmax[dim],&idmin,&idmax,&dlow,&dhigh),err);
#endif /* cray */

#if defined(sun)||defined(sgi)
			Drscall(getrge2_(&lu,&ndim,&dmin[dim],&dmax[dim],&idmin,&idmax,&dlow,&dhigh),err);
#endif /* sun||sgi */

#ifdef hpux
			Drscall(getrge2(&lu,&ndim,&dmin[dim],&dmax[dim],&idmin,&idmax,&dlow,&dhigh),err);
#endif /* hpux */
			dlen=abs(idmax-idmin)+1;

				/* Set actual dimension lengths, first and */
				/* last values for getedim. */

			actdimlen[dim]=dlen;
			cyfe[dim]=dlow;
			cyle[dim]=dhigh;
			
			bufdim[dim]=dlen;
			if(reverse)
				Swap(dmin[dim],dmax[dim],temp);
			if((err=getslab1(lu,rank,order,fe,le,cycle,name,dfe,dle,datadim,data,dim-1,
					  bufdim,offset,dmin,dmax,nbytes*dlen,d,dtype)))
			{
				fprintf(stderr,"Error getting data in routine %s, line %d\n",ROUTINE,__LINE__);
				return(err);
			}
		}
				/* Restore user range to original order, */
				/* for subsequent passes. */
				/* Note that file dimension ordering */
				/* need not be restored (DRS knows the ordering.*/
		if(reverse)
		{
			
			Swap(fe[dim],le[dim],temp);
			Swap(cyfe[dim],cyle[dim],temp);
		}
		
	}
	return(IDRS_SUCCESS);
}
				/* Copy 'from' array to 'to' array, */
				/* in Fortran order. */
				/* */
				/* order = transposition array */
				/*      ('to' dimension n = 'from' dimension order[n] */
				/* todim = dimensions of 'to' */
				/* fromdim = dimensions of 'from' */
				/* offset = offset within 'to' */
				/* bpe = bytes per element */

copybuf(from,to,rank,order,todim,fromdim,offset,bpe)
	char *from,*to;
	int order[],todim[],fromdim[],offset[],bpe;
{
	int d[MXDIM],todim2[MXDIM],fp[MXDIM],r[MXDIM],rp[MXDIM],rt[MXDIM],dp[MXDIM];
	register int i,j,k,l;
	register char *uaddr,*baddr,*ul,*uk,*uj;
	
	SetRoutine("copybuf");
	
				/* d   = order, extended to MXDIM values, 0-origin */
				/*       maps 'from' to 'to' ordering */
				/* dp  = inverse ordering (of d): d[dp[i]]=dp[d[i]]=i */
				/*       maps 'to' to 'from' ordering */
				/* todim2 = todim, extended to MXDIM values */
				/* fp  = offset, permuted to 'to' order */
				/* rp  = coefficients for 'to' addressing: */
				/*       uaddr= u+rp0*i'+rp1*j'+rp2*k'+rp3*l' */
				/* rt  = rp, permuted to 'from' order */

	for(i=0; i<rank; i++)
	{
		if(offset[i]+fromdim[i]>todim[i])
		{
			fprintf(stderr,"Error in routine getslab:\n");
			fprintf(stderr,"Dimension %d of result array is not large enough:\n",i+1);
			fprintf(stderr,"offset=%d, source dimension=%d, result dimension=%d\n",
			       offset[i],fromdim[i],todim[i]);
			return(-1);
		}
	}
	

	for(i=0; i<MXDIM; i++)
	{
		d[i]= i<rank ? order[i]-1 : i;
		dp[d[i]]=i;
		fp[i]= i<rank ? offset[d[i]] : 0;
		todim2[i] = i<rank ? todim[i] : 1;
	}
	for(i=1, rp[0]=bpe; i<MXDIM; i++)
		rp[i]=todim2[i-1]*rp[i-1];

	for(i=0,ul=to; i<MXDIM; i++)
	{
		ul+=rp[i]*fp[i]; /* base 'to' offset */
		rt[i]=rp[dp[i]];
	}
	
				/* copy; ordering is that of the 'from' array. */
	for(l=0, baddr=from;l<fromdim[3];l++)
	{
		uk=ul;
		for(k=0;k<fromdim[2];k++)
		{
			uj=uk;
			for(j=0;j<fromdim[1];j++)
			{
				uaddr=uj;
				for(i=0;i<fromdim[0];i++)
				{
					memcpy(uaddr,baddr,bpe);
					baddr+=bpe;
					uaddr+=rt[0];
				}
				uj+=rt[1];
			}
			uk+=rt[2];
		}
		ul+=rt[3];
	}
	return(0);
	
}
