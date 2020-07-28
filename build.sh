/usr/local/Cellar/bison/3.7/bin/bison -d test.y --graph -t
flex test.l
gcc -ll test.tab.c lex.yy.c testrepl.c
