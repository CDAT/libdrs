/* vars.c,v 2.4 1995/10/16 19:15:47 drach Exp
   vars.c,v
 * Revision 2.4  1995/10/16  19:15:47  drach
 * - Cast Getcdim data arg to float*
 *
 * Revision 2.3  1993/07/16  00:34:04  drach
 * Cleaned up ifdefs.
 *
 * Revision 2.2  1992/10/14  23:50:19  drach
 * Modified addvarlist to support 'uniquefying' names: if
 * two variables are named 'x', the second will have a
 * drsed name of 'x~2';
 *
 * Added deletevarlist to delete var from linked list and
 * hash table.
 *
 * Fixed set of var->elembytes field depending on machine type.
 *
 * Removed title printing for equally-spaced dimensions (no title
 * defined in this case).
 *
 * Modified setvar to handle renaming to blank fields (but not
 * blank names)
 *
 * Revision 2.1  1992/06/24  17:15:46  drach
 * modified addvarlist to use hashing, to check
 * for variables with the same name, and add
 * a ~n modifier when same-name variables
 * are encountered
 *
 * Revision 2.0  1992/03/02  23:14:59  drach
 * Entered into RCS
 *
*/
#include "drsed.h"
#include "drsed.tab.h"
#include "hashSearch.h"
#include <string.h>

extern DRS_VARIABLE *DRSEDcreatevar();
extern DRS_VARIABLE *DRSEDfindvar();
extern char    *DRSEDalloc();

/* Add var to list headed by head, and return new head. */
/* Also add to hash table. */
 /* Return var if successful, or NULL if an error occurred. */

DRS_VARIABLE   *
DRSEDaddvarlist(var, head)
    DRS_VARIABLE   *var, *head;
{
	ENTRY varListEntry, *varFirstEntry, *insertionStatus;
	DRS_VARIABLE *varFirst;

	varListEntry.key = var->fileName;
	varListEntry.data = var;

				/* Try to insert the variable */

	if( hashSearch( varListEntry, INSERT ) == HASH_ERROR){

				/* The insert failed, name clash? */
		if(( varFirstEntry = hashSearch( varListEntry, FIND )) != HASH_ERROR ){

				/* Duplicate entry was found, find a unique name */

			varFirst = varFirstEntry->data;
			insertionStatus = HASH_ERROR;
			while( insertionStatus == HASH_ERROR ){
				sprintf( var->name, "%s~%d", var->fileName, ++varFirst->count );
				varListEntry.key = var->name;
				varListEntry.data = var;
				insertionStatus = hashSearch( varListEntry, INSERT );
			}
		}
		else{
				/* The insertion failed but no name conflict, so table overflow */
			DRSEDerror( "Cannot add %s to hash table, table overflow?\n", var->name );
			return NULL_VARIABLE;
		}
	}
	   
	var->next = head;
	if( head ) head->prev = var;
	var->prev = NULL_VARIABLE;
	return var;
	
}

				/* Delete var from linked list and hash table */
				/* Return var if successful, NULL else */
DRS_VARIABLE   *
DRSEDdeletevarlist( var )
	DRS_VARIABLE *var;
{
	ENTRY varListEntry;
	DRS_VARIABLE *baseVar;
				/* Delete var from the hash table */

	varListEntry.key = var->name;
	if( hashSearch( varListEntry, DELETE ) == HASH_ERROR ){
		DRSEDerror( "Cannot delete %s from hash table, not found", var->name );
		return (DRS_VARIABLE *)0;
	}

				/* Delete var from the linked list */

	if( var->prev )
		var->prev->next = var->next;
	else
		var->file->varlist = var->next;
	if( var->next ) var->next->prev = var->prev;
	var->next = NULL_VARIABLE;
	var->prev = NULL_VARIABLE;
	
				/* Reset name clash count */

	var->count = 1;
	return var;
}

/* Read the variable description */
DRS_VARIABLE   *
DRSEDreadvar(file)
    DRS_FILE       *file;
{
    DRS_VARIABLE   *var, *dimvar;
    int             idim, reqlen, retlen, err;
    DRS_DIMENSION  *dim;

    /* allocate memory for the next variable */
    if (!(var = DRSEDcreatevar())) {
	DRSEDerror("Cannot create variable for file %s", file->name);
	return (var);
    }
    /* Get naming info */
    DRSCALL(Getname(var->source, var->fileName, var->title, var->units, var->cdate, var->ctime, var->eltype, &var->ndim),NULL_VARIABLE);
    strtrim(var->source);
    strtrim(var->fileName);
    strcpy(var->name,var->fileName);
    strtrim(var->title);
    strtrim(var->units);
    DRSCALL(Getelemd(&var->ieltype, &var->elembytes),NULL_VARIABLE);
#ifdef cray
    if(var->ieltype==IDRS_IEEE_R4 || var->ieltype==IDRS_I4) var->elembytes=IDRS_BYTES_PER_WORD;
#else
    if(var->ieltype==IDRS_CRAY_R8 || var->ieltype==IDRS_I8) var->elembytes=IDRS_BYTES_PER_WORD;
#endif
    var->nelems = 0;		/* No data read yet */
    var->file=file;
    for (idim = 0; idim < var->ndim; idim++) {
	dim = &var->dim[idim];
	/* Get dimension info */
	DRSCALL(Getedim(idim + 1, dim->source, dim->name, dim->title, dim->units, &dim->dtype, &var->dimlen[idim], &dim->firstel, &dim->lastel),NULL_VARIABLE);
	strtrim(dim->name);
	strtrim(dim->units);
	/* Default requested ranges  */
	dim->reqfirstel = dim->firstel;
	dim->reqlastel = dim->lastel;
	var->reqdimlen[idim] = var->dimlen[idim];
	dim->owner=var;
	dim->num=idim;
	/*
	 * Get dimension data for unequally-spaced dimensions
	 */
	if (dim->dtype == IDRS_UNEQUALLY_SPACED) {

	    /* Find the dimension variable; */
	    if ((dimvar = DRSEDfindvar(dim->name, file)) == NULL_VARIABLE) {

		DRSEDerror("Cannot find dimension variable %s for variable %s", dim->name, var->name);
		return (NULL_VARIABLE);
	    }
	    /*
	     * if the dimension variable has not had data read into it,
	     */
	    /* do it now. */
	    if (dimvar->data == NULL) {
		reqlen = dimvar->dimlen[0] * sizeof(float);
		if (!(dimvar->data = DRSEDalloc(reqlen,NULL))) {

		    DRSEDerror("Cannot allocate memory for dimension variable %s of variable %s", dimvar->name, var->name);
		    return (NULL_VARIABLE);

		}
		Seterr(0, IDRS_NOREPORT);
		if (Drstest(err = Getcdim(idim + 1, dim->source, dim->name, dim->title, dim->units, &dim->dtype, reqlen, (float *)dimvar->data, &retlen)) && err != IDRS_BADLEN) {

		    DRSEDerror("Error getting dimension variable %s for variable %s", dimvar->name, var->name);
		    return (NULL_VARIABLE);
		}
		Seterr(0, IDRS_WARNING);
		strtrim(dim->source);
		strtrim(dim->title);
		dim->dimdata = dimvar;
				/* Dimension variables only have one dimension */
		dimvar->nelems=dimvar->dimlen[0];
	    }
	    else		/* dimension var already has data in it. */
	    {
		    strcpy(dim->source,dimvar->source);
		    strcpy(dim->title,dimvar->title);
		    dim->dimdata=dimvar;
		    
	    }
	    
	}
	else			/* Equally-spaced dimension */
	{
		strcpy(dim->source," ");
		strcpy(dim->title," ");
	}
	
    }
    return (var);
}


/* Get a pointer to a new variable structure */
DRS_VARIABLE   *
DRSEDcreatevar()
{
	DRS_VARIABLE *pVar;

	pVar= (DRS_VARIABLE *) DRSEDalloc(sizeof(DRS_VARIABLE),NULL);
	pVar->count = 1;
	pVar->next = NULL_VARIABLE;
	pVar->prev = NULL_VARIABLE;
	return pVar;
}

				/* Get a field from a variable */
void
DRSEDgetvarfield(var,field)
	DRS_VARIABLE *var;
	int field;
{
	int i,nelems;
	

    switch (field)
    {
      case INDEX:
	    if(DRSEDgetvarlen(var,&nelems))
	    {
		    DRSEDerror("Cannot get indices for %s",var->name);
		    return;
	    }
	    for(i=0; i<var->ndim;i++)
	    {
		    DRSEDprintf(NOFLUSH,"%d",var->ife[i]);
		    if(interact)
			    DRSEDprintf(NOFLUSH,":");
		    else
			    DRSEDprintf(NOFLUSH,"\n");
		    DRSEDprintf(NOFLUSH,"%d",var->ile[i]);
		    if(interact)
			    DRSEDprintf(NOFLUSH," ");
		    else
			    DRSEDprintf(FLUSH,"\n");
	    }
	    if(interact)DRSEDprintf(FLUSH,"\n");
	    
	    break;
	    
				    
      case SHAPE:
	    if(DRSEDgetvarlen(var,&nelems))
	    {
		    DRSEDerror("Cannot get shape for %s",var->name);
		    return;
		    
	    }
	    
	    for (i = 0; i < var->ndim; i++) 
	    {
		    DRSEDprintf(NOFLUSH,"%d ", var->reqdimlen[i]);
		    if(!interact) DRSEDprintf(FLUSH,"\n");
	    }
	    if(interact) DRSEDprintf(FLUSH,"\n");
	    
	    break;

      case LENGTH:
	    if(DRSEDgetvarlen(var,&nelems))
	    {
		    DRSEDerror("Cannot get length for %s",var->name);
		    return;
	    }
	DRSEDprintf(FLUSH,"%d\n", nelems);
	break;
    case SOURCE:
	DRSEDprintf(FLUSH,"%s\n", var->source);
	break;
    case NAME:
	DRSEDprintf(FLUSH,"%s\n", var->fileName);
	break;
    case TITLE:
	DRSEDprintf(FLUSH,"%s\n", var->title);
	break;
    case UNITS:
	DRSEDprintf(FLUSH,"%s\n", var->units);
	break;
    case TIME:
	DRSEDprintf(FLUSH,"%s %s\n", var->cdate, var->ctime);
	break;
    case TYPE:
	DRSEDprintf(FLUSH,"%s\n", var->eltype);
	break;
    case ND:
	DRSEDprintf(FLUSH,"%d\n", var->ndim);
	break;
    default:
	DRSEDerror("Invalid field: %d", field);
	break;
    }
}
				/* Read variable data from file */
int
DRSEDreadvardata(var)
	DRS_VARIABLE *var;
{
	static char *currentdata;			/* Current data */
	int err,idim,nbytes,ife,ile,dimlen,oper,nelems;
	float dfe,dle;
	DRS_FILE *file;
				/* If the variable is a dimension variable, */
				/* and has already been read (i.e., is referenced */
				/* by another variable, leave it's data space as private.*/
	if(!strcmp(var->dim[0].name,"internal") && var->data)
		return(0);
	file=var->file;
	if(err=DRSEDgetvarlen(var,&nelems))
		return(err);
	nbytes=nelems*var->elembytes;

	for(idim=0; idim<var->ndim; idim++)
	{
		switch(var->dim[idim].dtype)
		{
		  case IDRS_EQUALLY_SPACED:
			DRSCALL(err=Setdim(idim+1,var->dim[idim].name," ",var->reqdimlen[idim],var->dim[idim].reqfirstel,var->dim[idim].reqlastel),err);
			break;
		  case IDRS_UNEQUALLY_SPACED:
			DRSCALL(err=Setvdim(idim+1," ",var->dim[idim].name," "," ",var->dim[idim].reqfirstel,var->dim[idim].reqlastel),err);
			break;
		}
		
	}
				/* Read the data */
	if((currentdata=DRSEDalloc(nbytes,currentdata))==NULL)
	{
		DRSEDerror("Cannot allocate %d bytes for %s",nbytes,var->name);
		return(DRSED_GENERIC);
	}
	
	DRSCALL(err=Getdat(file->unit,currentdata,nbytes),err);
	var->data=currentdata;
	var->nelems=nelems;
	return(0);
}
				/* Print (formatted) variable data */
void
DRSEDprintvardata(var)
	DRS_VARIABLE *var;
{
	DRSEDinitPrintDim(var);
	DRSEDwritefblock(stdout,var->data,var->nelems,var->ieltype,var->elembytes,"",1,0);
	return;
	
}

				/* Print (unformatted) variable data */
void
DRSEDprintuvardata(var)
	DRS_VARIABLE *var;
{
	DRSEDprintublock(var->data,var->nelems,var->elembytes);
	return;
	
}
void
DRSEDwriteuvardata(var,outfile)
	DRS_VARIABLE *var;
	FILE *outfile;
{
	fwrite(var->data,var->nelems,var->elembytes,outfile);
	return;
}
				/* Write data from var with format, to outfile */
void
DRSEDwritevardata(var,outfile,format)
	DRS_VARIABLE *var;
	FILE *outfile;
	char *format;
{
	DRSEDinitPrintDim(var);
	DRSEDwritefblock(outfile,var->data,var->nelems,var->ieltype,
			 var->elembytes,format,0,1);
}

		
				/* Get the variable element length*/
int
DRSEDgetvarlen(var,len)
	DRS_VARIABLE *var;
	int *len;
{
	int err,idim,nelems,ife,ile,oper,dimlen;
	float dfe,dle;
	DRS_FILE *file;

	file=var->file;
				/* Specify the variable to inquire. */
	DRSCALL(err=Setname(var->source,var->fileName,var->title,var->units," "),err);
	
				/* Make the requested variable current, for inquiry */
	Seterr(0,IDRS_FATAL);
	oper=IDRS_GETFIRSTVAR;
	
	do
	{
		DRSCALL(err=Inqdict(file->unit,oper),(Seterr(0,IDRS_FATAL),err));
		oper=IDRS_GETNEXTVAR;
	}
	
	
	while(err==IDRS_INEXACTMATCH && err!=IDRS_NOMOREVARS);
	Seterr(0,IDRS_WARNING);
	

				/* Get the number of values to be read */
				/* and set the dimension ranges */
	for(idim=0,nelems=1; idim<var->ndim; idim++)
	{
		DRSCALL(err=Getrge2(file->unit,idim+1,var->dim[idim].reqfirstel,var->dim[idim].reqlastel,&ife,&ile,&dfe,&dle),err);
		var->ife[idim]=ife;
		var->ile[idim]=ile;
		var->dim[idim].reqfirstel=dfe;
		var->dim[idim].reqlastel=dle;
		dimlen=var->reqdimlen[idim]=abs(ife-ile)+1;
		
		nelems*=dimlen;
		
	}
	*len=nelems;
	return(0);
	
}

void
DRSEDdescribevar(var)
	DRS_VARIABLE *var;
{
	int idim;
	DRS_DIMENSION *dim;
	double interval;

	DRSEDprintf(NOFLUSH,"Name: ");
	DRSEDgetvarfield(var,NAME);
	DRSEDprintf(NOFLUSH,"Title: ");
	DRSEDgetvarfield(var,TITLE);
	DRSEDprintf(NOFLUSH,"Source: ");
	DRSEDgetvarfield(var,SOURCE);
	DRSEDprintf(NOFLUSH,"Units: ");
	DRSEDgetvarfield(var,UNITS);
	DRSEDprintf(NOFLUSH,"Data type: ");
	DRSEDgetvarfield(var,TYPE);
	DRSEDprintf(NOFLUSH,"Shape: ");
	DRSEDgetvarfield(var,SHAPE);
	DRSEDprintf(NOFLUSH,"Date: ");
	DRSEDgetvarfield(var,TIME);

	for(idim=0; idim<var->ndim; idim++)
	{
		dim=&var->dim[idim];
		DRSEDprintf(NOFLUSH,"** Dimension %d **\n",idim+1);
		
		switch(dim->dtype)
		{
		  case IDRS_EQUALLY_SPACED:
			DRSEDprintf(NOFLUSH,"  Name: ");
			DRSEDgetdimfield(NOFLUSH,dim,NAME);
			DRSEDprintf(NOFLUSH,"  Units: ");
			DRSEDgetdimfield(NOFLUSH,dim,UNITS);
			DRSEDprintf(NOFLUSH,"  Spacing: even\n");
			DRSEDprintf(NOFLUSH,"  Interval: ");
			interval=(var->dimlen[idim]==1 ? 0.0 :
				  fabs(dim->lastel - dim->firstel)/(var->dimlen[idim] - 1));
			DRSEDprintf(NOFLUSH,"%g\n",interval);
			DRSEDprintf(NOFLUSH,"  Range: ");
			DRSEDgetdimfield(NOFLUSH,dim,RANGE);
			break;
			
		  case IDRS_UNEQUALLY_SPACED:
			DRSEDprintf(NOFLUSH,"  Name: ");
			DRSEDgetdimfield(NOFLUSH,dim,NAME);
			DRSEDprintf(NOFLUSH,"  Title: ");
			DRSEDgetdimfield(NOFLUSH,dim,TITLE);
			DRSEDprintf(NOFLUSH,"  Source: ");
			DRSEDgetdimfield(NOFLUSH,dim,SOURCE);
			DRSEDprintf(NOFLUSH,"  Units: ");
			DRSEDgetdimfield(NOFLUSH,dim,UNITS);
			DRSEDprintf(NOFLUSH,"  Spacing: uneven\n");
			DRSEDprintf(NOFLUSH,"  Length: ");
			DRSEDprintf(NOFLUSH,"%d\n",var->dimlen[idim]);
			DRSEDprintf(NOFLUSH,"  Values: ");
			DRSEDgetdimfield(NOFLUSH,dim,DATA);
			break;
			
		  default:
			DRSEDerror("Invalid dimension type: %d",dim->dtype);
			return;
			
		}
	}
	
}
				/* Set the requested elements for */
				/* variable cvar, dimension ndim */
				/* to 1-origin indices ifirst, ilast.*/
int
DRSEDsetreqel(cvar,ndim,ifirst,ilast)
	DRS_VARIABLE *cvar;
	int ndim,ifirst,ilast;
{
	double interval;
	DRS_DIMENSION *dim;
	float *dimarray;
	int len;

	len=cvar->dimlen[ndim];
	if(ifirst < 1 || ifirst > len || ilast < 1 || ilast > len){
		DRSEDerror("Invalid range: %d:%d",ifirst,ilast);
		return 1;
	}

	dim=&(cvar->dim[ndim]);
	
	if(dim->dtype == IDRS_UNEQUALLY_SPACED){
		dimarray=(float *)(dim->dimdata->data);
		dim->reqfirstel=dimarray[ifirst-1];
		dim->reqlastel=dimarray[ilast-1];
	}
	else{
		interval=(cvar->dimlen[ndim]==1 ? 0.0 :
			  (dim->lastel - dim->firstel)/(cvar->dimlen[ndim] - 1));
		dim->reqfirstel=dim->firstel+(ifirst-1)*interval;
		dim->reqlastel=dim->firstel+(ilast-1)*interval;
	}
	return 0;
}
				/* Set variable field  */
void
DRSEDsetvar( var, field, str )
	DRS_VARIABLE *var;
	int field;
	char *str;
{
	DRS_SOURCE tempStr;	/* Assumes that source is the largest string! */
	int err;
	
	Cluvdb();
	err=Setname(var->source,var->fileName,var->title,var->units," ");
	if(Inqdict(var->file->unit,IDRS_GETFIRSTVAR) != IDRS_SUCCESS){
		DRSEDerror("Error finding variable %s in dictionary file %s.\n",
			   var->name,var->file->name);
		return;
	}

	strncpy(tempStr,str,IDRS_SOURCELEN-1);
	if(!strcmp(tempStr,"")) strcpy(tempStr," ");
	switch (field) {
	  case SOURCE:
		tempStr[IDRS_SOURCELEN-1]='\0';
		err=Setname(tempStr,var->fileName,var->title,var->units," ");	
		break;
	  case NAME:
		if(!strcmp(tempStr," ")){
			DRSEDerror("Cannot have blank variable names.\n");
			return;
		}
		tempStr[IDRS_NAMELEN-1]='\0';
		err=Setname(var->source,tempStr,var->title,var->units," ");
		break;
	  case TITLE:
		tempStr[IDRS_TITLELEN-1]='\0';
		err=Setname(var->source,var->fileName,tempStr,var->units," ");
		break;
	  case UNITS:
		tempStr[IDRS_UNITSLEN-1]='\0';
		err=Setname(var->source,var->fileName,var->title,tempStr," ");
		break;
	  default:
		DRSEDerror("Invalid set field: %d.\n",field);
		return;
	}

				/* Write the field to the dictionary */
	if(Putdic(var->file->unit,IDRS_BLANKS_ARE_LITERAL) != IDRS_SUCCESS){
		DRSEDerror("Error writing to dictionary file %s.\n",var->file->name);
		return;
	}
				/* The write was successful, so update the variable */
				/* structure. */
	switch( field ){
	  case SOURCE:
		strcpy(var->source,tempStr);
		if(strcmp(tempStr," ")) strtrim(var->source);
		break;
	  case NAME:
		if( !DRSEDdeletevarlist( var )){
			DRSEDerror("Error changing %s name.\n",var->name);
			return;
		}
		strcpy(var->fileName,tempStr);
		if(strcmp(tempStr," ")) strtrim(var->fileName);
		strcpy(var->name,var->fileName);
		if( !( var->file->varlist=DRSEDaddvarlist(var,var->file->varlist ))){
			DRSEDerror("Error changing %s name.\n",var->name);
			return;
		}
		break;
	  case TITLE:
		strcpy(var->title,tempStr);
		if(strcmp(tempStr," ")) strtrim(var->title);
		break;
	  case UNITS:
		strcpy(var->units,tempStr);
		if(strcmp(tempStr," ")) strtrim(var->units);
		break;
	}
	return;
}
