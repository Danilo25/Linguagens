/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    IF = 258,                      /* IF  */
    ELSE = 259,                    /* ELSE  */
    FOR = 260,                     /* FOR  */
    SWITCH = 261,                  /* SWITCH  */
    WHILE = 262,                   /* WHILE  */
    RETURN = 263,                  /* RETURN  */
    BREAK = 264,                   /* BREAK  */
    CONTINUE = 265,                /* CONTINUE  */
    CASE = 266,                    /* CASE  */
    PRINTF = 267,                  /* PRINTF  */
    SCANF = 268,                   /* SCANF  */
    UNIT = 269,                    /* UNIT  */
    BOOL = 270,                    /* BOOL  */
    INT = 271,                     /* INT  */
    FLOAT = 272,                   /* FLOAT  */
    STRUCTURE = 273,               /* STRUCTURE  */
    SUM = 274,                     /* SUM  */
    CHAR = 275,                    /* CHAR  */
    UNSIGNED = 276,                /* UNSIGNED  */
    CONST = 277,                   /* CONST  */
    STRING = 278,                  /* STRING  */
    ID = 279,                      /* ID  */
    INT_LIT = 280,                 /* INT_LIT  */
    FLOAT_LIT = 281,               /* FLOAT_LIT  */
    STRING_LIT = 282,              /* STRING_LIT  */
    CHAR_LIT = 283,                /* CHAR_LIT  */
    EQ = 284,                      /* EQ  */
    NE = 285,                      /* NE  */
    LE = 286,                      /* LE  */
    GE = 287,                      /* GE  */
    LT = 288,                      /* LT  */
    GT = 289,                      /* GT  */
    ASSIGN = 290,                  /* ASSIGN  */
    ARROW_LEFT = 291,              /* ARROW_LEFT  */
    ARROW_RIGHT = 292,             /* ARROW_RIGHT  */
    PLUS_ASSIGN = 293,             /* PLUS_ASSIGN  */
    MINUS_ASSIGN = 294,            /* MINUS_ASSIGN  */
    MUL_ASSIGN = 295,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 296,              /* DIV_ASSIGN  */
    MOD_ASSIGN = 297,              /* MOD_ASSIGN  */
    INCREMENT = 298,               /* INCREMENT  */
    DECREMENT = 299,               /* DECREMENT  */
    PLUS = 300,                    /* PLUS  */
    MINUS = 301,                   /* MINUS  */
    MUL = 302,                     /* MUL  */
    DIV = 303,                     /* DIV  */
    MOD = 304,                     /* MOD  */
    DOT = 305,                     /* DOT  */
    AND = 306,                     /* AND  */
    OR = 307,                      /* OR  */
    NOT = 308,                     /* NOT  */
    SEMICOLON = 309,               /* SEMICOLON  */
    COMMA = 310,                   /* COMMA  */
    LPAREN = 311,                  /* LPAREN  */
    RPAREN = 312,                  /* RPAREN  */
    LBRACE = 313,                  /* LBRACE  */
    RBRACE = 314,                  /* RBRACE  */
    LBRACKET = 315,                /* LBRACKET  */
    RBRACKET = 316,                /* RBRACKET  */
    AMP = 317,                     /* AMP  */
    PIPE = 318,                    /* PIPE  */
    CARET = 319,                   /* CARET  */
    TILDE = 320,                   /* TILDE  */
    QUESTION = 321,                /* QUESTION  */
    COLON = 322                    /* COLON  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 13 "parser.y"

    int ival;
    float fval;
    char* sval;

#line 137 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
