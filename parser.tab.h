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
    DO = 264,                      /* DO  */
    PRINT = 265,                   /* PRINT  */
    SCAN = 266,                    /* SCAN  */
    UNIT = 267,                    /* UNIT  */
    BOOL = 268,                    /* BOOL  */
    INT = 269,                     /* INT  */
    FLOAT = 270,                   /* FLOAT  */
    CHAR = 271,                    /* CHAR  */
    STRING = 272,                  /* STRING  */
    STRUCTURE = 273,               /* STRUCTURE  */
    SUM = 274,                     /* SUM  */
    MUT = 275,                     /* MUT  */
    BREAK = 276,                   /* BREAK  */
    CASE = 277,                    /* CASE  */
    SKIP = 278,                    /* SKIP  */
    STOP = 279,                    /* STOP  */
    PLUSPLUS = 280,                /* PLUSPLUS  */
    MINUSMINUS = 281,              /* MINUSMINUS  */
    PLUS_INT = 282,                /* PLUS_INT  */
    MINUS_INT = 283,               /* MINUS_INT  */
    MUL_INT = 284,                 /* MUL_INT  */
    DIV_INT = 285,                 /* DIV_INT  */
    MOD_INT = 286,                 /* MOD_INT  */
    PLUS_FLOAT = 287,              /* PLUS_FLOAT  */
    MINUS_FLOAT = 288,             /* MINUS_FLOAT  */
    MUL_FLOAT = 289,               /* MUL_FLOAT  */
    DIV_FLOAT = 290,               /* DIV_FLOAT  */
    AND = 291,                     /* AND  */
    OR = 292,                      /* OR  */
    NOT = 293,                     /* NOT  */
    EQQ = 294,                     /* EQQ  */
    NEQ = 295,                     /* NEQ  */
    LE = 296,                      /* LE  */
    GE = 297,                      /* GE  */
    LSHIFT = 298,                  /* LSHIFT  */
    RSHIFT = 299,                  /* RSHIFT  */
    LT = 300,                      /* LT  */
    GT = 301,                      /* GT  */
    EQ = 302,                      /* EQ  */
    ARROW_LEFT = 303,              /* ARROW_LEFT  */
    ARROW_RIGHT = 304,             /* ARROW_RIGHT  */
    SEMICOLON = 305,               /* SEMICOLON  */
    COMMA = 306,                   /* COMMA  */
    LPAREN = 307,                  /* LPAREN  */
    RPAREN = 308,                  /* RPAREN  */
    LBRACE = 309,                  /* LBRACE  */
    RBRACE = 310,                  /* RBRACE  */
    LBRACKET = 311,                /* LBRACKET  */
    RBRACKET = 312,                /* RBRACKET  */
    ID = 313,                      /* ID  */
    INT_LIT = 314,                 /* INT_LIT  */
    FLOAT_LIT = 315,               /* FLOAT_LIT  */
    CHAR_LIT = 316,                /* CHAR_LIT  */
    STRING_LIT = 317               /* STRING_LIT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 17 "parser.y"

    int int_val;
    float float_val;
    char char_val;
    char *str_val;

#line 133 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
