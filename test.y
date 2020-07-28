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
    int fn;                                         /* which function */
}

/* declare tokens */
%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC 
%token EOL
%token IF THEN ELSE WHILE DO LET

%nonassoc <fn> CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

%type <a> exp stmt list explist
%type <sl> symlist

%%
calclist: /* nothing */ {printf("calclist: nothing");}
    | calclist stmt EOL {
        printf("calclist: stmt EOL");
        printf("= %4.4g\n", eval($2));
        treefree($2);
    }
    | calclist LET NAME '(' symlist ')' '=' list EOL {
        printf("calclist: let name eol");
        dodef($3, $5, $8);
        printf("Defined %s\n> ", $3->name);
    }
    | calclist error EOL { printf("> "); yyerrok; }
    ;

stmt: IF exp THEN list              { printf("parser> \n"); $$ = newflow('I', $2, $4, NULL); }
    | IF exp THEN list ELSE list    { printf("parser> \n"); $$ = newflow('I', $2, $4, $6); }
    | WHILE exp DO list             { printf("parser> \n"); $$ = newflow('W', $2, $4, NULL)}
    | exp                           { printf("parser> \n");}
    ;

list: /* nothing */                 { printf("parser> \n"); $$ = NULL; }
    | stmt ';' list                 { if ($3 == NULL ) {
                                        $$ = $1;
                                        printf("parser> \n");
                                      }
                                      else {
                                        printf("parser> \n"); $$ = newast('L', $1, $3);
                                      }
                                    }
    ;

exp: exp CMP exp                    { printf("parser> \n"); $$ = newcmp($2, $1, $3); }
    | exp '+' exp                   { printf("parser> \n"); $$ = newast('+', $1,$3); }
    | exp '-' exp                   { printf("parser> \n"); $$ = newast('-', $1,$3); }
    | exp '*' exp                   { printf("parser> \n"); $$ = newast('*', $1,$3); }
    | exp '/' exp                   { printf("parser> \n"); $$ = newast('/', $1,$3); }
    | '|' exp                       { printf("parser> \n"); $$ = newast('|', $2,NULL); }
    | '(' exp ')'                   { printf("parser> \n"); $$ = $2; }
    | '-' exp %prec UMINUS          { printf("parser> \n"); $$ = newast('M', $2,NULL); }
    | NUMBER                        { printf("parser> \n"); $$ = newnum($1); }
    | NAME                          { printf("parser> \n"); $$ = newref($1); }
    | NAME '=' exp                  { printf("parser> \n"); $$ = newasgn($1, $3); }
    | FUNC '(' explist ')'          { printf("parser> \n"); $$ = newfunc($1, $3); }
    | NAME '(' explist ')'          { printf("parser> \n"); $$ = newcall($1, $3); }
    ;

explist: exp
    | exp ',' explist               { printf("parser> \n"); $$ = newast('L', $1, $3); }
    ;

symlist: NAME                       { printf("parser> \n"); $$ = newsymlist($1, NULL); }
    | NAME ',' symlist              { printf("parser> \n"); $$ = newsymlist($1, $3); }
    ;
%%