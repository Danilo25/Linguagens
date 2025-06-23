%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern YYSTYPE yylval;

%}

%%

"if"            { return IF; }
"else"          { return ELSE; }
"for"           { return FOR; }
"switch"        { return SWITCH; }
"while"         { return WHILE; }
"return"        { return RETURN; }

"Unit"          { return UNIT; }
"Bool"          { return BOOL; }
"Int"           { return INT; }
"Float"         { return FLOAT; }
"Struct"        { return STRUCTURE; }
"Tag-union"     { return SUM; }
"Char"          { return CHAR; }
"Unsigned"      { return UNSIGNED; }
"Const"         { return CONST; }
"String"        { return STRING; }

"break"         { return BREAK; }
"continue"      { return CONTINUE; }
"case"          { return CASE; }

"=="            { return EQ; }
"!="            { return NE; }
"<="            { return LE; }
">="            { return GE; }
"<"             { return LT; }
">"             { return GT; }
"&&"            { return AND; }
"||"            { return OR; }
"!"             { return NOT; }

"<-"            { return ARROW_LEFT; }
"->"            { return ARROW_RIGHT; }

"++"            { return INCREMENT; }
"--"            { return DECREMENT; }

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }
"%"             { return MOD; }
"."             { return DOT; }

";"             { return SEMICOLON; }
","             { return COMMA; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"["             { return LBRACKET; }
"]"             { return RBRACKET; }
"&"             { return AMP; }
"|"             { return PIPE; }
"^"             { return CARET; }
"~"             { return TILDE; }
"?"             { return QUESTION; }
":"             { return COLON; }


[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return ID; }
[0-9]+\.[0-9]+([eE][-+]?[0-9]+)? { yylval.fval = atof(yytext); return FLOAT_LIT; }
[0-9]+|"-"[0-9]+ { yylval.ival = atoi(yytext); return INT_LIT; }
"\""([^"\\]|\\.)*"\"" { yylval.sval = strdup(yytext); return STRING_LIT; }
"'"([^'\\]|\\.)*"'" { yylval.sval = strdup(yytext); return CHAR_LIT; }

[ \t]+          { /* Ignore spaces and tabs */ }
"//".* { /* Ignore single-line comments */ }
\r\n|\r|\n      { /* Ignore newlines, or return NEWLINE if grammar needs it */ }

.               { fprintf(stderr, "UNKNOWN_TOKEN: %s\n", yytext); return UNKNOWN; }

%%

int yywrap() {
    return 1;
}