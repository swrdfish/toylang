/* calculator with AST */

%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "test.h"

#define YYDEBUG 1

void yyerror(const char* fmt, ...) {
    va_list ap;
    va_start(ap, fmt);

    vprintf(fmt, ap);
}
%}

%union {
    struct ast *a;
    double d;
    struct symbol *s;                               /* which symbol */
    struct symlist *sl;
    int fn;                                        /* which function */
    char ** str;
}

/* declare tokens */
%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC 
%token EOL
%token IF ELSE WHILE LET FOR

%nonassoc <fn> CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

%type <a> exp stmt list explist
%type <sl> symlist

%%
calclist: /* nothing */
    | calclist stmt EOL {
        printf("= %4.4g\n", eval($2));
        treefree($2);
    }
    | calclist LET NAME '(' symlist ')' '=' list EOL {
        dodef($3, $5, $8);
        printf("Defined %s\n> ", $3->name);
    }
    | calclist error EOL { printf("> "); yyerrok; }
    ;

stmt: IF '(' exp ')' block                      { $$ = newflow('I', $2, $4, NULL); }
    | IF '('exp ')' block ELSE block            { $$ = newflow('I', $2, $4, $6); }
    | WHILE '(' exp ')'block                    { $$ = newflow('W', $2, $4, NULL); }
    | FOR '(' exp ';' exp ';' exp ')' block     { $$ = newflow('F', $3, $5, $7); }
    | exp
    ;

block: '{' list '}'

list: /* nothing */                 { $$ = NULL; }
    | stmt ';' list                 { if ($3 == NULL ) {
                                        $$ = $1;
                                      }
                                      else {
                                        $$ = newast('L', $1, $3);
                                      }
                                    }
    | stmt ';' EOL list             { if ($4 == NULL ) {
                                        $$ = $1;
                                      }
                                      else {
                                        $$ = newast('L', $1, $4);
                                      }
                                    }
    | block
    | EOL
    ;



exp: exp CMP exp                    { $$ = newcmp($2, $1, $3); }
    | exp '+' exp                   { $$ = newast('+', $1,$3); }
    | exp '-' exp                   { $$ = newast('-', $1,$3); }
    | exp '*' exp                   { $$ = newast('*', $1,$3); }
    | exp '/' exp                   { $$ = newast('/', $1,$3); }
    | '|' exp                       { $$ = newast('|', $2,NULL); }
    | '(' exp ')'                   { $$ = $2; }
    | '-' exp %prec UMINUS          { $$ = newast('M', $2,NULL); }
    | NUMBER                        { $$ = newnum($1); }
    | NAME                          { $$ = newref($1); }
    | NAME '=' exp                  { $$ = newasgn($1, $3); }
    | FUNC '(' explist ')'          { $$ = newfunc($1, $3); }
    | NAME '(' explist ')'          { $$ = newcall($1, $3); }
    ;

explist: exp
    | exp ',' explist               { $$ = newast('L', $1, $3); }
    ;

symlist: NAME                       { $$ = newsymlist($1, NULL); }
    | NAME ',' symlist              { $$ = newsymlist($1, $3); }
    ;
%%

main(int argc, char **argv)
{
    yyparse();
}