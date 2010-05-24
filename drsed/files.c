/* files.c,v 2.3 1993/07/16 00:33:22 drach Exp
   files.c,v
 * Revision 2.3  1993/07/16  00:33:22  drach
 * Removed debug comment.
 *
 * Revision 2.2  1992/10/14  23:45:38  drach
 * In openfile, open with EXTEND rather than READ option.
 *
 * Revision 2.1  1992/06/24  17:14:54  drach
 * Replaced linked list search with hash table search
 *
 * Revision 2.0  1992/03/02  23:14:59  drach
 * Entered into RCS
 *
*/
#include "drsed.h"
#include "drsed.tab.h"
#include "hashSearch.h"
#define DICTUNIT 7		/* dictionary Fortran logical unit */
#define DATAUNIT 8		/* data file lu */
extern DRS_VARIABLE *DRSEDaddvarlist();
extern DRS_VARIABLE *DRSEDreadvar();


				/* Get a pointer to a new file structure */
DRS_FILE *DRSEDgetfile()
{
	return((DRS_FILE *)DRSEDalloc(sizeof(DRS_FILE),NULL));
}
				/* Open DRS file with given filename */
				/* return pointer, or nil if error*/
DRS_FILE *DRSEDopenfile(filename)
	char *filename;
{
	DRS_FILE *file;
	int err;
	

				/* Open file; ignore version 1 errors */
	Seterr(0,IDRS_FATAL);
	err=Drstest(Aslun(DICTUNIT,filename,DATAUNIT," ",IDRS_EXTEND));
	
	Seterr(0,IDRS_WARNING);
	if(err)
		file=NULL_FILE;
	else 
	{
		
				/* Create file structure */
		if(file=DRSEDgetfile())
		{
			strcpy(file->name,filename);
			file->unit=DICTUNIT;
			file->dataunit=DATAUNIT;
			file->varlist=NULL_VARIABLE;
		}
	}
	(void) hashInit();
	return(file);
	
		

	
}
				/* Read dictionary for file */
				/* return DRS error if any*/
int DRSEDreaddicfile(file)
	DRS_FILE *file;
{
	int err,reterr;
	DRS_VARIABLE *var;
	
	if(!file) return(DRSED_GENERIC); /* If the file is null, return with error */

	if(file->varlist != NULL_VARIABLE) return(0); /* return if dictionary already read */
/*	DRSEDprintf(FLUSH,"Calling DRSEDreaddicfile now.\n"); */
	file->nvars=0;
	Seterr(0,IDRS_FATAL);	/* Ignore no more variables warning */
	Cluvdb();		/* Clear VDB */
	err=Inqdict(file->unit,IDRS_GETFIRSTVAR); /* Start inquiry of all vars */
	Seterr(0,IDRS_WARNING);
				/* Continue while most recent error is nonfatal */
				/* and not 'no more variables.'*/
	while(err != IDRS_NOMOREVARS && !(reterr=Drstest(err)))
	{
		if((var=DRSEDreadvar(file))==NULL_VARIABLE)
			return(DRSED_GENERIC);
		if(!(file->varlist=DRSEDaddvarlist(var,file->varlist)))
			return DRSED_GENERIC;
		file->nvars++;
		Seterr(0,IDRS_FATAL);
		err=Inqdict(file->unit,IDRS_GETNEXTVAR);
		Seterr(0,IDRS_WARNING);
	}
	return(reterr ? DRSED_GENERIC : 0);
}
				/* List variables in file */
void
DRSEDlist(file,option)
	DRS_FILE *file;
	int option;
{
	DRS_VARIABLE *var;
	
	for(var=file->varlist; var != NULL_VARIABLE;
	    var=var->next)
	{
		switch(option)
		{
		  case BRIEF:
			DRSEDprintf(NOFLUSH,"%s ",var->name);
			break;
		  case FULL:
			DRSEDprintf(NOFLUSH,"%.16s: %s \n",var->name,var->title);
			break;
		  default:
			DRSEDerror("Invalid list option %d, file %s",option,file->name);
			return;
		}
		if(!interact) DRSEDprintf(FLUSH,"\n");
		
	}
	if(interact) DRSEDprintf(FLUSH,"\n");
	
}
				/* Find variable named varname in file */


/* Find variable in file with name, or nil if none */
DRS_VARIABLE   *
DRSEDfindvar(name, file)
    char           *name;
    DRS_FILE       *file;

{
    DRS_VARIABLE   *var;
    ENTRY varEntry, *varFound;
    
    if(file==NULL_FILE){
	    DRSEDerror("No file open");
	    return(NULL_VARIABLE);
    }

    varEntry.key = name;
    if(( varFound = hashSearch( varEntry, FIND )) == 0){
	    DRSEDerror("Variable not found: %s",name);
	    var = NULL_VARIABLE;
    }
    else
	    var = (DRS_VARIABLE *) varFound->data;

    return var;
}
				/* Get a field from a file */
void
DRSEDgetfilefield(file,field)
	DRS_FILE *file;
	int field;
{
	switch(field)
	{
	  case NV:
		DRSEDprintf(FLUSH,"%d\n",file->nvars);
		break;
	  default:
		DRSEDerror("Illegal file field: %d",field);
		break;
	}
	
}

int DRSEDopenoutputfile(filename,outfile)
	char *filename;
	FILE **outfile;
{
	if(*outfile != NULL && *outfile != stdout)
		DRSEDcloseoutputfile(outfile);
	
	if((*outfile=fopen(filename,"w"))==NULL)
	{
		DRSEDerror("Error opening output file %s",filename);
		return(DRSED_GENERIC);
	}
	else
		return(0);
}
int
DRSEDcloseoutputfile(outfile)
	FILE **outfile;
{
	if(*outfile==NULL || *outfile==stdout)
	{
		DRSEDerror("No outfile currently open");
		return(DRSED_GENERIC);
	}
	else
	{
		fclose(*outfile);
		return(0);
	}
}

			
