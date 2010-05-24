/* error.c,v 2.0 1992/03/02 23:14:59 drach Released
   error.c,v
 * Revision 2.0  1992/03/02  23:14:59  drach
 * Entered into RCS
 *
*/
#include "drsed.h"
#include <varargs.h>
				/* Report error, with format fmt, and */
				/* variable argument list va_alist*/
DRSEDerror(fmt, va_alist)
     char *fmt ;
     va_dcl
{
	va_list args;
	if(!interact) fprintf(stderr,"%s: error near line %d\n",progname,lineno);
	va_start(args);
	vfprintf(stderr,fmt,args);
	va_end(args);
	fputc('\n',stderr);
	fflush(stderr);
}
				/* yacc error routine */
yyerror(s)
	char *s;
{
	DRSEDerror(s);
}
				/* Handle error handshake in batch mode */
DRSEDbatcherror(err)
{
	fflush(stdin);
	DRSEDprintf(FLUSH,"%d\n",err);
	if(getchar()!='\n')
		DRSEDerror("Expecting <CR> response in batch mode");
	ungetc('\n',stdin);
	
}
