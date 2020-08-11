%{
# include "test.h"
# include "test.tab.h"
%}

/* float exponent */
EXP ([Ee][-+]?[0-9]+)

%%

 /* single character ops */
"+" |
"-" |
"*" |
"/" |
"=" |
"|" |
"," |
";" |
"(" |
")" |
"{" |
"}" |
"[" |
"]" |
"!" { return yytext[0]; }

 /* comparion ops, all are a CMP token */
">"     { yylval.fn = 1; return CMP; }
"<"     { yylval.fn = 2; return CMP; }
"!="    { yylval.fn = 3; return CMP; }
"=="    { yylval.fn = 4; return CMP; }
">="    { yylval.fn = 5; return CMP; }
"<="    { yylval.fn = 6; return CMP; }

 /* keywords */
"if"    { return IF; }
"else"  { return ELSE; }
"while" { return WHILE; }
"let"   { return LET; }
"for"   { return FOR; }

 /* built-in functions */
"sqrt"  { yylval.fn = B_sqrt; return FUNC; }
"exp"   { yylval.fn = B_exp; return FUNC; }
"log"   { yylval.fn = B_log; return FUNC; }
"print" { yylval.fn = B_print; return FUNC; }


 /* names */
[a-zA-Z][a-zA-Z0-9]*    { yylval.s = lookup(yytext); return NAME; }

[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}?        { yylval.d = atof(yytext); return NUMBER; }

 /* string literal */
\"(\\.|[^"\\])*\"       { yylval.str = yytext; return STRING; }

 /* comments */
"//".*
[ \t]   /* ignore whitespace */

\\\n                    { printf("c> "); }  /* ignore line continuation */

\n                      { return EOL; }

.                       { printf("Mystery character %c\n", *yytext); }


%%
