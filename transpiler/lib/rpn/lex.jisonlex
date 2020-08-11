digit       [0-9]
id			[a-zA-Z][a-zA-Z0-9]*

%%

/* string literal */
\"(\\.|[^"\\])*\"           return 'STRING';

/* keywords */
"if"                        return 'IF';
"else"                      return 'ELSE';
"while"                     return 'WHILE';
"for"                       return 'FOR';
"let"                       return 'LET';

/* assignment operator */
"="                         return 'ASSIGN';

/* arithmatic operators */
"+"                         return 'AOP';
"-"                         return 'AOP';
"*"                         return 'AOP';
"/"                         return 'AOP';

/* comparison operator */
"=="                        return 'CMP';                       
"!="                        return 'CMP';                       
">="                        return 'CMP';                       
"<="                        return 'CMP';
"<"                         return 'CMP';                        
">"                         return 'CMP';                        

/* logical operator */
"&&"                        yytext = 'AND'; return 'BINOP';
"||"                        yytext = 'OR'; return 'BINOP';
"!"                         yytext = 'NOT'; return 'BINOP';
"AND"                       return 'BINOP';
"OR"                        return 'BINOP';
"NOT"                       return 'BINOP';

/* braces */
"{"                         return 'LBRACE';
"}"                         return 'RBRACE';
"("                         return 'LPAREN';
")"                         return 'RPAREN';
"["                         return 'LSQUARE';
"]"                         return 'RSQUARE';

/* names */
{id}                        return 'NAME';

/* numbers */
{digit}+("."{digit}+)?\b    return 'NUMBER';
"."{digit}+                 return 'NUMBER';

/* delimeters */
";"                         return 'SEMICOLON';
","                         return 'COMMA';

"//".*                      /* ignore comment */
\s+                         /* skip whitespace */
\n                          return 'EOL';
.                           throw 'Illegal character';
<<EOF>>                     return 'EOF';

