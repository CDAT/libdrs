/* io.c,v 2.1 1992/06/24 17:15:21 drach Exp
   io.c,v
 * Revision 2.1  1992/06/24  17:15:21  drach
 * added support for CRAY_R8, I8 element types
 *
 * Revision 2.0  1992/03/02  23:14:59  drach
 * Entered into RCS
 *
*/
#include <string.h>
#include "drsed.h"
#ifdef mac
#include <stdarg.h>
#else
#include <varargs.h>
#endif
#define MAX(A,B) ((A)<(B) ? (B) : (A))
				/* Print variable argument list with format */
				/* fmt to stdout, then flush buffer */
void
#ifdef mac
DRSEDprintf(int flushopt,char *fmt, ...)
#else
DRSEDprintf(flushopt,fmt,va_alist)
	int flushopt;
	
     char *fmt ;
     va_dcl
#endif
{
	va_list args;
	va_start(args, *fmt);
	vfprintf(stdout,fmt,args);
	va_end(args);
	if(flushopt==FLUSH)
		fflush(stdout);
	
}
				/* Formatted output of block of nelem identical */
				/* elements of type elemtype, length elemlen each, with */
				/* format informat. Write addresses iff writeaddrs; */
				/* Write missing data iff writemissing (otherwise print '-'. */
void
DRSEDwritefblock(outfile,block,nelem,elemtype,elemlen,informat,writeaddrs,writemissing)
	FILE *outfile;
	char *block,*informat;
	int nelem,elemtype,elemlen,writeaddrs,writemissing;
{
	int i,j,elemsPerLine;
	char format[256];
	void DRSEDprintDim();

	if(!strcmp(informat,"")) strncpy(format,informat,255);
	switch(elemtype)
	{
	  case IDRS_IEEE_R4:
		elemsPerLine=6;
		for(i=0; i<nelem;)
		{
			
			if(writeaddrs)
				DRSEDprintDim(i);
			else
				fputc('\n',outfile);
			for(j=0; i<nelem && j<elemsPerLine; i++,j++,block+=elemlen){
				if(!writemissing && (*(float *)block >= (1.0-1.0e-7)*MISSINGDATA))
					fprintf(outfile,"      -    ");
				else
					fprintf(outfile," %10.7g",*(float *)block);
			}
		}
		break;
	  case IDRS_I4:
		elemsPerLine=6;
		for(i=0; i<nelem;)
		{
			if(writeaddrs)
				DRSEDprintDim(i);
			else
				fputc('\n',outfile);
			for(j=0; i<nelem && j<elemsPerLine; i++,j++,block+=elemlen)
				fprintf(outfile," %10d",*(int *)block);
		}
		break;
	  case IDRS_CRAY_R8:
		elemsPerLine=5;
		for(i=0; i<nelem;)
		{
			
			if(writeaddrs)
				DRSEDprintDim(i);
			else
				fputc('\n',outfile);
			for(j=0; i<nelem && j<elemsPerLine; i++,j++,block+=elemlen){
				if(!writemissing && (*(float *)block >= (1.0-1.0e-7)*MISSINGDATA))
					fprintf(outfile,"      -    ");
				else
					fprintf(outfile," %13.10g",*(float *)block);
			}
		}
		break;
	  case IDRS_I8:
		elemsPerLine=5;
		for(i=0; i<nelem;)
		{
			if(writeaddrs)
				DRSEDprintDim(i);
			else
				fputc('\n',outfile);
			for(j=0; i<nelem && j<elemsPerLine; i++,j++,block+=elemlen)
				fprintf(outfile," %13d",*(int *)block);
		}
		break;
	  case IDRS_ASCII:
		sprintf(format," %%.%ds ",elemlen);
		elemsPerLine=MAX(80/(elemlen+2),1);
		for(i=0; i<nelem;){
			if(writeaddrs)
				DRSEDprintDim(i);
			else
				fputc('\n',outfile);
			for(j=0; i<nelem && j<elemsPerLine; i++,j++,block+=elemlen)
				fprintf(outfile,format,block);
		}
		break;
	  default:
		DRSEDerror("Illegal element type: %d",elemtype);
		break;
	}
	fputc('\n',outfile);
	fflush(outfile);
}
				/* Unformatted write nelem elements of block */
				/* to stdout, with elemlen bytes each*/

void
DRSEDprintublock(block,nelem,elemlen)
	char *block;
	int nelem,elemlen;
{
	fwrite(block,elemlen,nelem,stdout);
	fflush(stdout);
}

static DRS_VARIABLE *cpvar;	/* current print variable */
static int divisor[MXDIM];
static float interval[MXDIM];	/* interval for eq sp dims */
static int orient[MXDIM];	/* +/-1 for orientation of requested vals rel to file */
				/* Initialize new current print variable parameters */
void
DRSEDinitPrintDim(var)
DRS_VARIABLE *var;
{
	int ndim,i;
	
	cpvar=var;
	ndim=var->ndim;
	divisor[0]=1;
	for(i=1; i<ndim; i++)
		divisor[i]=divisor[i-1]*var->reqdimlen[i-1];
	for(i=0;i<ndim;i++){
		orient[i]=(var->ife[i] <= var->ile[i] ? 1 : -1);
		if(var->dim[i].dtype==IDRS_EQUALLY_SPACED)
			interval[i]=(var->dimlen[i]==1 ? 0.0 :
				  (var->dim[i].lastel - var->dim[i].firstel)/(var->dimlen[i] - 1));
	}
}
				/* Print the dimension values of the nth requested element */
void
DRSEDprintDim(n)
int n;
{
	int i,icurr[MXDIM];
	float dimval,*pdimval;

	for(i=cpvar->ndim-1; i>=0; i--){
		icurr[i]=n/divisor[i];
		n %= divisor[i];
	}
	fprintf(stdout,"\n( ");
	for(i=0; i<cpvar->ndim; i++){
		if(cpvar->dim[i].dtype==IDRS_EQUALLY_SPACED){
			dimval=cpvar->dim[i].reqfirstel+orient[i]*icurr[i]*interval[i];
			pdimval=&dimval;
		}
		else{
			pdimval=(float *)(cpvar->dim[i].dimdata->data);
			pdimval+=cpvar->ife[i]+orient[i]*icurr[i]-1;
		}
		if(i) fprintf(stdout,", ");
		fprintf(stdout,"%5.7g",*pdimval);
	}
	fprintf(stdout,"):");
}






