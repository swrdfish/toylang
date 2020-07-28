## Demo Lexer and Parser
Implementation the calculator from the book: [Flex and Bison](https://www.amazon.in/Flex-Bison-John-R-Levine/dp/8184048165/ref=sr_1_1?dchild=1&keywords=flex+and+bison&qid=1595940764&sr=8-1)

#### Pre-requisites
Make sure you have `flex`, `bison` and `graphviz` installed before you build.

#### Build and run
```bash
./build.sh
./a.out
```

#### Demo program:
```
1 + 2 * 4 / 5 

let gt(a,b)=res=1; if a>b then res=1; else res=-1;;

let sq(n)=e=1; while |((t=n/e)-e)>.001 do e=avg(e,t);;

let avg(a,b)=(a+b)/2;

gt(9,99)

sq(10)

avg(6,5)
```