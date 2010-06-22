/* error.c,v 2.0 1992/03/02 23:14:59 drach Released
   error.c,v
 * Revision 2.0  1992/03/02  23:14:59  drach
 * Entered into RCS
 *
*/
#include "drsed.h"
#ifdef mac
#include <stdarg.h>
#else
#include <varargs.h>
#endif
				/* Report error, with format fmt, and */
				/* variable argument list va_alist*/
#ifdef mac
void DRSEDerror(char *fmt, ...)
#else
DRSEDerror(fmt, va_alist)
     char *fmt ;
     va_dcl
#endif
{
	va_list args;
	if(!interact) fprintf(stderr,"%s: error near line %d\n",progname,lineno);
	va_start(args,*fmt);
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
