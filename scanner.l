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

"if"            { printf("Token: IF\n"); return IF; }
"else"          { printf("Token: ELSE\n"); return ELSE; }
"for"           { printf("Token: FOR\n"); return FOR; }
"switch"        { printf("Token: SWITCH\n"); return SWITCH; }
"while"         { printf("Token: WHILE\n"); return WHILE; }
"return"        { printf("Token: RETURN\n"); return RETURN; }
"do"            { printf("Token: DO\n"); return DO; }

"print"         { printf("Token: PRINT\n"); return PRINT; }
"scan"          { printf("Token: SCAN\n"); return SCAN; }

"Unit"          { printf("Token: UNIT\n"); return UNIT; }
"Bool"          { printf("Token: BOOL\n"); return BOOL; }
"Int"           { printf("Token: INT\n"); return INT; }
"Float"         { printf("Token: FLOAT\n"); return FLOAT; }
"Char"          { printf("Token: CHAR\n"); return CHAR; }
"String"        { printf("Token: STRING\n"); return STRING; }

"struct"        { printf("Token: STRUCTURE\n"); return STRUCTURE; }
"sum"           { printf("Token: SUM\n"); return SUM; }

"mut"           { printf("Token: MUT\n"); return MUT; }

"break"         { printf("Token: BREAK\n"); return BREAK; }
"case"          { printf("Token: CASE\n"); return CASE; }

"skip"          { printf("Token: SKIP\n"); return SKIP; }
"stop"          { printf("Token: STOP\n"); return STOP; }
"++"            { printf("Token: PLUSPLUS\n"); return PLUSPLUS; }
"--"            { printf("Token: MINUSMINUS\n"); return MINUSMINUS; }

"+"             { printf("Token: PLUS_INT\n"); return PLUS_INT; }
"-"             { printf("Token: MINUS_INT\n"); return MINUS_INT; }
"*"             { printf("Token: MUL_INT\n"); return MUL_INT; }
"/"             { printf("Token: DIV_INT\n"); return DIV_INT; }
"%"             { printf("Token: MOD_INT\n"); return MOD_INT; }
"+."            { printf("Token: PLUS_FLOAT\n"); return PLUS_FLOAT; }
"-."            { printf("Token: MINUS_FLOAT\n"); return MINUS_FLOAT; }
"*."            { printf("Token: MUL_FLOAT\n"); return MUL_FLOAT; }
"/."            { printf("Token: DIV_FLOAT\n"); return DIV_FLOAT; }
"&&"            { printf("Token: AND\n"); return AND; }
"||"            { printf("Token: OR\n"); return OR; }
"not"           { printf("Token: NOT\n"); return NOT; }

"=="            { printf("Token: EQQ\n"); return EQQ; }
"!="            { printf("Token: NEQ\n"); return NEQ; }
"<="            { printf("Token: LE\n"); return LE; }
">="            { printf("Token: GE\n"); return GE; }
"<<"            { printf("Token: LSHIFT\n"); return LSHIFT; }
">>"            { printf("Token: RSHIFT\n"); return RSHIFT; }
"<"             { printf("Token: LT\n"); return LT; }
">"             { printf("Token: GT\n"); return GT; }
"="             { printf("Token: EQ\n"); return EQ; }
"<-"            { printf("Token: ARROW_LEFT\n"); return ARROW_LEFT; }
"->"            { printf("Token: ARROW_RIGHT\n"); return ARROW_RIGHT; }

";"             { printf("Token: SEMICOLON\n"); return SEMICOLON; }
","             { printf("Token: COMMA\n"); return COMMA; }
"("             { printf("Token: LPAREN\n"); return LPAREN; }
")"             { printf("Token: RPAREN\n"); return RPAREN; }
"{"             { printf("Token: LBRACE\n"); return LBRACE; }
"}"             { printf("Token: RBRACE\n"); return RBRACE; }
"["             { printf("Token: LBRACKET\n"); return LBRACKET; }
"]"             { printf("Token: RBRACKET\n"); return RBRACKET; }

"."             { printf("Token: DOT\n"); return DOT; }

"//".*          { /* Ignore comments */ }

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Token: ID (%s)\n", yytext);
    yylval.str_val = strdup(yytext);
    return ID;
}

[0-9]+\.[0-9]+([eE][-+]?[0-9]+)? {
    printf("Token: FLOAT_LIT (%s)\n", yytext);
    yylval.float_val = atof(yytext);
    return FLOAT_LIT;
}

[0-9]+|"-"[0-9]+ {
    printf("Token: INT_LIT (%s)\n", yytext);
    yylval.int_val = atoi(yytext);
    return INT_LIT;
}

"\""([^"\\]|\\.)*"\"" {
    yytext[yyleng-1] = '\0';
    printf("Token: STRING_LIT (%s)\n", yytext + 1);
    yylval.str_val = strdup(yytext + 1);
    return STRING_LIT;
}

"'"([^'\\]|\\.)"'" {
    printf("Token: CHAR_LIT (%c)\n", yytext[1]);
    yylval.char_val = yytext[1];
    return CHAR_LIT;
}

[ \t\r\n]+      { /* Ignore whitespace */ }

.               {
    fprintf(stderr, "LEXICAL ERROR: UNKNOWN TOKEN '%s' at line %d\n", yytext, yylineno);
    return 0;
}

%%
