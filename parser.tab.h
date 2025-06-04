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
    PRINTF = 264,                  /* PRINTF  */
    SCANF = 265,                   /* SCANF  */
    UNIT = 266,                    /* UNIT  */
    BOOL = 267,                    /* BOOL  */
    INT = 268,                     /* INT  */
    FLOAT = 269,                   /* FLOAT  */
    STRUCTURE = 270,               /* STRUCTURE  */
    SUM = 271,                     /* SUM  */
    CHAR = 272,                    /* CHAR  */
    UNSIGNED = 273,                /* UNSIGNED  */
    CONST = 274,                   /* CONST  */
    STRING = 275,                  /* STRING  */
    BREAK = 276,                   /* BREAK  */
    CONTINUE = 277,                /* CONTINUE  */
    CASE = 278,                    /* CASE  */
    EQ = 279,                      /* EQ  */
    NE = 280,                      /* NE  */
    LE = 281,                      /* LE  */
    GE = 282,                      /* GE  */
    LT = 283,                      /* LT  */
    GT = 284,                      /* GT  */
    AND = 285,                     /* AND  */
    OR = 286,                      /* OR  */
    NOT = 287,                     /* NOT  */
    SEMICOLON = 288,               /* SEMICOLON  */
    COMMA = 289,                   /* COMMA  */
    LPAREN = 290,                  /* LPAREN  */
    RPAREN = 291,                  /* RPAREN  */
    LBRACE = 292,                  /* LBRACE  */
    RBRACE = 293,                  /* RBRACE  */
    LBRACKET = 294,                /* LBRACKET  */
    RBRACKET = 295,                /* RBRACKET  */
    ARROWR = 296,                  /* ARROWR  */
    AMP = 297,                     /* AMP  */
    PIPE = 298,                    /* PIPE  */
    CARET = 299,                   /* CARET  */
    TILDE = 300,                   /* TILDE  */
    QUESTION = 301,                /* QUESTION  */
    COLON = 302,                   /* COLON  */
    ID = 303,                      /* ID  */
    FLOAT_LIT = 304,               /* FLOAT_LIT  */
    INT_LIT = 305,                 /* INT_LIT  */
    STRING_LIT = 306,              /* STRING_LIT  */
    CHAR_LIT = 307,                /* CHAR_LIT  */
    PLUS = 308,                    /* PLUS  */
    MINUS = 309,                   /* MINUS  */
    TIMES = 310,                   /* TIMES  */
    DIVIDE = 311,                  /* DIVIDE  */
    ASSIGN_OP = 312,               /* ASSIGN_OP  */
    THEN_STMT = 313                /* THEN_STMT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
