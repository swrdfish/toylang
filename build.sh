/usr/local/Cellar/bison/3.7/bin/bison -d test.y --graph
flex test.l
gcc -ll test.tab.c lex.yy.c testrepl.c
