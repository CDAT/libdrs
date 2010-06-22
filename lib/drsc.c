/*
     drsc.c,v 2.12 1996/11/01 18:37:17 drach Exp
     drsc.c,v
 * Revision 2.12  1996/11/01  18:37:17  drach
 * - Fixed up standard include file names
 *
 * Revision 2.11  1995/10/26  23:22:10  drach
 * - Added wrappers for drsl2ncp and drsn2lcp
 *
 * Revision 2.10  1995/10/16  18:47:32  drach
 * - Added d_floor, bcopy, bzero routines for DEC Alpha
 *
 * Revision 2.9  1995/03/30  00:50:33  drach
 * Added disclaimer
 *
 * Revision 2.8  1994/11/23  19:15:59  drach
 * Added nsldrsopen.
 *
 * Revision 2.7  1993/10/21  01:22:31  drach
 * Added drsautosync.
 *
 * Revision 2.6  1993/10/15  19:30:07  drach
 * Added interface to drssync.
 *
 * Revision 2.5  1993/07/14  22:30:14  drach
 * Removed text after #endif, etc.
 *
 * Revision 2.4  1993/07/13  01:12:45  drach
 * Merged Sun, Unicos, SGI, and HP versions.
 *
 * Revision 2.3  1993/01/05  02:04:13  drach
 * Added Getpelem
 *
 * Revision 2.2  1992/10/14  23:13:58  drach
 * Added iopt argument to treat blank naming fields as literal or null
 *
 * Revision 2.1  1992/10/06  00:52:11  drach
 * Added putdic interface, SGI wrapper routines for d_floor, bcopy
 *
 * Revision 2.0  1992/03/07  00:32:13  drach
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
/* C interface to DRS

   Author: Bob Drach
   Date: 12/5/89

   Comments:

   - All routines have the same name as the Fortran counterpart, with
   the first character capitalized.

   - Input scalars are passed by VALUE. This allows use of the parameters
   defined in drscdf.h as arguments. Input real-valued scalars may be
   either floats or doubles (C converts them to doubles in either case.)

   - Output scalars are passed by reference.

   - Output character arrays will have their last character set to null
   ('\0') . Output character arrays should be defined using the following
   typedefs: DRS_SOURCE, DRS_NAME, DRS_TITLE, DRS_DATE, DRS_TIME,
   DRS_TYPE, DRS_FILENAME, DRS_UNITS.

   Modifications:
   18 Jan 90: added Setrep (BD)
   22 Jan 90: Fixed floating point args in Setdim and Setvdim (BD)
   13 Mar 90: added Getrge2, Getelemd, and Getslab (BD)
   14 Jun 90: added Getcdim,Getedim
   27 Jun 90: added Cray interface
*/

#include "drscdf.h"

#ifdef cray
#include <string.h>
#include <fortran.h>
				/* cftstring=TOFCD(cstring) */
				/* TOFCDOUT(output-cstring,cftstring,cstringlen) */
				/* TOCPOUT(cftstring,output-cstring)*/
#define TOFCD(A) _cptofcd((A),strlen(A))
#define TOFCDOUT(B,A,L) memset((B),' ',(L)-1);(B)[(L)-1]='\0';(A)=_cptofcd((B),(L)-1)
#define TOCPOUT(A,B) (B)=_fcdtocp((A));(B)[_fcdlen(A)]='\0'

#else /* !cray */

#include <string.h>
#endif /* cray */

int
Aslun(lud,dicfil,lu,datfil,istat)
	int lud, lu, istat;
	char dicfil[], datfil[];
	
{
#ifdef cray
	fortran int ASLUN(int *,_fcd,int *,_fcd,int *);
	_fcd fdicfil,fdatfil;

	fdicfil= TOFCD(dicfil);
	fdatfil= TOFCD(datfil);
	return(ASLUN(&lud,fdicfil,&lu,fdatfil,&istat));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int aslun_();
	
	return(aslun_(&lud,dicfil,&lu,datfil,&istat,
		      strlen(dicfil),strlen(datfil)));
#endif /* sun||sgi */
#ifdef hpux
	int aslun();
	
	return(aslun(&lud,dicfil,&lu,datfil,&istat,
		      strlen(dicfil),strlen(datfil)));
#endif /* hpux */
}

int
Cllun(lu)
	int lu;
{
#ifdef cray
	fortran int CLLUN(int *);
	return(CLLUN(&lu));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int cllun_();
	return(cllun_(&lu));
#endif /* sun||sgi */
#ifdef hpux
	int cllun();
	return(cllun(&lu));
#endif /* hpux */
}

int
Cluvdb()
{
#ifdef cray
	fortran int CLUVDB();
	return(CLUVDB());
#endif /* cray */
#if defined(sun)||defined(sgi)
	int cluvdb_();
	return(cluvdb_());
#endif /* sun||sgi */
#ifdef hpux
	int cluvdb();
	return(cluvdb());
#endif /* hpux */
}

int
Drsautosync(lu,iopt)
        int lu,iopt;
{
#ifdef cray
	fortran int DRSAUTOSYNC(int *,int *);
	return(DRSAUTOSYNC(&lu,&iopt));
#endif
#if defined(sun)||defined(sgi)
	int drsautosync_();
	return(drsautosync_(&lu,&iopt));
#endif
#ifdef hpux
	int drsautosync();
	return(drsautosync(&lu,&iopt));
#endif
}

int
Drssync(lu)
        int lu;
{
#ifdef cray
	fortran int DRSSYNC(int *);
	return(DRSSYNC(&lu));
#endif
#if defined(sun)||defined(sgi)
	int drssync_();
	return(drssync_(&lu));
#endif
#ifdef hpux
	int drssync();
	return(drssync(&lu));
#endif
}

int
Drstest(ierr)
	int ierr;
{
#ifdef cray
	fortran int DRSTEST(int *);
	int test;
	test=DRSTEST(&ierr);
	return(_ltob(&test));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int drstest_();
	return(drstest_(&ierr));
#endif /* sun||sgi */
#ifdef hpux
	int drstest();
	return(drstest(&ierr));
#endif /* hpux */
}

int
Getdat(lu,a,isize)
#ifdef __linux
        int lu, isize;
	void* a;
#else
	int lu, a[], isize;
#endif
{
#ifdef cray
	fortran int GETDAT(int *,int *,int *);
	return(GETDAT(&lu,a,&isize));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int getdat_();
	return(getdat_(&lu,a,&isize));
#endif /* sun||sgi */
#ifdef hpux
	int getdat();
	return(getdat(&lu,a,&isize));
#endif /* hpux */
}

int
Getcdim(idim,source,name,title,units,dtype,reqlen,var,retlen)
	int idim,*dtype,reqlen,*retlen;
	char source[],name[],title[],units[];
	float var[];
{
#ifdef cray
	fortran int GETCDIM(int *,_fcd,_fcd,_fcd,_fcd,int *,int *,float *,int *);
	_fcd fsource,fname,ftitle,funits;
	int err;

	TOFCDOUT(source,fsource,IDRS_SOURCELEN);
	TOFCDOUT(name,fname,IDRS_NAMELEN);
	TOFCDOUT(title,ftitle,IDRS_TITLELEN);
	TOFCDOUT(units,funits,IDRS_UNITSLEN);

	err=GETCDIM(&idim,fsource,fname,ftitle,funits,dtype,
		     &reqlen,var,retlen);
	
	TOCPOUT(fsource,source);
	TOCPOUT(fname,name);
	TOCPOUT(ftitle,title);
	TOCPOUT(funits,units);

	return(err);
#endif /* cray */
#if defined(sun)||defined(sgi)
	int getcdim_();
	source[IDRS_SOURCELEN-1]=title[IDRS_TITLELEN-1]=
		name[IDRS_NAMELEN-1]=units[IDRS_UNITSLEN-1]='\0';
	return(getcdim_(&idim,source,name,title,units,dtype,
			&reqlen,var,retlen,IDRS_SOURCELEN-1,
			IDRS_NAMELEN-1,IDRS_TITLELEN-1,IDRS_UNITSLEN-1));
#endif /* sun||sgi */
#ifdef hpux
	int getcdim();
	source[IDRS_SOURCELEN-1]=title[IDRS_TITLELEN-1]=
		name[IDRS_NAMELEN-1]=units[IDRS_UNITSLEN-1]='\0';
	return(getcdim(&idim,source,name,title,units,dtype,
			&reqlen,var,retlen,IDRS_SOURCELEN-1,
			IDRS_NAMELEN-1,IDRS_TITLELEN-1,IDRS_UNITSLEN-1));
#endif /* hpux */
}

int
Getdim(n,dna,dun,dtype,idim,df,dl)
	int n,*idim,*dtype;
	char dna[], dun[];
	float *df,*dl;
{
#ifdef cray
	fortran int GETDIM(int *,_fcd,_fcd,int *,int *,float *,float *);
	_fcd fname,funits;
	int err;
	

	TOFCDOUT(dna,fname,IDRS_NAMELEN);
	TOFCDOUT(dun,funits,IDRS_UNITSLEN);

	err=GETDIM(&n,fname,funits,dtype,idim,df,dl);

	TOCPOUT(fname,dna);
	TOCPOUT(funits,dun);
	
	return(err);
#endif /* cray */
#if defined(sun)||defined(sgi)
	int getdim_();
	dna[IDRS_NAMELEN-1]=dun[IDRS_UNITSLEN-1]='\0';
	
	return(getdim_(&n,dna,dun,dtype,idim,df,dl,
			IDRS_NAMELEN-1,
			IDRS_UNITSLEN-1));
#endif /* sun||sgi */
#ifdef hpux
	int getdim();
	dna[IDRS_NAMELEN-1]=dun[IDRS_UNITSLEN-1]='\0';
	
	return(getdim(&n,dna,dun,dtype,idim,df,dl,
			IDRS_NAMELEN-1,
			IDRS_UNITSLEN-1));
#endif /* hpux */
}

int
Getedim(n,dsrc,dna,dti,dun,dtype,idim,df,dl)
	int n,*idim,*dtype;
	char dna[], dun[],dsrc[],dti[];
	float *df,*dl;
{
#ifdef cray
	fortran int GETEDIM(int *,_fcd,_fcd,_fcd,_fcd,int *,int *,float *,float *);
	_fcd fsource,fname,ftitle,funits;
	int err;
	

	TOFCDOUT(dsrc,fsource,IDRS_SOURCELEN);
	TOFCDOUT(dna,fname,IDRS_NAMELEN);
	TOFCDOUT(dti,ftitle,IDRS_TITLELEN);
	TOFCDOUT(dun,funits,IDRS_UNITSLEN);

	err=GETEDIM(&n,fsource,fname,ftitle,funits,dtype,idim,df,dl);

	TOCPOUT(fsource,dsrc);
	TOCPOUT(fname,dna);
	TOCPOUT(ftitle,dti);
	TOCPOUT(funits,dun);
	
	return(err);
#endif /* cray */
#if defined(sun)||defined(sgi)
	int getedim_();
	dna[IDRS_NAMELEN-1]=dun[IDRS_UNITSLEN-1]='\0';
	dsrc[IDRS_SOURCELEN-1]=dti[IDRS_TITLELEN-1]='\0';
	
	return(getedim_(&n,dsrc,dna,dti,dun,dtype,idim,df,dl,
			IDRS_SOURCELEN-1,IDRS_NAMELEN-1,
			IDRS_TITLELEN-1,IDRS_UNITSLEN-1));
#endif /* sun||sgi */
#ifdef hpux
	int getedim();
	dna[IDRS_NAMELEN-1]=dun[IDRS_UNITSLEN-1]='\0';
	dsrc[IDRS_SOURCELEN-1]=dti[IDRS_TITLELEN-1]='\0';
	
	return(getedim(&n,dsrc,dna,dti,dun,dtype,idim,df,dl,
			IDRS_SOURCELEN-1,IDRS_NAMELEN-1,
			IDRS_TITLELEN-1,IDRS_UNITSLEN-1));
#endif /* hpux */
}

int
Getelemd(type,bpe)
	int *type,*bpe;
{
#ifdef cray
	int GETELEMD(int *,int *);
	return(GETELEMD(type,bpe));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int getelemd_();
	return(getelemd_(type,bpe));
#endif /* sun||sgi */
#ifdef hpux
	int getelemd();
	return(getelemd(type,bpe));
#endif /* hpux */
}

int
Getpelem(type,bpe)
	int *type,*bpe;
{
#ifdef cray
	int GETPELEM(int *,int *);
	return(GETPELEM(type,bpe));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int getpelem_();
	return(getpelem_(type,bpe));
#endif /* sun||sgi */
#ifdef hpux
	int getpelem();
	return(getpelem(type,bpe));
#endif /* hpux */
}


int
Getname(source,name,title,units,date,time,typed,nd)
	char source[],name[],title[],units[],date[],time[],typed[];
	int *nd;
{
#ifdef cray
	fortran int GETNAME(_fcd,_fcd,_fcd,_fcd,_fcd,_fcd,_fcd,int *);
	_fcd fsource,fname,ftitle,funits,fdate,ftime,ftyped;
	int err;
	
	TOFCDOUT(source,fsource,IDRS_SOURCELEN);
	TOFCDOUT(name,fname,IDRS_NAMELEN);
	TOFCDOUT(title,ftitle,IDRS_TITLELEN);
	TOFCDOUT(units,funits,IDRS_UNITSLEN);
	TOFCDOUT(date,fdate,IDRS_DATELEN);
	TOFCDOUT(time,ftime,IDRS_TIMELEN);
	TOFCDOUT(typed,ftyped,IDRS_TYPELEN);
	
	err=GETNAME(fsource,fname,ftitle,funits,fdate,ftime,ftyped,nd);

	TOCPOUT(fsource,source);
	TOCPOUT(fname,name);
	TOCPOUT(ftitle,title);
	TOCPOUT(funits,units);
	TOCPOUT(fdate,date);
	TOCPOUT(ftime,time);
	TOCPOUT(ftyped,typed);
	
	return(err);
#endif /* cray */
#if defined(sun)||defined(sgi)
	int getname_();

	source[IDRS_SOURCELEN-1]=name[IDRS_NAMELEN-1]=title[IDRS_TITLELEN-1]
		=units[IDRS_UNITSLEN-1]=date[IDRS_DATELEN-1]
			=time[IDRS_TIMELEN-1]=typed[IDRS_TYPELEN-1]
				='\0';
	
	return(getname_(source,name,title,units,date,time,typed,nd,
		      IDRS_SOURCELEN-1, IDRS_NAMELEN-1, IDRS_TITLELEN-1,
		      IDRS_UNITSLEN-1, IDRS_DATELEN-1, IDRS_TIMELEN-1,
		      IDRS_TYPELEN-1));
#endif /* sun||sgi */
#ifdef hpux
	int getname();

	source[IDRS_SOURCELEN-1]=name[IDRS_NAMELEN-1]=title[IDRS_TITLELEN-1]
		=units[IDRS_UNITSLEN-1]=date[IDRS_DATELEN-1]
			=time[IDRS_TIMELEN-1]=typed[IDRS_TYPELEN-1]
				='\0';
	
	return(getname(source,name,title,units,date,time,typed,nd,
		      IDRS_SOURCELEN-1, IDRS_NAMELEN-1, IDRS_TITLELEN-1,
		      IDRS_UNITSLEN-1, IDRS_DATELEN-1, IDRS_TIMELEN-1,
		      IDRS_TYPELEN-1));
#endif /* hpux */
}

int
Getrge2(lu,idim,elem1,elem2,ind1,ind2,dlow,dhigh)
	int lu,idim,*ind1,*ind2;
	double elem1,elem2;
	float *dlow,*dhigh;
{
#ifdef cray
	fortran int GETRGE2(int *,int *,float *,float *,int *,int *,float *,float *);
	float temp1,temp2;

	temp1=elem1;
	temp2=elem2;
	
	return(GETRGE2(&lu,&idim,&temp1,&temp2,ind1,ind2,dlow,dhigh));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int getrge2_();
	float temp1,temp2;

	temp1=elem1;
	temp2=elem2;
	
	return(getrge2_(&lu,&idim,&temp1,&temp2,ind1,ind2,dlow,dhigh));
#endif /* sun||sgi */
#ifdef hpux
	int getrge2();
	float temp1,temp2;

	temp1=elem1;
	temp2=elem2;
	
	return(getrge2(&lu,&idim,&temp1,&temp2,ind1,ind2,dlow,dhigh));
#endif /* hpux */
}

int
Getslab(lu,rank,order,fe,le,cycle,data,datadim)
#ifdef __linux
     int lu,rank,*order,*datadim;
     float *fe,*le,*cycle;
     void* data;
#else
	int lu,rank,order[],datadim[];
	float fe[],le[],cycle[];
	char data[];
#endif
{
#ifdef cray
	int getslab_(int *,int *,int *,float *,float *,float *,char *,int *);
	return(getslab_(&lu,&rank,order,fe,le,cycle,data,datadim));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int getslab_();
	return(getslab_(&lu,&rank,order,fe,le,cycle,data,datadim));
#endif /* sun||sgi */
#ifdef hpux
	int getslab();
	return(getslab(&lu,&rank,order,fe,le,cycle,data,datadim));
#endif /* hpux */
}

	
int
Getvdim(idim,source,title,reqlen,var,retlen)
	int idim,reqlen,*retlen;
	char source[],title[];
	float var[];
{
#ifdef cray
	fortran int GETVDIM(int *,_fcd,_fcd,int *,float *,int *);
	_fcd fsource,ftitle;
	int err;
	
	TOFCDOUT(source,fsource,IDRS_SOURCELEN);
	TOFCDOUT(title,ftitle,IDRS_TITLELEN);

	err=GETVDIM(&idim,fsource,ftitle,&reqlen,var,retlen);

	TOCPOUT(fsource,source);
	TOCPOUT(ftitle,title);

	return(err);

#endif /* cray */
#if defined(sun)||defined(sgi)
	int getvdim_();
	source[IDRS_SOURCELEN-1]=title[IDRS_TITLELEN-1]='\0';
	return(getvdim_(&idim,source,title,&reqlen,var,retlen,
			IDRS_SOURCELEN-1,IDRS_TITLELEN-1));
#endif /* sun||sgi */
#ifdef hpux
	int getvdim();
	source[IDRS_SOURCELEN-1]=title[IDRS_TITLELEN-1]='\0';
	return(getvdim(&idim,source,title,&reqlen,var,retlen,
			IDRS_SOURCELEN-1,IDRS_TITLELEN-1));
#endif /* hpux */
}

	

int
Inqdict(lu,oper)
	int lu,oper;
{
#ifdef cray
	fortran int INQDICT(int *,int *);
	return(INQDICT(&lu,&oper));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int inqdict_();
	return(inqdict_(&lu,&oper));
#endif /* sun||sgi */
#ifdef hpux
	int inqdict();
	return(inqdict(&lu,&oper));
#endif /* hpux */
}

int
Inqlun(lu,datafile,nvar,version)
	int lu,*nvar;
	char datafile[];
	float *version;
{
#ifdef cray
	fortran int INQLUN(int *,_fcd,int *,float *);
	_fcd fdatafile;
	int err;
	TOFCDOUT(datafile,fdatafile,IDRS_FILENAMELEN);
	err=INQLUN(&lu,fdatafile,nvar,version);
	TOCPOUT(fdatafile,datafile);
	return(err);
	
#endif /* cray */
#if defined(sun)||defined(sgi)
	int inqlun_();
	datafile[IDRS_FILENAMELEN-1]='\0';
	return(inqlun_(&lu,datafile,nvar,version,
		       IDRS_FILENAMELEN-1));
#endif /* sun||sgi */
#ifdef hpux
	int inqlun();
	datafile[IDRS_FILENAMELEN-1]='\0';
	return(inqlun(&lu,datafile,nvar,version,
		       IDRS_FILENAMELEN-1));
#endif /* hpux */
}

int
Prdict(lup,lu)
	int lup,lu;
{
#ifdef cray
	fortran int PRDICT(int *,int *);
	return(PRDICT(&lup,&lu));
#endif /* cray */
#if defined(sun)||defined(sgi)
        int prdict_();
        return(prdict_(&lup,&lu));
#endif /* sun||sgi */
#ifdef hpux
        int prdict();
        return(prdict(&lup,&lu));
#endif /* hpux */
}
	
int
Putdic(lu,iopt)
	int lu,iopt;
{
#ifdef cray
	fortran int PUTDIC(int *,int *);
	return(PUTDIC(&lu,&iopt));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int putdic_();
	return(putdic_(&lu,&iopt));
#endif /* sun||sgi */
#ifdef hpux
	int putdic();
	return(putdic(&lu,&iopt));
#endif /* hpux */
}

int
Putdat(lu,a)
#ifdef __linux
     int lu;
     void* a;
#else
	int lu,a[];
#endif
{
#ifdef cray
	fortran int PUTDAT(int *,int *);
	return(PUTDAT(&lu,a));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int putdat_();
	return(putdat_(&lu,a));
#endif /* sun||sgi */
#ifdef hpux
	int putdat();
	return(putdat(&lu,a));
#endif /* hpux */
}

int
Putvdim(lu,len,dimvar,i1,i2)
	int lu,len,*i1,*i2;
	float dimvar[];
{
#ifdef cray
	fortran int PUTVDIM(int *,int *,float *,int *,int *);
	return(PUTVDIM(&lu,&len,dimvar,i1,i2));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int putvdim_();
	return(putvdim_(&lu,&len,dimvar,i1,i2));
#endif /* sun||sgi */
#ifdef hpux
	int putvdim();
	return(putvdim(&lu,&len,dimvar,i1,i2));
#endif /* hpux */
}

int
Setdate(date,time)
	char date[],time[];
{
#ifdef cray
	fortran int SETDATE(_fcd,_fcd);
	_fcd fdate,ftime;
	fdate=TOFCD(date);
	ftime=TOFCD(time);
	return(SETDATE(fdate,ftime));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int setdate_();
	return(setdate_(date,time,
			strlen(date),strlen(time)));
#endif /* sun||sgi */
#ifdef hpux
	int setdate();
	return(setdate(date,time,
			strlen(date),strlen(time)));
#endif /* hpux */
}


int
Setdim(n,dna,dun,idim,df,dl)
	int n,idim;
	char dna[],dun[];
	double df,dl;		/* C converts args to double anyway. */
{
#ifdef cray
	fortran int SETDIM(int *,_fcd,_fcd,int *,float *,float *);
	float dftemp, dltemp;
	_fcd fdna,fdun;
	
	
	dftemp=df;
	dltemp=dl;
	fdna=TOFCD(dna);
	fdun=TOFCD(dun);
	
	return(SETDIM(&n,fdna,fdun,&idim,&dftemp,&dltemp));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int setdim_();
	float dftemp, dltemp;
	
	dftemp=df;
	dltemp=dl;
	
	return(setdim_(&n,dna,dun,&idim,&dftemp,&dltemp,
		       strlen(dna),strlen(dun)));
#endif /* sun||sgi */
#ifdef hpux
	int setdim();
	float dftemp, dltemp;
	
	dftemp=df;
	dltemp=dl;
	
	return(setdim(&n,dna,dun,&idim,&dftemp,&dltemp,
		       strlen(dna),strlen(dun)));
#endif /* hpux */
}
	

int
Seterr(ierrlun,reportlevel)
	int ierrlun, reportlevel;
{
#ifdef cray
	fortran int SETERR(int *,int *);
	return(SETERR(&ierrlun,&reportlevel));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int seterr_();
	return(seterr_(&ierrlun,&reportlevel));
#endif /* sun||sgi */
#ifdef hpux
	int seterr();
	return(seterr(&ierrlun,&reportlevel));
#endif /* hpux */
}

int
Setname(source,name,title,units,typed)
	char source[],name[],title[],units[],typed[];
{
#ifdef cray
	fortran SETNAME(_fcd,_fcd,_fcd,_fcd,_fcd);
	_fcd fsource,fname,ftitle,funits,ftyped;
	
	fsource=TOFCD(source);
	fname=TOFCD(name);
	ftitle=TOFCD(title);
	funits=TOFCD(units);
	ftyped=TOFCD(typed);

	return(SETNAME(fsource,fname,ftitle,funits,ftyped));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int setname_();
	return(setname_(source,name,title,units,typed,
			strlen(source),strlen(name),strlen(title),
			strlen(units),strlen(typed)));
#endif /* sun||sgi */
#ifdef hpux
	int setname();
	return(setname(source,name,title,units,typed,
			strlen(source),strlen(name),strlen(title),
			strlen(units),strlen(typed)));
#endif /* hpux */
}

int
Setrep(irep)
	int irep;
{
#ifdef cray
	fortran int SETREP(int *);
	return(SETREP(&irep));
#endif /* cray */
#if defined(sun)||defined(sgi)
	int setrep_();
	return(setrep_(&irep));
#endif /* sun||sgi */
#ifdef hpux
	int setrep();
	return(setrep(&irep));
#endif /* hpux */
}

int
Setvdim(n,dso,dna,dti,dun,df,dl)
	int n;
	char dso[], dna[], dti[], dun[];
	double df, dl;		/* C converts args to double anyway. */
{
#ifdef cray
	fortran int SETVDIM(int *,_fcd,_fcd,_fcd,_fcd,float *,float *);
	float dftemp, dltemp;
	_fcd fsource,fname,ftitle,funits;

	dftemp=df;
	dltemp=dl;
	
	fsource=TOFCD(dso);
	fname=TOFCD(dna);
	ftitle=TOFCD(dti);
	funits=TOFCD(dun);

	return(SETVDIM(&n,fsource,fname,ftitle,funits,&dftemp,&dltemp));

#endif /* cray */
#if defined(sun)||defined(sgi)
	int setvdim_();
	float dftemp, dltemp;

	dftemp=df;
	dltemp=dl;
	
	return(setvdim_(&n,dso,dna,dti,dun,&dftemp,&dltemp,
			strlen(dso),strlen(dna),strlen(dti),
			strlen(dun)));
#endif /* sun||sgi */
#ifdef hpux
	int setvdim();
	float dftemp, dltemp;

	dftemp=df;
	dltemp=dl;
	
	return(setvdim(&n,dso,dna,dti,dun,&dftemp,&dltemp,
			strlen(dso),strlen(dna),strlen(dti),
			strlen(dun)));
#endif /* hpux */
}

				/* SGI wrapper routines */
#if defined (sgi) || defined (mac) 
/*
double
d_floor_( double *x ){
	return floor( *x );
}
*/
void
bcopy_( const void *src, void *dest, int len ){
	(void) bcopy( src, dest, len );
}

void
bzero_( void *b, int len ){
	(void) bzero( b, len );
}

#endif /* sgi */
					     /* DEC Alpha wrapper routines */
#ifdef __alpha
#include <math.h>
double
d_floor_( double *x ){
	return floor( *x );
}

void
bcopy_( const char *src, char *dest, int len ){
	(void) bcopy( src, dest, len );
}

void
bzero_( char *b, int len ){
	(void) bzero( b, len );
}
#endif					     /* DEC Alpha */
					     /* Wrapper to fix bug in NSL routine */
#ifdef NSL_DRS
int NSLDRSOPEN (Path, oflag, mode)
_fcd	 Path;		/* UniTree path name for the file */
int	 *oflag;	/* Access to the file */
int	 *mode;		/* What perms to create the file if needed */
{
	int plen;		/* Byte length of path name */
	char *CPath;		/* C character pointer to path name */
	int NSLFd;		/* File descriptor if successful, otherwise -1 */

	plen = _fcdlen(Path);		/* Get the length */
	CPath = (char *)malloc (plen+1);
	strncpy (CPath, _fcdtocp(Path), plen);
	CPath[plen]='\0';                    /* MUST NULL-TERMINATE FORTRAN STRINGS !!! */
	NSLFd = nslopen(CPath, *oflag, *mode);
	(void)free(CPath);
	return (NSLFd);
}
					     /* Wrapper for NSL-to-local copy */
int DRSN2LCP (infile,outfile)
	_fcd infile;
	_fcd outfile;
{
	int ilen;			     /* Byte length of input file name */
	char *ipath;			     /* C input path name */
	int olen;			     /* Byte length of output file name */
	char *opath;			     /* C output path name */
	int err;			     /* Error return */
	char *c;
	
	ilen = _fcdlen(infile);
	ipath = (char *)malloc(ilen+1);
	strncpy(ipath,_fcdtocp(infile),ilen);
	for(c=ipath; *c && *c != ' '; c++); /* Trim trailing blanks */
	*c = '\0';
	
	olen = _fcdlen(outfile);
	opath = (char *)malloc(olen+1);
	strncpy(opath,_fcdtocp(outfile),olen);
	for(c=opath; *c && *c != ' '; c++); /* Trim trailing blanks */
	*c = '\0';
	
	err = drsn2lcp(ipath,opath);
	(void) free(ipath);
	(void) free(opath);
	return err;
}

					     /* Wrapper for local-to-NSL copy */
int DRSL2NCP (infile,outfile)
	_fcd infile;
	_fcd outfile;
{
	int ilen;			     /* Byte length of input file name */
	char *ipath;			     /* C input path name */
	int olen;			     /* Byte length of output file name */
	char *opath;			     /* C output path name */
	int err;			     /* Error return */
	char *c;

	ilen = _fcdlen(infile);
	ipath = (char *)malloc(ilen+1);
	strncpy(ipath,_fcdtocp(infile),ilen);
	for(c=ipath; *c && *c != ' '; c++); /* Trim trailing blanks */
	*c = '\0';
	
	olen = _fcdlen(outfile);
	opath = (char *)malloc(olen+1);
	strncpy(opath,_fcdtocp(outfile),olen);
	for(c=opath; *c && *c != ' '; c++); /* Trim trailing blanks */
	*c = '\0';
	
	err = drsl2ncp(ipath,opath);
	(void) free(ipath);
	(void) free(opath);
	return err;
}
#endif /* NSL_DRS */
