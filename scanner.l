%{
#include "parser.tab.h"
#include <stdio.h>
%}

%%

"if"            { printf("IF "); }
"else"          { printf("ELSE "); }
"for"           { printf("FOR "); }
"switch"        { printf("SWITCH "); }
"while"         { printf("WHILE "); }
"return"        { printf("RETURN "); }
"do"            { printf("DO "); }

"print"        { printf("PRINT "); }
"scan"         { printf("SCAN "); }

"Unit"          { printf("UNIT "); }
"Bool"          { printf("BOOL "); }
"Int"           { printf("INT "); }
"Float"         { printf("FLOAT "); }
"Char"          { printf("CHAR "); }
"String"        { printf("STRING "); }

"struct"        { printf("STRUCTURE "); }
"sum"           { printf("SUM "); }

"mut"         { printf("MUT"); }

"break"         { printf("BREAK "); }
"case"          { printf("CASE "); }

"skip"          { printf("SKIP"); }
"stop"          { printf("STOP"); }
"++"            { printf("PLUSPLUS"); }
"--"            { printf("MINUSMINUS"); }

"+"             { printf("PLUS_INT "); }
"-"             { printf("MINUS_INT "); }
"*"             { printf("MUL_INT "); }
"/"             { printf("DIV_INT"); }
"%"             { printf("MOD_INT "); }
"+."            { printf("PLUS_FLOAT "); }
"-."            { printf("MINUS_FLOAT "); }
"*."            { printf("MUL_FLOAT "); }
"/."            { printf("DIV_FLOAT "); }
"&&"            { printf("AND "); }
"||"            { printf("OR "); }
"not"           { printf("NOT "); }

"=="            { printf("EQQ "); }
"!="            { printf("NEQ "); }
"<="            { printf("LE "); }
">="            { printf("GE "); }
"<<"            { printf("LSHIFT "); }
">>"            { printf("RSHIFT "); }
"<"             { printf("LT "); }
">"             { printf("GT "); }
"="             { printf("EQ"); }
"<-"            { printf("ARROW_LEFT "); }
"->"            { printf("ARROW_RIGHT "); }

";"             { printf("SEMICOLON "); }
","             { printf("COMMA "); }
"("             { printf("LPAREN "); }
")"             { printf("RPAREN "); }
"{"             { printf("LBRACE "); }
"}"             { printf("RBRACE "); }
"["             { printf("LBRACKET "); }
"]"             { printf("RBRACKET "); }


"//".* { /* Single-line comment rule */ }

[a-zA-Z_][a-zA-Z0-9_]*           { printf("ID(%s) ", yytext); }
[0-9]+\.[0-9]+([eE][-+]?[0-9]+)? { printf("FLOAT_LIT(%s) ", yytext); }
[0-9]+|"-"[0-9]                  { printf("INT_LIT(%s) ", yytext); }
"\""([^"\\]|\\.)*"\""            { printf("STRING_LIT(%s) ", yytext); }
"'"([^'\\]|\\.)*"'"              { printf("CHAR_LIT(%s) ", yytext); }

[ \t\r\n]+                       { /* Whitespace rule */ }

.                                { fprintf(stderr, "LEXICAL ERROR: UNKNOWN TOKEN '%s'\n", yytext); }

%%

int yywrap() {
    return 1;
}
