%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap
%option yylineno

%%

"Unit"          { return UNIT; }
"Float"         { return FLOAT; }
"Int"           { return INT; }
"Rational"      { return RATIONAL; }
"Matrix"        { return MATRIX; }
"BST"           { return BST; }
"ref"           { return REF; }

"print"         { return PRINT; }
"return"        { return RETURN; }
"if"            { return IF; }
"while"         { return WHILE; }

"<="            { return LE; }
">="            { return GE; }
"=="            { return EQ; }
"!="            { return NE; }
"<"             { return LT; }
">"             { return GT; }
"<-"            { return ARROW_LEFT; }
"&"             { return AMPERSAND; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }

";"             { return SEMICOLON; }
","             { return COMMA; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }

[0-9]+\.[0-9]+  { yylval.float_val = atof(yytext); return FLOAT_LIT; }
[0-9]+          { yylval.int_val   = atoi(yytext); return INT_LIT; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str_val = strdup(yytext); return ID; }

[ \t\r\n]+      { }
"//".* { }

.               { fprintf(stderr, "ERRO LÉXICO: '%s' na linha %d\n", yytext, yylineno); exit(1); }

%%
