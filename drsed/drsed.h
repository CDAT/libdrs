/* drsed.h,v 2.3 1993/07/16 00:31:17 drach Exp
   drsed.h,v
 * Revision 2.3  1993/07/16  00:31:17  drach
 * Made external declarations explicit.
 *
 * Revision 2.2  1992/10/14  23:36:00  drach
 * Added prev field to DRS_VARIABLE struct, to support (in addvarlist
 * and deletevarlist) variables with the same name.
 *
 * Revision 2.1  1992/06/24  17:12:14  drach
 * Added two fields to the DRS_VARIABLE structure:
 * - fileName (the actual name in the file, as opposed
 *   to the name used by drsed)
 * - count - the number of other variables with
 *   the same name (set for first var with duplicate
 *   names only, to support hashing)
 *
 * Revision 2.0  1992/03/03  01:01:43  drach
 * Entered into RCS
 *
*/
#ifndef _drsed_h
#define _drsed_h

#include <stdio.h>
#include <malloc.h>
#include <math.h>
#include "drscdf.h"
#define MISSINGDATA 1.0e20	/* missing data float value */
#define DRSED 1	                /* drsed.h definition flag */
#define DRSCALL(X,Y) if(Drstest(X)) return(Y)
#define NULL_FILE (DRS_FILE *)0
#define NULL_VARIABLE (DRS_VARIABLE *)0
#define NULL_DIMENSION (DRS_DIMENSION *)0
#define MAXSTRING 132		/* string buffer length */
#define MXDIM 4			/* max dimensions */
#define MXFILE 6		/* max open files */
#define DRSED_GENERIC 999	/* DRSED generic error */
#define FLUSH 1			/* flushopt args for DRSEDprintf */
#define NOFLUSH 0
typedef struct DRS_DIMENSION
{
	int dtype;		/* Dimension type == IDRS_EQUALLY_SPACED */
				/* || IDRS_UNEQUALLY_SPACED */
	DRS_SOURCE source;
	DRS_NAME name;
	DRS_TITLE title;
	DRS_UNITS units;
	struct DRS_VARIABLE *dimdata;          /* Pointer to dimension, if uneq spaced */
	char *data;		/* Pointer to data, if eq spaced */
	struct DRS_VARIABLE *owner; /* Variable which owns this dimension */
	int num;		/* Number of this dimension */
	float firstel;		/* File first element */
	float lastel;		/* File last element */
	float reqfirstel;	/* Requested first element */
	float reqlastel;	/* Requested last element */
} DRS_DIMENSION;

typedef struct DRS_VARIABLE
{
	DRS_SOURCE source;
	DRS_NAME fileName;	/* Actual name in the DRS file */
	char name[IDRS_NAMELEN+10]; /* DRS name = fileName catenated with "[count]" */
	DRS_TITLE title;
	DRS_UNITS units;
	DRS_DATE cdate;
	DRS_TIME ctime;
	DRS_TYPE eltype;	/* formatted element type */
	int ieltype;		/* IDRS_IEEE_R4, IDRS_I4, etc. */
	int elembytes;		/* element byte length */
	int ndim;		/* number of dimensions */
	int dimlen[MXDIM];	/* dimension length array */
	int reqdimlen[MXDIM];	/* Requested range sizes */
	int ife[MXDIM];		/* 1-origin Dimension index of first requested elem */
	int ile[MXDIM];		/* 1-origin Dimension index of last requested elem */
	DRS_DIMENSION dim[MXDIM]; /* dimension array */
	int nelems;		/* Number of elements in data buffer */
	struct DRS_FILE *file;		/* file containing this variable */
	char *data;		/* actual data */
	struct DRS_VARIABLE *next; /* next variable in list */
	struct DRS_VARIABLE *prev; /* previous variable in list */
	int count;		/* Number of vars whose fileNames clash with this var */
} DRS_VARIABLE;
typedef struct DRS_FILE
{
	DRS_FILENAME name;
	DRS_FILENAME dataname;
	int unit;
	int dataunit;
	int nvars;		/* number of variables */
	DRS_VARIABLE *varlist;	/* head of variable list, or nil if not read */
	struct DRS_FILE *next;		/* next file in file list */
} DRS_FILE;

extern int interact;        /* interactive flag */
extern char stringbuf[MAXSTRING];  /* most recently read string */
extern DRS_FILE *currentfile;      /* most recently referenced DRS file */
extern DRS_VARIABLE *currentvar;   /* most recently referenced DRS variable */
extern char *progname;		/* program name */
extern int lineno;		/* current line number */
#ifdef sun
extern char *calloc();
#endif
#endif /* _drsed_h */
