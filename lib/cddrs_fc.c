/* C functions intended to be called by the fcw_ functions in cddrsfwrap.f90, and which will call
   the "pure-C" libcdms  cw_ functions in cddrs.c. */

#include "drscdf.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

static char namestr1[IDRS_FILENAMELEN];	     /* C-style string for names */
static char namestr2[IDRS_FILENAMELEN];	     /* C-style string for names */
static char namestr3[IDRS_FILENAMELEN];	     /* C-style string for names */
static char namestr4[IDRS_FILENAMELEN];	     /* C-style string for names */
static char namestr5[IDRS_FILENAMELEN];	     /* C-style string for names */
static char namestr6[IDRS_FILENAMELEN];	     /* C-style string for names */
static char namestr7[IDRS_FILENAMELEN];	     /* C-style string for names */

int fstr2cstr( const char * const fstr, char * cstr, const int fstrlen ) {
  /* copies a Fortran string to a new C string.  The Fortran string length should
     be exclusive of blank padding - that is, the Fortran code should pass something like
     len_trim(fstr). */
  if ( fstrlen >= IDRS_FILENAMELEN ) {
    printf( "ERROR in string conversion: F str=%s has len=%i but DRS max filename length==%i\n",fstr,fstrlen,IDRS_FILENAMELEN );
    return IDRS_BADCHARLEN;}
  strncpy( cstr, fstr, fstrlen );
  cstr[fstrlen] = '\0';
  return IDRS_SUCCESS;
}
int cstr2fstr( const char * const cstr, char * fstr, const int fstrmax ) {
  /* copies a C string to an existing Fortran string, padding with blanks as necessary.
   The Fortran string's length (allocated size) is fstrmax. */
  int i, cstrlen;
  cstrlen = strlen(cstr);
  if ( cstrlen > fstrmax ) {
    printf( "ERROR in string conversion: C str=%s has len=%i but Fortran max length==%i\n",cstr,cstrlen,fstrmax );
    return IDRS_BADCHARLEN;}
  strncpy( fstr, cstr, cstrlen );
  for ( i=cstrlen; i<fstrmax; ++i ) {
    fstr[i] = ' ';
  }
  return IDRS_SUCCESS;
}

int fc_aslun_( int *plud, char* dicfilin, int *plu, char* datfilin, int *pistat,
	       const int * const dicfilmax, const int * const dicfillen,
	       const int * const datfilmax, const int * const datfillen ) {
  /* Fortran wrapper for cw_aslun().  The first 5 arguments are the same as the first 5 arguments of
     cs_aslun(), except that plud,plu,pistat are int* rather than int.
     To each string argument, e.g. dicfilin, there are two lengths, e.g. dicfilmax and dicfillen.
     In Fortran, dicfilmax=len(dicfilin) and dicfillen=len_trim(dicfilin).  ("trim" means "delete padding
     with trailing blanks").
   */
  int ierr;
  ierr = fstr2cstr( dicfilin, namestr1, *dicfillen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( datfilin, namestr2, *datfillen );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  ierr = cw_aslun( *plud, namestr1, *plu, namestr2, *pistat );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  /* Don't change input strings - sometimes they're a constant, and they won't be looked at anyway.*/
  return ierr;
}

int fc_setname_( char* isource, char* iname, char* ititle, char* iunits, char* typed,
		const int * const srcmax, const int * const srclen,
		const int * const nammax, const int * const namlen,
		const int * const timax, const int * const tilen,
		const int * const unmax, const int * const unlen,
		const int * const typmax, const int * const typlen )
{
  int ierr;
  ierr = fstr2cstr( isource, namestr1, *srclen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( iname, namestr2, *namlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( ititle, namestr3, *tilen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( iunits, namestr4, *unlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( typed, namestr5, *typlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  ierr = cw_setname( namestr1, namestr2, namestr3, namestr4, namestr5 );
  return ierr;
}

int fc_getname_( char* source, char* name, char* title, char* units, char* date, char* time,
		char* typed, int* nd,
		const int * const srcmax, const int * const srclen,
		const int * const nammax, const int * const namlen,
		const int * const timax, const int * const tilen,
		const int * const unmax, const int * const unlen,
		const int * const datmax, const int * const datlen,
		const int * const timmax, const int * const timlen,
		const int * const typmax, const int * const typlen )
{
  int ierr;
  ierr = fstr2cstr( source, namestr1, *srclen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( name, namestr2, *namlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( title, namestr3, *tilen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( units, namestr4, *unlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( date, namestr5, *datlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( time, namestr6, *timlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( typed, namestr7, *typlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  ierr = cw_getname( namestr1, namestr2, namestr3, namestr4, namestr5, namestr6, namestr7, nd );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  /* Some of these strings may be used later, so they won't be constants. */
  ierr = cstr2fstr( namestr1, source, *srcmax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr2, name, *nammax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr3, title, *timax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr4, units, *unmax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr5, date, *datmax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr6, time, *timmax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr7, typed, *typmax );
  return ierr;
}

int fc_getedim_( int *pn, char *dsrc, char *dna, char *dti, char *dun, int *dtype, int *idim,
		 float *df, float *dl,
		 const int * const srcmax, const int * const srclen,
		 const int * const nammax, const int * const namlen,
		 const int * const timax, const int * const tilen,
		 const int * const unmax, const int * const unlen )
{
  int ierr;
  ierr = fstr2cstr( dsrc, namestr1, *srclen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dna, namestr2, *namlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dti, namestr3, *tilen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dun, namestr4, *unlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  ierr = cw_getedim( *pn, namestr1, namestr2, namestr3, namestr4, dtype, idim, df, dl );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  /* Some of these strings may be used later, so they won't be constants. */
  ierr = cstr2fstr( namestr1, dsrc, *srcmax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr2, dna, *nammax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr3, dti, *timax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr4, dun, *unmax );
  return ierr;
}

int fc_getcdim_( int *pn, char *dsrc, char *dna, char *dti, char *dun,
		 int *dtype, int *preqlen, float *var, int *retlen,
		 const int * const srcmax, const int * const srclen,
		 const int * const namax, const int * const nalen,
		 const int * const timax, const int * const tilen,
		 const int * const unmax, const int * const unlen )
{
  int ierr;
  ierr = fstr2cstr( dsrc, namestr1, *srclen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dna, namestr2, *nalen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dti, namestr3, *tilen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dun, namestr4, *unlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  ierr = cw_getcdim( *pn, namestr1, namestr2, namestr3, namestr4, dtype, *preqlen, var, retlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  /* Some of these strings may be used later, so they won't be constants. */
  ierr = cstr2fstr( namestr1, dsrc, *srcmax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr2, dna, *namax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr3, dti, *timax );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = cstr2fstr( namestr4, dun, *unmax );
  return ierr;
}

int fc_setdim_( int *pn, char *dnain, char *dunin, int *pidim, double *pdf, double *pdl,
	       const int * const nammax, const int * const namlen,
	       const int * const unmax, const int * const unlen )
/* Note that pdf,pdl were float (not double) in earlier versions of libcdms */
{
  int ierr;
  ierr = fstr2cstr( dnain, namestr2, *namlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dunin, namestr4, *unlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  ierr = cw_setdim( *pn, namestr2, namestr4, *pidim, *pdf, *pdl );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  /* Don't change input strings - sometimes they're a constant, and they won't be looked at anyway.*/
  /* ierr = cstr2fstr( namestr2, dnain, *nammax ); */
  /* if ( ierr != IDRS_SUCCESS ) return ierr; */
  /* ierr = cstr2fstr( namestr4, dunin, *unmax ); */
  return ierr;
}


int fc_drstest_( int *ierr ) {
  int new_ierr;
  new_ierr = cw_drstest( *ierr );
  return new_ierr;
}


int fc_getdat_( int *plu, void *a, int *pisize ) {
  return cw_getdat( *plu, a, *pisize );
}


int fc_cluvdb_() {
  return cw_cluvdb();
}

int fcw_inqdict_(int *plu,int *poper){
  return cw_inqdict( *plu, *poper );
}
int fcw_cllun_(int *plu){
  return cw_cllun( *plu );
}

int fc_seterr_( int *pierrlun, int *preportlevel ) {
  /* Fortran wrapper for cw_seterr.  The arguments are the same are the arguments of cw_seterr,
     except that they are int* rather than int.
  */
  int ierr;
  ierr = cw_seterr( *pierrlun, *preportlevel );
  return ierr;
}

int fc_getslab_( int *plu, int *prank, int* order, float* fe, float* le, float* cycle, void* data,
		int* datadim ) {
  /* Fortran wrapper for cw_getslab.  The int and int* arguments of cw_getslab are int* arguments
     here. The float* arguments of cw_getslab are also float* here.
  */
  int ierr;
  ierr = cw_getslab( *plu, *prank, order, fe, le, cycle, data, datadim );
  return ierr;
}

int fc_putdat_( int *plu, void* data ) {
  /* Fortran wrapper for cw_putdat. */
  int ierr;
  ierr = cw_putdat( *plu, data );
  return ierr;
}

int fc_putvdim_( int *plu, int *len, float* dimvar, int* i1, int* i2 ) {
  /* Fortran wrapper for cw_putvdim. */
  int ierr;
  ierr = cw_putvdim( *plu, *len, dimvar, i1, i2 );
  return ierr;
}

int fc_setvdim_( int *pn, char* dsoin, char* dnain, char* dtiin, char* dunin,
		 double *pdf, double *pdl,
		 const int * const somax, const int * const solen,
		 const int * const nammax, const int * const nalen,
		 const int * const timmax, const int * const tilen,
		 const int * const unmax, const int * const unlen )  {
  /* Fortran wrapper for cw_setvdim. */
  /* Probably this is like cw_setdim_ in that
     pdf,pdl were float (not double) in earlier versions of libcdms */
  int ierr;
  ierr = fstr2cstr( dsoin, namestr1, *solen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dnain, namestr2, *nalen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dtiin, namestr3, *tilen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dunin, namestr4, *unlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  ierr = cw_setvdim( *pn, namestr1, namestr2, namestr3, namestr4, *pdf, *pdl );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  return ierr;
}
    
int fc_varid( int *fileid, char* dsoin, char* dnain, char* dtiin, char* dunin,
	      const int * const somax, const int * const solen,
	      const int * const nammax, const int * const nalen,
	      const int * const timmax, const int * const tilen,
	      const int * const unmax, const int * const unlen )  {
  /* Fortran wrapper for cw_varid */
  /*int cw_varid(int fileid, const char* source, const char* name, const char* title, const char* units)*/
  int ierr, varid;
  char *source, *name, *title, *units;
  ierr = fstr2cstr( dsoin, namestr1, *solen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dnain, namestr2, *nalen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dtiin, namestr3, *tilen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  ierr = fstr2cstr( dunin, namestr4, *unlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;

  varid = cw_varid( *fileid, namestr1, namestr2, namestr3, namestr4 );
  return varid;
}

int fc_error_( char *fmtin,
	       const int * const fmtmax, const int * const fmtlen ) {
  /* Fortran wrapper for cw_error.  Takes no arguments other than an output string.  */
  /* void cw_error(char *fmt, ...) */
  int ierr;
  ierr = IDRS_SUCCESS;
  ierr = fstr2cstr( fmtin, namestr1, *fmtlen );
  if ( ierr != IDRS_SUCCESS ) return ierr;
  cw_error( namestr1 );
  return IDRS_SUCCESS;
}
