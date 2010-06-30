/* dims.c,v 2.1 1992/10/14 23:33:39 drach Rel
   dims.c,v
 * Revision 2.1  1992/10/14  23:33:39  drach
 * 1) Access unequally-spaced dimension fields from the dimension variable.
 * 2) Added setdim function to modify name and units of a dimension.
 *    This supports the SET command
 *
 * Revision 2.0  1992/03/02  23:14:59  drach
 * Entered into RCS
 *
*/
#include <string.h>
#include "drsed.h"
#include "drsed.tab.h"
	extern char *DRSEDalloc();

				/* Print fields from a dimension */
int
DRSEDgetdimfield(flushopt,dim,field)
	DRS_DIMENSION *dim;
	int field,flushopt;
{
	DRS_VARIABLE *var;
	int idim,reqlen,retlen,err;
	
	switch(field)
	{
	  case NAME:
		DRSEDprintf(flushopt,"%s\n",
			    (dim->dtype==IDRS_EQUALLY_SPACED ? dim->name : dim->dimdata->name));
		break;
		
	  case TITLE:
		DRSEDprintf(flushopt,"%s\n",
			    (dim->dtype==IDRS_EQUALLY_SPACED ? dim->title : dim->dimdata->title));
		break;
		
	  case SOURCE:
		DRSEDprintf(flushopt,"%s\n",(dim->dtype==IDRS_EQUALLY_SPACED ? dim->source : dim->dimdata->source));
		break;
		
	  case UNITS:
		DRSEDprintf(flushopt,"%s\n",(dim->dtype==IDRS_EQUALLY_SPACED ? dim->units : dim->dimdata->units));
		break;
		
	  case DATA:
				/* For evenly-spaced dimensions, generate in dim->data */
		if(dim->dtype==IDRS_EQUALLY_SPACED)
		{
			int i;
			float *f,g,interval;

			var=dim->owner;
			idim=dim->num;
			reqlen=var->dimlen[idim]*sizeof(float);
			if(dim->data==NULL)
			{
				if((dim->data=DRSEDalloc(reqlen,dim->data))==NULL)
				{
					DRSEDerror("Cannot allocate memory for dimension %s of variable %s",dim->name,var->name);
					return;
				}
				else
				{
					interval=(dim->lastel - dim->firstel)/(var->dimlen[idim] - 1);
					for(i=0,f=(float *)dim->data,g=dim->firstel; i<var->dimlen[idim]; i++)
					{
						*f++=g;
						g+=interval;
					}
				}
			}
			if(interact){
				DRSEDinitPrintDim(var);
				DRSEDwritefblock(stdout,dim->data,var->dimlen[idim],IDRS_IEEE_R4,sizeof(float),"",1,0);
			}
			else
				DRSEDprintublock(dim->data,var->dimlen[idim],sizeof(float));
			
		}
		else
		{
			if(interact)
				DRSEDprintvardata(dim->dimdata);
			else
				DRSEDprintuvardata(dim->dimdata);
		}
		break;
		
	  case RANGE:
		DRSEDprintf(flushopt,"%g %g\n",dim->firstel,dim->lastel);
		break;
		
	  default:
		DRSEDerror("Invalid dimension field: %d",field);
		return(DRSED_GENERIC);
		
	}
	
	return(0);
}

				/* Set dimension field */
void
DRSEDsetdim( dim, field, str )
	DRS_DIMENSION *dim;
	int field;
	char *str;
{
	DRS_VARIABLE *var;
	DRS_SOURCE tempStr;	/* Assumes that source is the largest string! */
	int err;

	if(dim->dtype == IDRS_UNEQUALLY_SPACED){
		DRSEDsetvar(dim->dimdata, field, str);
		return;
	}
	else{
		var=dim->owner;
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
		  case NAME:
			tempStr[IDRS_NAMELEN-1]='\0';
			err=Setdim(dim->num+1,tempStr,dim->units,0,1.0e20,1.0e20);
			break;
		  case UNITS:
			tempStr[IDRS_UNITSLEN-1]='\0';
			err=Setdim(dim->num+1,dim->name,tempStr,0,1.0e20,1.0e20);
			break;
		  case SOURCE:
		  case TITLE:
			DRSEDerror("Evenly spaced dimension %s of variable %s does not have a %s field.\n",dim->name,var->name, (field==SOURCE ? "source" : "title"));
			return;
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
		  case NAME:
			strcpy(dim->name,tempStr);
			if(strcmp(tempStr," ")) strtrim(dim->name);
			break;
		  case UNITS:
			strcpy(dim->units,tempStr);
			if(strcmp(tempStr," ")) strtrim(dim->units);
			break;
		}
	}
	return;
}

