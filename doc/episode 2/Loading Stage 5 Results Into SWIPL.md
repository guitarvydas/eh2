```
$ swipl

Welcome to SWI-Prolog (threaded, 64 bits, version 9.2.9)

SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.

Please run ?- license. for legal details.

  

For online help and background, visit https://www.swi-prolog.org

For built-in help, use ?- help(Topic). or ?- apropos(Word).

  

?- consult('stage5.txt')

|    .

**ERROR: /Users/paultarvydas/projects/eh2/stage5.txt:131:47: Syntax error: Unexpected end of file**

**true.**

  

?-
```
Prolog is an old-fashioned language that expects commas to be inserted in only the right places, instead of treating commas a whitespace.

It should be easy to fix the output by inserting commas after every `cell`. We will also need a small script that removes redundant commas, like ",}" and ",]".