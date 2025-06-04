%{
#include <stdio.h>
#include "parser.tab.h"


int yywrap();

// Definition of yywrap()
int yywrap() {
    return 1; 
}
%}

%%
"se"          { return IF; } 
"senao"       { return ELSE; }
"para"        { return FOR; }
"dentre"      { return SWITCH; }
"enquanto"    { return WHILE; }
"retorne"     { return RETURN; }

"pintef"      { return PRINTF; }
"leia"        { return SCANF; }

"Um"          { return UNIT; }
"Dois"        { return BOOL; }
"Int"         { return INT; }
"Flut"        { return FLOAT; }
"Estrutura"   { return STRUCTURE; }
"Tag-union"   { return SUM; }
"Cara"        { return CHAR; }
"Nat"         { return UNSIGNED; }
"Const"       { return CONST; }
"Cadeia"      { return STRING; }

"pare"        { return BREAK; }
"pule"        { return CONTINUE; }
"caso"        { return CASE; }

"=="          { return EQ; }
"!="          { return NE; }
"<="          { return LE; }
">="          { return GE; }
"<"           { return LT; }
">"           { return GT; }
"&&"          { return AND; }
"||"          { return OR; }
"!"           { return NOT; }

"+"           { return PLUS; }
"-"           { return MINUS; }
"*"           { return TIMES; }
"/"           { return DIVIDE; }
"="           { return ASSIGN_OP; }

";"           { return SEMICOLON; }
","           { return COMMA; }
"("           { return LPAREN; }
")"           { return RPAREN; }
"{"           { return LBRACE; }
"}"           { return RBRACE; }
"["           { return LBRACKET; }
"]"           { return RBRACKET; }
"->"          { return ARROWR; }
"<-"          { return ARROWR; }
"&"           { return AMP; }
"|"           { return PIPE; }
"^"           { return CARET; }
"~"           { return TILDE; }
"?"           { return QUESTION; }
":"           { return COLON; }

[a-zA-Z][a-zA-Z0-9_]* {
    // If you need the string value of the ID in the parser, you'd store it in yylval here.
    // For this example, we'll just return the token type.
    return ID;
}
[0-9]+\.[0-9]+ { return FLOAT_LIT; }
[0-9]+         { return INT_LIT; }
"\""([^"\\]|\\.)*"\"" { return STRING_LIT; }
"'"([^'\\]|\\.)*"'" { return CHAR_LIT; }

[" "]+ { /* ignore whitespace */ }
["\t"]+ { /* ignore tabs */ }
["\r"|"\n"]+ { /* ignore newlines */ }
. {
    fprintf(stderr, "Lexical error: Unknown character '%s'\n", yytext);
    // You might want to return an error token or exit here.
    exit(1);
}
%%