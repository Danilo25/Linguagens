%{
#include "parser.tab.h"
#include <stdio.h>
%}

%%

"if"            { return IF; }
"else"          { return ELSE; }
"for"           { return FOR; }
"switch"        { return SWITCH; }
"while"         { return WHILE; }
"return"        { return RETURN; }

"printf"        { return PRINTF; }
"scanf"         { return SCANF; }

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


"//".* { /* Single-line comment rule */ }

[a-zA-Z_][a-zA-Z0-9_]*           { printf("ID(%s) ", yytext); }
[0-9]+\.[0-9]+([eE][-+]?[0-9]+)? { printf("FLOAT_LIT(%s) ", yytext); }
[0-9]+|"-"[0-9]                  { printf("INT_LIT(%s) ", yytext); }
"\""([^"\\]|\\.)*"\""            { printf("STRING_LIT(%s) ", yytext); }
"'"([^'\\]|\\.)*"'"              { printf("CHAR_LIT(%s) ", yytext); }
[" "]+   { }
["\t"]+  { }
\r\n|\r|\n   { printf("\n"); }
.                       { printf("UNKNOWN(%s) ", yytext); }
%%
