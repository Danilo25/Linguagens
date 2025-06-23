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
    UNIT = 267,                    /* UNIT  */
    BOOL = 268,                    /* BOOL  */
    INT = 269,                     /* INT  */
    FLOAT = 270,                   /* FLOAT  */
    STRUCTURE = 271,               /* STRUCTURE  */
    SUM = 272,                     /* SUM  */
    CHAR = 273,                    /* CHAR  */
    UNSIGNED = 274,                /* UNSIGNED  */
    CONST = 275,                   /* CONST  */
    STRING = 276,                  /* STRING  */
    ID = 277,                      /* ID  */
    INT_LIT = 278,                 /* INT_LIT  */
    FLOAT_LIT = 279,               /* FLOAT_LIT  */
    STRING_LIT = 280,              /* STRING_LIT  */
    CHAR_LIT = 281,                /* CHAR_LIT  */
    EQ = 282,                      /* EQ  */
    NE = 283,                      /* NE  */
    LE = 284,                      /* LE  */
    GE = 285,                      /* GE  */
    LT = 286,                      /* LT  */
    GT = 287,                      /* GT  */
    ARROW_LEFT = 288,              /* ARROW_LEFT  */
    ARROW_RIGHT = 289,             /* ARROW_RIGHT  */
    INCREMENT = 290,               /* INCREMENT  */
    DECREMENT = 291,               /* DECREMENT  */
    PLUS = 292,                    /* PLUS  */
    MINUS = 293,                   /* MINUS  */
    MUL = 294,                     /* MUL  */
    DIV = 295,                     /* DIV  */
    MOD = 296,                     /* MOD  */
    DOT = 297,                     /* DOT  */
    AND = 298,                     /* AND  */
    OR = 299,                      /* OR  */
    NOT = 300,                     /* NOT  */
    SEMICOLON = 301,               /* SEMICOLON  */
    COMMA = 302,                   /* COMMA  */
    LPAREN = 303,                  /* LPAREN  */
    RPAREN = 304,                  /* RPAREN  */
    LBRACE = 305,                  /* LBRACE  */
    RBRACE = 306,                  /* RBRACE  */
    LBRACKET = 307,                /* LBRACKET  */
    RBRACKET = 308,                /* RBRACKET  */
    AMP = 309,                     /* AMP  */
    PIPE = 310,                    /* PIPE  */
    CARET = 311,                   /* CARET  */
    TILDE = 312,                   /* TILDE  */
    QUESTION = 313,                /* QUESTION  */
    COLON = 314,                   /* COLON  */
    UNKNOWN = 315                  /* UNKNOWN  */
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

#line 130 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
