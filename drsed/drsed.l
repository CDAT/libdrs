%{
/* drsed specification for lexical analyzer. */
/* drsed.l,v 2.6 1996/03/22 18:30:04 drach Exp
   drsed.l,v
 * Revision 2.6  1996/03/22  18:30:04  drach
 * - Remove extraneous '}'
 *
 * Revision 2.4  1996/02/12  17:24:16  drach
 * - Recognize the _KRC_ flag to generate K&R C
 *
 * Revision 2.3  1995/10/16  19:15:17  drach
 * - Cast arguments for atof, strtol correctly for DEC Alpha version
 *
 * Revision 2.2  1993/07/16  00:31:55  drach
 * Added cast to (char *) for second argument of strncpy, for compatibility with HP.
 *
 * Revision 2.1  1992/06/24  17:14:18  drach
 * Added '~' as a legal character
 *
 * Revision 2.0  1992/03/02  23:14:59  drach
 * Entered into RCS
 *
*/
#include <strings.h>
#if defined(__alpha)
#include <stdlib.h>
#else
extern double atof();
extern long strtol();
#endif
extern char stringbuf[];
%}
%a 20000
%o 30000
escquote	\\\"
nonquotes	([^"]|{escquote})*
%%
\"{nonquotes}\"                 {  /* strip off quotes */
				  if( yyleng-1 > MAXSTRING)
				  {
				    DRSEDerror("A string is too large, was truncated: %s",
				      yytext);
				      strncpy(stringbuf,(char *)(yytext+1),MAXSTRING-1);
				    stringbuf[MAXSTRING-1]='\0';
				  }
				  else
				  {
				    strncpy(stringbuf,(char *)(yytext+1),yyleng-2);
				    stringbuf[yyleng-2]='\0';
				  }
				  strtrim(stringbuf);
				  yylval.sval=stringbuf;
				  return(USERSTRING);
				}
all|ALL				{return(ALL);}
batch|BATCH                     {return(BATCH);}
brief|BRIEF			{return(BRIEF);}
close|CLOSE			{return(CLOSE);}
create|CREATE			{return(CREATE);}
data|DATA			{return(DATA);}
describe|DESCRIBE		{return(DESCRIBE);}
full|FULL			{return(FULL);}
help|HELP			{return(HELP);}
index|INDEX			{return(INDEX);}
interactive|INTERACTIVE		{return(INTERACTIVE);}
length|LENGTH			{return(LENGTH);}
list|LIST			{return(LIST);}
mode|MODE			{return(MODE);}
name|NAME			{return(NAME);}
nd|ND				{return(ND);}
nv|NV				{return(NV);}
open|OPEN			{return(OPEN);}
print|PRINT			{return(PRINT);}
printi|PRINTI			{return(PRINTI);}
printu|PRINTU			{return(PRINTU);}
quit|QUIT			{if(currentfile != NULL_FILE)
                                   Cllun(currentfile->unit); /* Explicit close in case SET was used */
                                 return(0); /* endtoken */}
range|RANGE			{return(RANGE);}
set|SET				{return(SET);}
shape|SHAPE			{return(SHAPE);}
source|SOURCE			{return(SOURCE);}
time|TIME			{return(TIME);}
title|TITLE			{return(TITLE);}
type|TYPE			{return(TYPE);}
units|UNITS			{return(UNITS);}
write|WRITE			{return(WRITE);}
writeu|WRITEU			{return(WRITEU);}

[+-]?[0-9]*\.[0-9]*([eE][+-]?[0-9]+)? {
#ifndef _KRC_
				        yylval.dval= atof((const char *)yytext);
#else
				        yylval.dval= atof((char *)yytext);
#endif
					return(DOUBLE_CONST);
				      }
[+-]?[0-9]+|0[xX][0-9a-fA-F]+ {
#ifndef _KRC_
			        yylval.ival=strtol((const char *)yytext,(char**)0,0);
#else
			        yylval.ival=strtol((char *)yytext,(char**)0,0);
#endif
				return(INTEGER_CONST);
			      }
[A-Za-z_~#\.\/][A-Za-z_0-9~#\.\/]* {
			    if( yyleng > MAXSTRING-1)
			    {
			      DRSEDerror("An identifier name is too large, was truncated: %s",yytext);
			      strncpy(stringbuf,(char *)yytext,MAXSTRING-1);
			      stringbuf[MAXSTRING-1]='\0';
			    }
			    else
			    {
			      strncpy(stringbuf,(char *)yytext,yyleng);
			      stringbuf[yyleng]='\0';
			    }
			    yylval.sval=stringbuf;
			    return(IDENT);
			  }

\n	    {
	      lineno++;
	      return yytext[0];
	    }	
[ \t\14\f]+ {
	      /* whitespace */ ;
	    }			  
.	    {return yytext[0];}
