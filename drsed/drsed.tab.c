/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ALL = 258,
     BATCH = 259,
     BRIEF = 260,
     CLOSE = 261,
     CREATE = 262,
     DATA = 263,
     DESCRIBE = 264,
     FULL = 265,
     HELP = 266,
     INDEX = 267,
     INTERACTIVE = 268,
     LENGTH = 269,
     LIST = 270,
     MODE = 271,
     NAME = 272,
     ND = 273,
     NV = 274,
     OPEN = 275,
     PRINT = 276,
     PRINTI = 277,
     PRINTU = 278,
     QUIT = 279,
     RANGE = 280,
     SET = 281,
     SHAPE = 282,
     SOURCE = 283,
     TIME = 284,
     TITLE = 285,
     TYPE = 286,
     UNITS = 287,
     WRITE = 288,
     WRITEU = 289,
     DOUBLE_CONST = 290,
     INTEGER_CONST = 291,
     USERSTRING = 292,
     IDENT = 293
   };
#endif
/* Tokens.  */
#define ALL 258
#define BATCH 259
#define BRIEF 260
#define CLOSE 261
#define CREATE 262
#define DATA 263
#define DESCRIBE 264
#define FULL 265
#define HELP 266
#define INDEX 267
#define INTERACTIVE 268
#define LENGTH 269
#define LIST 270
#define MODE 271
#define NAME 272
#define ND 273
#define NV 274
#define OPEN 275
#define PRINT 276
#define PRINTI 277
#define PRINTU 278
#define QUIT 279
#define RANGE 280
#define SET 281
#define SHAPE 282
#define SOURCE 283
#define TIME 284
#define TITLE 285
#define TYPE 286
#define UNITS 287
#define WRITE 288
#define WRITEU 289
#define DOUBLE_CONST 290
#define INTEGER_CONST 291
#define USERSTRING 292
#define IDENT 293




/* Copy the first part of user declarations.  */
#line 18 "drsed.y"

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


/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 40 "drsed.y"
{
         double dval;
	 int ival;
	 char *sval;
	 DRS_FILE *fileval;
	 DRS_VARIABLE *varval;
       }
/* Line 193 of yacc.c.  */
#line 203 "y.tab.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 216 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  2
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   113

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  46
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  48
/* YYNRULES -- Number of rules.  */
#define YYNRULES  128
/* YYNRULES -- Number of states.  */
#define YYNSTATES  153

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   293

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      39,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      40,    41,    43,     2,    42,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    44,     2,
       2,    45,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     7,    11,    15,    17,    19,    21,
      23,    25,    27,    29,    31,    33,    35,    37,    39,    41,
      43,    45,    47,    49,    51,    54,    57,    59,    60,    62,
      64,    66,    69,    72,    74,    76,    78,    80,    82,    84,
      86,    88,    90,    92,    94,    98,   100,   102,   104,   106,
     108,   110,   112,   115,   116,   118,   120,   122,   124,   126,
     128,   130,   132,   134,   136,   138,   140,   142,   144,   146,
     148,   150,   152,   154,   156,   158,   160,   162,   164,   166,
     169,   170,   172,   174,   177,   179,   181,   184,   186,   189,
     190,   194,   195,   199,   201,   205,   206,   209,   211,   213,
     217,   220,   221,   225,   226,   230,   232,   236,   237,   240,
     242,   244,   248,   251,   255,   256,   258,   260,   263,   265,
     267,   273,   280,   282,   284,   286,   288,   289,   291
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      47,     0,    -1,    -1,    47,    39,    -1,    47,    48,    39,
      -1,    47,     1,    39,    -1,    49,    -1,    51,    -1,    52,
      -1,    55,    -1,    59,    -1,    62,    -1,    64,    -1,    66,
      -1,    68,    -1,    70,    -1,    78,    -1,    86,    -1,    91,
      -1,    87,    -1,    89,    -1,     6,    -1,    38,    -1,    37,
      -1,     7,    50,    -1,     9,    71,    -1,    54,    -1,    -1,
      38,    -1,    37,    -1,    56,    -1,    57,    71,    -1,    58,
      71,    -1,    19,    -1,    28,    -1,    17,    -1,    30,    -1,
      32,    -1,    29,    -1,    31,    -1,    18,    -1,    14,    -1,
      27,    -1,    12,    -1,    60,    61,    53,    -1,    28,    -1,
      17,    -1,    30,    -1,    32,    -1,    25,    -1,     8,    -1,
      36,    -1,    11,    63,    -1,    -1,     3,    -1,     6,    -1,
       7,    -1,     8,    -1,     9,    -1,    11,    -1,    14,    -1,
      15,    -1,    16,    -1,    17,    -1,    18,    -1,    19,    -1,
      20,    -1,    21,    -1,    22,    -1,    23,    -1,    24,    -1,
      25,    -1,    26,    -1,    27,    -1,    28,    -1,    29,    -1,
      30,    -1,    31,    -1,    32,    -1,    15,    65,    -1,    -1,
       5,    -1,    10,    -1,    16,    67,    -1,    13,    -1,     4,
      -1,    20,    69,    -1,    50,    -1,    21,    71,    -1,    -1,
      53,    72,    73,    -1,    -1,    40,    74,    41,    -1,    75,
      -1,    74,    42,    75,    -1,    -1,    76,    77,    -1,    43,
      -1,    90,    -1,    90,    44,    90,    -1,    22,    79,    -1,
      -1,    53,    80,    81,    -1,    -1,    40,    82,    41,    -1,
      83,    -1,    82,    42,    83,    -1,    -1,    84,    85,    -1,
      43,    -1,    36,    -1,    36,    44,    36,    -1,    23,    71,
      -1,    33,    71,    88,    -1,    -1,    38,    -1,    37,    -1,
      34,    71,    -1,    36,    -1,    35,    -1,    26,    92,    53,
      45,    93,    -1,    26,    92,    61,    53,    45,    93,    -1,
      28,    -1,    17,    -1,    30,    -1,    32,    -1,    -1,    38,
      -1,    37,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    63,    63,    64,    65,    66,    68,    69,    70,    71,
      72,    73,    74,    75,    76,    77,    78,    79,    80,    81,
      82,    84,    88,    89,    91,    95,    99,   107,   108,   109,
     111,   115,   118,   121,   123,   124,   125,   126,   127,   128,
     129,   131,   132,   133,   135,   141,   142,   143,   144,   145,
     146,   148,   150,   152,   153,   154,   155,   156,   157,   158,
     159,   160,   161,   162,   163,   164,   165,   166,   167,   168,
     169,   170,   171,   172,   173,   174,   175,   176,   177,   179,
     192,   193,   194,   196,   198,   199,   201,   205,   221,   225,
     224,   244,   251,   253,   254,   256,   256,   264,   270,   276,
     283,   287,   286,   306,   313,   315,   316,   318,   318,   326,
     332,   338,   345,   348,   351,   352,   353,   355,   358,   359,
     361,   363,   369,   370,   371,   372,   374,   375,   376
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "ALL", "BATCH", "BRIEF", "CLOSE",
  "CREATE", "DATA", "DESCRIBE", "FULL", "HELP", "INDEX", "INTERACTIVE",
  "LENGTH", "LIST", "MODE", "NAME", "ND", "NV", "OPEN", "PRINT", "PRINTI",
  "PRINTU", "QUIT", "RANGE", "SET", "SHAPE", "SOURCE", "TIME", "TITLE",
  "TYPE", "UNITS", "WRITE", "WRITEU", "DOUBLE_CONST", "INTEGER_CONST",
  "USERSTRING", "IDENT", "'\\n'", "'('", "')'", "','", "'*'", "':'", "'='",
  "$accept", "statementlist", "statement", "closestatement", "file",
  "createstatement", "describestatement", "var", "var1", "getstatement",
  "filefield", "varfield", "derivarfield", "getdimstatement", "dimfield",
  "dim", "helpstatement", "statementtype", "liststatement", "listopt",
  "modestatement", "modeopt", "openstatement", "existingfile",
  "printstatement", "varspec", "@1", "dimspec", "dimlist", "dimint", "@2",
  "dimint1", "printistatement", "ivarspec", "@3", "idimspec", "idimlist",
  "idimint", "@4", "idimint1", "printustatement", "writestatement",
  "format", "writeustatement", "const", "setstatement", "setfield",
  "setstring", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,    10,
      40,    41,    44,    42,    58,    61
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    46,    47,    47,    47,    47,    48,    48,    48,    48,
      48,    48,    48,    48,    48,    48,    48,    48,    48,    48,
      48,    49,    50,    50,    51,    52,    53,    54,    54,    54,
      55,    55,    55,    56,    57,    57,    57,    57,    57,    57,
      57,    58,    58,    58,    59,    60,    60,    60,    60,    60,
      60,    61,    62,    63,    63,    63,    63,    63,    63,    63,
      63,    63,    63,    63,    63,    63,    63,    63,    63,    63,
      63,    63,    63,    63,    63,    63,    63,    63,    63,    64,
      65,    65,    65,    66,    67,    67,    68,    69,    70,    72,
      71,    73,    73,    74,    74,    76,    75,    77,    77,    77,
      78,    80,    79,    81,    81,    82,    82,    84,    83,    85,
      85,    85,    86,    87,    88,    88,    88,    89,    90,    90,
      91,    91,    92,    92,    92,    92,    93,    93,    93
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     3,     3,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     2,     2,     1,     0,     1,     1,
       1,     2,     2,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     3,     1,     1,     1,     1,     1,
       1,     1,     2,     0,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     2,
       0,     1,     1,     2,     1,     1,     2,     1,     2,     0,
       3,     0,     3,     1,     3,     0,     2,     1,     1,     3,
       2,     0,     3,     0,     3,     1,     3,     0,     2,     1,
       1,     3,     2,     3,     0,     1,     1,     2,     1,     1,
       5,     6,     1,     1,     1,     1,     0,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     1,     0,    21,     0,    50,    27,    53,    43,
      41,    80,     0,    35,    40,    33,     0,    27,    27,    27,
      49,     0,    42,    34,    38,    36,    39,    37,    27,    27,
       3,     0,     6,     7,     8,     9,    30,    27,    27,    10,
       0,    11,    12,    13,    14,    15,    16,    17,    19,    20,
      18,     5,    23,    22,    24,    29,    28,    89,    26,    25,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    52,    81,    82,    79,    85,
      84,    83,    87,    86,    88,   101,   100,   112,   123,   122,
     124,   125,    27,   114,   117,     4,    31,    32,    51,    27,
      91,   103,     0,    27,   116,   115,   113,    44,    95,    90,
     107,   102,   126,     0,     0,    93,     0,     0,   105,     0,
     128,   127,   120,   126,    92,    95,   119,   118,    97,    96,
      98,   104,   107,   110,   109,   108,   121,    94,     0,   106,
       0,    99,   111
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,    31,    32,    54,    33,    34,    57,    58,    35,
      36,    37,    38,    39,    40,   109,    41,    85,    42,    88,
      43,    91,    44,    93,    45,    59,   110,   119,   124,   125,
     126,   139,    46,    96,   111,   121,   127,   128,   129,   145,
      47,    48,   116,    49,   140,    50,   102,   132
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -39
static const yytype_int8 yypact[] =
{
     -39,     1,   -39,   -25,   -39,    10,   -39,    37,    35,   -39,
     -39,    68,    32,   -11,   -39,   -39,    10,    37,    37,    37,
     -39,    55,   -39,     3,   -39,    41,   -39,    50,    37,    37,
     -39,    -2,   -39,   -39,   -39,   -39,   -39,    37,    37,   -39,
      54,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,
     -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,
     -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,
     -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,
     -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,
     -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,   -39,
     -39,   -39,    56,    44,   -39,   -39,   -39,   -39,   -39,    37,
      31,    62,    58,    37,   -39,   -39,   -39,   -39,   -39,   -39,
     -39,   -39,    59,    60,   -36,   -39,   -32,    57,   -39,    33,
     -39,   -39,   -39,    59,   -39,   -39,   -39,   -39,   -39,   -39,
      63,   -39,   -39,    64,   -39,   -39,   -39,   -39,    65,   -39,
      70,   -39,   -39
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -39,   -39,   -39,   -39,    88,   -39,   -39,   -18,   -39,   -39,
     -39,   -39,   -39,   -39,   -39,     7,   -39,   -39,   -39,   -39,
     -39,   -39,   -39,   -39,   -39,    51,   -39,   -39,   -39,   -24,
     -39,   -39,   -39,   -39,   -39,   -39,   -39,   -30,   -39,   -39,
     -39,   -39,   -39,   -39,   -38,   -39,   -39,   -20
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -49
static const yytype_int16 yytable[] =
{
      95,     2,     3,   136,   137,   134,   135,     4,     5,     6,
       7,   138,     8,     9,    51,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,   -46,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    89,   105,    60,   -45,
      30,    61,    62,    63,    64,    90,    65,    52,    53,    66,
      67,    68,    69,    70,    71,    72,    73,    74,    75,    76,
      77,    78,    79,    80,    81,    82,    83,    84,    94,   143,
      97,   118,    98,    86,    55,    56,   144,   -47,    87,   103,
     104,   114,   115,    99,   112,   100,   -48,   101,   106,   107,
     108,   117,   108,    55,    56,   123,   130,   131,   141,   142,
     136,   137,   120,   122,    92,   133,   152,   148,   150,   113,
     151,   147,   149,   146
};

static const yytype_uint8 yycheck[] =
{
      18,     0,     1,    35,    36,    41,    42,     6,     7,     8,
       9,    43,    11,    12,    39,    14,    15,    16,    17,    18,
      19,    20,    21,    22,    23,    36,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,     4,    39,     3,    36,
      39,     6,     7,     8,     9,    13,    11,    37,    38,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    17,    36,
      19,    40,    17,     5,    37,    38,    43,    36,    10,    28,
      29,    37,    38,    28,   102,    30,    36,    32,    37,    38,
      36,   109,    36,    37,    38,   113,    37,    38,    41,    42,
      35,    36,    40,    45,    16,    45,    36,    44,    44,   102,
     148,   135,   142,   133
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    47,     0,     1,     6,     7,     8,     9,    11,    12,
      14,    15,    16,    17,    18,    19,    20,    21,    22,    23,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      39,    48,    49,    51,    52,    55,    56,    57,    58,    59,
      60,    62,    64,    66,    68,    70,    78,    86,    87,    89,
      91,    39,    37,    38,    50,    37,    38,    53,    54,    71,
       3,     6,     7,     8,     9,    11,    14,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    63,     5,    10,    65,     4,
      13,    67,    50,    69,    71,    53,    79,    71,    17,    28,
      30,    32,    92,    71,    71,    39,    71,    71,    36,    61,
      72,    80,    53,    61,    37,    38,    88,    53,    40,    73,
      40,    81,    45,    53,    74,    75,    76,    82,    83,    84,
      37,    38,    93,    45,    41,    42,    35,    36,    43,    77,
      90,    41,    42,    36,    43,    85,    93,    75,    44,    83,
      44,    90,    36
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      fprintf (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  int yystate;
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 63 "drsed.y"
    {if(interact) printf(">");}
    break;

  case 3:
#line 64 "drsed.y"
    {if(interact) printf(">");}
    break;

  case 4:
#line 65 "drsed.y"
    {if(interact) printf(">");}
    break;

  case 5:
#line 66 "drsed.y"
    {yyerrok; if(interact) printf(">");}
    break;

  case 21:
#line 84 "drsed.y"
    {DRSEDCALL(DRSEDcloseoutputfile(&_drsed_outfile),(err=err));
		      	_drsed_outfile=stdout;
			}
    break;

  case 24:
#line 91 "drsed.y"
    { DRSEDCALL(DRSEDopenoutputfile((yyvsp[(2) - (2)].sval),&_drsed_outfile),(err=err));
			       if(_drsed_outfile==NULL) _drsed_outfile=stdout;
			     }
    break;

  case 25:
#line 95 "drsed.y"
    {
					DRSEDCALL(currentvar==NULL_VARIABLE,
					 DRSEDdescribevar(currentvar))}
    break;

  case 26:
#line 99 "drsed.y"
    {if((yyvsp[(1) - (1)].varval)==NULL_VARIABLE)
				       {DRSEDerror("No variable current");
					DRSEDYYERROR;
				       }
			       else
				       (yyval.varval)=currentvar=(yyvsp[(1) - (1)].varval);}
    break;

  case 27:
#line 107 "drsed.y"
    {(yyval.varval)=currentvar;}
    break;

  case 28:
#line 108 "drsed.y"
    {(yyval.varval)=DRSEDfindvar((yyvsp[(1) - (1)].sval),currentfile);}
    break;

  case 29:
#line 109 "drsed.y"
    {(yyval.varval)=DRSEDfindvar((yyvsp[(1) - (1)].sval),currentfile);}
    break;

  case 30:
#line 111 "drsed.y"
    {if(err=(currentfile==NULL_FILE))
			  	DRSEDerror("No file currently specified, use OPEN");
			   DRSEDCALL(err,
			    		DRSEDgetfilefield(currentfile,(yyvsp[(1) - (1)].ival)))}
    break;

  case 31:
#line 115 "drsed.y"
    {
			       	       DRSEDCALL(currentvar==NULL_VARIABLE,
			       		DRSEDgetvarfield(currentvar,(yyvsp[(1) - (2)].ival)))}
    break;

  case 32:
#line 118 "drsed.y"
    {DRSEDCALL(currentvar==NULL_VARIABLE,
				      	DRSEDgetvarfield(currentvar,(yyvsp[(1) - (2)].ival)))}
    break;

  case 33:
#line 121 "drsed.y"
    {(yyval.ival)=NV;}
    break;

  case 34:
#line 123 "drsed.y"
    {(yyval.ival)=SOURCE;}
    break;

  case 35:
#line 124 "drsed.y"
    {(yyval.ival)=NAME;}
    break;

  case 36:
#line 125 "drsed.y"
    {(yyval.ival)=TITLE;}
    break;

  case 37:
#line 126 "drsed.y"
    {(yyval.ival)=UNITS;}
    break;

  case 38:
#line 127 "drsed.y"
    {(yyval.ival)=TIME;}
    break;

  case 39:
#line 128 "drsed.y"
    {(yyval.ival)=TYPE;}
    break;

  case 40:
#line 129 "drsed.y"
    {(yyval.ival)=ND;}
    break;

  case 41:
#line 131 "drsed.y"
    {(yyval.ival)=LENGTH;}
    break;

  case 42:
#line 132 "drsed.y"
    {(yyval.ival)=SHAPE;}
    break;

  case 43:
#line 133 "drsed.y"
    {(yyval.ival)=INDEX;}
    break;

  case 44:
#line 135 "drsed.y"
    { if(((yyvsp[(3) - (3)].varval) != NULL_VARIABLE) && ((yyvsp[(2) - (3)].ival) < 1 || (yyvsp[(2) - (3)].ival) > (yyvsp[(3) - (3)].varval)->ndim))
				    {
				      DRSEDerror("Variable %s does not have a dimension %d",(yyvsp[(3) - (3)].varval)->name,(yyvsp[(2) - (3)].ival)); DRSEDYYERROR;}
				      DRSEDCALL((yyvsp[(3) - (3)].varval)==NULL_VARIABLE,
				  	DRSEDgetdimfield(FLUSH,&(yyvsp[(3) - (3)].varval)->dim[(yyvsp[(2) - (3)].ival)-1],(yyvsp[(1) - (3)].ival)))}
    break;

  case 45:
#line 141 "drsed.y"
    {(yyval.ival)=SOURCE;}
    break;

  case 46:
#line 142 "drsed.y"
    {(yyval.ival)=NAME;}
    break;

  case 47:
#line 143 "drsed.y"
    {(yyval.ival)=TITLE;}
    break;

  case 48:
#line 144 "drsed.y"
    {(yyval.ival)=UNITS;}
    break;

  case 49:
#line 145 "drsed.y"
    {(yyval.ival)=RANGE;}
    break;

  case 50:
#line 146 "drsed.y"
    {(yyval.ival)=DATA;}
    break;

  case 51:
#line 148 "drsed.y"
    {(yyval.ival)=(yyvsp[(1) - (1)].ival);}
    break;

  case 52:
#line 150 "drsed.y"
    {DRSEDCALL(0,DRSEDhelp((yyvsp[(2) - (2)].ival)))}
    break;

  case 53:
#line 152 "drsed.y"
    {(yyval.ival)=ALL;}
    break;

  case 54:
#line 153 "drsed.y"
    {(yyval.ival)=ALL;}
    break;

  case 55:
#line 154 "drsed.y"
    {(yyval.ival)=CLOSE;}
    break;

  case 56:
#line 155 "drsed.y"
    {(yyval.ival)=CREATE;}
    break;

  case 57:
#line 156 "drsed.y"
    {(yyval.ival)=DATA;}
    break;

  case 58:
#line 157 "drsed.y"
    {(yyval.ival)=DESCRIBE;}
    break;

  case 59:
#line 158 "drsed.y"
    {(yyval.ival)=HELP;}
    break;

  case 60:
#line 159 "drsed.y"
    {(yyval.ival)=LENGTH;}
    break;

  case 61:
#line 160 "drsed.y"
    {(yyval.ival)=LIST;}
    break;

  case 62:
#line 161 "drsed.y"
    {(yyval.ival)=MODE;}
    break;

  case 63:
#line 162 "drsed.y"
    {(yyval.ival)=NAME;}
    break;

  case 64:
#line 163 "drsed.y"
    {(yyval.ival)=ND;}
    break;

  case 65:
#line 164 "drsed.y"
    {(yyval.ival)=NV;}
    break;

  case 66:
#line 165 "drsed.y"
    {(yyval.ival)=OPEN;}
    break;

  case 67:
#line 166 "drsed.y"
    {(yyval.ival)=PRINT;}
    break;

  case 68:
#line 167 "drsed.y"
    {(yyval.ival)=PRINTI;}
    break;

  case 69:
#line 168 "drsed.y"
    {(yyval.ival)=PRINTU;}
    break;

  case 70:
#line 169 "drsed.y"
    {(yyval.ival)=QUIT;}
    break;

  case 71:
#line 170 "drsed.y"
    {(yyval.ival)=RANGE;}
    break;

  case 72:
#line 171 "drsed.y"
    {(yyval.ival)=SET;}
    break;

  case 73:
#line 172 "drsed.y"
    {(yyval.ival)=SHAPE;}
    break;

  case 74:
#line 173 "drsed.y"
    {(yyval.ival)=SOURCE;}
    break;

  case 75:
#line 174 "drsed.y"
    {(yyval.ival)=TIME;}
    break;

  case 76:
#line 175 "drsed.y"
    {(yyval.ival)=TITLE;}
    break;

  case 77:
#line 176 "drsed.y"
    {(yyval.ival)=TYPE;}
    break;

  case 78:
#line 177 "drsed.y"
    {(yyval.ival)=UNITS;}
    break;

  case 79:
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
				  DRSEDCALL(0,DRSEDlist(currentfile,(yyvsp[(2) - (2)].ival)));
			  }
			  }
    break;

  case 80:
#line 192 "drsed.y"
    {(yyval.ival)=(interact ? FULL : BRIEF);}
    break;

  case 81:
#line 193 "drsed.y"
    {(yyval.ival)=BRIEF;}
    break;

  case 82:
#line 194 "drsed.y"
    {(yyval.ival)=FULL;}
    break;

  case 83:
#line 196 "drsed.y"
    {DRSEDCALL(0,(err=err));}
    break;

  case 84:
#line 198 "drsed.y"
    {interact=1;}
    break;

  case 85:
#line 199 "drsed.y"
    {interact=0;}
    break;

  case 86:
#line 201 "drsed.y"
    {if((yyvsp[(2) - (2)].fileval) != NULL_FILE) 
					   currentfile=(yyvsp[(2) - (2)].fileval);
				   DRSEDCALL(DRSEDreaddicfile((yyvsp[(2) - (2)].fileval)),(err=err))}
    break;

  case 87:
#line 205 "drsed.y"
    {		/* Don't reopen the same file */
	                 if(currentfile != NULL_FILE && !strcmp((yyvsp[(1) - (1)].sval),currentfile->name))
				 (yyval.fileval)=currentfile;
			 else
			 {
				 if(currentfile != NULL_FILE)
				 {
					 
					 Cllun(currentfile->unit);
					 currentfile=NULL_FILE;
				 }
				 (yyval.fileval)=DRSEDopenfile((yyvsp[(1) - (1)].sval));
			 }
		 }
    break;

  case 88:
#line 221 "drsed.y"
    {DRSEDCALL(DRSEDreadvardata(currentvar),
			      	DRSEDprintvardata(currentvar))}
    break;

  case 89:
#line 225 "drsed.y"
    {if((yyvsp[(1) - (1)].varval)==NULL_VARIABLE)
			{
			DRSEDerror("Variable not found");
			DRSEDYYERROR;
			}
		 else
		 {currentvar=(yyvsp[(1) - (1)].varval);
		  ndim=0;
		 }
		}
    break;

  case 90:
#line 236 "drsed.y"
    {if (ndim!=currentvar->ndim)
		    {
		        DRSEDerror("Must specify %d dimensions for %s",currentvar->ndim, currentvar->name);
			DRSEDYYERROR;
			}
		}
    break;

  case 91:
#line 244 "drsed.y"
    {
		for(ndim=0; ndim<currentvar->ndim; ndim++)
		  {
			  currentvar->dim[ndim].reqfirstel=currentvar->dim[ndim].firstel;
			  currentvar->dim[ndim].reqlastel=currentvar->dim[ndim].lastel;
		  }
		}
    break;

  case 95:
#line 256 "drsed.y"
    { if(ndim>=currentvar->ndim)
		  {
		  	  DRSEDerror("Too many dimensions specified for variable %s",currentvar->name);
			  DRSEDYYERROR;
		  }
		}
    break;

  case 97:
#line 265 "drsed.y"
    {
			  currentvar->dim[ndim].reqfirstel=currentvar->dim[ndim].firstel;
			  currentvar->dim[ndim].reqlastel=currentvar->dim[ndim].lastel;
			  ndim++;
		  }
    break;

  case 98:
#line 271 "drsed.y"
    {
			  currentvar->dim[ndim].reqfirstel=(yyvsp[(1) - (1)].dval);
			  currentvar->dim[ndim].reqlastel=(yyvsp[(1) - (1)].dval);
			  ndim++;
		  }
    break;

  case 99:
#line 277 "drsed.y"
    {
			  currentvar->dim[ndim].reqfirstel=(yyvsp[(1) - (3)].dval);
			  currentvar->dim[ndim].reqlastel=(yyvsp[(3) - (3)].dval);
			  ndim++;
		  }
    break;

  case 100:
#line 283 "drsed.y"
    {DRSEDCALL(DRSEDreadvardata(currentvar),
			      	DRSEDprintvardata(currentvar))}
    break;

  case 101:
#line 287 "drsed.y"
    {if((yyvsp[(1) - (1)].varval)==NULL_VARIABLE)
			{
			DRSEDerror("Variable not found");
			DRSEDYYERROR;
			}
		 else
		 {currentvar=(yyvsp[(1) - (1)].varval);
		  ndim=0;
		 }
		}
    break;

  case 102:
#line 298 "drsed.y"
    {if (ndim!=currentvar->ndim)
		    {
		        DRSEDerror("Must specify %d dimensions for %s",currentvar->ndim, currentvar->name);
			DRSEDYYERROR;
			}
		}
    break;

  case 103:
#line 306 "drsed.y"
    {
		for(ndim=0; ndim<currentvar->ndim; ndim++)
		  {
			  currentvar->dim[ndim].reqfirstel=currentvar->dim[ndim].firstel;
			  currentvar->dim[ndim].reqlastel=currentvar->dim[ndim].lastel;
		  }
		}
    break;

  case 107:
#line 318 "drsed.y"
    { if(ndim>=currentvar->ndim)
		  {
		  	  DRSEDerror("Too many dimensions specified for variable %s",currentvar->name);
			  DRSEDYYERROR;
		  }
		}
    break;

  case 109:
#line 327 "drsed.y"
    {
			  currentvar->dim[ndim].reqfirstel=currentvar->dim[ndim].firstel;
			  currentvar->dim[ndim].reqlastel=currentvar->dim[ndim].lastel;
			  ndim++;
		  }
    break;

  case 110:
#line 333 "drsed.y"
    {
		  	  DRSEDCALL(err2=DRSEDsetreqel(currentvar,ndim,(yyvsp[(1) - (1)].ival),(yyvsp[(1) - (1)].ival)),(err=err));
			  if(err2) YYERROR;
			  ndim++;
		  }
    break;

  case 111:
#line 339 "drsed.y"
    {
		  	  DRSEDCALL(err2=DRSEDsetreqel(currentvar,ndim,(yyvsp[(1) - (3)].ival),(yyvsp[(3) - (3)].ival)),(err=err));
			  if(err2) YYERROR;
			  ndim++;
		  }
    break;

  case 112:
#line 345 "drsed.y"
    {DRSEDCALL(DRSEDreadvardata(currentvar),
			      	DRSEDprintuvardata(currentvar))}
    break;

  case 113:
#line 348 "drsed.y"
    {DRSEDCALL(DRSEDreadvardata(currentvar),
				      DRSEDwritevardata(currentvar,_drsed_outfile,(yyvsp[(3) - (3)].sval)))}
    break;

  case 114:
#line 351 "drsed.y"
    {(yyval.sval)="";}
    break;

  case 117:
#line 355 "drsed.y"
    {DRSEDCALL(DRSEDreadvardata(currentvar),
				DRSEDwriteuvardata(currentvar,_drsed_outfile))}
    break;

  case 118:
#line 358 "drsed.y"
    {(yyval.dval)=(yyvsp[(1) - (1)].ival);}
    break;

  case 119:
#line 359 "drsed.y"
    {(yyval.dval)=(yyvsp[(1) - (1)].dval);}
    break;

  case 120:
#line 361 "drsed.y"
    {DRSEDCALL(currentvar == NULL_VARIABLE,
					     DRSEDsetvar(currentvar,(yyvsp[(2) - (5)].ival),(yyvsp[(5) - (5)].sval)))}
    break;

  case 121:
#line 364 "drsed.y"
    { if(( (yyvsp[(4) - (6)].varval) != NULL_VARIABLE) && ((yyvsp[(3) - (6)].ival)<1 || (yyvsp[(3) - (6)].ival)>(yyvsp[(4) - (6)].varval)->ndim))
		         {DRSEDerror("Variable %s does not have a dimension %d",(yyvsp[(4) - (6)].varval)->name,(yyvsp[(3) - (6)].ival)); DRSEDYYERROR;}
			  DRSEDCALL(currentvar==NULL_VARIABLE,
			    DRSEDsetdim(&currentvar->dim[(yyvsp[(3) - (6)].ival)-1],(yyvsp[(2) - (6)].ival),(yyvsp[(6) - (6)].sval)))}
    break;

  case 122:
#line 369 "drsed.y"
    {(yyval.ival)=SOURCE;}
    break;

  case 123:
#line 370 "drsed.y"
    {(yyval.ival)=NAME;}
    break;

  case 124:
#line 371 "drsed.y"
    {(yyval.ival)=TITLE;}
    break;

  case 125:
#line 372 "drsed.y"
    {(yyval.ival)=UNITS;}
    break;

  case 126:
#line 374 "drsed.y"
    {(yyval.sval)=singleBlank;}
    break;


/* Line 1267 of yacc.c.  */
#line 2189 "y.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse look-ahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


#line 378 "drsed.y"

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

