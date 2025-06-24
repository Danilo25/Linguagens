%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern char *yytext;
extern int yylineno;

int yylex(void);
%}

%option noyywrap
%option yylineno

%%

"if"            { return IF; }
"else"          { return ELSE; }
"for"           { return FOR; }
"switch"        { return SWITCH; }
"while"         { return WHILE; }
"return"        { return RETURN; }
"do"            { return DO; }

"print"         { return PRINT; }
"scan"          { return SCAN; }

"Unit"          { return UNIT; }
"Bool"          { return BOOL; }
"Int"           { return INT; }
"Float"         { return FLOAT; }
"Char"          { return CHAR; }
"String"        { return STRING; }

"struct"        { return STRUCTURE; }
"sum"           { return SUM; }

"mut"           { return MUT; }

"break"         { return BREAK; }
"case"          { return CASE; }

"skip"          { return SKIP; }
"stop"          { return STOP; }
"++"            { return PLUSPLUS; }
"--"            { return MINUSMINUS; }

"+"             { return PLUS_INT; }
"-"             { return MINUS_INT; }
"*"             { return MUL_INT; }
"/"             { return DIV_INT; }
"%"             { return MOD_INT; }
"+."            { return PLUS_FLOAT; }
"-."            { return MINUS_FLOAT; }
"*."            { return MUL_FLOAT; }
"/."            { return DIV_FLOAT; }
"&&"            { return AND; }
"||"            { return OR; }
"not"           { return NOT; }

"=="            { return EQQ; }
"!="            { return NEQ; }
"<="            { return LE; }
">="            { return GE; }
"<<"            { return LSHIFT; }
">>"            { return RSHIFT; }
"<"             { return LT; }
">"             { return GT; }
"="             { return EQ; }
"<-"            { return ARROW_LEFT; }
"->"            { return ARROW_RIGHT; }

";"             { return SEMICOLON; }
","             { return COMMA; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"["             { return LBRACKET; }
"]"             { return RBRACKET; }

"//".*          { /* Ignore comments */ }

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str_val = strdup(yytext);
    return ID;
}

[0-9]+\.[0-9]+([eE][-+]?[0-9]+)? {
    yylval.float_val = atof(yytext);
    return FLOAT_LIT;
}

[0-9]+|"-"[0-9]+ {
    yylval.int_val = atoi(yytext);
    return INT_LIT;
}

"\""([^"\\]|\\.)*"\"" {
    yytext[yyleng-1] = '\0';
    yylval.str_val = strdup(yytext + 1);
    return STRING_LIT;
}

"'"([^'\\]|\\.)"'" {
    yylval.char_val = yytext[1];
    return CHAR_LIT;
}

[ \t\r\n]+      { /* Ignore whitespace */ }

.               {
    fprintf(stderr, "LEXICAL ERROR: UNKNOWN TOKEN '%s' at line %d\n", yytext, yylineno);
    return 0;
}

%%
