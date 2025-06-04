%{
#include <stdio.h>
%}

%%
"se"         { printf("IF "); }
"senao"      { printf("ELSE "); }
"para"       { printf("FOR "); }
"dentre"     { printf("SWITCH "); }
"enquanto"   { printf("WHILE "); }
"retorne"    { printf("RETURN "); }

"pintef"     { printf("PRINTF"); }
"leia"       { printf("SCANF"); }

"Um"         { printf("UNIT"); }
"Dois"       { printf("BOOL"); }
"Int"        { printf("INT "); }
"Flut"       { printf("FLOAT "); }
"Estrutura"  { printf("STRUCTURE"); }
"Tag-union"  { printf("SUM"); }
"Cara"       { printf("CHAR "); }
"Nat"        { printf("UNSIGNED "); }
"Const"      { printf("CONST "); }
"Cadeia"     { printf("STRING "); }

"pare"      { printf("BREAK "); }
"pule"   { printf("CONTINUE "); }
"caso"       { printf("CASE "); }

"=="         { printf("EQ "); }
"!="         { printf("NE "); }
"<="         { printf("LE "); }
">="         { printf("GE "); }
"<"          { printf("LT "); }
">"          { printf("GT "); }
"&&"         { printf("AND "); }
"||"         { printf("OR "); }
"!"          { printf("NOT "); }

";"          { printf("SEMICOLON "); }
","          { printf("COMMA "); }
"("          { printf("LPAREN "); }
")"          { printf("RPAREN "); }
"{"          { printf("LBRACE "); }
"}"          { printf("RBRACE "); }
"["          { printf("LBRACKET "); }
"]"          { printf("RBRACKET "); }
"->"         { printf("ARROWR "); }
"<-"         { printf("ARROWR "); }
"&"          { printf("AMP "); }
"|"          { printf("PIPE "); }
"^"          { printf("CARET "); }
"~"          { printf("TILDE "); }
"?"          { printf("QUESTION "); }
":"          { printf("COLON "); }

[a-zA-Z][a-zA-Z0-9_]*     { printf("ID(%s) ", yytext); }
[0-9]+\.[0-9]+         { printf("FLOAT_LIT(%s) ", yytext); }
[0-9]+                  { printf("INT_LIT(%s) ", yytext); }
"\""([^"\\]|\\.)*"\""   { printf("STRING_LIT(%s) ", yytext); }
"'"([^'\\]|\\.)*"'"       { printf("CHAR_LIT(%s) ", yytext); }
[" "]+    { }
["\t"]+  { }
"\r"|"\n"]+  { }
.                           { printf("UNKNOWN(%s) ", yytext); }
%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}
