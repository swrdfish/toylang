/* declare tokens */
%token NAME
%token IF

%%
start: input EOF
    ;

input: 
    | NAME            {{ console.log('name'); }}
    | IF              {{ console.log('if'); }}
    | CMP
    ;


%%