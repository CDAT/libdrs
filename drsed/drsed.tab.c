#ifndef lint
static char yysccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93";
#endif
#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define yyclearin (yychar=(-1))
#define yyerrok (yyerrflag=0)
#define YYRECOVERING (yyerrflag!=0)
#define YYPREFIX "yy"
#line 19 "drsed.y"
#include "drsed.h"
#include <string.h>
#define DRSEDCALL(X,Y) err=X;\
	               if(!interact)\
		       	  DRSEDbatcherror(err);\
		       if(!err) Y;
#define DRSEDYYERROR if(!interact)\
		        DRSEDbatcherror(DRSED_GENERIC);\
                     YYERROR
static char *sink;
static char singleBlank[]=" ";
static int size;
extern DRS_FILE *DRSEDopenfile();
extern int DRSEDreaddicfile();
extern DRS_VARIABLE *DRSEDfindvar();
static int err;  /* error return */
static int err2;
static int ndim; /* number of dimensions */
extern FILE *_drsed_outfile;
char c;
#line 40 "drsed.y"
typedef union {
         double dval;
	 int ival;
	 char *sval;
	 DRS_FILE *fileval;
	 DRS_VARIABLE *varval;
       } YYSTYPE;
#line 41 "y.tab.c"
#define ALL 257
#define BATCH 258
#define BRIEF 259
#define CLOSE 260
#define CREATE 261
#define DATA 262
#define DESCRIBE 263
#define FULL 264
#define HELP 265
#define INDEX 266
#define INTERACTIVE 267
#define LENGTH 268
#define LIST 269
#define MODE 270
#define NAME 271
#define ND 272
#define NV 273
#define OPEN 274
#define PRINT 275
#define PRINTI 276
#define PRINTU 277
#define QUIT 278
#define RANGE 279
#define SET 280
#define SHAPE 281
#define SOURCE 282
#define TIME 283
#define TITLE 284
#define TYPE 285
#define UNITS 286
#define WRITE 287
#define WRITEU 288
#define DOUBLE_CONST 289
#define INTEGER_CONST 290
#define USERSTRING 291
#define IDENT 292
#define YYERRCODE 256
short yylhs[] = {                                        -1,
    0,    0,    0,    0,   16,   16,   16,   16,   16,   16,
   16,   16,   16,   16,   16,   16,   16,   16,   16,   17,
    2,    2,   18,   19,   13,   14,   14,   14,   20,   20,
   20,    7,    8,    8,    8,    8,    8,    8,    8,    9,
    9,    9,   21,   11,   11,   11,   11,   11,   11,   10,
   22,    6,    6,    6,    6,    6,    6,    6,    6,    6,
    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
    6,    6,    6,    6,    6,    6,    6,   23,    5,    5,
    5,   24,   33,   33,   25,    1,   26,   35,   32,   34,
   34,   36,   36,   39,   37,   38,   38,   38,   27,   42,
   40,   41,   41,   43,   43,   46,   44,   45,   45,   45,
   28,   30,    3,    3,    3,   31,   15,   15,   29,   29,
   12,   12,   12,   12,    4,    4,    4,
};
short yylen[] = {                                         2,
    0,    2,    3,    3,    1,    1,    1,    1,    1,    1,
    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
    1,    1,    2,    2,    1,    0,    1,    1,    1,    2,
    2,    1,    1,    1,    1,    1,    1,    1,    1,    1,
    1,    1,    3,    1,    1,    1,    1,    1,    1,    1,
    2,    0,    1,    1,    1,    1,    1,    1,    1,    1,
    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
    1,    1,    1,    1,    1,    1,    1,    2,    0,    1,
    1,    2,    1,    1,    2,    1,    2,    0,    3,    0,
    3,    1,    3,    0,    2,    1,    1,    3,    2,    0,
    3,    0,    3,    1,    3,    0,    2,    1,    1,    3,
    2,    3,    0,    1,    1,    2,    1,    1,    5,    6,
    1,    1,    1,    1,    0,    1,    1,
};
short yydefred[] = {                                      1,
    0,    0,   20,    0,   49,    0,    0,   42,   40,    0,
    0,    0,   39,   32,    0,    0,    0,    0,   48,    0,
   41,    0,   37,    0,   38,    0,    0,    0,    2,   29,
    0,    0,    0,    0,    5,    6,    7,    8,    9,   10,
   11,   12,   13,   14,   15,   16,   17,   18,   19,    4,
   22,   21,   23,   28,   27,   88,   25,   24,   53,   54,
   55,   56,   57,   58,   59,   60,   61,   62,   63,   64,
   65,   66,   67,   68,   69,   70,   71,   72,   73,   74,
   75,   76,   77,   51,   80,   81,   78,   84,   83,   82,
   85,   86,   87,  100,   99,  111,  122,  121,  123,  124,
    0,    0,  116,   30,   31,   50,    0,    3,    0,    0,
    0,    0,  115,  114,  112,   43,   94,   89,  106,  101,
    0,    0,    0,   92,    0,    0,  104,    0,    0,  127,
  126,  119,   91,   94,  118,  117,   96,    0,   95,  103,
  106,    0,  108,  107,  120,   93,    0,  105,    0,   98,
  110,
};
short yydgoto[] = {                                       1,
   91,   53,  115,  132,   87,   84,   30,   31,   32,  107,
   33,  101,   56,   57,  138,   34,   35,   36,   37,   38,
   39,   40,   41,   42,   43,   44,   45,   46,   47,   48,
   49,   58,   90,  118,  109,  123,  124,  139,  125,   95,
  120,  110,  126,  127,  144,  128,
};
short yysindex[] = {                                      0,
   -9,   16,    0, -260,    0, -223, -220,    0,    0, -242,
 -246,    0,    0,    0, -260, -223, -223, -223,    0, -257,
    0,    0,    0,    0,    0,    0, -223, -223,    0,    0,
 -223, -223, -262,   24,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
 -219, -217,    0,    0,    0,    0, -223,    0,   -2,    6,
 -223,   19,    0,    0,    0,    0,    0,    0,    0,    0,
   20, -215,  -28,    0,  -40,  -26,    0,  -35, -215,    0,
    0,    0,    0,    0,    0,    0,    0,   25,    0,    0,
    0,   27,    0,    0,    0,    0, -211,    0, -208,    0,
    0,
};
short yyrindex[] = {                                      0,
    0,    0,    0,    0,    0,   -5,   74,    0,    0,   76,
    0,  -10,    0,    0,    0,   -5,   -5,   -5,    0,    0,
    0,   -7,    0,   -4,    0,   -1,   -5,   -5,    0,    0,
   -5,   -5,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   28,   77,    0,    0,    0,    0,   80,    0,    1,   81,
   28,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   82,    0,    0,    0,    0,    0,    0,   82,    0,
    0,    0,    0,    0,    0,    0,    0,    3,    0,    0,
    0,   26,    0,    0,    0,    0,    0,    0,    0,    0,
    0,
};
short yygindex[] = {                                      0,
    0,   78,    0,  -34,    0,    0,    0,    0,    0,    2,
    0,    0,  -13,    0,  -51,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   -8,    0,    0,    0,    0,  -37,    0,    0,    0,
    0,    0,    0,  -42,    0,    0,
};
#define YYTABLESIZE 293
short yytable[] = {                                      34,
   29,  137,   33,   94,   26,   35,  143,   93,   36,   96,
   90,   88,  133,   97,  140,  134,   85,  141,  102,  103,
   89,   86,  104,  105,   98,   50,   99,  106,  100,   34,
   51,   52,   33,  108,   26,   35,   59,  117,   36,   60,
   61,   62,   63,   97,   64,  119,   97,   65,   66,   67,
   68,   69,   70,   71,   72,   73,   74,   75,   76,   77,
   78,   79,   80,   81,   82,   83,  109,   54,   55,  109,
  106,   54,   55,  113,  114,  130,  131,  135,  136,  122,
  129,  151,  147,   52,  149,   79,  113,  112,   26,   26,
  102,  125,   92,  116,  145,  150,  146,  121,  148,    0,
    0,    0,  111,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    2,    0,  135,  136,
    3,    4,    5,    6,  142,    7,    8,    0,    9,   10,
   11,   12,   13,   14,   15,   16,   17,   18,    0,   19,
   20,   21,   22,   23,   24,   25,   26,   27,   28,   45,
   34,   34,   44,   33,   33,   46,   35,   35,   47,   36,
   36,   90,   90,
};
short yycheck[] = {                                      10,
   10,   42,   10,   17,   10,   10,   42,   16,   10,   18,
   10,  258,   41,  271,   41,   44,  259,   44,   27,   28,
  267,  264,   31,   32,  282,   10,  284,  290,  286,   40,
  291,  292,   40,   10,   40,   40,  257,   40,   40,  260,
  261,  262,  263,   41,  265,   40,   44,  268,  269,  270,
  271,  272,  273,  274,  275,  276,  277,  278,  279,  280,
  281,  282,  283,  284,  285,  286,   41,  291,  292,   44,
  290,  291,  292,  291,  292,  291,  292,  289,  290,   61,
   61,  290,   58,   10,   58,   10,   10,  101,   61,   10,
   10,   10,   15,  107,  129,  147,  134,  111,  141,   -1,
   -1,   -1,  101,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  256,   -1,  289,  290,
  260,  261,  262,  263,  290,  265,  266,   -1,  268,  269,
  270,  271,  272,  273,  274,  275,  276,  277,   -1,  279,
  280,  281,  282,  283,  284,  285,  286,  287,  288,  290,
  291,  292,  290,  291,  292,  290,  291,  292,  290,  291,
  292,  291,  292,
};
#define YYFINAL 1
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 292
#if YYDEBUG
char *yyname[] = {
"end-of-file",0,0,0,0,0,0,0,0,0,"'\\n'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,"'('","')'","'*'",0,"','",0,0,0,0,0,0,0,0,0,0,0,0,0,"':'",0,0,
"'='",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
"ALL","BATCH","BRIEF","CLOSE","CREATE","DATA","DESCRIBE","FULL","HELP","INDEX",
"INTERACTIVE","LENGTH","LIST","MODE","NAME","ND","NV","OPEN","PRINT","PRINTI",
"PRINTU","QUIT","RANGE","SET","SHAPE","SOURCE","TIME","TITLE","TYPE","UNITS",
"WRITE","WRITEU","DOUBLE_CONST","INTEGER_CONST","USERSTRING","IDENT",
};
char *yyrule[] = {
"$accept : statementlist",
"statementlist :",
"statementlist : statementlist '\\n'",
"statementlist : statementlist statement '\\n'",
"statementlist : statementlist error '\\n'",
"statement : closestatement",
"statement : createstatement",
"statement : describestatement",
"statement : getstatement",
"statement : getdimstatement",
"statement : helpstatement",
"statement : liststatement",
"statement : modestatement",
"statement : openstatement",
"statement : printstatement",
"statement : printistatement",
"statement : printustatement",
"statement : setstatement",
"statement : writestatement",
"statement : writeustatement",
"closestatement : CLOSE",
"file : IDENT",
"file : USERSTRING",
"createstatement : CREATE file",
"describestatement : DESCRIBE varspec",
"var : var1",
"var1 :",
"var1 : IDENT",
"var1 : USERSTRING",
"getstatement : filefield",
"getstatement : varfield varspec",
"getstatement : derivarfield varspec",
"filefield : NV",
"varfield : SOURCE",
"varfield : NAME",
"varfield : TITLE",
"varfield : UNITS",
"varfield : TIME",
"varfield : TYPE",
"varfield : ND",
"derivarfield : LENGTH",
"derivarfield : SHAPE",
"derivarfield : INDEX",
"getdimstatement : dimfield dim var",
"dimfield : SOURCE",
"dimfield : NAME",
"dimfield : TITLE",
"dimfield : UNITS",
"dimfield : RANGE",
"dimfield : DATA",
"dim : INTEGER_CONST",
"helpstatement : HELP statementtype",
"statementtype :",
"statementtype : ALL",
"statementtype : CLOSE",
"statementtype : CREATE",
"statementtype : DATA",
"statementtype : DESCRIBE",
"statementtype : HELP",
"statementtype : LENGTH",
"statementtype : LIST",
"statementtype : MODE",
"statementtype : NAME",
"statementtype : ND",
"statementtype : NV",
"statementtype : OPEN",
"statementtype : PRINT",
"statementtype : PRINTI",
"statementtype : PRINTU",
"statementtype : QUIT",
"statementtype : RANGE",
"statementtype : SET",
"statementtype : SHAPE",
"statementtype : SOURCE",
"statementtype : TIME",
"statementtype : TITLE",
"statementtype : TYPE",
"statementtype : UNITS",
"liststatement : LIST listopt",
"listopt :",
"listopt : BRIEF",
"listopt : FULL",
"modestatement : MODE modeopt",
"modeopt : INTERACTIVE",
"modeopt : BATCH",
"openstatement : OPEN existingfile",
"existingfile : file",
"printstatement : PRINT varspec",
"$$1 :",
"varspec : var $$1 dimspec",
"dimspec :",
"dimspec : '(' dimlist ')'",
"dimlist : dimint",
"dimlist : dimlist ',' dimint",
"$$2 :",
"dimint : $$2 dimint1",
"dimint1 : '*'",
"dimint1 : const",
"dimint1 : const ':' const",
"printistatement : PRINTI ivarspec",
"$$3 :",
"ivarspec : var $$3 idimspec",
"idimspec :",
"idimspec : '(' idimlist ')'",
"idimlist : idimint",
"idimlist : idimlist ',' idimint",
"$$4 :",
"idimint : $$4 idimint1",
"idimint1 : '*'",
"idimint1 : INTEGER_CONST",
"idimint1 : INTEGER_CONST ':' INTEGER_CONST",
"printustatement : PRINTU varspec",
"writestatement : WRITE varspec format",
"format :",
"format : IDENT",
"format : USERSTRING",
"writeustatement : WRITEU varspec",
"const : INTEGER_CONST",
"const : DOUBLE_CONST",
"setstatement : SET setfield var '=' setstring",
"setstatement : SET setfield dim var '=' setstring",
"setfield : SOURCE",
"setfield : NAME",
"setfield : TITLE",
"setfield : UNITS",
"setstring :",
"setstring : IDENT",
"setstring : USERSTRING",
};
#endif
#ifdef YYSTACKSIZE
#undef YYMAXDEPTH
#define YYMAXDEPTH YYSTACKSIZE
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 500
#define YYMAXDEPTH 500
#endif
#endif
int yydebug;
int yynerrs;
int yyerrflag;
int yychar;
short *yyssp;
YYSTYPE *yyvsp;
YYSTYPE yyval;
YYSTYPE yylval;
short yyss[YYSTACKSIZE];
YYSTYPE yyvs[YYSTACKSIZE];
#define yystacksize YYSTACKSIZE
#line 379 "drsed.y"
#include "drsed.yy.c"
				/* print help */
void
DRSEDhelp(option)
	int option;
{
	switch(option)
	{
	  case ALL:
		DRSEDprintf(NOFLUSH,"The following commands are available:\n");
	  case CLOSE:
		DRSEDprintf(NOFLUSH,"CLOSE - Close the current output file.\n");
		if(option!=ALL) break;
	  case CREATE:
		DRSEDprintf(NOFLUSH,"CREATE outputfile - Create an ASCII output file.\n");
		if(option != ALL) break;
	  case DATA:
		DRSEDprintf(NOFLUSH,"DATA dimension-number [variable] - Print dimension values.\n");
		if(option != ALL) break;
	  case DESCRIBE:
		DRSEDprintf(NOFLUSH,"DESCRIBE [variable] - Print variable description.\n");
		
		if(option != ALL) break;
	  case HELP:
		DRSEDprintf(NOFLUSH,"HELP [command|ALL]\n");
		
		if(option != ALL) break;
	  case LENGTH:
		DRSEDprintf(NOFLUSH,"LENGTH [variable] - Number of variable elements.\n");
		
		if(option != ALL) break;
	  case LIST:
		DRSEDprintf(NOFLUSH,"LIST [BRIEF|FULL] - List names and titles in current DRS file.\n");
		
		if(option != ALL) break;
	  case MODE:
		DRSEDprintf(NOFLUSH,"MODE [INTERACTIVE|BATCH]\n");
		
		if(option != ALL) break;
	  case NAME:
		DRSEDprintf(NOFLUSH,"NAME [dimension-number] [variable] - Name of (dimension of) variable.\n");
		
		if(option != ALL) break;
	  case ND:
		DRSEDprintf(NOFLUSH,"ND [variable] - Number of dimensions of variable.\n");
		
		if(option != ALL) break;
	  case NV:
		DRSEDprintf(NOFLUSH,"NV - Number of variables in current file.\n");
		
		if(option != ALL) break;
	  case OPEN:
		DRSEDprintf(NOFLUSH,"OPEN drs-dictionary-file - Open a DRS file.\n");
		
		if(option != ALL) break;
	  case PRINT:
		DRSEDprintf(NOFLUSH,"PRINT variable[(user-dimension-ranges)]] - Print variable to standard output.\n");
		
		if(option != ALL) break;
	  case PRINTI:
		DRSEDprintf(NOFLUSH,"PRINTI variable[(index-dimension-ranges)]] - Print variable to standard output.\n");
		
		if(option != ALL) break;
	  case PRINTU:
	/*	DRSEDprintf(NOFLUSH,"PRINTU variable[(dimension-ranges)]]\n"); */
		
		if(option != ALL) break;
	  case QUIT:
		DRSEDprintf(NOFLUSH,"QUIT - Quit DRSED.\n");
		
		if(option != ALL) break;
	  case RANGE:
		DRSEDprintf(NOFLUSH,"RANGE dimension-number [variable[(dimension-ranges)]] - First and last values of a dimension of the variable.\n");
		
		if(option != ALL) break;
	  case SET:
		DRSEDprintf(NOFLUSH,"SET source|name|title|units [dimension-number] [variable] = new-string - Set a naming string for a variable or dimension.\n");
		if(option != ALL) break;
	  case SHAPE:
		DRSEDprintf(NOFLUSH,"SHAPE [variable] - Length of each dimension of the variable.\n");
		
		if(option != ALL) break;
	  case SOURCE:
		DRSEDprintf(NOFLUSH,"SOURCE [dimension-number] [variable] - Source of (dimension of) variable.\n");
		
		if(option != ALL) break;
	  case TIME:
		DRSEDprintf(NOFLUSH,"TIME [variable] - Time that variable was written\n");
		
		if(option != ALL) break;
	  case TITLE:
		DRSEDprintf(NOFLUSH,"TITLE [dimension-number] [variable] - Title of (dimension of) variable.\n");
		
		if(option != ALL) break;
	  case TYPE:
		DRSEDprintf(NOFLUSH,"TYPE [variable] - Data type of variable.\n");
		
		if(option != ALL) break;
	  case WRITE:
		DRSEDprintf(NOFLUSH,"WRITE [variable[(dimension-ranges)]] - Write to the ASCII outputfile created by the most recent CREATE command.\n");
		if(option != ALL) break;
	  case UNITS:
		DRSEDprintf(NOFLUSH,"UNITS [dimension-number] [variable] - Units of (dimension of) variable.\n");
		break;
	}
	switch(option){
	  case ALL:
	  case NAME:
	  case PRINT:
	  case PRINTI:
	  case RANGE:
	  case WRITE:
		DRSEDprintf(NOFLUSH,"\n   The form of dimension-ranges is (range-1,range-2,...,range-n),\nwhere range is either a single dimension value, a range of values of the form value-1:value2,\nor '*' for the entire dimension range. For example,\n\n                print x(*,1,10.5:100)\n\nprints the values of the variable x for all values of the first dimension, where the second\nUSER dimension value is 1 and the third USER dimension values range from 10.5 to 100, inclusive.\n\n   The command `printi' uses indices instead of user dimension values. For example,\n\n                printi x(*,1:5,11)\n\nprints the values of x corresponding to all values of the first dimension, the first five values of the second dimension, and the eleventh value of the third dimension.\n\n   For most commands, if no variable is specified, the most recently\nreferenced variable is used.\n");
	}
}
#line 530 "y.tab.c"
#define YYABORT goto yyabort
#define YYREJECT goto yyabort
#define YYACCEPT goto yyaccept
#define YYERROR goto yyerrlab
int
yyparse()
{
    register int yym, yyn, yystate;
#if YYDEBUG
    register char *yys;
    extern char *getenv();

    if (yys = getenv("YYDEBUG"))
    {
        yyn = *yys;
        if (yyn >= '0' && yyn <= '9')
            yydebug = yyn - '0';
    }
#endif

    yynerrs = 0;
    yyerrflag = 0;
    yychar = (-1);

    yyssp = yyss;
    yyvsp = yyvs;
    *yyssp = yystate = 0;

yyloop:
    if (yyn = yydefred[yystate]) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("%sdebug: state %d, reading %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: state %d, shifting to state %d\n",
                    YYPREFIX, yystate, yytable[yyn]);
#endif
        if (yyssp >= yyss + yystacksize - 1)
        {
            goto yyoverflow;
        }
        *++yyssp = yystate = yytable[yyn];
        *++yyvsp = yylval;
        yychar = (-1);
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;
#ifdef lint
    goto yynewerror;
#endif
yynewerror:
    yyerror("syntax error");
#ifdef lint
    goto yyerrlab;
#endif
yyerrlab:
    ++yynerrs;
yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yyssp]) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: state %d, error recovery shifting\
 to state %d\n", YYPREFIX, *yyssp, yytable[yyn]);
#endif
                if (yyssp >= yyss + yystacksize - 1)
                {
                    goto yyoverflow;
                }
                *++yyssp = yystate = yytable[yyn];
                *++yyvsp = yylval;
                goto yyloop;
            }
            else
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: error recovery discarding state %d\n",
                            YYPREFIX, *yyssp);
#endif
                if (yyssp <= yyss) goto yyabort;
                --yyssp;
                --yyvsp;
            }
        }
    }
    else
    {
        if (yychar == 0) goto yyabort;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("%sdebug: state %d, error recovery discards token %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
        yychar = (-1);
        goto yyloop;
    }
yyreduce:
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: state %d, reducing by rule %d (%s)\n",
                YYPREFIX, yystate, yyn, yyrule[yyn]);
#endif
    yym = yylen[yyn];
    yyval = yyvsp[1-yym];
    switch (yyn)
    {
case 1:
#line 63 "drsed.y"
{if(interact) printf(">");}
break;
case 2:
#line 64 "drsed.y"
{if(interact) printf(">");}
break;
case 3:
#line 65 "drsed.y"
{if(interact) printf(">");}
break;
case 4:
#line 66 "drsed.y"
{yyerrok; if(interact) printf(">");}
break;
case 20:
#line 84 "drsed.y"
{DRSEDCALL(DRSEDcloseoutputfile(&_drsed_outfile),(err=err));
		      	_drsed_outfile=stdout;
			}
break;
case 23:
#line 91 "drsed.y"
{ DRSEDCALL(DRSEDopenoutputfile(yyvsp[0].sval,&_drsed_outfile),(err=err));
			       if(_drsed_outfile==NULL) _drsed_outfile=stdout;
			     }
break;
case 24:
#line 95 "drsed.y"
{
					DRSEDCALL(currentvar==NULL_VARIABLE,
					 DRSEDdescribevar(currentvar))}
break;
case 25:
#line 99 "drsed.y"
{if(yyvsp[0].varval==NULL_VARIABLE)
				       {DRSEDerror("No variable current");
					DRSEDYYERROR;
				       }
			       else
				       yyval.varval=currentvar=yyvsp[0].varval;}
break;
case 26:
#line 107 "drsed.y"
{yyval.varval=currentvar;}
break;
case 27:
#line 108 "drsed.y"
{yyval.varval=DRSEDfindvar(yyvsp[0].sval,currentfile);}
break;
case 28:
#line 109 "drsed.y"
{yyval.varval=DRSEDfindvar(yyvsp[0].sval,currentfile);}
break;
case 29:
#line 111 "drsed.y"
{if(err=(currentfile==NULL_FILE))
			  	DRSEDerror("No file currently specified, use OPEN");
			   DRSEDCALL(err,
			    		DRSEDgetfilefield(currentfile,yyvsp[0].ival))}
break;
case 30:
#line 115 "drsed.y"
{
			       	       DRSEDCALL(currentvar==NULL_VARIABLE,
			       		DRSEDgetvarfield(currentvar,yyvsp[-1].ival))}
break;
case 31:
#line 118 "drsed.y"
{DRSEDCALL(currentvar==NULL_VARIABLE,
				      	DRSEDgetvarfield(currentvar,yyvsp[-1].ival))}
break;
case 32:
#line 121 "drsed.y"
{yyval.ival=NV;}
break;
case 33:
#line 123 "drsed.y"
{yyval.ival=SOURCE;}
break;
case 34:
#line 124 "drsed.y"
{yyval.ival=NAME;}
break;
case 35:
#line 125 "drsed.y"
{yyval.ival=TITLE;}
break;
case 36:
#line 126 "drsed.y"
{yyval.ival=UNITS;}
break;
case 37:
#line 127 "drsed.y"
{yyval.ival=TIME;}
break;
case 38:
#line 128 "drsed.y"
{yyval.ival=TYPE;}
break;
case 39:
#line 129 "drsed.y"
{yyval.ival=ND;}
break;
case 40:
#line 131 "drsed.y"
{yyval.ival=LENGTH;}
break;
case 41:
#line 132 "drsed.y"
{yyval.ival=SHAPE;}
break;
case 42:
#line 133 "drsed.y"
{yyval.ival=INDEX;}
break;
case 43:
#line 135 "drsed.y"
{ if((yyvsp[0].varval != NULL_VARIABLE) && (yyvsp[-1].ival < 1 || yyvsp[-1].ival > yyvsp[0].varval->ndim))
				    {
				      DRSEDerror("Variable %s does not have a dimension %d",yyvsp[0].varval->name,yyvsp[-1].ival); DRSEDYYERROR;}
				      DRSEDCALL(yyvsp[0].varval==NULL_VARIABLE,
				  	DRSEDgetdimfield(FLUSH,&yyvsp[0].varval->dim[yyvsp[-1].ival-1],yyvsp[-2].ival))}
break;
case 44:
#line 141 "drsed.y"
{yyval.ival=SOURCE;}
break;
case 45:
#line 142 "drsed.y"
{yyval.ival=NAME;}
break;
case 46:
#line 143 "drsed.y"
{yyval.ival=TITLE;}
break;
case 47:
#line 144 "drsed.y"
{yyval.ival=UNITS;}
break;
case 48:
#line 145 "drsed.y"
{yyval.ival=RANGE;}
break;
case 49:
#line 146 "drsed.y"
{yyval.ival=DATA;}
break;
case 50:
#line 148 "drsed.y"
{yyval.ival=yyvsp[0].ival;}
break;
case 51:
#line 150 "drsed.y"
{DRSEDCALL(0,DRSEDhelp(yyvsp[0].ival))}
break;
case 52:
#line 152 "drsed.y"
{yyval.ival=ALL;}
break;
case 53:
#line 153 "drsed.y"
{yyval.ival=ALL;}
break;
case 54:
#line 154 "drsed.y"
{yyval.ival=CLOSE;}
break;
case 55:
#line 155 "drsed.y"
{yyval.ival=CREATE;}
break;
case 56:
#line 156 "drsed.y"
{yyval.ival=DATA;}
break;
case 57:
#line 157 "drsed.y"
{yyval.ival=DESCRIBE;}
break;
case 58:
#line 158 "drsed.y"
{yyval.ival=HELP;}
break;
case 59:
#line 159 "drsed.y"
{yyval.ival=LENGTH;}
break;
case 60:
#line 160 "drsed.y"
{yyval.ival=LIST;}
break;
case 61:
#line 161 "drsed.y"
{yyval.ival=MODE;}
break;
case 62:
#line 162 "drsed.y"
{yyval.ival=NAME;}
break;
case 63:
#line 163 "drsed.y"
{yyval.ival=ND;}
break;
case 64:
#line 164 "drsed.y"
{yyval.ival=NV;}
break;
case 65:
#line 165 "drsed.y"
{yyval.ival=OPEN;}
break;
case 66:
#line 166 "drsed.y"
{yyval.ival=PRINT;}
break;
case 67:
#line 167 "drsed.y"
{yyval.ival=PRINTI;}
break;
case 68:
#line 168 "drsed.y"
{yyval.ival=PRINTU;}
break;
case 69:
#line 169 "drsed.y"
{yyval.ival=QUIT;}
break;
case 70:
#line 170 "drsed.y"
{yyval.ival=RANGE;}
break;
case 71:
#line 171 "drsed.y"
{yyval.ival=SET;}
break;
case 72:
#line 172 "drsed.y"
{yyval.ival=SHAPE;}
break;
case 73:
#line 173 "drsed.y"
{yyval.ival=SOURCE;}
break;
case 74:
#line 174 "drsed.y"
{yyval.ival=TIME;}
break;
case 75:
#line 175 "drsed.y"
{yyval.ival=TITLE;}
break;
case 76:
#line 176 "drsed.y"
{yyval.ival=TYPE;}
break;
case 77:
#line 177 "drsed.y"
{yyval.ival=UNITS;}
break;
case 78:
#line 179 "drsed.y"
{if(currentfile==NULL_FILE) {
	                          DRSEDerror("No file currently open");
				  DRSEDCALL(DRSED_GENERIC,(err=err));
			  } else if (currentfile->varlist==NULL_VARIABLE)
			  {
				  DRSEDerror("%s does not contain any variables!",currentfile->name);
				  DRSEDCALL(DRSED_GENERIC,(err=err));
			  } else
			  {
				  DRSEDCALL(0,DRSEDlist(currentfile,yyvsp[0].ival));
			  }
			  }
break;
case 79:
#line 192 "drsed.y"
{yyval.ival=(interact ? FULL : BRIEF);}
break;
case 80:
#line 193 "drsed.y"
{yyval.ival=BRIEF;}
break;
case 81:
#line 194 "drsed.y"
{yyval.ival=FULL;}
break;
case 82:
#line 196 "drsed.y"
{DRSEDCALL(0,(err=err));}
break;
case 83:
#line 198 "drsed.y"
{interact=1;}
break;
case 84:
#line 199 "drsed.y"
{interact=0;}
break;
case 85:
#line 201 "drsed.y"
{if(yyvsp[0].fileval != NULL_FILE) 
					   currentfile=yyvsp[0].fileval;
				   DRSEDCALL(DRSEDreaddicfile(yyvsp[0].fileval),(err=err))}
break;
case 86:
#line 205 "drsed.y"
{		/* Don't reopen the same file */
	                 if(currentfile != NULL_FILE && !strcmp(yyvsp[0].sval,currentfile->name))
				 yyval.fileval=currentfile;
			 else
			 {
				 if(currentfile != NULL_FILE)
				 {
					 
					 Cllun(currentfile->unit);
					 currentfile=NULL_FILE;
				 }
				 yyval.fileval=DRSEDopenfile(yyvsp[0].sval);
			 }
		 }
break;
case 87:
#line 221 "drsed.y"
{DRSEDCALL(DRSEDreadvardata(currentvar),
			      	DRSEDprintvardata(currentvar))}
break;
case 88:
#line 225 "drsed.y"
{if(yyvsp[0].varval==NULL_VARIABLE)
			{
			DRSEDerror("Variable not found");
			DRSEDYYERROR;
			}
		 else
		 {currentvar=yyvsp[0].varval;
		  ndim=0;
		 }
		}
break;
case 89:
#line 236 "drsed.y"
{if (ndim!=currentvar->ndim)
		    {
		        DRSEDerror("Must specify %d dimensions for %s",currentvar->ndim, currentvar->name);
			DRSEDYYERROR;
			}
		}
break;
case 90:
#line 244 "drsed.y"
{
		for(ndim=0; ndim<currentvar->ndim; ndim++)
		  {
			  currentvar->dim[ndim].reqfirstel=currentvar->dim[ndim].firstel;
			  currentvar->dim[ndim].reqlastel=currentvar->dim[ndim].lastel;
		  }
		}
break;
case 94:
#line 256 "drsed.y"
{ if(ndim>=currentvar->ndim)
		  {
		  	  DRSEDerror("Too many dimensions specified for variable %s",currentvar->name);
			  DRSEDYYERROR;
		  }
		}
break;
case 96:
#line 265 "drsed.y"
{
			  currentvar->dim[ndim].reqfirstel=currentvar->dim[ndim].firstel;
			  currentvar->dim[ndim].reqlastel=currentvar->dim[ndim].lastel;
			  ndim++;
		  }
break;
case 97:
#line 271 "drsed.y"
{
			  currentvar->dim[ndim].reqfirstel=yyvsp[0].dval;
			  currentvar->dim[ndim].reqlastel=yyvsp[0].dval;
			  ndim++;
		  }
break;
case 98:
#line 277 "drsed.y"
{
			  currentvar->dim[ndim].reqfirstel=yyvsp[-2].dval;
			  currentvar->dim[ndim].reqlastel=yyvsp[0].dval;
			  ndim++;
		  }
break;
case 99:
#line 283 "drsed.y"
{DRSEDCALL(DRSEDreadvardata(currentvar),
			      	DRSEDprintvardata(currentvar))}
break;
case 100:
#line 287 "drsed.y"
{if(yyvsp[0].varval==NULL_VARIABLE)
			{
			DRSEDerror("Variable not found");
			DRSEDYYERROR;
			}
		 else
		 {currentvar=yyvsp[0].varval;
		  ndim=0;
		 }
		}
break;
case 101:
#line 298 "drsed.y"
{if (ndim!=currentvar->ndim)
		    {
		        DRSEDerror("Must specify %d dimensions for %s",currentvar->ndim, currentvar->name);
			DRSEDYYERROR;
			}
		}
break;
case 102:
#line 306 "drsed.y"
{
		for(ndim=0; ndim<currentvar->ndim; ndim++)
		  {
			  currentvar->dim[ndim].reqfirstel=currentvar->dim[ndim].firstel;
			  currentvar->dim[ndim].reqlastel=currentvar->dim[ndim].lastel;
		  }
		}
break;
case 106:
#line 318 "drsed.y"
{ if(ndim>=currentvar->ndim)
		  {
		  	  DRSEDerror("Too many dimensions specified for variable %s",currentvar->name);
			  DRSEDYYERROR;
		  }
		}
break;
case 108:
#line 327 "drsed.y"
{
			  currentvar->dim[ndim].reqfirstel=currentvar->dim[ndim].firstel;
			  currentvar->dim[ndim].reqlastel=currentvar->dim[ndim].lastel;
			  ndim++;
		  }
break;
case 109:
#line 333 "drsed.y"
{
		  	  DRSEDCALL(err2=DRSEDsetreqel(currentvar,ndim,yyvsp[0].ival,yyvsp[0].ival),(err=err));
			  if(err2) YYERROR;
			  ndim++;
		  }
break;
case 110:
#line 339 "drsed.y"
{
		  	  DRSEDCALL(err2=DRSEDsetreqel(currentvar,ndim,yyvsp[-2].ival,yyvsp[0].ival),(err=err));
			  if(err2) YYERROR;
			  ndim++;
		  }
break;
case 111:
#line 345 "drsed.y"
{DRSEDCALL(DRSEDreadvardata(currentvar),
			      	DRSEDprintuvardata(currentvar))}
break;
case 112:
#line 348 "drsed.y"
{DRSEDCALL(DRSEDreadvardata(currentvar),
				      DRSEDwritevardata(currentvar,_drsed_outfile,yyvsp[0].sval))}
break;
case 113:
#line 351 "drsed.y"
{yyval.sval="";}
break;
case 116:
#line 355 "drsed.y"
{DRSEDCALL(DRSEDreadvardata(currentvar),
				DRSEDwriteuvardata(currentvar,_drsed_outfile))}
break;
case 117:
#line 358 "drsed.y"
{yyval.dval=yyvsp[0].ival;}
break;
case 118:
#line 359 "drsed.y"
{yyval.dval=yyvsp[0].dval;}
break;
case 119:
#line 361 "drsed.y"
{DRSEDCALL(currentvar == NULL_VARIABLE,
					     DRSEDsetvar(currentvar,yyvsp[-3].ival,yyvsp[0].sval))}
break;
case 120:
#line 364 "drsed.y"
{ if(( yyvsp[-2].varval != NULL_VARIABLE) && (yyvsp[-3].ival<1 || yyvsp[-3].ival>yyvsp[-2].varval->ndim))
		         {DRSEDerror("Variable %s does not have a dimension %d",yyvsp[-2].varval->name,yyvsp[-3].ival); DRSEDYYERROR;}
			  DRSEDCALL(currentvar==NULL_VARIABLE,
			    DRSEDsetdim(&currentvar->dim[yyvsp[-3].ival-1],yyvsp[-4].ival,yyvsp[0].sval))}
break;
case 121:
#line 369 "drsed.y"
{yyval.ival=SOURCE;}
break;
case 122:
#line 370 "drsed.y"
{yyval.ival=NAME;}
break;
case 123:
#line 371 "drsed.y"
{yyval.ival=TITLE;}
break;
case 124:
#line 372 "drsed.y"
{yyval.ival=UNITS;}
break;
case 125:
#line 374 "drsed.y"
{yyval.sval=singleBlank;}
break;
#line 1193 "y.tab.c"
    }
    yyssp -= yym;
    yystate = *yyssp;
    yyvsp -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: after reduction, shifting from state 0 to\
 state %d\n", YYPREFIX, YYFINAL);
#endif
        yystate = YYFINAL;
        *++yyssp = YYFINAL;
        *++yyvsp = yyval;
        if (yychar < 0)
        {
            if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
            if (yydebug)
            {
                yys = 0;
                if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
                if (!yys) yys = "illegal-symbol";
                printf("%sdebug: state %d, reading %d (%s)\n",
                        YYPREFIX, YYFINAL, yychar, yys);
            }
#endif
        }
        if (yychar == 0) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: after reduction, shifting from state %d \
to state %d\n", YYPREFIX, *yyssp, yystate);
#endif
    if (yyssp >= yyss + yystacksize - 1)
    {
        goto yyoverflow;
    }
    *++yyssp = yystate;
    *++yyvsp = yyval;
    goto yyloop;
yyoverflow:
    yyerror("yacc stack overflow");
yyabort:
    return (1);
yyaccept:
    return (0);
}
