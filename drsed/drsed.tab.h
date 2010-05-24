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
typedef union {
         double dval;
	 int ival;
	 char *sval;
	 DRS_FILE *fileval;
	 DRS_VARIABLE *varval;
       } YYSTYPE;
extern YYSTYPE yylval;
