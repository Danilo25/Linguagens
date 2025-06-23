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
"goto"          { printf("GOTO "); }
"default"       { printf("DEFAULT "); }
"sizeof"        { printf("SIZEOF "); }

"printf"        { printf("PRINTF "); }
"scanf"         { printf("SCANF "); }

"unit"          { printf("UNIT "); }
"bool"          { printf("BOOL "); }
"int"|"Int"     { printf("INT "); }
"float"         { printf("FLOAT "); }
"Flut"          { printf("FLOAT "); }
"struct"        { printf("STRUCTURE "); }
"union"         { printf("SUM "); }
"char"          { printf("CHAR "); }
"unsigned"      { printf("UNSIGNED "); }
"const"         { printf("CONST "); }
"string"|"String" { printf("STRING "); }
"void"          { printf("VOID "); }
"estrutura"     { printf("STRUCTURE "); }

"short"         { printf("SHORT "); }
"long"          { printf("LONG "); }
"signed"        { printf("SIGNED "); }
"double"        { printf("DOUBLE "); }
"auto"          { printf("AUTO "); }
"register"      { printf("REGISTER "); }
"static"        { printf("STATIC "); }
"extern"        { printf("EXTERN "); }
"typedef"       { printf("TYPEDEF "); }
"enum"          { printf("ENUM "); }
"volatile"      { printf("VOLATILE "); }
"restrict"      { printf("RESTRICT "); }

"break"         { printf("BREAK "); }
"continue"      { printf("CONTINUE "); }
"case"          { printf("CASE "); }

"=="            { printf("EQ "); }
"!="            { printf("NE "); }
"<="            { printf("LE "); }
">="            { printf("GE "); }
"<<"            { printf("LSHIFT "); }
">>"            { printf("RSHIFT "); }
"<"             { printf("LT "); }
">"             { printf("GT "); }

"="             { printf("ASSIGN "); }
"<-"            { printf("ARROW_LEFT "); }
"->"            { printf("ARROW_RIGHT "); }
"+="            { printf("PLUS_ASSIGN "); }
"-="            { printf("MINUS_ASSIGN "); }
"*="            { printf("MUL_ASSIGN "); }
"/="            { printf("DIV_ASSIGN "); }
"%="            { printf("MOD_ASSIGN "); }
"&="            { printf("BIT_AND_ASSIGN "); }
"|="            { printf("BIT_OR_ASSIGN "); }
"^="            { printf("BIT_XOR_ASSIGN "); }
"<<="           { printf("LSHIFT_ASSIGN "); }
">>="           { printf("RSHIFT_ASSIGN "); }

"++"            { printf("INCREMENT "); }
"--"            { printf("DECREMENT "); }

"+"             { printf("PLUS "); }
"-"             { printf("MINUS "); }
"*"             { printf("MUL "); }
"/"             { printf("DIV "); }
"%"             { printf("MOD "); }
"."             { printf("DOT "); }

"&&"            { printf("AND "); }
"||"            { printf("OR "); }
"!"             { printf("NOT "); }

";"             { printf("SEMICOLON "); }
","             { printf("COMMA "); }
"("             { printf("LPAREN "); }
")"             { printf("RPAREN "); }
"{"             { printf("LBRACE "); }
"}"             { printf("RBRACE "); }
"["             { printf("LBRACKET "); }
"]"             { printf("RBRACKET "); }
"[]"            { printf("ARRAY_TYPE "); }

"&"             { printf("AMP "); }
"|"             { printf("PIPE "); }
"^"             { printf("CARET "); }
"\\~"           { printf("TILDE "); }
"?"             { printf("QUESTION "); }
":"             { printf("COLON "); }

"//".* { /* Single-line comment rule */ }
"/*" {  /* Multi-line comment rule */
    int c;
    while ( (c = input()) != 0 ) {
        if (c == '*') {
            if ( (c = input()) == '/' ) {
                break;
            } else {
                unput(c);
            }
        }
    }
}

[a-zA-Z_][a-zA-Z0-9_]* { printf("ID(%s) ", yytext); }
[0-9]+\.[0-9]+([eE][-+]?[0-9]+)? { printf("FLOAT_LIT(%s) ", yytext); }
[0-9]+                  { printf("INT_LIT(%s) ", yytext); }
"\""([^"\\]|\\.)*"\""   { printf("STRING_LIT(%s) ", yytext); }
"'"([^'\\]|\\.)*"'"     { printf("CHAR_LIT(%s) ", yytext); }

[ \t\r\n]+       { /* Whitespace rule */ }

.                       { fprintf(stderr, "LEXICAL ERROR: UNKNOWN TOKEN '%s'\n", yytext); }

%%

// int main(int argc, char **argv) {
//     yylex();
//     return 0;
// }
int yywrap() {
    return 1;
}