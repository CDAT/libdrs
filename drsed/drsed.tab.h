/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

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
/* Line 1529 of yacc.c.  */
#line 133 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

